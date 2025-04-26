package states;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

using StringTools;

class Player extends FlxSprite
{
    public function new()
    {
        super();
        loadGraphic(Paths.image("levels/bf"));
        drag.x = 800;
        drag.y = 500;
        velocity.y = 500;
        maxVelocity.x = 150;


        setSize(14, height); //so you can climb ladders lol
    }

    public var touchingLadder:Bool = false;

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.pressed.LEFT)
        {
            velocity.x -= 1000*elapsed;
            flipX = true;
        }
        if (FlxG.keys.pressed.RIGHT)
        {
            velocity.x += 1000*elapsed;
            flipX = false;
        }

        if (!touchingLadder)
        {
            if (FlxG.keys.justPressed.SPACE)
            {
                velocity.y = -500;
            }
            velocity.y = FlxMath.lerp(velocity.y, 500, elapsed*5);
        }
        else
        {
            velocity.y = 0;
            if (FlxG.keys.pressed.UP)
            {
                velocity.y = -150;
            }
            if (FlxG.keys.pressed.DOWN)
            {
                velocity.y = 150;
            }
        }

        super.update(elapsed);
    }
}
class NPC extends FlxSprite
{

}

class LevelPlayState extends MusicBeatState
{
    var levelName:String = "";
    var levelPath:String = "";
    var ogmoPath:String = "";
    override public function new(level:String = "testLevel")
    {
        super();
        levelName = level;
        levelPath = Paths.json("level data/" + level);
        ogmoPath = Paths.ogmo("level data/" + level);
    }

    var levelData:FlxOgmo3Loader;
    var walls:FlxTilemap;
    var bg:FlxTilemap;
    var dec:FlxTilemap;
    var ladders:FlxTilemap;

    var player:Player;

    override public function create()
    {
        levelData = new FlxOgmo3Loader(ogmoPath, levelPath);

        //setup tilemaps
        var image:String = Paths.image("levels/"+levelName);
        bg = levelData.loadTilemap(image, "BG");
        dec = levelData.loadTilemap(image, "Pillars");
        ladders = levelData.loadTilemap(image, "Ladders");
        walls = levelData.loadTilemap(image, "Walls");
        

        add(bg);
        add(dec);
        add(ladders);
        add(walls);

        player = new Player();

        levelData.loadEntities(function(entity:EntityData)
        {
            switch(entity.name)
            {
                case "player spawn": 
                    player.setPosition(entity.x, entity.y-16); //offset slightly up so not in the floor

            }
        }, "Entities");
        add(player);

        FlxG.camera.follow(player, LOCKON, 1);
        FlxG.camera.zoom = 4;
        walls.follow();
        
        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (player != null && walls != null)
        {
            if (ladders != null)
                player.touchingLadder = player.overlaps(ladders);

            FlxG.collide(player, walls, function(d1, d2)
            {
                
            });
        }
    }
}