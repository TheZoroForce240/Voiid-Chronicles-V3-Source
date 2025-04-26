@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
haxelib set lime 8.1.1
haxelib set openfl 9.1.0
haxelib set flixel 5.2.2
haxelib set flixel-addons 3.0.2
haxelib set flixel-ui 2.5.0
haxelib set flixel-tools 1.5.1
haxelib set hxCodec 2.6.1
haxelib set hxcpp 4.2.1
haxelib git flxperspective https://github.com/TheZoroForce240/FlxPerspective
echo Finished!
pause
