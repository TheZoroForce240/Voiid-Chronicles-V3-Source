package online;

import Popup.MessagePopup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import online.MultiplayerRoomState.GradientText;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import ui.HealthIcon;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.api.FlxGameJolt;
import states.MusicBeatState;

using StringTools;

class ChessPieceType
{
    public static final NONE = 0;
    public static final PAWN = 1;
    public static final BISH = 2;
    public static final ROOK = 3;
    public static final KNIGHT = 4;
    public static final KING = 5;
    public static final QUEEN = 6;

    public static final iconWhiteMap = [
        "",
        "Wiik1VoiidMatt",
        "VoiidShaggy",
        "Wiik100VoiidMatt",
        "Wiik3VoiidMatt",
        "Wiik4VoiidMatt",
        "Rejected"
    ];
    public static final iconBlackMap = [
        "",
        "Wiik1BFRTX",
        "Gerald",
        "PicoPlayer",
        "RevBF",
        "OniiBF",
        "GF",
    ];
}

typedef ChessPieceData = 
{
    var type:Int;
    var white:Bool;
    var x:Int;
    var y:Int;
    var icon:ChessIcon;
}

class ChessIcon extends HealthIcon
{
    public var pieceData:ChessPieceData;
    public var grabbed:Bool = false;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (grabbed)
        {
            x = FlxG.mouse.x - (this.width*0.5);
            y = FlxG.mouse.y - (this.height*0.5);
        }
        else 
        {
            var targetX:Float = ChessState.BOARDX + (pieceData.x * ChessState.GRIDPIXELSIZE);
            var targetY:Float = ChessState.BOARDY + (pieceData.y * ChessState.GRIDPIXELSIZE);
            targetX += (ChessState.GRIDPIXELSIZE*0.5) - (this.width*0.5);
            targetY += (ChessState.GRIDPIXELSIZE*0.5) - (this.height*0.5);
            x = FlxMath.lerp(x, targetX, elapsed*8);
            y = FlxMath.lerp(y, targetY, elapsed*8);
        }
    }
}

class ChessState extends MusicBeatState
{
    static final defaultState = 
    [
        "0:3","0:4","0:2","0:6","0:5","0:2","0:4","0:3",
        "0:1","0:1","0:1","0:1","0:1","0:1","0:1","0:1",
        "0:0","0:0","0:0","0:0","0:0","0:0","0:0","0:0",
        "0:0","0:0","0:0","0:0","0:0","0:0","0:0","0:0",
        "0:0","0:0","0:0","0:0","0:0","0:0","0:0","0:0",
        "0:0","0:0","0:0","0:0","0:0","0:0","0:0","0:0",
        "1:1","1:1","1:1","1:1","1:1","1:1","1:1","1:1",
        "1:3","1:4","1:2","1:6","1:5","1:2","1:4","1:3","true"
    ];

    public static final GRIDSIZE = 8;
    public static final GRIDPIXELSIZE = 80;
    public static final BOARDX = 320;
    public static final BOARDY = 40;

    var whiteTurn:Bool = true;

    var grid:Array<Array<FlxSprite>> = [[],[],[],[],[],[],[],[]];

    var player1Text:GradientText;
    var player2Text:GradientText;
    var yourTurnText:FlxText;
    var opponentsTurn:FlxText;

    var gridDataFlat:Array<String> = [];
    var gridData:Array<Array<ChessPieceData>> = [];

    var blackIcons:Array<ChessIcon> = [];
    var whiteIcons:Array<ChessIcon> = [];

    override public function create()
    {
        super.create();

        FlxG.autoPause = false;

        if (Multiplayer.currentPlayer == 0)
        {
            var dataStr:String = "";
            for (i in 0...defaultState.length)
            {
                dataStr += defaultState[i];
                if (i < defaultState.length-1)
                    dataStr += ",";
            }
            
            trace(dataStr);
            FlxGameJolt.setData(Multiplayer.serverPrefix + "chess" + Multiplayer.serverID, dataStr, false, function(map:Map<String,String>)
            {
                
            }, "chessEndTurn");
        }
        resetTimer();

        new FlxTimer().start(5, function(tmr)
        {
            Multiplayer.clients[Multiplayer.currentPlayer].ready = false; //reset for when exiting back into lobby
			Multiplayer.clients[Multiplayer.currentPlayer].started = false;
        });

        FlxG.mouse.visible = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image("online/room/bg_online"));
        bg.setGraphicSize(1280);
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        add(bg);

        var chatBox = new ChatBox(20, FlxG.height-50);
        add(chatBox);

        //generate the actual grid first
        var alt:Bool = true;
        var color1 = 0xFFCEC5D2;
        var color2 = 0xFF570F97;
        for (i in 0...GRIDSIZE)
        {
            for (j in 0...GRIDSIZE)
            {
                
                var box:FlxSprite = new FlxSprite().makeGraphic(GRIDPIXELSIZE,GRIDPIXELSIZE, alt ? color1 : color2);
                box.x = BOARDX + (i*GRIDPIXELSIZE);
                box.y = BOARDY + (j*GRIDPIXELSIZE);
                add(box);
                alt = !alt;

                grid[i][j] = box;

            }
            alt = !alt;
        }

        player1Text = new GradientText(0,FlxG.height-30,0, "Player 1");
        player1Text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(player1Text);
        MultiplayerRoomState.applyGradientToText(player1Text, Multiplayer.player1Client.playerName);
        if (Multiplayer.currentPlayer == 0)
            player1Text.text += " [YOU]";
        player1Text.x = FlxG.width*0.75 - (player1Text.width);

        player2Text = new GradientText(0, 10, 0, "Player 2");
        player2Text.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(player2Text);
        MultiplayerRoomState.applyGradientToText(player2Text, Multiplayer.player2Client.playerName);
        if (Multiplayer.currentPlayer == 1)
            player2Text.text += " [YOU]";
        player2Text.x = FlxG.width*0.25;

        yourTurnText = new FlxText(0, 0, 0, "[YOUR TURN]");
        yourTurnText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(yourTurnText);

        opponentsTurn = new FlxText(0, 0, 0, "[OPPONENT TURN]");
        opponentsTurn.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        add(opponentsTurn);

        if (Multiplayer.currentPlayer == 0)
        {
            yourTurnText.y = FlxG.height-30;
            opponentsTurn.y = 10;
            opponentsTurn.x = FlxG.width*0.75 - (opponentsTurn.width);
            yourTurnText.x = FlxG.width*0.25;
        }
        else 
        {
            yourTurnText.y = 10;
            opponentsTurn.y = FlxG.height-30;
            yourTurnText.x = FlxG.width*0.75 - (yourTurnText.width);
            opponentsTurn.x = FlxG.width*0.25;
        }

        var defaultCopy:Array<String> = [];
        for (a in defaultState)
            defaultCopy.push(a);

        loadGridData(defaultCopy);
    }

    var pingTimer:FlxTimer = null;
    function resetTimer()
    {
        if (pingTimer != null)
            pingTimer.cancel();
        pingTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) //ping every 0.25 secs
        {
            updateChessStatus();
        }, 0); //0 means loop forever
    }

    var justEndedTurn:Bool = false;

    function updateChessStatus()
    {
        FlxGameJolt.fetchData(Multiplayer.serverPrefix + "chess" + Multiplayer.serverID, false, function(map:Map<String,String>)
        {
            if (map != null)
            {
                if (map.get('success') == 'true' && map.exists('data'))
                {
                    var dataStr:String = map.get("data");
                    var data = dataStr.split(",");
                    var curTurn = data[data.length-1] == "true";
                    if (whiteTurn != curTurn)
                    {
                        trace('updated chess board');
                        //if (!justEndedTurn)
                            loadGridData(data); //load in data
                        whiteTurn = curTurn;
                    }
                }
            }
        }, "chess");
    }
    function endTurn()
    {
        whiteTurn = !whiteTurn;
        gridDataFlat[gridDataFlat.length-1] = whiteTurn ? "true" : "false";

        var dataStr:String = "";
        for (i in 0...gridDataFlat.length)
        {
            dataStr += gridDataFlat[i];
            if (i < gridDataFlat.length-1)
                dataStr += ",";
        }
        justEndedTurn = true;
        FlxGameJolt.setData(Multiplayer.serverPrefix + "chess" + Multiplayer.serverID, dataStr, false, function(map:Map<String,String>)
        {

        }, "chessEndTurn");
    }

    var gameEnding = false;

    function loadGridData(data:Array<String>)
    {
        gridDataFlat = data;
        gridData = [[],[],[],[],[],[],[],[]]; //reset

        var whiteHasKing:Bool = false;
        var blackHasKing:Bool = false;

        var idx:Int = 0;
        var row:Int = 0;
        for (pieceData in gridDataFlat)
        {
            if (row == 8)
            {
                break;
            }
            var splitData = pieceData.split(":");

            var piece:ChessPieceData = 
            {
                type: Std.parseInt(splitData[1]),
                white: splitData[0] == "1",
                x: idx,
                y: row,
                icon: null
            };

            if (piece.type == ChessPieceType.KING)
            {
                if (piece.white)
                    whiteHasKing = true;
                else 
                    blackHasKing = true;
            }
            
            gridData[row].push(piece);

            idx++;
            if (idx >= GRIDSIZE)
            {
                idx = 0;
                row++;
            }
        }
        //trace(gridData);
        updateIcons();

        if (!gameEnding)
        {
            if (!whiteHasKing || !blackHasKing)
            {
                gameEnding = true;
                if (whiteHasKing)
                {
                    Main.popupManager.addPopup(new MessagePopup(6, 300, 100, Multiplayer.player1Client.playerName+" wins!"));
                }
                else 
                {
                    Main.popupManager.addPopup(new MessagePopup(6, 300, 100, Multiplayer.player2Client.playerName+" wins!"));
                }
                
                new FlxTimer().start(2.5, function(tmr)
                {
                    pingTimer.cancel();
                    //FlxGameJolt.removeData(Multiplayer.serverPrefix + "chess" + Multiplayer.serverID, false, function(mapa:Map<String,String>)
                    //{
                    //
                    //}, "endChess");
                    FlxG.switchState(new MultiplayerRoomState());
                });
            }
        }

    }

    function stringifyData()
    {
        //gridDataFlat.
    }


    function updateIcons()
    {
        for (i in blackIcons)
            remove(i);
        for (i in whiteIcons)
            remove(i);

        for (row in gridData)
        {
            for (piece in row)
            {
                if (piece.type != 0)
                {
                    var map = piece.white ? ChessPieceType.iconBlackMap : ChessPieceType.iconWhiteMap;
                    var icon:ChessIcon = new ChessIcon(map[piece.type]);
                    piece.icon = icon;
                    icon.pieceData = piece;
                    icon.scale *= 0.7;
                    icon.updateHitbox();
                    icon.x = BOARDX + (piece.x * GRIDPIXELSIZE);
                    icon.y = BOARDY + (piece.y * GRIDPIXELSIZE);
                    icon.x += (GRIDPIXELSIZE*0.5) - (icon.width*0.5);
                    icon.y += (GRIDPIXELSIZE*0.5) - (icon.height*0.5);
                    add(icon);

                    if (piece.white)
                        whiteIcons.push(icon);
                    else 
                        blackIcons.push(icon);
                }
            }
        }
    }

    function moveIcon(piece:ChessPieceData, newX:Int, newY:Int)
    {
        gridDataFlat[piece.x + (piece.y*GRIDSIZE)] = "0:0"; //moving from
        gridDataFlat[newX + (newY*GRIDSIZE)] = (piece.white ? "1" : "0") + ":" + piece.type;
        loadGridData(gridDataFlat);
        endTurn();
    }

    var curGrabbedPiece:ChessIcon = null;
    var availableMoves:Array<Array<Int>> = [];
    var availableTiles:Array<FlxSprite> = [];

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        var overlapX:Int = -1;
        var overlapY:Int = -1;

        var x:Int = 0;
        var y:Int = 0;
        for (row in grid)
        {
            for (tile in row)
            {
                if (FlxG.mouse.overlaps(tile))
                {
                    tile.color = 0xFF555555;
                    overlapX = x;
                    overlapY = y;
                }
                else 
                {
                    tile.color = 0xFFFFFFFF;
                }
                x++;
            }
            x = 0;
            y++;
        }

        if (gameEnding)
            return;

        if (!Multiplayer.active)
        {
            gameEnding = true;
            Main.popupManager.addPopup(new MessagePopup(6, 300, 100, "Disconnected from Server"));
			Multiplayer.endServer();
            FlxG.switchState(new states.VoiidMainMenuState());
            return;
        }

        if ((whiteTurn && Multiplayer.currentPlayer == 1) || (!whiteTurn && Multiplayer.currentPlayer == 0))
        {
            opponentsTurn.visible = true;
            yourTurnText.visible = false;
            if (curGrabbedPiece != null) //stop from breaking
            {
                curGrabbedPiece.grabbed = false;
                curGrabbedPiece = null;
                for (t in availableTiles)
                    remove(t);
            }

            return;
        }
        opponentsTurn.visible = false;
        yourTurnText.visible = true;
            
        

        if (FlxG.mouse.justPressed)
        {
            if (overlapX != -1 && overlapY != -1)
            {
                //trace(overlapX);
                //trace(overlapY);
                var piece = gridData[overlapX][overlapY];

                if (piece.type != 0 && piece.white == (Multiplayer.currentPlayer == 0))
                {
                    piece.icon.grabbed = true;
                    remove(piece.icon);
                    add(piece.icon); //make sure its on top
                    curGrabbedPiece = piece.icon;

                    availableMoves = getPossibleMovePositions(piece);
                    trace(availableMoves);
                    for (m in availableMoves)
                    {
                        var box:FlxSprite = new FlxSprite().makeGraphic(GRIDPIXELSIZE,GRIDPIXELSIZE, 0x7700D400);
                        box.x = BOARDX + (m[0]*GRIDPIXELSIZE);
                        box.y = BOARDY + (m[1]*GRIDPIXELSIZE);
                        add(box);
                        availableTiles.push(box);
                    }
                }
            }
        }
        else if (FlxG.mouse.justReleased)
        {
            if (curGrabbedPiece != null)
            {
                curGrabbedPiece.grabbed = false;
                if (overlapX != -1 && overlapY != -1)
                {
                    var pos = [overlapY, overlapX];
                    for (moves in availableMoves)
                    {
                        if (pos[0] == moves[0] && pos[1] == moves[1]) //check if move is valid
                        {
                            moveIcon(curGrabbedPiece.pieceData, overlapY, overlapX); //x and y is flipped for some reason?
                            break;
                        }
                    }
                    
                }
            }
            curGrabbedPiece = null;
            for (t in availableTiles)
                remove(t);
        }
    }


    function getPossibleMovePositions(piece:ChessPieceData)
    {
        var x = piece.x;
        var y = piece.y;
        var moves:Array<Array<Int>> = [];
        switch(piece.type)
        {
            case ChessPieceType.PAWN:

                var doubleJumpRow = 1;
                var movement = 1;

                if (piece.white) //flip for opponent
                {
                    doubleJumpRow = 6;
                    movement = -1;
                }

                if (!isPositionBlocked(x, y+movement))
                {
                    moves.push([x, y+movement]);
                    if (y == doubleJumpRow) //allow moving 2 spaces
                        if (!isPositionBlocked(x, y+(movement*2)))
                            moves.push([x, y+(movement*2)]);
                }
                
                //check if can take 
                if (isPositionOpponentPiece(piece, x-1, y+movement)) 
                    moves.push([x-1, y+movement]);
                if (isPositionOpponentPiece(piece, x+1, y+movement))
                    moves.push([x+1, y+movement]);

                
            case ChessPieceType.ROOK:
                var left = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-left, y))
                    {
                        moves.push([x-left, y]);
                        if (isPositionOpponentPiece(piece, x-left, y))
                            break;
                        left++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var right = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+right, y))
                    {
                        moves.push([x+right, y]);
                        if (isPositionOpponentPiece(piece, x+right, y))
                            break;
                        right++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var up = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x, y-up))
                    {
                        moves.push([x, y-up]);
                        if (isPositionOpponentPiece(piece, x, y-up))
                            break;
                        up++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var down = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x, y+down))
                    {
                        moves.push([x, y+down]);
                        if (isPositionOpponentPiece(piece, x, y+down))
                            break;
                        down++;
                    }
                    else 
                    {
                        break;
                    }
                }
            case ChessPieceType.BISH:
                var leftUp = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-leftUp, y-leftUp))
                    {
                        moves.push([x-leftUp, y-leftUp]);
                        if (isPositionOpponentPiece(piece, x-leftUp, y-leftUp))
                            break;
                        leftUp++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var rightUp = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+rightUp, y-rightUp))
                    {
                        moves.push([x+rightUp, y-rightUp]);
                        if (isPositionOpponentPiece(piece, x+rightUp, y-rightUp))
                            break;
                        rightUp++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var leftDown = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-leftDown, y+leftDown))
                    {
                        moves.push([x-leftDown, y+leftDown]);
                        if (isPositionOpponentPiece(piece, x-leftDown, y+leftDown))
                            break;
                        leftDown++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var rightDown = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+rightDown, y+rightDown))
                    {
                        moves.push([x+rightDown, y+rightDown]);
                        if (isPositionOpponentPiece(piece, x+rightDown, y+rightDown))
                            break;
                        rightDown++;
                    }
                    else 
                    {
                        break;
                    }
                }

            case ChessPieceType.KNIGHT:
                if (!isPositionTeamBlocked(piece, x+1, y+2))
                    moves.push([x+1, y+2]);
                if (!isPositionTeamBlocked(piece, x-1, y-2))
                    moves.push([x-1, y-2]);
                if (!isPositionTeamBlocked(piece, x-1, y+2))
                    moves.push([x-1, y+2]);
                if (!isPositionTeamBlocked(piece, x+1, y-2))
                    moves.push([x+1, y-2]);

                if (!isPositionTeamBlocked(piece, x+2, y+1))
                    moves.push([x+2, y+1]);
                if (!isPositionTeamBlocked(piece, x-2, y-1))
                    moves.push([x-2, y-1]);
                if (!isPositionTeamBlocked(piece, x-2, y+1))
                    moves.push([x-2, y+1]);
                if (!isPositionTeamBlocked(piece, x+2, y-1))
                    moves.push([x+2, y-1]);

            case ChessPieceType.KING:
                if (!isPositionTeamBlocked(piece, x+1, y+1))
                    moves.push([x+1, y+1]);
                if (!isPositionTeamBlocked(piece, x-1, y-1))
                    moves.push([x-1, y-1]);
                if (!isPositionTeamBlocked(piece, x-1, y+1))
                    moves.push([x-1, y+1]);
                if (!isPositionTeamBlocked(piece, x+1, y-1))
                    moves.push([x+1, y-1]);
                if (!isPositionTeamBlocked(piece, x+1, y))
                    moves.push([x+1, y]);
                if (!isPositionTeamBlocked(piece, x-1, y))
                    moves.push([x-1, y]);
                if (!isPositionTeamBlocked(piece, x, y+1))
                    moves.push([x, y+1]);
                if (!isPositionTeamBlocked(piece, x, y-1))
                    moves.push([x, y-1]);
            case ChessPieceType.QUEEN:
                var left = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-left, y))
                    {
                        moves.push([x-left, y]);
                        if (isPositionOpponentPiece(piece, x-left, y))
                            break;
                        left++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var right = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+right, y))
                    {
                        moves.push([x+right, y]);
                        if (isPositionOpponentPiece(piece, x+right, y))
                            break;
                        right++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var up = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x, y-up))
                    {
                        moves.push([x, y-up]);
                        if (isPositionOpponentPiece(piece, x, y-up))
                            break;
                        up++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var down = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x, y+down))
                    {
                        moves.push([x, y+down]);
                        if (isPositionOpponentPiece(piece, x, y+down))
                            break;
                        down++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var leftUp = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-leftUp, y-leftUp))
                    {
                        moves.push([x-leftUp, y-leftUp]);
                        if (isPositionOpponentPiece(piece, x-leftUp, y-leftUp))
                            break;
                        leftUp++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var rightUp = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+rightUp, y-rightUp))
                    {
                        moves.push([x+rightUp, y-rightUp]);
                        if (isPositionOpponentPiece(piece, x+rightUp, y-rightUp))
                            break;
                        rightUp++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var leftDown = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x-leftDown, y+leftDown))
                    {
                        moves.push([x-leftDown, y+leftDown]);
                        if (isPositionOpponentPiece(piece, x-leftDown, y+leftDown))
                            break;
                        leftDown++;
                    }
                    else 
                    {
                        break;
                    }
                }
                var rightDown = 1;
                while(true)
                {
                    if (!isPositionTeamBlocked(piece, x+rightDown, y+rightDown))
                    {
                        moves.push([x+rightDown, y+rightDown]);
                        if (isPositionOpponentPiece(piece, x+rightDown, y+rightDown))
                            break;
                        rightDown++;
                    }
                    else 
                    {
                        break;
                    }
                }
        }
        return moves;
    }
    function isPositionBlocked(x:Int, y:Int) 
    {
        if (x < 0 || x >= GRIDSIZE)
            return true;
        if (y < 0 || y >= GRIDSIZE)
            return true;
        if (gridData[y][x].type != 0)
            return true;

        return false;
    }
    function isPositionTeamBlocked(piece:ChessPieceData, x:Int, y:Int) //check if blocked but only if its the same team (so you can take opponent pieces)
    {
        if (x < 0 || x >= GRIDSIZE)
            return true;
        if (y < 0 || y >= GRIDSIZE)
            return true;
        if (gridData[y][x].type != 0 && gridData[y][x].white == piece.white)
            return true;

        return false;
    }
    function isPositionOpponentPiece(piece:ChessPieceData, x:Int, y:Int)
    {
        if (x < 0 || x >= GRIDSIZE)
            return false;
        if (y < 0 || y >= GRIDSIZE)
            return false;
        if (gridData[y][x].type != 0 && gridData[y][x].white != piece.white)
            return true;

        return false;
    }
    
}