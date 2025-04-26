
function createPost()

    initShader('speed', 'SpeedEffect')
    setCameraShader('game', 'speed')
    setShaderProperty('speed', 'effect', 0.0)

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
    if modcharts then 
        setCameraShader('hud', 'mirror')
    end
    setShaderProperty('mirror', 'zoom', 1.0)

    initShader('mirrorGame', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirrorGame')
	setShaderProperty('mirrorGame', 'zoom', 1.0)

    initShader('bars', 'BarsEffect')
    setCameraShader('game', 'bars')
    setShaderProperty('bars', 'effect', 0.0)

    initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
    if modcharts then 
        setCameraShader('hud', 'mirror2')
    end
    setShaderProperty('mirror2', 'zoom', 1.0)
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
    setShaderProperty('vhs', 'effect', 1)
    setShaderProperty('vhs', 'chromaStrength', -0.002)

    initShader('scanline', 'ScanlineEffect')
    setCameraShader('game', 'scanline')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 1)
    setShaderProperty('scanline', 'smooth', true)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 1)

    initShader('vignette', 'VignetteEffect')
    setCameraShader('hud', 'vignette')
    --setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 0)
    setShaderProperty('vignette', 'size', 1)


    makeSprite('uno', "uno", -9999, 0, 1)
    setObjectCamera('uno', 'other')
    setActorAntialiasing(true,'uno')

    makeSprite('dos', "dos", -9999, 0, 1)
    setObjectCamera('dos', 'other')
    setActorAntialiasing(true,'dos')

    makeSprite('tres', "tres", -9999, 0, 1)
    setObjectCamera('tres', 'other')
    setActorAntialiasing(true,'tres')
end

function songStart()
    stepHit()
    
    tweenShaderProperty('vignette', 'size', 0.35, crochet*0.001*16*8, 'cubeInOut')
    tweenShaderProperty('vignette', 'strength', 15, crochet*0.001*16*8, 'cubeInOut')
end

function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
    local secStep8 = curStep % 8
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32


    if secStep == 0 then 
        if section == 8 then 
            tweenShaderProperty('vignette', 'size', 1.0, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('vignette', 'strength', 0, crochet*0.001*16*7, 'expoIn')

            tweenShaderProperty('mirrorGame', 'x', -2.0, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('mirrorGame', 'y', -3.0, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('mirrorGame', 'angle', 90.0, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('mirrorGame', 'zoom', 3.0, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('mirrorGame', 'warp', -0.25, crochet*0.001*16*7, 'expoIn')
            tweenShaderProperty('bars', 'effect', 0.5, crochet*0.001*16*6.5, 'expoIn')
        elseif section == 16 or section == 20 or section == 24 or section == 28 or section == 32 or section == 36 or section == 40 or section == 42 or section == 44 or section == 48 or section == 96 or section == 100 
        or section == 104 or section == 108 or section == 112 or section == 120 or section == 116 or section == 124 or section == 128 or section == 132 or section == 136 or section == 140 then 
            bloomBurst(3, 3, 8)
        elseif section == 64 or section == 144 then 
            bloomBurst(4, 4, 16)

        
        end
    end

    if section == 15 then
        if secStep == 8 then 
            tweenShaderProperty('vignette', 'size', 0.25, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('vignette', 'strength', 15, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*16, 'cubeOut')
    
            tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'y', 0.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'angle', 0.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'warp', 0, crochet*0.001*8, 'cubeOut')
    
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('vhs', 'effect', 0.0, crochet*0.001*8, 'cubeOut')
    
            bloomBurst(2, 2, 8)
        elseif secStep == 12 then
            tweenShaderProperty('mirrorGame', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end

    end
    

    if section == 19 or section == 51 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
        end
    end

    if section == 22 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.1, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 1.3, crochet*0.001*4, 'cubeIn')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.7, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 23 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 2.2, crochet*0.001*4, 'cubeIn')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0, crochet*0.001*4, 'cubeIn')
        end
    end


    if section == 25 or section == 57 then 
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 26 or section == 58 then 
        if secStep == 0 then 
            doShake(16, 0.01)
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('mirror2', 'warp', -0.65, crochet*0.001*16, 'cubeInOut')
        end
    elseif section == 27 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0, crochet*0.001*4, 'cubeOut')
        end
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 59 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0, crochet*0.001*4, 'cubeOut')
        end
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeIn')
        end
    end


    if section == 30 or section == 62 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*16, 'cubeOut')
        end


        if secStep == 0 then 
           -- tweenNumIn('uno', 600, 8, 'expoOut')     
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeIn')   
        elseif secStep == 8 then 
           -- tweenNumIn('dos', -600, 8, 'expoOut')
           -- tweenActorProperty('uno', 'y', getActorX('uno')+600, crochet*0.001*8, 'expoOut')
           tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeIn')
        end

    elseif section == 31 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'x', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*8, 'cubeOut')

            --tweenNumIn('tres', 600, 8, 'expoOut')
            --tweenActorProperty('dos', 'y', getActorX('dos')-600, crochet*0.001*8, 'expoOut')
        elseif secStep == 8 then 
           -- tweenActorProperty('tres', 'y', getActorX('tres')+600, crochet*0.001*8, 'expoOut')

            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('vhs', 'effect', 1.0, crochet*0.001*8, 'cubeIn')
            tweenStageColorSwap('hue', 0.1, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 63 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'x', 4.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
        end
    end

    if section == 35 then 
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 38 then 
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            setShaderProperty('greyscale', 'strength', 1.0)
            doShake(4, 0.01)
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 39 then 
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*8, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.4, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            
        end
    elseif section == 40 or section == 44 then 
        if secStep == 8 then 
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeInOut')
            
        end
    elseif section == 41 then 
        if secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            
        end
    elseif section == 43 then 
        if secStep == 8 then 
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*8, 'cubeIn')
        end


    elseif section == 46 then 
        if secStep == 0 then 
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*16, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 47 then 
        if secStep == 0 then 
            
            setAndEaseBackShader('mirror', 'angle', 30.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            setAndEaseBackShader('mirror', 'angle', -30.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')
        end
    end

    if section == 54 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.1, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 55 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0, crochet*0.001*4, 'cubeIn')
        end
    end



    if section == 64 or section == 65 or section == 80 or section == 81 then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 0.0)
            setShaderProperty('speed', 'effect', 0.5)
            bloomBurst(3, 3, 8)
            tweenShaderProperty('mirrorGame', 'zoom', 0.55, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', -0.1, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirrorGame', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*8, 'cubeOut')
        end
    elseif section == 67 or section == 83 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', -1, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 69 or section == 85 then 
        if secStep == 0 then 
            tweenShaderProperty('mirrorGame', 'zoom', 0.55, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', -0.9, crochet*0.001*8, 'cubeOut')
        end
    elseif section == 70 or section == 86 then 
        if secStep == 0 then 
            tweenShaderProperty('mirrorGame', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', -1.0, crochet*0.001*8, 'cubeOut')
        end

    elseif section == 71 or section == 87 then 

        if secStep == 0 then 
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'y', 1, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirrorGame', 'x', 0, crochet*0.001*4, 'cubeIn')
        elseif secStep == 8 then 
            tweenShaderProperty('mirrorGame', 'y', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 72 or section == 88 then 
        if secStep == 0 then 
            bloomBurst(3, 3, 8)
            tweenShaderProperty('mirrorGame', 'zoom', 0.55, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', -0.1, crochet*0.001*8, 'cubeOut')
        end
    elseif section == 76 or section == 92 then 
        if secStep == 0 then 
            tweenShaderProperty('mirrorGame', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*8, 'cubeOut')
        end

    elseif section == 78 or section == 94 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
        end
    end

    if section == 88 and secStep == 0 then 
        tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*8, 'cubeOut')
    elseif section == 92 and secStep == 0 then 
        tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
    end

    if (section >= 72 and section < 80) or (section >= 88 and section < 96) then 
        if secStep == 0 then 
            setShaderProperty('greyscale', 'strength', 0.0)
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
        end
    end

    if section == 64 or section == 80 or section == 69 or section == 88 or section == 90 or section == 93 then 
        if secStep == 0 then 
            tweenShaderProperty('mirrorGame', 'angle', -15.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirrorGame', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 65 or section == 81 or section == 89 or section == 91 then 
        if secStep == 0 then 
            tweenShaderProperty('mirrorGame', 'angle', 15.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirrorGame', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
        end
    end

    if section == 96 and secStep == 0 then 
        tweenShaderProperty('greyscale', 'strength', 0.5, crochet*0.001*8, 'cubeOut')
        setShaderProperty('speed', 'effect', 0.0)
        setShaderProperty('vhs', 'effect', 0.0)
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 98 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 100 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 101 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 102 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*8, 'cubeOut')
    elseif section == 102 and secStep == 8 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*8, 'cubeOut')
    elseif section == 103 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*4, 'cubeOut')
    elseif section == 103 and secStep == 4 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*4, 'cubeOut')
    elseif section == 104 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 106 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 108 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 109 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*16, 'cubeOut')
    elseif section == 110 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 15.0, crochet*0.001*8, 'cubeOut')
    elseif section == 110 and secStep == 8 then 
        tweenShaderProperty('mirror', 'angle', -15.0, crochet*0.001*8, 'cubeOut')
    elseif section == 111 and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'cubeOut')
    elseif section == 111 and secStep == 8 then 
        tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('mirror2', 'warp', -0.35, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('vhs', 'effect', 1.0, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
        tweenStageColorSwap('hue', 0.0, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('bars', 'effect', 0.3, crochet*0.001*8, 'cubeIn')
    elseif section == 114 and secStep == 0 then 
        tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*32, 'cubeIn')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*32, 'cubeIn')
        tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*32, 'cubeIn')
        tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*32, 'cubeIn')
    end

    if section == 114 or section == 115 then 
        if secStep == 0 then 
            setShaderProperty('mirrorGame', 'y', 0.0)
            tweenShaderProperty('mirrorGame', 'y', 2.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            setShaderProperty('mirrorGame', 'y', 0.0)
            tweenShaderProperty('mirrorGame', 'y', 2.0, crochet*0.001*8, 'cubeOut')
        end
    end

    if section == 118 and secStep == 0 then 
        tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
    elseif section == 119 and secStep == 0 then 
        tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('mirrorGame', 'angle', 360.0, crochet*0.001*32, 'cubeInOut')
    elseif section == 120 and secStep == 0 then 
        tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')

    elseif section == 122 and secStep == 0 then 
        tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
    elseif section == 123 and secStep == 0 then 
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'angle', 20.0, crochet*0.001*4, 'cubeOut')
    elseif section == 123 and secStep == 4 then 
        tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
    elseif section == 123 and secStep == 8 then 
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
    elseif section == 123 and secStep == 12 then 
        tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
    elseif section == 124 and secStep == 0 then 
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
    elseif section == 125 and secStep == 0 then 
        tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('mirror2', 'warp', -0.35, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('bars', 'effect', 0.3, crochet*0.001*16, 'cubeIn')
    elseif section == 127 and secStep == 0 then 
        tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*16, 'cubeIn')
    end

    if section == 126 or section == 127 then
        if secStep == 0 then 
            setShaderProperty('mirrorGame', 'y', 0.0)
            tweenShaderProperty('mirrorGame', 'y', 2.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            setShaderProperty('mirrorGame', 'y', 0.0)
            tweenShaderProperty('mirrorGame', 'y', 2.0, crochet*0.001*8, 'cubeOut')
        end
    end


    if section == 128 and secStep == 0 then 

        tweenShaderProperty('mirrorGame', 'zoom', 0.55, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirrorGame', 'x', -0.1, crochet*0.001*16, 'cubeOut')

        tweenShaderProperty('vignette', 'size', 0.5, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('vignette', 'strength', 8.0, crochet*0.001*16, 'cubeOut')
    elseif section == 136 and secStep == 0 then 
        tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirrorGame', 'zoom', 1.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirrorGame', 'x', 0.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('vignette', 'size', 0.25, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('vignette', 'strength', 15.0, crochet*0.001*16, 'cubeOut')
    end

    if section == 143 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
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
    tweenShaderProperty('bloom2', 'effect', 0.25, crochet*0.001*t, ease)
    tweenShaderProperty('bloom2', 'strength', 0.5, crochet*0.001*t, ease)
end

function doShake(steps, freq)
    triggerEvent('screen shake', (crochet*0.001*steps)..','..freq, (crochet*0.001*steps)..','..freq)
end