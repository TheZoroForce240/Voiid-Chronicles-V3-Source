
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

    --initShader('bars', 'BarsEffect')
    --setCameraShader('game', 'bars')
    --setShaderProperty('bars', 'effect', 0.0)

    initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
    if modcharts then 
        setCameraShader('hud', 'mirror2')
    end
    setShaderProperty('mirror2', 'zoom', 4.0)
	--setShaderProperty('mirror', 'zoom', 2.0)
    --setShaderProperty('mirror', 'warp', -0.2)


    --setShaderProperty('mirror', 'x', -0.5)
    --setShaderProperty('mirror', 'warp', -0.1)
    --setShaderProperty('mirror', 'angle', 180)

    

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.35)
    setShaderProperty('bloom2', 'strength', 0.5)

    initShader('greyscale', 'GreyscaleEffect')
    setCameraShader('game', 'greyscale')
    setCameraShader('hud', 'greyscale')
    setShaderProperty('greyscale', 'strength', 1)




    initShader('vhs', 'VHSEffect')
    setCameraShader('game', 'vhs')
    setCameraShader('hud', 'vhs')
    setShaderProperty('vhs', 'effect', 0.5)
    setShaderProperty('vhs', 'chromaStrength', -0.002)

    initShader('scanline', 'ScanlineEffect')
    setCameraShader('game', 'scanline')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 1)
    setShaderProperty('scanline', 'smooth', true)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 1)

    initShader('vignette', 'VignetteEffect')
    setCameraShader('other', 'vignette')
    --setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 0)
    setShaderProperty('vignette', 'size', 1)

    setStageColorSwap('hue', -0.1)
end

function songStart()
    stepHit()
    
    tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*16*4, 'cubeOut')
    tweenShaderProperty('vignette', 'size', 0.15, crochet*0.001*16*4, 'cubeOut')
    tweenShaderProperty('vignette', 'strength', 15, crochet*0.001*16*4, 'cubeOut')
    tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*16*4, 'cubeOut')
end
local swap = 1
function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
    local secStep8 = curStep % 8
	local secStep32 = curStep % 32
	local secStep64 = curStep % 64
    local secStep128 = curStep % 128



    if section == 7 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 20, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*4, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 8 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
            tweenShaderProperty('vhs', 'effect', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 16 or section == 48 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
        end
    elseif section == 21 then 
        if secStep == 12 then 
            tweenShaderProperty('mirror', 'angle', 20, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*2, 'cubeOut')
        end
    elseif section == 22 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 0.8, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 23 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 24 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
            tweenShaderProperty('vhs', 'effect', 0.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1, crochet*0.001*4, 'cubeOut')
            setShaderProperty('greyscale', 'strength', 1)
            tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*64, 'linear')
        end
    elseif section == 31 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 32 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
            tweenShaderProperty('vhs', 'effect', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 35 or section == 67 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeIn')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        elseif secStep == 12 then 
            setShaderProperty('mirror', 'angle', 0)
            tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*8, 'expoInOut')
        end
    elseif section == 36 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
        end
    elseif section == 39 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 1)
        end
        if secStep == 8 or secStep == 12 then 
            --setProperty('camGame', 'alpha', 0)
           -- setProperty('camHUD', 'alpha', 0)
        end
        if secStep == 10 or secStep == 14 then 
            --setProperty('camGame', 'alpha', 1)
            --setProperty('camHUD', 'alpha', 1)
        end
    elseif section == 40 or section == 58 or section == 64 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 0)
            bloomBurst(1, 1, 8, 'cubeOut')
        end
    elseif section == 54 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 1)
            bloomBurst(1, 1, 8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 55 then 
        if secStep == 0 then 
            
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        elseif secStep == 12 then 
            setShaderProperty('mirror', 'angle', 360)
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'expoInOut')
        end
    elseif section == 56 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 0)
            bloomBurst(1, 1, 8, 'cubeOut')
            setStageColorSwap('hue', -0.3)
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end

    elseif section == 57 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'expoIn')
        elseif secStep == 8 then 
            setShaderProperty('greyscale', 'strength', 1)
            setAndEaseBackShader('mirror', 'angle', 10.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        elseif secStep == 11 then 
            setAndEaseBackShader('mirror', 'angle', -10.0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            setAndEaseBackShader('mirror', 'angle', 10.0, crochet*0.001*2, 'cubeOut')
        end
    elseif section == 61 then 
        if secStep == 0 then 
            
        elseif secStep == 8 then 
            setShaderProperty('greyscale', 'strength', 1)
            tweenShaderProperty('mirror', 'angle', 25.0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 11 then 
            tweenShaderProperty('mirror', 'angle', -25.0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'angle', 25.0, crochet*0.001*2, 'cubeOut')
        end
    elseif section == 62 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
            setShaderProperty('greyscale', 'strength', 1)
        end
    elseif section == 63 then 
        if secStep == 0 then 
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')
        end
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 71 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 1)
        end
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            setShaderProperty('mirror', 'angle', 360)
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'expoInOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 72 then 
        if secStep == 0 then 
            tweenShaderProperty('vignette', 'size', 1.0, crochet*0.001*16*7, 'linear')
            tweenShaderProperty('vignette', 'strength', 0, crochet*0.001*16*7, 'linear')
        end
    end


    if (section >= 32 and curStep <= 568) or (section >= 64 and curStep <= 1080) then 
        if secStep == 0 or secStep == 4 or secStep == 8 or secStep == 11 or secStep == 14 then 
            setAndEaseBackShader('mirror', 'angle', 10.0*swap, crochet*0.001*2, 'cubeOut')
            swap = swap * -1
        end
    end

    --bumps

    if (section >= 8 and section < 24) or (section >= 40 and section < 56 )then 
        if secStep == 8 or secStep128 == 62 then 
            triggerEvent('add camera zoom', '0.05', '-0.05')
        end

        if secStep32 == 0 or secStep32 == 12 or secStep32 == 18 or secStep32 == 20 or secStep64 == 60 then 
            triggerEvent('add camera zoom', '0.05', '0.05')
        end
    end

    if (section >= 24 and curStep < 504) then 
        if secStep32 == 0 or secStep == 12 or secStep64 == 14 or secStep32 == 20 or secStep64 == 62 then 
            triggerEvent('add camera zoom', '0.05', '0.05')
        end
    end

    if (section >= 32 and section < 39) or (section >= 64 and section < 71) then 
        if secStep == 0 or secStep == 4 or secStep == 8 or secStep == 11 or secStep == 14 then 
            triggerEvent('add camera zoom', '0.05', '0.05')
        end
    end

    if (section >= 56 and section < 64) then 
        if secStep == 4 or secStep64 == 62 or secStep64 == 12 or secStep64 == 44 or secStep64 == 60 then 
            triggerEvent('add camera zoom', '0.05', '-0.05')
        end

        if secStep == 0 or secStep32 == 6 or secStep32 == 10 or secStep32 == 11 or secStep32 == 14 or secStep32 == 30 or secStep32 == 27 or secStep32 == 24 then 
            triggerEvent('add camera zoom', '0.05', '0.05')
        end
    end

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