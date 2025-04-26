
function createPost()

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
    if modcharts then 
        setCameraShader('hud', 'mirror')
    end
    setShaderProperty('mirror', 'zoom', 1.0)

    initShader('mirrorGame', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirrorGame')
	setShaderProperty('mirrorGame', 'zoom', 1.0)

    initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
    if modcharts then 
        setCameraShader('hud', 'mirror2')
    end
    setShaderProperty('mirror2', 'zoom', 1.0)

    initShader('mirrorP', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirrorP')
    if modcharts then 
        setCameraShader('hud', 'mirrorP')
    end
    setShaderProperty('mirrorP', 'zoom', 1.0)
	--setShaderProperty('mirror', 'zoom', 2.0)
    --setShaderProperty('mirror', 'warp', -0.2)


    --setShaderProperty('mirror', 'x', -0.5)
    --setShaderProperty('mirror', 'warp', -0.1)
    --setShaderProperty('mirror', 'angle', 180)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 0.0)

    

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.0)
    setShaderProperty('bloom2', 'strength', 0.0)

    initShader('vhs', 'VHSEffect')
    setCameraShader('game', 'vhs')
    setCameraShader('hud', 'vhs')
    setShaderProperty('vhs', 'effect', 1)
    setShaderProperty('vhs', 'chromaStrength', -0.002)

    initShader('vignette1', 'VignetteEffect')
    setCameraShader('hud', 'vignette1')
    --setCameraShader('game', 'vignette')
    setShaderProperty('vignette1', 'strength', 0)
    setShaderProperty('vignette1', 'size', 1)

end

local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.2

local perlinXRange = 0.1
local perlinYRange = 0.1
local perlinZRange = 5

function update(elapsed)
    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('mirrorP', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange))
	setShaderProperty('mirrorP', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange))
	setShaderProperty('mirrorP', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange))
end

function songStart()
    stepHit()

    tweenShaderProperty('vhs', 'effect', 0.0, crochet*0.001*16*8, 'linear')
    tweenShaderProperty('vignette1', 'size', 0.35, crochet*0.001*16*8, 'linear')
    tweenShaderProperty('vignette1', 'strength', 15, crochet*0.001*16*8, 'linear')
end

function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
    local secStep8 = curStep % 8
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32

    if (section >= 16 and section < 32) or (section >= 48 and section < 64) then 
        if secStep == 0 or secStep == 6 or secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 or secStep == 8 or secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end

        if secStep == 0 or secStep == 2 or secStep == 4 or secStep == 6 then 
            --tweenShaderProperty('mirror', 'zoom', 0.9, crochet*0.001, 'cubeOut')
            triggerEvent('add camera zoom', 0.02, 0.02)
        elseif secStep == 1 or secStep == 3 or secStep == 5 or secStep == 7 then 
            --tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001, 'cubeIn')
        elseif secStep == 12 then 
            --tweenShaderProperty('mirror', 'zoom', 1.1, crochet*0.001*4, 'cubeIn')
        end
    elseif (section >= 32 and section < 48) or (section >= 112 and section < 128) then 

        if secStep == 0 or secStep == 4 or secStep == 8 then 
            --tweenShaderProperty('mirror', 'zoom', 0.9, crochet*0.001, 'cubeOut')
            triggerEvent('add camera zoom', 0.1, 0.05)
        end

    elseif (section >= 96 and section < 112) then 

        --[[if secStep == 4 or secStep == 12 or secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*1, 'cubeOut')
        elseif secStep == 5 or secStep == 13 or secStep == 15 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*1, 'cubeIn')
        end]]--
        if curStep % 2 == 0 then  
            tweenShaderProperty('mirror', 'zoom', 1.08, crochet*0.001, 'cubeOut')
        elseif curStep % 2 == 1 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001, 'cubeIn')
        end
    elseif (section >= 80 and section < 96) then 

        --[[if secStep32 == 0 or secStep32 == 8 or secStep32 == 12 or secStep32 == 18 or secStep32 == 24 or secStep32 == 28 then 
            tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
        elseif secStep32 == 2 or secStep32 == 10 or secStep32 == 14 or secStep32 == 20 or secStep32 == 26 or secStep32 == 30 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end]]--

        if curStep % 4 == 0 then  
            tweenShaderProperty('mirror', 'zoom', 1.08, crochet*0.001*2, 'cubeOut')
        elseif curStep % 4 == 2 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end

    end


    if secStep == 0 then 
        if section == 8 then 
            bloomBurst(1,1, 8, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.5, crochet*0.001*8, 'cubeOut')
        elseif section == 16 then 
            bloomBurst(2,2, 16, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
            perlinSpeed = 0.8
        elseif section == 24 or section == 28 or section == 32 or section == 48 or section == 56 or section == 96 then 
            bloomBurst(2,2, 16, 'cubeOut')
        elseif section == 52 then 
            tweenShaderProperty('vhs', 'effect', 1.0, crochet*0.001*8, 'cubeOut')
            bloomBurst(2,2, 16, 'cubeOut')
            perlinSpeed = 2
            perlinZRange = 10
        elseif section == 64 then 
            tweenShaderProperty('vhs', 'effect', 0.0, crochet*0.001*64, 'cubeOut')
            perlinSpeed = 0.2
            perlinZRange = 5
            tweenActorProperty('camHUD', 'alpha', 0.0, crochet*0.001*64, 'cubeOut')
        elseif section == 78 then 
            tweenShaderProperty('vhs', 'effect', 1.0, crochet*0.001*32, 'expoIn')
            tweenStageColorSwap('hue', 0.5, crochet*0.001*30, 'cubeIn')
            tweenActorProperty('camHUD', 'alpha', 1.0, crochet*0.001*32, 'expoIn')
        elseif section == 80 then 
            setStageColorSwap('hue', 0)
            perlinSpeed = 3.5
            perlinZRange = 15

        elseif section == 128 then 
            tweenShaderProperty('vhs', 'effect', 0.0, crochet*0.001*64, 'cubeOut')
            bloomBurst(2, 2, 64, 'cubeOut')
            perlinSpeed = 0.2
            tweenShaderProperty('vignette1', 'size', 1.0, crochet*0.001*16*16, 'linear')
            tweenShaderProperty('vignette1', 'strength', 0, crochet*0.001*16*16, 'linear')
        end
    end

    if section == 28 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'y', 0.05, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror2', 'x', 0.55, crochet*0.001*2, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror2', 'x', 0.6, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 then 
            tweenShaderProperty('mirror2', 'y', 0.15, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror2', 'y', 0.2, crochet*0.001*2, 'cubeOut')
        elseif secStep == 10 then 
            tweenShaderProperty('mirror2', 'y', 0.25, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then
            tweenShaderProperty('mirror2', 'y', 0.3, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror2', 'x', 0.55, crochet*0.001*2, 'cubeOut')
        end
    elseif section == 29 then
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'x', 0.6, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror2', 'x', 0.65, crochet*0.001*2, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror2', 'x', 0.6, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 then 
            tweenShaderProperty('mirror2', 'x', 0.65, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror2', 'x', 0.7, crochet*0.001*2, 'cubeOut')
        elseif secStep == 10 then 
            tweenShaderProperty('mirror2', 'x', 0.65, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then
            tweenShaderProperty('mirror2', 'y', 0.35, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror2', 'y', 0.4, crochet*0.001*2, 'cubeOut')
        end

    elseif section == 30 then
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'y', 0.35, crochet*0.001*1, 'cubeOut')
        elseif secStep == 1 then 
            tweenShaderProperty('mirror2', 'y', 0.3, crochet*0.001*1, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror2', 'y', 0.25, crochet*0.001*1, 'cubeOut')
        elseif secStep == 3 then 
            tweenShaderProperty('mirror2', 'y', 0.2, crochet*0.001*1, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror2', 'y', 0.15, crochet*0.001*1, 'cubeOut')
        elseif secStep == 5 then 
            tweenShaderProperty('mirror2', 'y', 0.1, crochet*0.001*1, 'cubeOut')

        elseif secStep == 6 then 
            tweenShaderProperty('mirror2', 'x', 0.6, crochet*0.001*1, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror2', 'x', 0.55, crochet*0.001*1, 'cubeOut')
        elseif secStep == 10 then 
            tweenShaderProperty('mirror2', 'x', 0.5, crochet*0.001*1, 'cubeOut')
        elseif secStep == 11 then 
            tweenShaderProperty('mirror2', 'x', 0.55, crochet*0.001*1, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror2', 'x', 0.5, crochet*0.001*1, 'cubeOut')
        end
    end

    if section == 27 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror2', 'zoom', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'x', 0.5, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 31 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('mirror2', 'x', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'y', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirrorGame', 'x', -0.5, crochet*0.001*8, 'cubeIn')

        elseif secStep == 0 then 
            tweenShaderProperty('mirror2', 'y', 0.05, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror2', 'y', 0.0, crochet*0.001*2, 'cubeOut')
        end

    elseif section == 119 then 
        if secStep == 8 then 
            tweenShaderProperty('mirrorGame', 'x', -0.5, crochet*0.001*8, 'cubeIn')
        end
    end



    if section == 32 or section == 40 or section == 112 or section == 120 then 
        if secStep == 12 then 
            tweenShaderProperty('mirrorGame', 'x', 0.5, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 33 or section == 41 or section == 113 or section == 121 then 
        if secStep == 12 then 
            tweenShaderProperty('mirrorGame', 'x', -0.5, crochet*0.001*4, 'cubeIn')
        end

    elseif section == 34 or section == 42 or section == 114 or section == 122 then 
        if secStep == 12 then 
            tweenShaderProperty('mirrorGame', 'x', 0.5, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 35 or section == 43 or section == 115 or section == 123 then
        if secStep == 12 then
            tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 36 or section == 44 or section == 116 or section == 124 then 
        if secStep == 0 or secStep == 6 or secStep == 12 then 
            tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 or secStep == 8 then 
            tweenShaderProperty('mirror2', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 4 or secStep == 10 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
        end

        if secStep == 12 then
            tweenShaderProperty('mirrorGame', 'x', -0.5, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 37 or section == 45 or section == 117 or section == 125 then 
        if secStep == 12 then
            tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 39 or section == 119 then 

        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            if section == 119 then 
                tweenShaderProperty('mirror2', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
            else 
                tweenShaderProperty('mirror2', 'angle', -360.0, crochet*0.001*8, 'cubeIn')
            end
            
            tweenShaderProperty('mirrorGame', 'x', -0.5, crochet*0.001*8, 'cubeIn')
        end

    elseif section == 47 or section == 127 then 

        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*16, 'cubeIn')
        end
    end


    if section >= 60 and section < 64 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        end
    end


    if section == 108 or section == 110 then 
        if secStep == 0 or secStep == 6 or secStep == 12 then
            bloomBurst(1, 1, 4, 'linear')
            doShake(4, 0.01)
        end
    elseif section == 109 then 
        if secStep == 2 then
            bloomBurst(1, 1, 4, 'linear')
            doShake(4, 0.01)
        end
    elseif section == 111 then 
        if secStep == 2 then
            bloomBurst(1, 1, 4, 'linear')
            doShake(4, 0.01)
        elseif secStep == 8 then 
            bloomBurst(1, 1, 8, 'linear')
            doShake(8, 0.01)
        end
    end

end

function tweenNumIn(obj, targetY, t, ease)
    actorScreenCenter(obj)

    setActorY(getActorY(obj)+targetY, obj)

    tweenActorProperty(obj, 'y', getActorY(obj)-targetY, crochet*0.001*t, ease)
end

function setAndEaseBack(mod, prop, set, time, ease)
	setActorProperty(mod, prop, set)
	tweenActorProperty(mod, prop, 0, time, ease)
end
function setAndEaseBackShader(mod, prop, set, time, ease)
	setShaderProperty(mod, prop, set)
	tweenShaderProperty(mod, prop, 0, time, ease)
end
function setAndEaseBackTo(mod, prop, set, time, ease, back)
	setActorProperty(mod, prop, set)
	tweenActorProperty(mod, prop, back, time, ease)
end

function setAndEaseBackToShader(mod, prop, set, time, ease, back)
	setShaderProperty(mod, prop, set)
	tweenShaderProperty(mod, prop, back, time, ease)
end

function bloomBurst(e, s, t, ease)
    setShaderProperty('bloom2', 'effect', e)
    setShaderProperty('bloom2', 'strength', s)
    tweenShaderProperty('bloom2', 'effect', 0.0, crochet*0.001*t, ease)
    tweenShaderProperty('bloom2', 'strength', 0.0, crochet*0.001*t, ease)
end

function doShake(steps, freq)
    triggerEvent('screen shake', (crochet*0.001*steps)..','..freq, (crochet*0.001*steps)..','..freq)
end

