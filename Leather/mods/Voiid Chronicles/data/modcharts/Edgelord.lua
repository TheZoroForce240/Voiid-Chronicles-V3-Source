function start(song)
    makeText('charter1', 'Charter: BruvDiego', 5,690,20)
    makeText('charter2', 'Charter: RhysRJJ', -500,690,20)
    makeText('charter3', 'Charter: Official_YS', -500,690,20)
    setObjectCamera("charter1","hud")
    setObjectCamera("charter2","hud")
    setObjectCamera("charter3","hud")
end

function createPost()

    showOnlyStrums = true

    initShader('greyscale', 'GreyscaleEffect')
    setCameraShader('game', 'greyscale')
    setCameraShader('hud', 'greyscale')
    setShaderProperty('greyscale', 'strength', 0.9)

    initShader('color', 'ColorOverrideEffect')
    setCameraShader('game', 'color')
    setCameraShader('hud', 'color')
    setShaderProperty('color', 'red', 0.9)
    setShaderProperty('color', 'green', 1.1)
    setShaderProperty('color', 'blue', 1.2)

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.1)
    setShaderProperty('bloom2', 'strength', 0.1)

	initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
	if modcharts then 
		setCameraShader('hud', 'mirror')
	end
	setShaderProperty('mirror', 'zoom', 1)

    initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
	if modcharts then 
		setCameraShader('hud', 'mirror2')
	end
	setShaderProperty('mirror2', 'zoom', 1)


    initShader('hudColorSwap', 'ColorSwapEffect')
    setCameraShader('hud', 'hudColorSwap')

    initShader('chroma', 'ChromAbEffect')
    setCameraShader('game', 'chroma')
    setCameraShader('hud', 'chroma')
    setShaderProperty('chroma', 'strength', 0.0025)


    
    initShader('blur', 'BlurEffect')
    setCameraShader('game', 'blur')
	if modcharts then 
		setCameraShader('hud', 'blur')
	end
    setShaderProperty('blur', 'strength', 0)



    initShader('scanline', 'ScanlineEffect')
    setCameraShader('game', 'scanline')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 0)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 16)


    --setShaderProperty('smoke', 'smokeStrength', 50)

    

end



local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.0

local perlinXRange = 0.0
local perlinYRange = 0.0
local perlinZRange = 0

local started = false;
local swap = 1

local hues = {0.0, 0.25, 0.5, 0.75}
local hueCount = 1

function update(elapsed)
    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed

    setShaderProperty('mirror2', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange))
	setShaderProperty('mirror2', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange))
	setShaderProperty('mirror2', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange))

    if not started then 
        setShaderProperty('smoke', 'smokeStrength', 10) --stupid shit cuz smoke lua file is after and cant edit property in createpost here
        started = true
    end

    setShaderProperty('hudColorSwap', 'hue', getStageColorSwap('hue'))
   
end

function stepHit(curStep)
    if curStep == 896 then
        tweenPos("charter1", -500, 690, 0.01)
        tweenPos("charter2", 5, 690, 0.01)
    end
    if curStep == 2432 then
        tweenPos("charter2", -500, 690, 0.01)
    end
    if curStep == 2560 then
        tweenPos("charter3", 5, 690, 0.01)
    end

    local section = math.floor(curStep/16)
    local secStep16 = curStep%16
    local secStep8 = curStep%8
    local secStep4 = curStep%4

    --section 1
    if section <= 56 then 
        if secStep16 == 0 then 
            if section == 8 then 
                showOnlyStrums = false
                setShaderProperty('color', 'red', 1.0)
                setShaderProperty('color', 'green', 1.0)
                setShaderProperty('color', 'blue', 1.0)
                setShaderProperty('greyscale', 'strength', 0.0)
                setShaderProperty('chroma', 'strength', 0.001)
                setShaderProperty('bloom2', 'effect', 0.1)
                setShaderProperty('bloom2', 'strength', 0.1)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('smoke', 'smokeStrength', 1, crochet*0.001*16, 'cubeOut')
                perlinSpeed = 0.5
                perlinXRange = 0.05
                perlinYRange = 0.05
                perlinZRange = 5
            elseif section == 24 then 
                setShaderProperty('chroma', 'strength', 0.003)
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            elseif section == 40 then 
                setShaderProperty('chroma', 'strength', 0.001)
                tweenShaderProperty('scanline', 'strength', 1, crochet*0.001*4, 'cubeOut')
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            elseif section == 48 then 
                setShaderProperty('chroma', 'strength', 0)
                tweenShaderProperty('scanline', 'strength', 0, crochet*0.001*4, 'cubeOut')
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            elseif section == 54 then 
                tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            elseif section == 56 then 
                tweenShaderProperty('mirror2', 'warp', 0, crochet*0.001*4, 'cubeOut')
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                perlinSpeed = 2
                perlinXRange = 0.1
                perlinYRange = 0.1
                perlinZRange = 8
                tweenShaderProperty('scanline', 'strength', 1, crochet*0.001*4, 'cubeOut')
            end
        end
    
        if section == 7 and secStep16 == 12 then 
            tweenShaderProperty('mirror', 'zoom', 0.85, crochet*0.001*4, 'cubeIn')
        end
    
        if section == 11 then 
            if secStep16 == 0 then 
                tweenShaderProperty('blur', 'strength', 8, crochet*0.001*4, 'cubeOut')
                makeSprite('uno', "uno", 0, 0, 1)
                setObjectCamera('uno', 'other')
                actorScreenCenter('uno')
                setActorX(getActorX('uno')-1000, 'uno')
                setActorAntialiasing(true,'uno')
                tweenActorProperty('uno', 'x', getActorX('uno')+1000, crochet*0.001*2, 'cubeOut')
            elseif secStep16 == 4 then 
                makeSprite('dos', "dos", 0, 0, 1)
                setObjectCamera('dos', 'other')
                actorScreenCenter('dos')
                setActorX(getActorX('dos')+1000, 'dos')
                setActorAntialiasing(true,'dos')
                tweenActorProperty('dos', 'x', getActorX('dos')-1000, crochet*0.001*2, 'cubeOut')
    
                tweenActorProperty('uno', 'x', getActorX('uno')-1000, crochet*0.001*2, 'cubeOut')
            elseif secStep16 == 8 then 
                makeSprite('tres', "tres", 0, 0, 1)
                setObjectCamera('tres', 'other')
                actorScreenCenter('tres')
                setActorX(getActorX('tres')-1000, 'tres')
                setActorAntialiasing(true,'tres')
                tweenActorProperty('tres', 'x', getActorX('tres')+1000, crochet*0.001*2, 'cubeOut')
                tweenActorProperty('dos', 'x', getActorX('dos')+1000, crochet*0.001*2, 'cubeOut')
            elseif secStep16 == 12 then 
                tweenActorProperty('tres', 'x', getActorX('tres')-1000, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('blur', 'strength', 0, crochet*0.001*4, 'cubeIn')
            end
        end
    
    
    
        if section >= 8 and section < 54 then 
    
    
            if section == 11 or section == 15 then 
                if secStep16 == 0 then 
                    tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 4 then 
                    tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 8 then 
                    tweenShaderProperty('mirror', 'zoom', 1.25, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 12 then 
                    tweenShaderProperty('mirror', 'zoom', 0.9, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
                end
            elseif section == 19 then 
                if secStep16 == 0 then 
                    tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 4 then 
                    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 8 then 
                    tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 12 then 
                    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
                end
            else 
                if secStep16 == 0 or secStep16 == 8 then 
                    tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 12 or secStep16 == 4 then 
                    tweenShaderProperty('mirror', 'zoom', 0.85, crochet*0.001*4, 'cubeIn')
                end
            end
    
    
        end
    
        if (section >= 40 and section < 44) or section == 47 then 
            if curStep % 64 == 0 then 
                tweenShaderProperty('mirror2', 'zoom', 1.25, crochet*0.001*8, 'cubeOut')
            end
            if curStep % 64 == 12 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 14 then 
                tweenShaderProperty('mirror2', 'zoom', 1, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 16 then 
                tweenShaderProperty('mirror2', 'zoom', 1.25, crochet*0.001*8, 'cubeOut')
            end
    
            if curStep % 64 == 28 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 30 then 
                tweenShaderProperty('mirror2', 'zoom', 1, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 32 then 
                tweenShaderProperty('mirror2', 'zoom', 1.25, crochet*0.001*8, 'cubeOut')
            end
    
            if curStep % 64 == 44 then 
                tweenShaderProperty('mirror2', 'zoom', 1.75, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 46 then 
                tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            end
    
            if curStep % 64 == 48 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', 10, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 50 then 
                tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 52 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', -10, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 54 then 
                tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 56 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', 10, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 58 then 
                tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 60 then 
                tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            elseif curStep % 64 == 62 then 
                tweenShaderProperty('mirror2', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
            end
        end
        if (section == 44) and secStep16 == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.25, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')
        end
        if (section == 48) and secStep16 == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')
        end
    
        if section == 55 and secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeInOut')
            tweenShaderProperty('mirror', 'zoom', 0.8, crochet*0.001*4, 'cubeIn')
        end
    end

    ---section 2 (hated this so much)
    if section >= 56 and section < 153 then 
        if section == 68 and secStep16 == 0 then 
            --tilt(-20, 4)
            setShaderProperty('mirror', 'zoom', 1.0)
        end
    
        if section == 88 and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1, crochet*0.001*4, 'cubeOut')
        elseif (section == 96 or section == 144) and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            setShaderProperty('mirror', 'zoom', 0.6)
        elseif (section == 104 or section == 112) and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
    
        elseif (section == 119) and secStep16 == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeIn')
        elseif (section == 120) and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            perlinSpeed = 0.2
        elseif (section == 128) and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            tweenStageColorSwap('hue', 0.1, crochet*0.001*8, 'cubeOut')
            perlinSpeed = 2.5
    
        elseif (section == 136) and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            perlinSpeed = 1.5
        end
    
        
        if (section >= 56 and section < 72) or (section >= 86 and section < 100) or (section >= 104 and section < 119) or (section >= 136 and section < 152) then 
    
    
    
            if section == 63 and secStep16 >= 6 then 
                if secStep16 == 8 then 
                    tweenShaderProperty('mirror', 'zoom', 2, crochet*0.001*4, 'cubeOut')
                    --tweenShaderProperty('blur', 'strength', 5, crochet*0.001*8, 'cubeIn')
                    tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*6, 'cubeIn')
                elseif secStep16 == 14 then
                    --trace('fuck')
                    tweenShaderProperty('mirror', 'zoom', 0.6, crochet*0.001*2, 'cubeIn')
                end
                
            elseif section == 67 and secStep16 >= 6 then 
                if secStep16 == 8 then 
                    --tilt(-10, 4)
                    setShaderProperty('mirror', 'zoom', 1.5)
                elseif secStep16 == 12 then
                    --tilt(10, 4)
                    setShaderProperty('mirror', 'zoom', 2.0)
                end
            elseif (section == 95 or section == 143) and secStep16 >= 8 then 
                if secStep16 == 8 or secStep16 == 12 then 
                    setProperty('camGame', 'alpha', 0)
                    if secStep16 == 8 then 
                        tweenShaderProperty('mirror', 'zoom', 3, crochet*0.001*8, 'expoIn')
                    end
                elseif secStep16 == 10 or secStep16 == 14 then
                    setProperty('camGame', 'alpha', 1)
                end
            elseif section == 118 and secStep16 >= 12 then 
                if secStep16 == 12 then 
                    tweenShaderProperty('mirror', 'zoom', 2, crochet*0.001*8, 'cubeOut')
                    tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeOut')
                    
                end
            else 
                if curStep % 8 == 0 then 
                    tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
                elseif curStep % 8 == 6 then
                    tweenShaderProperty('mirror', 'zoom', 0.85, crochet*0.001*2, 'cubeIn')
                end
            end
        end
        if (section >= 72 and section < 86) or (section >= 100 and section < 104) or (section >= 128 and section < 136) then 
    
    
            if section == 63 and secStep16 >= 8 then 
    
            elseif section == 103 and secStep16 >= 8 then 
                if secStep16 == 8 then 
                    tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
                    tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
                elseif secStep16 == 12 then 
                    tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*4, 'cubeIn')
                    tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
                    tweenStageColorSwap('hue', 0, crochet*0.001*8, 'cubeIn')
                end
            else 
                if curStep % 4 == 0 then 
                    tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
                elseif curStep % 4 == 2 then
                    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001, 'cubeIn')
                end
            end
    
    
        end
    
        if section == 64 and secStep16 == 0 then 
            tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*4, 'cubeOut')
        end
    
        if (section == 65 or section == 113) and secStep16 == 8 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tilt(10, 8)
        end
        
        if (section == 66 or section == 114) and secStep16 == 8 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tilt(-10, 8)
        end
    
    
    
    
        if curStep == 960 or curStep == 982 or curStep == 998 or curStep == 1008 or curStep == 1016 or curStep == 1024 
            or curStep == 1080 or curStep == 1084 or curStep == 1088 or curStep == 1112 or curStep == 1128 or curStep == 1672 
            or curStep == 1704 or curStep == 1720 or curStep == 1728 or curStep == 1752 or curStep == 1792 or curStep == 1848 or curStep == 1852 or curStep == 1856 
            or curStep == 1880 or curStep == 1896 then 
            tilt(10*swap, 4)
            swap = swap * -1
        end
    
        if section == 71 then 
    
            if secStep16 == 0 then 
                tweenShaderProperty('mirror', 'angle', 45, crochet*0.001*15, 'cubeIn')
                tweenShaderProperty('bloom2', 'effect', 2.2, crochet*0.001*15, 'cubeIn')
                tweenShaderProperty('bloom2', 'strength', 2.2, crochet*0.001*15, 'cubeIn')
            elseif secStep16 == 8 then 
                tweenShaderProperty('mirror2', 'warp', -0.7, crochet*0.001*8, 'cubeIn')
                tweenShaderProperty('scanline', 'strength', 0, crochet*0.001*8, 'cubeIn')
                tweenStageColorSwap('hue', 0.1, crochet*0.001*8, 'cubeIn')
            end
    
        elseif section == 72 then 
    
            if secStep16 == 0 then 
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('bloom2', 'effect', 0.25, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0.25, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('mirror2', 'warp', -0.15, crochet*0.001*8, 'cubeOut')            
            end
        
        end
    
        if section == 131 then 
            if secStep16 == 8 then 
                tweenShaderProperty('mirror', 'zoom', 1.25, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*2, 'cubeOut')  
            elseif secStep16 == 12 then 
                tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
                tweenShaderProperty('mirror2', 'warp', -0.1, crochet*0.001*2, 'cubeOut')  
            elseif secStep16 == 14 then 
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
            end
        end

        if section == 152 and secStep16 == 0 then 
            setShaderProperty('bloom2', 'effect', 1.2)
            setShaderProperty('bloom2', 'strength', 1.2)
            tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*16, 'cubeOut')
            tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16, 'cubeOut')
            perlinSpeed = 1.0
        end
    end

    --section 3
    if section >= 160 then 

        if secStep16 == 0 then 
            if section == 160 then 
                setStageColorSwap('hue', 0.4)
                tweenStageColorSwap('hue', 0.2, crochet*0.001*16*8, 'linear')
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*16, 'cubeOut')  
            elseif section == 176 or section == 192 or section == 216 or section == 240 or section == 264 then 
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
            elseif section == 208 then 
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
                perlinSpeed = 3.0
            elseif section == 224 then 
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
                perlinSpeed = 1.5
            elseif section == 256 then 
                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
                perlinSpeed = 1.5
            elseif section == 272 then 

                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')

            elseif section == 288 then 

                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')

                perlinSpeed = 4

            elseif section == 320 then 

                setShaderProperty('bloom2', 'effect', 1.2)
                setShaderProperty('bloom2', 'strength', 1.2)
                tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
                tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')

                tweenStageColorSwap('hue', 'strength', 0.0, crochet*0.001*16, 'cubeOut')
                perlinSpeed = 1
            end
        end

        if section == 175 or section == 255 then 
            if secStep16 == 8 then 
                tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 12 then 
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
                tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
            end
            
        end
        if section == 263 then 
            if secStep16 == 8 then 
                tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 12 then 
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            end
            
        end

        if section == 207 then 
            if secStep16 == 0 then 
                tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')  
                tweenShaderProperty('mirror2', 'warp', -0.15, crochet*0.001*16, 'cubeIn') 
            elseif secStep16 == 8 then 
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn') 
            end
 
        end

        if section == 271 then 
            if secStep16 == 0 then 

            elseif secStep16 == 12 then 
                --tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*8, 'cubeInOut') 
                
            end
 
        end


        if (section >= 176 and section < 207) or (section >= 256 and curStep < 4212) or (section >= 264 and section < 272) then
            if curStep % 8 == 0 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeOut')
            elseif curStep % 8 == 6 then
                tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*2, 'cubeIn')
            end
        end

        if (section >= 208 and section < 224) then
            if curStep % 4 == 0 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
            elseif curStep % 4 == 3 then
                tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001, 'cubeIn')
            end
        end

        if (section >= 224 and curStep < 4084) then
            if curStep % 16 == 0 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*8, 'cubeOut')
            elseif curStep % 16 == 12 then
                tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*4, 'cubeIn')
            end
        end

        if section == 272 then 
            if secStep16 == 0 then 
                tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end
        end


        if section == 274 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.5)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end
        elseif section == 276 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.75)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 278 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.25)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 280 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.1)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 282 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.5)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 284 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.75)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 285 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.0)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end


        elseif section == 286 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.25)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

            if secStep16 == 8 then 
                setStageColorSwap('hue', 0.5)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 12 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

        elseif section == 287 then 
            if secStep16 == 0 then 
                setStageColorSwap('hue', 0.1)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 4 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end

            if secStep16 == 8 then 
                setStageColorSwap('hue', 0.0)
                setShaderProperty('greyscale', 'strength', 0)
                tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')

                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep16 == 12 then 
                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*4, 'cubeIn')
            end
        end


        if section >= 288 and section < 320 then 
            if curStep % 4 == 0 then 

                if (hues[(hueCount % 4)+1] == 0.0) then 
                    setStageColorSwap('hue', -0.25) --make it loop properly
                end
                tweenStageColorSwap('hue', hues[(hueCount % 4)+1], crochet*0.001*2, 'cubeOut')

                

                tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
                hueCount = hueCount + 1
            elseif curStep % 4 == 3 then
                tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001, 'cubeIn')
            end
        end

    end
    


end

function tilt(ang, time)
    setShaderProperty('mirror', 'angle', ang)
    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*time, 'cubeOut')
end