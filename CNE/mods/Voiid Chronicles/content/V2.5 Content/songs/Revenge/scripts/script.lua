function createPost()

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    setShaderProperty('smoke', 'waveStrength', 0.0)
    setShaderProperty('smoke', 'smokeStrength', 0.2)

    initShader('blur', 'BlurEffect')
    setCameraShader('game', 'blur')
    setCameraShader('hud', 'blur')
    setShaderProperty('blur', 'strength', 10)

    initShader('blur2', 'BlurEffect')
    setCameraShader('game', 'blur2')
    setCameraShader('hud', 'blur2')
    setShaderProperty('blur2', 'strengthY', 10)

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
    if modcharts then 
        setCameraShader('hud', 'mirror')
    end
	setShaderProperty('mirror', 'zoom', 1.5)
    setShaderProperty('mirror', 'angle', -50)

    makeSprite('white', '', 0, 0, 1)
    setObjectCamera('white', 'other')
    makeGraphic('white', 4000, 2000, '0xFFFFFFFF')
    setActorProperty('white', 'alpha', 0)
    actorScreenCenter('white')

    makeSprite('black', '', 0, 0, 1)
    setObjectCamera('black', 'other')
    makeGraphic('black', 4000, 2000, '0xFF000000')
    actorScreenCenter('black')



    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

    initShader('ca2', 'ChromAbEffect')
    setCameraShader('game', 'ca2')
    setCameraShader('hud', 'ca2')
    setShaderProperty('ca2', 'strength', 0.0)


    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.25)
    setShaderProperty('bloom2', 'strength', 0.25)



    initShader('scanline', 'ScanlineEffect')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 0)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 10)

    setStageColorSwap('hue', 0.1)

end

function songStart()
    stepHit()

    tweenActorProperty('black', 'alpha', 0, crochet*0.001*64*1.5, 'cubeInOut')
    tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*64*1.5, 'cubeOut')
    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*64*1.5, 'cubeOut')
    tweenShaderProperty('grey', 'strength', 0, crochet*0.001*64*1.5, 'cubeOut')

    tweenShaderProperty('blur', 'strength', 0, crochet*0.001*64*2, 'cubeOut')
    tweenShaderProperty('blur2', 'strengthY', 0, crochet*0.001*64*2, 'cubeOut')
end
local curHue = 0.1



function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32

    if section == 9 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            bloomBurst(1.5, 1.5, 4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 2, crochet*0.001*2, 'cubeOut')
            bloomBurst(1.5, 1.5, 4, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 10 and secStep == 0 then 
        bloomBurst(2.5, 2.5, 4, 'cubeOut')
    end

    --[[if section >= 10 and curStep <= 280 then 
        if secStep == 0 or secStep == 6 or secStep == 10 then 
            bumpStart(2)
        elseif secStep == 2 or secStep == 8 or secStep == 12 then 
            bumpEnd(2)
        end
    end]]--


    if section == 14 and secStep == 12 then 
        angleBump(30, 4)
    elseif section == 15 and secStep == 0 then 
        angleBump(-30, 4)
    end

    
    if section == 18 and secStep == 8 then 
        angleBump(30, 4)
    elseif section == 18 and secStep == 12 then 
        angleBump(-30, 4)
    end

    if section == 20 and secStep == 12 then 
        angleBump(30, 4)
    end


    if section == 17 then 
        if secStep == 0 then 
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*12, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*2, 'cubeIn')
        end
    elseif (section == 18 or section == 22) and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        bloomBurst(2.5, 2.5, 16, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
    elseif section == 19 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 21 then 

        if secStep == 4 or secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 20, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 or secStep == 10 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*2, 'cubeOut')
        end

    elseif section == 23 then 
        if secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end

        if secStep == 8 then 
            angleBump(30, 3)
        elseif secStep == 11 then 
            angleBump(-30, 3)
        elseif secStep == 14 then 
            angleBump(30, 2)
        end
    elseif section == 24 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        end
    elseif section == 25 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeInOut')
            tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*8, 'cubeInOut')
        end
    elseif section == 26 then 
        if secStep == 0 then 
            bloomBurst(2.5, 2.5, 16, 'cubeOut')

            

            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        end
    end


    if section == 27 then 
        if secStep == 4 or secStep == 12 then 
            angleBump(30, 4)
        elseif secStep == 8 then 
            angleBump(-30, 4)
        end
    elseif section == 28 and secStep == 0 then 

        angleBump(-30, 4)

    elseif section == 30 and secStep == 0 then 
        angleBump(30, 4)
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*48, 'cubeInOut')
    elseif section == 31 and secStep == 0 then 
        angleBump(-30, 4)
    elseif section == 32 and secStep == 0 then 
        angleBump(30, 4)
    elseif section == 33 and secStep == 0 then 
        tweenShaderProperty('mirror', 'zoom', 10, crochet*0.001*16, 'expoIn')
        tweenShaderProperty('mirror', 'angle', 60, crochet*0.001*16, 'expoIn')
        tweenShaderProperty('ca2', 'strength', 0.01, crochet*0.001*16, 'cubeIn')

        tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*16, 'cubeIn')

    elseif section == 34 and secStep == 0 then
        setStageColorSwap('hue', 0.0) 
        setShaderProperty('mirror', 'zoom', 1.5)
        tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('ca2', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        bloomBurst(2.5, 2.5, 16, 'cubeOut')
    end


    if section == 35 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        elseif secStep == 12 then 
            angleBump(30, 4)
        end
    elseif section == 36 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        end
    elseif section == 38 then 
        if secStep == 0 then 
            angleBump(30, 4)
        elseif secStep == 14 then 
            angleBump(-30, 2)
        end
    elseif section == 39 then 
        if secStep == 0 then 
            angleBump(30, 4)
        elseif secStep == 12 then 
            angleBump(-30, 4)
        end
    elseif section == 40 then 
        if secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 3, crochet*0.001*2, 'cubeIn')
        elseif secStep == 0 then 
            angleBump(30, 4)
        end
    elseif section == 41 then 
        if secStep == 0 then 
            setShaderProperty('bloom2', 'effect', 1.0)
            setShaderProperty('bloom2', 'strength', 1.0)
            setShaderProperty('grey', 'strength', 1.0)
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16, 'cubeOut')
        end
    elseif section == 42 then 
        if secStep == 0 then 
            setProperty('camGame', 'alpha', 1)
            angleBump(-30, 4)
            bloomBurst(2.5, 2.5, 16, 'cubeOut')
        end
    end


    if section == 46 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*64, 'cubeIn')
    elseif section == 49 then 
        if secStep == 0 then 
            tweenShaderProperty('ca2', 'strength', 0.01, crochet*0.001*12, 'cubeIn')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*12, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*12, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*12, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeIn')
        end
    end

    if section >= 46 and section < 49 then 
        if secStep == 4 then 
            angleBump(30, 4)
        elseif secStep == 12 then 
            angleBump(-30, 4)
        end
    end


    if section == 50 then 
        if secStep == 0 then 
            bloomBurst(1, 1, 4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            angleBump(30, 4)
        elseif secStep == 4 then 
            angleBump(-30, 4)
        end

    elseif section == 51 or section == 52 then 
        if secStep == 4 then 
            angleBump(30, 4)
        elseif secStep == 8 then 
            angleBump(-30, 4)
        end
    elseif section == 53 then 
        if secStep == 2 then 
            angleBump(30, 2)
        elseif secStep == 4 then 
            angleBump(-30, 2)
        elseif secStep == 6 then 
            angleBump(30, 2)
        elseif secStep == 8 then 
            angleBump(-30, 2)
        elseif secStep == 12 then 
            angleBump(30, 4)
        end
    elseif section == 54 or section == 55 or section == 57 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        elseif secStep == 4 then 
            angleBump(30, 4)
        end
    elseif section == 56 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        elseif secStep == 4 then 
            angleBump(30, 4)
        elseif secStep == 8 then 
            angleBump(-30, 4)
        elseif secStep == 12 then 
            angleBump(30, 4)
        end
    end


    if section == 57 then 
        if secStep == 0 then 
            tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*8, 'cubeIn')
        elseif secStep == 8 then 
            bloomBurst(2, 2, 8, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
            tweenActorProperty('white', 'alpha', 1.0, crochet*0.001*8, 'cubeOut')
            tweenActorProperty('black', 'alpha', 1.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 58 then 
        if secStep == 8 then 
            tweenActorProperty('black', 'alpha', 0.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 59 then 
        if secStep == 0 then 
            setAndEaseBackToShader('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut', 1.0)
            tweenActorProperty('white', 'alpha', 0.0, crochet*0.001*1, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')
            setStageColorSwap('hue', 0.1)
        end
    end

    --repeat--

    local offset = 49

    if section-offset == 14 and secStep == 12 then 
        angleBump(30, 4)
    elseif section-offset == 15 and secStep == 0 then 
        angleBump(-30, 4)
    end

    
    if section-offset == 18 and secStep == 8 then 
        angleBump(30, 4)
    elseif section-offset == 18 and secStep == 12 then 
        angleBump(-30, 4)
    end

    if section-offset == 20 and secStep == 12 then 
        angleBump(30, 4)
    end


    if section-offset == 17 then 
        if secStep == 0 then 
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*12, 'cubeIn')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*2, 'cubeIn')
        end
    elseif (section-offset == 18 or section-offset == 22) and secStep == 0 then 
        tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        bloomBurst(2.5, 2.5, 16, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
    elseif section-offset == 19 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 2 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end
    elseif section-offset == 21 then 

        if secStep == 4 or secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 20, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 or secStep == 10 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -20, crochet*0.001*2, 'cubeOut')
        end

    elseif section-offset == 23 then 
        if secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end

        if secStep == 8 then 
            angleBump(30, 3)
        elseif secStep == 11 then 
            angleBump(-30, 3)
        elseif secStep == 14 then 
            angleBump(30, 2)
        end
    elseif section-offset == 24 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        end
    elseif section-offset == 25 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeInOut')
            tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('grey', 'strength', 1, crochet*0.001*8, 'cubeInOut')
        end
    elseif section-offset == 26 then 
        if secStep == 0 then 
            bloomBurst(2.5, 2.5, 16, 'cubeOut')

            

            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            setStageColorSwap('hue', 0.0)
        end
    end

    -------------


    if section == 82 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('bloom2', 'effect', 2.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 2.0, crochet*0.001*16, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 83 then 
        if secStep == 0 then 
            bloomBurst(2.5, 2.5, 16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 85 then 
        if secStep == 0 then 
            angleBump(-30, 4)
        elseif secStep == 12 then 
            angleBump(30, 2)
        elseif secStep == 14 then 
            angleBump(-30, 2)
        end
    elseif section == 86 then 
        if secStep == 4 then 
            angleBump(30, 4)
        elseif secStep == 12 then 
            angleBump(-30, 2)
        elseif secStep == 14 then 
            angleBump(30, 2)
        end
    elseif section == 87 then 
        if secStep == 8 then 
            angleBump(-30, 4)
            tweenShaderProperty('bloom2', 'effect', 0.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 0.5, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 88 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 6 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 89 then
        if secStep == 0 then 
            angleBump(30, 4)
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 3.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 90 then 
        if secStep == 0 then 
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16, 'cubeOut')
        end
    elseif section == 91 then 
        if secStep == 0 then 
            setProperty('camGame', 'alpha', 1)
            bloomBurst(2.5, 2.5, 16, 'cubeOut')
            tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            setStageColorSwap('hue', 0.1)
        elseif secStep == 12 then 
            angleBump(30, 4)
        end
    elseif section == 92 then 

        if secStep == 0 then 
            angleBump(-30, 4)
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*16*7, 'linear')
        end

    elseif section == 98 then 

        if secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', -360.0, crochet*0.001*8, 'cubeInOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 99 then 

        if secStep == 0 then 
            tweenShaderProperty('scanline', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bloom2', 'effect', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('bloom2', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            angleBump(30, 4)
        end

    elseif section == 101 then 

        if secStep == 8 then 
            angleBump(-30, 4)
        elseif secStep == 12 then 
            angleBump(30, 4)
        end
    end

    if section >= 99 and section < 103 then 
        if curStep % 4 == 0 then 
            bumpStart(2)
        elseif curStep % 4 == 2 then 
            bumpEnd(2)
        end
    end
    if section >= 103 and section < 106 then 
        if curStep % 2 == 0 then 
            bumpStart(1)
        elseif curStep % 2 == 1 then 
            bumpEnd(1)
        end
    end
    if section == 106 then 
        triggerEvent('add camera zoom', 0.04, 0.04)
    end

    if section == 107 then
        if secStep == 0 then 
            tweenShaderProperty('scanline', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')
        end

        if secStep == 8 or secStep == 12 then 
            bumpStart(2)
        elseif secStep == 10 or secStep == 14 then 
            bumpEnd(2)
        end

    end
    if section == 108 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 0.2, crochet*0.001*4, 'cubeOut')
        bloomBurst(2, 2, 16, 'cubeOut')
    end

    if section == 111 and secStep == 12 then 
        tweenActorProperty('black', 'alpha', 1.0, crochet*0.001*4, 'cubeIn')
    end
   
end

function bumpStart(s)
    tweenShaderProperty('mirror', 'zoom', 0.9, crochet*0.001*s, 'cubeOut')
end
function bumpEnd(s)
    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*s, 'cubeIn')
end

function angleBump(ang, t)
    setAndEaseBackShader('mirror', 'angle', ang, crochet*0.001*t, 'cubeOut')
    setAndEaseBackShader('ca2', 'strength', 0.01, crochet*0.001*t, 'cubeOut')
end

function doShake(steps, freq)
    triggerEvent('screen shake', (crochet*0.001*steps)..','..freq, (crochet*0.001*steps)..','..freq)
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

local flicker = true
function onEvent(tag, time, val1, val2)
    if string.lower(tag) == 'add camera zoom' then 
        if (section >= 40 and section <= 42) or (section >= 89 and section <= 91) then 
            if flicker then 
                setProperty('camGame', 'alpha', 0)
            else
                setProperty('camGame', 'alpha', 1)
            end
            flicker = not flicker
        end
    end
end