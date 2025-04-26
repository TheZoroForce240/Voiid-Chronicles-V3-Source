package online;

import haxe.Exception;
import Popup.MessagePopup;
import states.PlayState;
import flixel.util.FlxTimer;
import flixel.addons.api.FlxGameJolt;
import flixel.FlxG;
import states.VoiidMainMenuState;

using StringTools;

typedef ClientData = 
{
    var serverID:String;
    var playerName:String;
    var playerConnected:Bool;
    var playerLoaded:Bool;

    var playerScore:Int;
    var playerMisses:Int;
    var playerAccuracy:Float;
    var playerHealth:Float;
    var playerRatingName:String;
    var playerRatingFC:String;
    var playerCombo:Int;
    var playerDied:Bool;

    var song:String;
    var diff:String;
    var songSpeed:Float;

    var lastTimestamp:Int;
    var playerFinishedSong:Bool;

    var winCondition:String;
    var privateServer:Bool;

    var ready:Bool;
    var started:Bool;

    var modcharts:Bool;
    var mechanics:Bool;

    var strumAnims:Array<String>;
}

class Multiplayer
{

    public static var player1Client:ClientData = null;
    public static var player2Client:ClientData = null;
    public static var clients:Array<ClientData> = [player2Client, player1Client];
    public static var currentPlayer:Int = 2;
    public static var opponentPlayer:Int = 2;
    public static var waitingForSync:Bool = false;
    public static var active:Bool = false;
    public static var serverID:String = '';
    public static var currentTimestamp:Int = 0;

    public static final serverPrefix:String = "S"+VoiidMainMenuState.modVersion;

    public static function setupNewClient(id:String, player:Int, userName:String):ClientData
    {
        FlxG.autoPause = false; //make sure it doesnt get desynced

        var data:ClientData = {
            serverID: id,
            playerName: userName,
            playerConnected: true,

            playerLoaded: false,
        
            playerScore: 0,
            playerMisses: 0,
            playerAccuracy: 0,
            playerHealth: 1,
            playerRatingName: '?',
            playerRatingFC: '',
            playerCombo: 0,
            playerDied: false,
        
            song: '',
            diff: '',
            songSpeed: 1.0,

            lastTimestamp: currentTimestamp,
            winCondition: "Score",
            privateServer: false,

            ready: false,
            started: false,

            modcharts: true,
            mechanics: true,
    
            playerFinishedSong: false,
            strumAnims: ['static', 'static', 'static', 'static','static', 'static', 'static', 'static','static', 'static', 'static', 'static'],   
        };
        serverID = id;

        var dataAsString:String = stringifyClientData(data);
        currentPlayer = player;
        opponentPlayer = getOpponentPlayer();
       
        FlxGameJolt.setData(serverPrefix+'P'+player+id, dataAsString, false, function(mapa:Map<String,String>)
        {
            active = true;
        });
        

        return data;
    }

    static function stringToBool(str:String)
    {
        return str == 'true';
    }

    //i would have wanted to end up using proper serialization but it really didnt wanna work so this will have to do
    static function stringifyClientData(data:ClientData)
    {
        var dataAsString = '';

        dataAsString += data.serverID+':';
        dataAsString += data.playerName+':';
        dataAsString += data.playerConnected+':';
        dataAsString += data.playerLoaded+':';

        dataAsString += data.playerScore+':';
        dataAsString += data.playerMisses+':';
        dataAsString += data.playerAccuracy+':';
        dataAsString += data.playerHealth+':';
        dataAsString += data.playerRatingName+':';
        dataAsString += data.playerRatingFC+':';
        dataAsString += data.playerCombo+':';
        dataAsString += data.playerDied+':';

        dataAsString += data.song+':';
        dataAsString += data.diff+':';
        dataAsString += data.songSpeed+':';

        dataAsString += data.lastTimestamp+':';
        dataAsString += data.playerFinishedSong+':';
        dataAsString += data.winCondition+':';
        dataAsString += data.privateServer+':';

        dataAsString += data.ready+':';
        dataAsString += data.started+':';
        dataAsString += data.modcharts+':';
        dataAsString += data.mechanics+':';

        for (i in 0...data.strumAnims.length)
        {
            dataAsString += data.strumAnims[i];
            if (i < data.strumAnims.length-1)
                dataAsString += ',';
        }

        return dataAsString;
    }
    public static function parseClientData(d:String):ClientData
    {
        var data = d.split(":");
        var strumAnims = data[23].split(',');
        return {
            serverID: data[0],
            playerName: data[1],
            playerConnected: stringToBool(data[2]),
            playerLoaded: stringToBool(data[3]),
        
            playerScore: Std.parseInt(data[4]),
            playerMisses: Std.parseInt(data[5]),
            playerAccuracy: Std.parseFloat(data[6]),
            playerHealth: Std.parseFloat(data[7]),
            playerRatingName: data[8],
            playerRatingFC: data[9],
            playerCombo: Std.parseInt(data[10]),
            playerDied: stringToBool(data[11]),
        
            song: data[12],
            diff: data[13],
            songSpeed: Std.parseFloat(data[14]),

            lastTimestamp: Std.parseInt(data[15]),
            playerFinishedSong: stringToBool(data[16]),
            winCondition: data[17],
            privateServer: stringToBool(data[18]),
            ready: stringToBool(data[19]),
            started: stringToBool(data[20]),
            modcharts: stringToBool(data[21]),
            mechanics: stringToBool(data[22]),
            strumAnims: strumAnims
        };
    }

    static var serverPingTimer:FlxTimer = null;
    static var messagePingTimer:FlxTimer = null;
    static var timestampPingTimer:FlxTimer = null;

    public static var forceUpdateTimestamp:Bool = false; //for server create menu, need to keep it updated

    public static function resetServerPingTimer()
    {
        if (active)
            updateServer();

        var pingTime:Float = 0.25;

        if (active || forceUpdateTimestamp)
            updateServerTimestamp();
        //FlxG.autoPause = false;

        if (serverPingTimer != null)
            serverPingTimer.cancel();
        serverPingTimer = new FlxTimer().start(pingTime, function(tmr:FlxTimer) //ping every 0.25 secs
        {
            if (active)
                updateServer();
        }, 0); //0 means loop forever

        if (messagePingTimer != null)
            messagePingTimer.cancel();
        messagePingTimer = new FlxTimer().start(0.75, function(tmr:FlxTimer)
        {
            if (active)
                ChatManager.checkForMessages();
        }, 0); //0 means loop forever

        if (timestampPingTimer != null)
            timestampPingTimer.cancel();
        timestampPingTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            if (active || forceUpdateTimestamp)
            {
                updateServerTimestamp();
            }
        }, 0); //0 means loop forever

        
    }

    public static function updateServerTimestamp()
    {
        FlxGameJolt.getTime(function(mapThing:Map<String,String>)
        {
            //trace(mapThing);
            if (mapThing != null)
            {
                if (mapThing.get('success') == 'true' && mapThing.exists('timestamp'))
                {
                    currentTimestamp = Std.parseInt(mapThing.get("timestamp")); 
                    //Main.popupManager.addPopup(new MessagePopup(2, 300, 50, "updated timestamp: " + currentTimestamp));
                    //trace(currentTimestamp);
                    //trace(currentTimestamp);
                }
            }
        });
    }
    public static function checkTimestampsForDisconnect(stamp1:Int, stamp2:Int)
    {
        var dis = Math.abs(stamp1-stamp2) > 15;
        if (dis)
        {
            trace('disconnect: ' + stamp1 + " : " + stamp2);
        }
        return dis;
    }

    public static function getOpponentPlayer()
    {
        var opponentPlayer = 1;
        if (currentPlayer == 1)
            opponentPlayer = 0;
        return opponentPlayer;
    }


    public static function updateServer(?callback:Void->Void = null)
    {
        if (!GameJolt.connected)
            return;



        /*var opponentPlayer = getOpponentPlayer();
        if (opponentPlayer == 0)
        {
            if (player1Client != null)
                player1Client.lastTimestamp = currentTimestamp;
        }
        else
        {
            if (player2Client != null)
                player2Client.lastTimestamp = currentTimestamp;
        }*/
        //clients = [player1Client, player2Client];
        //get opponent client data
       

        //if (clients[currentPlayer] != null)
            //clients[currentPlayer].lastTimestamp = currentTimestamp;

        //trace(opponentPlayer);
        //trace(currentPlayer);

        var opponentDataStore:String = serverPrefix+'P'+opponentPlayer+serverID;
        var playerDataStore:String = serverPrefix+'P'+currentPlayer+serverID;
        //trace(playerDataStore);
        //trace(opponentDataStore);

        //get opponent data
        FlxGameJolt.fetchData(opponentDataStore.trim(), false, function(mapThing:Map<String,String>)
        {
            if (mapThing != null)
            {
                if (mapThing.get('success') == 'true' && mapThing.exists('data'))
                {
                    var asString = mapThing.get('data');

                    var clientData = parseClientData(asString);
                    //trace(clientData);
                    if (currentPlayer == 0)
                        player2Client = clientData;
                    else 
                        player1Client = clientData;

                    clients = [player1Client, player2Client];
                    //trace("opp timestamp: " + clientData.lastTimestamp);
                    return;
                }
            }
            trace('got nothing from server?');
        }, "multiplayerPull");

        //send your client data to the server
        if (clients[currentPlayer] != null)
        {
            clients[currentPlayer].lastTimestamp = currentTimestamp;
            var dataAsString = stringifyClientData(clients[currentPlayer]);
            //trace("trying to send");
            //trace(playerDataStore);
            //trace(dataAsString);
            FlxGameJolt.setData(playerDataStore, dataAsString, false, function(mapa:Map<String,String>)
            {
                
                if (player1Client != null && player2Client != null && !waitingForSync)
                    if (checkTimestampsForDisconnect(player1Client.lastTimestamp, player2Client.lastTimestamp) || !player1Client.playerConnected || !player2Client.playerConnected) //if you go 20 secs without a ping
                        endServer(); //disconnect
    
                        //else 
                            //updateServer(); //constantly ping
    
                clients = [player1Client, player2Client];
    
                if (callback != null)
                    callback();
            }, "multiplayerPush");
        }
        else 
        {
            trace('client is null??');
            if (callback != null)
                callback();
        }

       // clients = [player1Client, player2Client];
    }

    public static function createServer(name:String, privateServer:Bool)
    {
        if (!GameJolt.connected)
            return;

        player1Client = setupNewClient(name, 0, FlxGameJolt.getUserName());	
        player1Client.privateServer = privateServer;
        resetServerPingTimer();
        waitingForSync = true;

        FlxGameJolt.removeData(serverPrefix+'chat'+name, false, function(mapa:Map<String,String>)
            {
    
            }, "removeChat");
    }
    public static function joinServer(name:String)
    {
        if (!GameJolt.connected)
            return;

        player2Client = setupNewClient(name, 1, FlxGameJolt.getUserName());			
        resetServerPingTimer();
        waitingForSync = true;
    }

    static var endingServer:Bool = false;

    public static function endServer()
    {
        if (!GameJolt.connected)
            return;

        if (endingServer)
            return;

        endingServer = true;

        trace(player1Client);
        trace(player2Client);

        var curServer = serverID;
        var callback = function()
        {
            
            player1Client = null;
            player2Client = null;
            FlxGameJolt.removeData(serverPrefix+'P1'+curServer, false, function(mapa:Map<String,String>)
            {
    
            }, "removeP1");
            FlxGameJolt.removeData(serverPrefix+'P0'+curServer, false, function(mapa:Map<String,String>)
            {
    
            }, "removeP0");
            FlxGameJolt.removeData(serverPrefix+'chat'+curServer, false, function(mapa:Map<String,String>)
            {
    
            }, "removeChat");
            FlxGameJolt.removeData(serverPrefix + "chess" + curServer, false, function(mapa:Map<String,String>)
            {
    
            }, "endChess");
            endingServer = false;
        }


        if (clients[currentPlayer] != null)
            clients[currentPlayer].playerConnected = false;
        updateServer(callback);        //update server saying that the player has disconnected
        active = false;
        PlayState.inMultiplayerSession = false;


    }

    public static var activeServers:Array<String> = [];
    public static var activeServersClients:Array<ClientData> = [];
    public static function getActiveServers(serversToCheck:Array<String>, callBack:Void->Void)
    {
        activeServers = [];
        activeServersClients = [];

        trace(serversToCheck);
        var finish = function()
        {
            trace(activeServers);
            if (callBack != null)
                callBack();
        }

        var func:Void->Void;
        func = function()
        {
            if (serversToCheck.length <= 0)
            {
                finish(); //gone through each server
                return;
            }

            var cont = function()
            {
                if (serversToCheck.length > 0) 
                {
                    serversToCheck.remove(serversToCheck[0]); //remove and redo func until all are checked
                    func();
                }
                else 
                {
                    finish();
                }
            }
                
            FlxGameJolt.fetchData(serversToCheck[0], false, function(mapThingP1:Map<String,String>)
            {
                if (mapThingP1 != null)
                {                
                    if (mapThingP1.get('success') == 'true' && mapThingP1.exists('data'))
                    {
                        FlxGameJolt.fetchData(serversToCheck[0].replace(serverPrefix+"P0", serverPrefix+"P1"), false, function(mapThingP2:Map<String,String>)
                        {
                            var player2Exists:Bool = false;
                            if (mapThingP2 != null)
                            {
                                if (mapThingP2.get('success') == 'true' && mapThingP2.exists('data'))
                                {
                                    var asString = mapThingP2.get('data');
                                    var client = parseClientData(asString);
                                    if (checkTimestampsForDisconnect(client.lastTimestamp, currentTimestamp)) //in case theres an old disconnected server
                                    {
                                        
                                    }
                                    else 
                                    {
                                        player2Exists = true; //probably already connected
                                    }
                                }
                            }

                            var asString = mapThingP1.get('data');
                            var client = parseClientData(asString);
                            if (checkTimestampsForDisconnect(client.lastTimestamp, currentTimestamp) || player2Exists) //in case theres an old disconnected server
                            {
                                trace(serversToCheck[0] + " not active");
                                FlxGameJolt.removeData(serversToCheck[0], false, function(mapThing:Map<String,String>)
                                {
                                    trace("removed " + serversToCheck[0]); //remove dead servers????, if it ends up not being dead the person connected should have it remade on the next ping i guess?????
                                    cont();
                                });
                            }
                            else 
                            {
                                if (!client.privateServer) //ignore if private
                                {
                                    activeServers.push(serversToCheck[0]);
                                    activeServersClients.push(client);
                                    trace(serversToCheck[0] + " is active");
                                }

                                cont();
                            }

                            
                        });
                    }
                    else 
                        cont();
                }
                else 
                    cont();
            });
        }
        func();
    }
}