--the funny
function createPost()

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    if modcharts then 
        setCameraShader('hud', 'smoke')
	end
    setShaderProperty('smoke', 'waveStrength', 0.1)
    setShaderProperty('smoke', 'smokeStrength', 0.4)

	initShader('barrel', 'MirrorRepeatEffect')
	setCameraShader('game', 'barrel')
    if modcharts then 
		setCameraShader('hud', 'barrel')
	end
	setShaderProperty('barrel', 'zoom', 1.5)

    initShader('sobel', 'SobelEffect')

    initShader('sobelHUD', 'SobelEffect')

    setCameraShader('game', 'sobel')
    if modcharts then 
        --setCameraShader('hud', 'sobelHUD')
	end
    setShaderProperty('sobel', 'strength', 0)
    setShaderProperty('sobel', 'intensity', 2)
    --setShaderProperty('sobelHUD', 'strength', 0.2)
   -- setShaderProperty('sobelHUD', 'intensity', 0.5)
    --setShaderProperty('sobel', 'strength', 0.7)
    --setShaderProperty('sobel', 'intensity', 2)



    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0)
    setShaderProperty('bloom2', 'strength', 0)

    initShader('pixel', 'MosaicEffect')
    setCameraShader('game', 'pixel')
    setCameraShader('hud', 'pixel')
    setShaderProperty('pixel', 'strength', 40)

    
    initShader('color', 'ColorOverrideEffect')
    setCameraShader('game', 'color')
    if modcharts then 
        setCameraShader('hud', 'color')
	end
    --setShaderProperty('color', 'green', 0.3)

    initShader('caBlue', 'ChromAbBlueSwapEffect')
    setCameraShader('game', 'caBlue')
    setCameraShader('hud', 'caBlue')
    --setShaderProperty('caBlue', 'strength', -0.001)
    setShaderProperty('caBlue', 'strength', 0.0)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

    
    initShader('barrelChroma', 'BarrelBlurEffect')
	setCameraShader('game', 'barrelChroma')
	setCameraShader('hud', 'barrelChroma')
	setShaderProperty('barrelChroma', 'zoom', 1.0)
    setShaderProperty('barrelChroma', 'barrel', 0.3)
    setShaderProperty('barrelChroma', 'doChroma', true)

    initShader('scanline', 'ScanlineEffect')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 1)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 5)

    --[[initShader('vignette', 'VignetteEffect')
    setCameraShader('hud', 'vignette')
    setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 10)
    setShaderProperty('vignette', 'size', 0.5)]]--


end

function songStart()
    --intro
    setShaderProperty('color', 'red', 1.0)
    setShaderProperty('color', 'green', 1.0)
    setShaderProperty('color', 'blue', 1.0)
    tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*32, 'cubeInOut')
    tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*32, 'cubeInOut')

    tweenShaderProperty('smoke', 'waveStrength', 0.01, crochet*0.001*40, 'cubeInOut')
end

function stepHit()

    if curStep == 112 then 
        tweenShaderProperty('barrel', 'zoom', 3, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('pixel', 'strength', 50, crochet*0.001*16, 'cubeIn')

        if not opponentPlay then 
            tweenShaderProperty('color', 'red', 0, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('color', 'green', 0, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('color', 'blue', 0, crochet*0.001*16, 'cubeIn')
        end

    elseif curStep == 128 then 
        setShaderProperty('caBlue', 'strength', -0.001)
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*16*7, 'linear')
        tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*4, 'cubeOut')

        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*16*8, 'cubeInOut')
        tweenShaderProperty('color', 'red', 0.9, crochet*0.001*16*7, 'cubeInOut')
        tweenShaderProperty('color', 'green', 1.25, crochet*0.001*16*7, 'cubeInOut')
        tweenShaderProperty('color', 'blue', 0.9, crochet*0.001*16*7, 'cubeInOut')
    end

    --cam zooms
    if curStep >= 128 and curStep < 256 then 
        if curStep % 4 == 0 then 
            triggerEvent('add camera zoom', 0.15, 0.08)
        end
    end
    if (curStep >= 256 and curStep < 384) or (curStep >= 512 and curStep < 640) or (curStep >= 1152 and curStep < 1216) then 
        if curStep % 32 == 0 or curStep % 32 == 24 then 
            triggerEvent('add camera zoom', 0.15, 0.08)
        end
        if curStep % 16 == 8 or curStep % 64 == 46 or curStep % 64 == 62 then 
            triggerEvent('add camera zoom', 0.08, 0.15)
        end
    end
    if (curStep >= 384 and curStep < 512) then 
        if curStep % 16 == 0 or curStep % 16 == 10 then 
            triggerEvent('add camera zoom', 0.15, 0.08)
        end
        if curStep % 8 == 4 then 
            triggerEvent('add camera zoom', 0.08, 0.15)
        end
    end
    if (curStep >= 640 and curStep < 704) then 
        if curStep % 8 == 0 then 
            triggerEvent('add camera zoom', 0.15, 0.08)
        end
        if curStep % 8 == 4 then 
            triggerEvent('add camera zoom', 0.08, 0.15)
        end
    end
    if (curStep >= 704 and curStep < 768) then 
        if curStep % 32 == 0 or curStep % 32 == 24 then 
            --triggerEvent('add camera zoom', 0.15, 0.08)
        end
        if curStep % 16 == 8 or curStep % 64 == 46 or curStep % 64 == 62 then 
            triggerEvent('add camera zoom', 0.08, 0.15)
        end
    end


    if curStep == 252 then 
        tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', -40, crochet*0.001*3, 'cubeOut')
    elseif curStep == 255 then 
        tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001, 'cubeIn')
        tweenShaderProperty('barrel', 'angle', 30, crochet*0.001, 'cubeIn')
    elseif curStep == 256 then 
        bloomBurst()
        tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 320 then 
        bloomBurst()
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')
    elseif curStep == 348 or curStep == 396 or curStep == 416 or curStep == 448 or curStep == 480 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    elseif curStep == 352 or curStep == 412 or curStep == 428 or curStep == 464 or curStep == 472 or curStep == 504 then 
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    end

    if curStep == 380 then 
        tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 40, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 1, crochet*0.001*3, 'cubeOut')
    elseif curStep == 383 then 
        tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001, 'cubeIn')
        tweenShaderProperty('barrel', 'angle', -30, crochet*0.001, 'cubeIn')
    elseif curStep == 384 then 
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
        bloomBurst()
        tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')

        tweenShaderProperty('barrelChroma', 'barrel', 0.5, crochet*0.001*8, 'cubeOut')
        setShaderProperty('caBlue', 'strength', -0.003)
        tweenShaderProperty('smoke', 'waveStrength', 0.025, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 508 then 
        tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 1, crochet*0.001*3, 'cubeOut')
    elseif curStep == 511 then 
        tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001, 'cubeIn')
        tweenShaderProperty('barrel', 'angle', -30, crochet*0.001, 'cubeIn')
    elseif curStep == 512 then 
        bloomBurst()
        tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')

        tweenShaderProperty('barrelChroma', 'barrel', 0.3, crochet*0.001*8, 'cubeOut')
        setShaderProperty('caBlue', 'strength', -0.003)
        tweenShaderProperty('smoke', 'waveStrength', 0.01, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 636 then 
        tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 40, crochet*0.001*3, 'cubeOut')
    elseif curStep == 639 then 
        tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001, 'cubeIn')
        tweenShaderProperty('barrel', 'angle', -30, crochet*0.001, 'cubeIn')
    elseif curStep == 640 then 
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeOut')
        bloomBurst()
        tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')

        tweenShaderProperty('barrelChroma', 'barrel', 0.5, crochet*0.001*8, 'cubeOut')
        setShaderProperty('caBlue', 'strength', -0.003)
        tweenShaderProperty('smoke', 'waveStrength', 0.025, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 764 then 
        tweenShaderProperty('barrel', 'zoom', 1.5, crochet*0.001*3, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 1, crochet*0.001*3, 'cubeOut')
    elseif curStep == 767 then 
        tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001, 'cubeIn')
    elseif curStep == 768 then 
        bloomBurst()
        tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')

        tweenShaderProperty('barrelChroma', 'barrel', 0.3, crochet*0.001*8, 'cubeOut')
        setShaderProperty('caBlue', 'strength', -0.003)
        tweenShaderProperty('smoke', 'waveStrength', 0.01, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 880 then 
        tweenShaderProperty('barrel', 'angle', -10, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('barrel', 'zoom', 1.2, crochet*0.001*4, 'backIn')
    elseif curStep == 884 then 
        tweenShaderProperty('barrel', 'angle', -20, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('barrel', 'zoom', 1.4, crochet*0.001*4, 'backIn')
    elseif curStep == 888 then 
        tweenShaderProperty('barrel', 'angle', -40, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('barrel', 'zoom', 1.6, crochet*0.001*4, 'backIn')
    elseif curStep == 892 then 
        tweenShaderProperty('barrel', 'angle', -360, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*4, 'backIn')
        tweenShaderProperty('color', 'red', 0, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('color', 'green', 0, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('color', 'blue', 0, crochet*0.001*4, 'cubeIn')
    elseif curStep == 896 then 
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.5, 'cubeOut')
        tweenShaderProperty('color', 'green', 0.6, crochet*0.001*1, 'cubeOut')
        tweenShaderProperty('sobel', 'strength', 0.6, crochet*0.001*1, 'cubeOut')
        tweenShaderProperty('sobelHUD', 'strength', 0.1, crochet*0.001*1, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*1, 'cubeOut')
        tweenShaderProperty('smoke', 'waveStrength', 0.025, crochet*0.001*8, 'cubeOut')
    end

    if curStep == 648 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    elseif curStep == 656 then 
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    elseif curStep == 664 then 
        setShaderProperty('barrel', 'angle', -30)
        setShaderProperty('barrel', 'zoom', 1.5)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.5, 'cubeIn')
    end

    if curStep >= 668 and curStep < 672 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', -20, crochet*0.001, 'cubeOut')
    end
    if curStep == 672 then 
        bloomBurst()
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    end

    if curStep == 680 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    elseif curStep == 683 or curStep == 716 or curStep == 736 then 
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    elseif curStep == 686 or curStep == 704 or curStep == 732 or curStep == 748 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    end

    if curStep == 688 then 
        tweenShaderProperty('barrel', 'zoom', 1.3, crochet*0.001*3.5, 'cubeOut')
    elseif curStep == 692 then 
        tweenShaderProperty('barrel', 'zoom', 1.6, crochet*0.001*3.5, 'cubeOut')
    elseif curStep == 696 then 
        tweenShaderProperty('barrel', 'zoom', 1.3, crochet*0.001*3.5, 'cubeOut')
    elseif curStep == 700 then 
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.5, 'cubeOut')
        setShaderProperty('barrel', 'angle', 360)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeIn')
    end

    if curStep == 912 then 
        setShaderProperty('pixel', 'strength', 40)
        setShaderProperty('barrel', 'angle', 90)
        setShaderProperty('barrel', 'zoom', 2.5)
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*7.5, 'cubeIn')
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*8, 'cubeOut')
    elseif curStep == 924 then 
        tweenShaderProperty('barrel', 'zoom', 2.5, crochet*0.001*3.5, 'cubeIn')
    end

    if curStep == 928 then 
        setShaderProperty('barrel', 'angle', 30)
        setShaderProperty('barrel', 'zoom', 1)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*4, 'cubeOut')
    elseif curStep == 934 or curStep == 939 then 
        setShaderProperty('barrel', 'zoom', 0.8)
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.5, 'cubeOut')
    end

    if curStep == 944 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    elseif curStep == 947 then 
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    elseif curStep == 950 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    end

    if curStep == 952 then 
        setShaderProperty('barrel', 'zoom', 0.8)
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.5, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeIn')
    end
    if curStep == 956 then 
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeIn')
        setShaderProperty('barrel', 'angle', 0)
        tweenShaderProperty('barrel', 'angle', 360, crochet*0.001*4, 'cubeIn')
    end

    if curStep == 968 then 
        setShaderProperty('barrel', 'angle', 0)
        tweenShaderProperty('barrel', 'angle', 45, crochet*0.001*15, 'cubeIn')
        tweenShaderProperty('color', 'green', 0.05, crochet*0.001*15, 'cubeIn')
    elseif curStep == 968+4 then 
        --tweenShaderProperty('barrel', 'angle', -20, crochet*0.001*4, 'cubeIn')
    elseif curStep == 968+8 then 
        --tweenShaderProperty('barrel', 'angle', -30, crochet*0.001*4, 'cubeIn')
    elseif curStep == 968+12 then 
        --tweenShaderProperty('barrel', 'angle', -40, crochet*0.001*4, 'cubeIn')
    elseif curStep == 968+16 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
        setShaderProperty('color', 'green', 0.6)
    end

    if curStep == 1000 then 
        tweenShaderProperty('barrel', 'angle', -90, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('color', 'green', 0, crochet*0.001*16, 'cubeIn')
        tweenShaderProperty('pixel', 'strength', 40, crochet*0.001*16, 'cubeIn')
    elseif curStep == 1000+4 then 
        --tweenShaderProperty('barrel', 'angle', 20, crochet*0.001*4, 'cubeIn')
    elseif curStep == 1000+8 then 
        --tweenShaderProperty('barrel', 'angle', 30, crochet*0.001*4, 'cubeIn')
    elseif curStep == 1000+12 then 
        --tweenShaderProperty('barrel', 'angle', 40, crochet*0.001*4, 'cubeIn')
    elseif curStep == 1000+16 then 

    end

    if curStep == 1024 then 
        setShaderProperty('barrel', 'zoom', 2)
        setShaderProperty('barrel', 'angle', 0)
        setShaderProperty('grey', 'strength', 1)
        setShaderProperty('pixel', 'strength', 0)
        setShaderProperty('sobel', 'strength', 0)
        setShaderProperty('sobelHUD', 'strength', 0)
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*4, 'linear')
        tweenShaderProperty('color', 'red', 0.9, crochet*0.001*16*3, 'cubeInOut')
        tweenShaderProperty('color', 'green', 1.25, crochet*0.001*16*3, 'cubeInOut')
        tweenShaderProperty('color', 'blue', 0.9, crochet*0.001*16*3, 'cubeInOut')
    end

    if curStep == 1092 or curStep == 1099 or curStep == 1104 or curStep == 1116 or curStep == 1124 or curStep == 1131 or curStep == 1136 or curStep == 1148 then 
        setShaderProperty('barrel', 'angle', -30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    elseif curStep == 1096 or curStep == 1102 or curStep == 1110 or curStep == 1120 or curStep == 1128 or curStep == 1134 or curStep == 1142 then 
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    end

    if curStep == 1152 then 
        bloomBurst()
        setShaderProperty('grey', 'strength', 0)
        setShaderProperty('barrel', 'angle', 30)
        tweenShaderProperty('barrel', 'angle', 0, crochet*0.001*3, 'cubeOut')
    end
    if curStep == 1248 then 
        bloomBurst()
    end
    if curStep == 1268 then
        tweenShaderProperty('color', 'red', 0, crochet*0.001*16, 'cubeInOut')
        tweenShaderProperty('color', 'green', 0, crochet*0.001*16, 'cubeInOut')
        tweenShaderProperty('color', 'blue', 0, crochet*0.001*16, 'cubeInOut')
    end
end

function bloomBurst()
    setShaderProperty('bloom2', 'effect', 0.25)
    setShaderProperty('bloom2', 'strength', 3)
    setShaderProperty('ca', 'strength', 0.005)
    tweenShaderProperty('bloom2', 'effect', 0, crochet*0.001*16, 'cubeOut')
    tweenShaderProperty('bloom2', 'strength', 0, crochet*0.001*16, 'cubeOut')
    tweenShaderProperty('ca', 'strength', 0, crochet*0.001*16, 'cubeOut')
end