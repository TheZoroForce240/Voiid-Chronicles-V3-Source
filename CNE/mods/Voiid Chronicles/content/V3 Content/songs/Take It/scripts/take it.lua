local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.3

local perlinXRange = 0.05
local perlinYRange = 0.05
local perlinZRange = 1

local doHueShifts = false
local hueTime = 0

function createPost()

    setStageColorSwap('hue', 0.1)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.1)
    setShaderProperty('bloom2', 'strength', 0.5)

    initShader('mirror', 'MirrorRepeatEffect')
	setCameraShader('game', 'mirror')
	--setCameraShader('hud', 'mirrorWarp')
	--setShaderProperty('mirrorWarp', 'zoom', 1.3)
    --setShaderProperty('mirrorWarp', 'warp', -0.3)
    setShaderProperty('mirror', 'zoom', 1.0)

    
    initShader('mirrorWarp', 'MirrorRepeatWarpEffect')
	setCameraShader('game', 'mirrorWarp')
	setCameraShader('hud', 'mirrorWarp')
	--setShaderProperty('mirrorWarp', 'zoom', 1.3)
    --setShaderProperty('mirrorWarp', 'warp', -0.3)
    setShaderProperty('mirrorWarp', 'zoom', 1.0)
    setShaderProperty('mirrorWarp', 'warp', -0.05)

    initShader('mirror2', 'MirrorRepeatEffect')
	setCameraShader('game', 'mirror2')
	setCameraShader('hud', 'mirror2')
	--setShaderProperty('mirrorWarp', 'zoom', 1.3)
    --setShaderProperty('mirrorWarp', 'warp', -0.3)
    setShaderProperty('mirror2', 'zoom', 1.0)



    initShader('chromAb', 'ChromAbEffect')
    setCameraShader('game', 'chromAb')
    setCameraShader('hud', 'chromAb')
    setShaderProperty('chromAb', 'strength', 0.003)

    initShader('scanline', 'ScanlineEffect')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 1)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 5)

end

function songStart()
    --intro
    --setShaderProperty('color', 'red', 1.0)
    --setShaderProperty('color', 'green', 1.0)
    --setShaderProperty('color', 'blue', 1.0)
   -- tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*32, 'cubeInOut')
    --tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*32, 'cubeInOut')

    tweenShaderProperty('grey', 'strength', 0, crochet*0.001*16*4, 'cubeIn')
end

function stepHit()

    local section = math.floor(curStep/16)
    local secStep16 = curStep%16
    local secStep32 = curStep%32
    local secStep64 = curStep%64

    if section == 4 then 
        if secStep16 == 0 then 
            bloomBurst()
        end
    end

    if (section >= 4 and section < 24) or (section >= 48 and section < 72) or (section >= 96 and section < 112) then 
        if secStep32 == 0 or secStep32 == 6 or secStep32 == 12 or secStep32 == 20 then 
            triggerEvent('add camera zoom', 0.1, 0.01)
        end
    end
    if (section >= 24 and section < 40) or (section >= 80 and section < 96) then 
        if secStep16 == 0 or secStep16 == 4 or secStep16 == 8 or secStep16 == 11 or secStep16 == 14 then 
            triggerEvent('add camera zoom', 0.1, 0.01)
        end
    end
    if (section >= 40 and section < 48) then 
        if secStep32 == 0 or secStep32 == 12 or secStep32 == 20 then 
            triggerEvent('add camera zoom', 0.1, 0.01)
        end
    end

    if section == 7 then 
        if secStep16 == 8 then 
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorWarp', 'zoom', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -45, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 8 then 
        if secStep16 == 0 then 
            bloomBurst()
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        end
    end

    if section == 15 or section == 63 then 
        if secStep16 == 8 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 1.75, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 16 or section == 64 then
        if secStep16 == 0 then 
            bloomBurst()
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            perlinZRange = 6
            perlinSpeed = 4
        end
    end

    if section == 17 or section == 21 or section == 23 or section == 65 or section == 69 then 
        if secStep16 == 8 then 
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorWarp', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep16 == 11 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
        elseif secStep16 == 14 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2.5, crochet*0.001, 'cubeOut')
        end
    elseif section == 18 or section == 22 or section == 66 or section == 70 then
        if secStep16 == 0 then 
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 24 then
        if secStep16 == 0 then 
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            perlinZRange = 10
            perlinSpeed = 6.0
            tweenShaderProperty('mirrorWarp', 'warp', -0.1, crochet*0.001*4, 'cubeOut')
        end
    end

    if section == 31 then 
        if secStep16 == 8 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'warp', -0.2, crochet*0.001*4, 'cubeIn')
        end
    end

    if section >= 24 and section < 40 then 
        if secStep16 == 0 then 
            bloomBurst()
        end
    end
    if section >= 32 and section < 40 then 
        perlinZRange = 2
        perlinSpeed = 1
        if secStep32 == 0 then 
            tweenShaderProperty('mirror', 'x', -1, crochet*0.001*2, 'cubeOut')
        elseif secStep32 == 4 then 
            tweenShaderProperty('mirror', 'y', -1, crochet*0.001*2, 'cubeOut')
        elseif secStep32 == 8 then 
            tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*4, 'cubeOut')
        elseif secStep32 == 16 then 
            tweenShaderProperty('mirror', 'x', 0, crochet*0.001*2, 'cubeOut')
        elseif secStep32 == 20 then 
            tweenShaderProperty('mirror', 'y', 0, crochet*0.001*2, 'cubeOut')
        elseif secStep32 == 24 then 
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        end
    end

    
    if section == 40 then 
        if secStep16 == 0 then 
        tweenShaderProperty('mirrorWarp', 'warp', -0.05, crochet*0.001*16, 'cubeOut')
        end
    elseif section == 48 then 
        if secStep16 == 0 then 
        bloomBurst()
        tweenShaderProperty('mirrorWarp', 'warp', 0.1, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0.5, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 55 then 
        if secStep16 == 8 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 10, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'warp', -0.1, crochet*0.001*4, 'cubeIn')
        end
        
    elseif section == 56 then 
        if secStep16 == 0 then 
        bloomBurst()
        tweenShaderProperty('mirrorWarp', 'zoom', 1, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
        end
    end

    if section == 71 then 
        if secStep16 == 8 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirrorWarp', 'zoom', 1.2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 4, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 72 then
        if secStep16 == 0 then
            bloomBurst()
            tweenShaderProperty('mirrorWarp', 'warp', -0.35, crochet*0.001*4, 'cubeIn')

            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*16*8, 'cubeInOut')
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*16*8, 'cubeInOut')

            for i = 0, keyCount-1 do 
                tweenActorProperty(i, "x", getActorX(i)+320, crochet*0.001*16, 'cubeOut')
                tweenActorProperty(i, "alpha", 0.1, crochet*0.001*16, 'cubeOut')
                tweenActorProperty(i+keyCount, "x", getActorX(i+keyCount)-320, crochet*0.001*16, 'cubeOut')
            end
        end
    end

    if section >= 72 and section < 80 then 
        if secStep16 == 0 then 
            setShaderProperty('mirror', 'y', -2)
            tweenShaderProperty('mirror', 'y', 0, crochet*0.001*16, 'cubeInOut')
        end
    end
    if section >= 80 and section < 95 then 
        if secStep16 == 0 then 
            bloomBurst()
        end
        setStageColorSwap('hue', 0.3)
        if secStep16 == 8 then 
            tweenShaderProperty('mirror2', 'zoom', 2, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
        end
    end
    if section == 95 then 
        if secStep16 == 8 then 
            tweenShaderProperty('mirror2', 'zoom', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'warp', -0.45, crochet*0.001*4, 'cubeIn')
        end
    end
    if section >= 96 and section < 104 then 
        doHueShifts = true
        if secStep16 == 0 then 
            bloomBurst()
        end
        if secStep16 == 8 then 
            if secStep32 == 8 then 
                tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*8, 'cubeOut')
            else 
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')
            end
           
            tweenShaderProperty('mirror2', 'zoom', 2, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
        end
    end
    if section == 104 then 
        if secStep16 == 0 then 
            setShaderProperty('grey', 'strength', 1)
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'warp', -0.55, crochet*0.001*4, 'cubeIn')
        end
    end
    if section >= 104 and section < 111 then
        if secStep16 == 0 then 
            bloomBurst()
        end 
        if secStep16 == 8 then 
            if secStep32 == 8 then 
                tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*8, 'cubeOut')
            else 
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')
            end
           
            tweenShaderProperty('mirror2', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
        end
    end
    if section == 111 then 
        if secStep16 == 8 then 
            if secStep32 == 8 then 
                tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*8, 'cubeOut')
            else 
                tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')
            end
           
            tweenShaderProperty('mirror2', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
        elseif secStep16 == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirrorWarp', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
        end
    end
    if section == 112 then 
        --bloomBurst()
        doHueShifts = false
        setStageColorSwap('hue', 0.1)
        perlinSpeed = 1
    end

end

function bloomBurst()
    setShaderProperty('bloom2', 'effect', 0.5)
    setShaderProperty('bloom2', 'strength', 5)
    tweenShaderProperty('bloom2', 'effect', 0.1, crochet*0.001*16, 'cubeOut')
    tweenShaderProperty('bloom2', 'strength', 0.5, crochet*0.001*16, 'cubeOut')
end



function update(elapsed)

    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('mirrorWarp', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange))
	setShaderProperty('mirrorWarp', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange))
	setShaderProperty('mirrorWarp', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange))

    if doHueShifts then
        hueTime = hueTime + elapsed*0.5
        setStageColorSwap('hue', hueTime%1)
    end

end