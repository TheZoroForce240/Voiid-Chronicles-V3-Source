
local startBF = ""
function createPost()
    startBF = player1

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    setShaderProperty('smoke', 'waveStrength', 0.0)
    setShaderProperty('smoke', 'smokeStrength', 0.5)

	initShader('wiggle', 'WiggleEffect')
    setCameraShader('game', 'wiggle')
    setCameraShader('hud', 'wiggle')
    setShaderProperty('wiggle', 'waveSpeed', 0.0)
    setShaderProperty('wiggle', 'waveFrequency', 1.0)
    setShaderProperty('wiggle', 'waveAmplitude', 0.0)


    initShader('sparks', 'SparkEffect')
    setCameraShader('hud', 'sparks')
    setShaderProperty('sparks', 'red', 1.0)
    setShaderProperty('sparks', 'green', 0.3)
    setShaderProperty('sparks', 'blue', 0.2)
    setShaderProperty('sparks', 'speed', 2.0)
    setShaderProperty('sparks', 'warp', -250.0)
    setShaderProperty('sparks', 'scale', 0.0)
    --setShaderProperty('sparks', 'waveAmplitude', 0.0)

    initShader('barrel', 'BarrelBlurEffect')
	setCameraShader('game', 'barrel')
	setCameraShader('hud', 'barrel')
	setShaderProperty('barrel', 'barrel', 0.0)
	setShaderProperty('barrel', 'zoom', 0.9)
	setShaderProperty('barrel', 'doChroma', true)

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
    if modcharts then 
        setCameraShader('hud', 'mirror')
    end
	setShaderProperty('mirror', 'zoom', 1.0)
    --setShaderProperty('mirror', 'x', -0.5)
    --setShaderProperty('mirror', 'warp', -0.1)
    --setShaderProperty('mirror', 'angle', 180)

    makeSprite('black', '', 0, 0, 1)
    setObjectCamera('black', 'hud')
    makeGraphic('black', 4000, 2000, '0xFF000000')
    actorScreenCenter('black')

    makeSprite('blackBG', '', 0, 0, 1)
	defaultZoom = getCamZoom()
    makeGraphic('blackBG', 1920/defaultZoom, 1080/defaultZoom, '0xFF000000')
	actorScreenCenter('blackBG')
	setActorScroll(0,0, 'blackBG')
	setActorAlpha(0, 'blackBG')
	
    local layerShit = getActorLayer('girlfriend')
	setActorLayer('blackBG', layerShit)



    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.0)
    setShaderProperty('bloom2', 'strength', 0.0)


    initShader('hudColorSwap', 'ColorSwapEffect')
    setCameraShader('hud', 'hudColorSwap')

    initShader('vignette', 'VignetteEffect')
    setCameraShader('hud', 'vignette')
    setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 15)
    setShaderProperty('vignette', 'size', 0.25)

    makeSprite('PhantomBF', 'PhantomBF',  getActorX('iconP1') + 150, getActorY('iconP1')-5000, 1)
    setActorScroll(0, 0, 'PhantomBF')
    setActorAlpha(0, 'PhantomBF')
    setObjectCamera('PhantomBF', "camHUD")

    tweenActorProperty('black', 'alpha', 0, 2.0, 'cubeInOut')
end
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local bfDuetFade = 0

local perlinSpeed = 1.5
					--p2          p1
					--x,y,z,angle,x,y,z,angle
local perlinTime = {0,0,0,0,0,0,0,0}

local perlinCamRange = {0.05,0.05,5,0}

function update(elapsed)

	for i = 1, #perlinTime do 
		perlinTime[i] = perlinTime[i] + elapsed*math.random()*perlinSpeed
	end

	setShaderProperty('barrel', 'x', ((-0.5 + perlin(perlinTime[1], 0, 0))*perlinCamRange[1]))
	setShaderProperty('barrel', 'y', ((-0.5 + perlin(0, perlinTime[2], 0))*perlinCamRange[2]))
	setShaderProperty('barrel', 'angle', ((-0.5 + perlin(0, 0, perlinTime[3]))*perlinCamRange[3]))
		
    if bfDuetFade > 0 then 
        bfDuetFade = bfDuetFade - elapsed
        if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
            setActorAlpha(0.7, 'bfCharacter1')

            setActorX(getActorX('iconP1') + 50, 'PhantomBF')
            setActorY(getActorY('iconP1') + -20, 'PhantomBF')
            setActorScaleX('PhantomBF', getActorScaleX('iconP1'))
            setActorScaleY('PhantomBF', getActorScaleY('iconP1'))
            updateHitbox('PhantomBF')
            setActorAlpha(getActorAlpha('bfCharacter1'), 'PhantomBF')
        end
    else 
        bfDuetFade = 0

        if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
            setActorAlpha(lerp(getActorAlpha('bfCharacter1'), 0, elapsed*10), 'bfCharacter1') --fade out
            setActorAlpha(getActorAlpha('bfCharacter1'), 'PhantomBF')
        else 
            setActorAlpha(0, 'PhantomBF')
        end
    end
end

function songStart()
    stepHit()
    
    
end

function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
    local secStep8 = curStep % 8
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32

    if secStep == 0 then 
        if section == 6 then 
            
            if not opponentPlay then 
                tweenShaderProperty('wiggle', 'waveAmplitude', 1, crochet*0.001*32, 'expoIn')
                tweenShaderProperty('barrel', 'barrel', -3, crochet*0.001*32, 'cubeIn')
            else 
                tweenShaderProperty('barrel', 'barrel', 3, crochet*0.001*32, 'cubeIn')
            end
            
        elseif section == 7 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
            if not opponentPlay then 
                tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*32, 'cubeInOut')
            end
        elseif section == 8 then 
            triggerEvent('Camera Flash','White','1')
            tweenShaderProperty('barrel', 'barrel', 0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0, crochet*0.001*4, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')


        elseif section == 70 then --first duet build up
            
            if not opponentPlay then 
                tweenShaderProperty('wiggle', 'waveAmplitude', 1, crochet*0.001*32, 'expoIn')
                tweenShaderProperty('barrel', 'barrel', -3, crochet*0.001*32, 'cubeIn')
            else 
                tweenShaderProperty('barrel', 'barrel', 3, crochet*0.001*32, 'cubeIn')
            end
        elseif section == 71 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
        elseif section == 72 then --first duet start
            tweenShaderProperty('barrel', 'barrel', 0.1, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0, crochet*0.001*4, 'cubeOut')

            tweenShaderProperty('sparks', 'scale', 1.2, crochet*0.001*16, 'cubeOut')
            tweenActorProperty('blackBG', 'alpha', 0.4, crochet*0.001*4, 'cubeOut')

            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            perlinCamRange = {0.1,0.1,10,0}
            perlinSpeed = 2.5

            
        elseif section == 104 then --first duet end
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            perlinCamRange = {0.0,0.0,0,0}
            perlinSpeed = 0.0
            tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('sparks', 'scale', 0.0, crochet*0.001*16, 'cubeOut')
            triggerEvent("change character", 'bf', startBF)


        elseif section == 178 then --second duet build up
            tweenShaderProperty('barrel', 'barrel', 3, crochet*0.001*32, 'cubeIn')
            if not opponentPlay then 
                tweenShaderProperty('wiggle', 'waveAmplitude', 1, crochet*0.001*32, 'expoIn')
            end
        elseif section == 179 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
        elseif section == 180 then --second duet start
            tweenShaderProperty('barrel', 'barrel', 0.1, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0, crochet*0.001*4, 'cubeOut')

            tweenShaderProperty('sparks', 'scale', 1.2, crochet*0.001*16, 'cubeOut')
            tweenActorProperty('blackBG', 'alpha', 0.4, crochet*0.001*4, 'cubeOut')

            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            perlinCamRange = {0.15,0.15,15,0}
            perlinSpeed = 2.5

        elseif section == 211 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('barrel', 'barrel', 4, crochet*0.001*16, 'cubeIn')
            tweenStageColorSwap('hue', -0.1, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('hudColorSwap', 'hue', -0.1, crochet*0.001*16, 'cubeIn')

        elseif section == 212 then
            bloomBurst(3, 3, 16, 'cubeOut')
            tweenShaderProperty('barrel', 'barrel', -0.1, crochet*0.001*8, 'cubeOut')

        elseif section == 244 then --second duet end
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            perlinCamRange = {0.0,0.0,0,0}
            perlinSpeed = 0.0
            tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('sparks', 'scale', 0.0, crochet*0.001*16, 'cubeOut')
            triggerEvent("change character", 'bf', startBF)
            tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('hudColorSwap', 'hue', 0.0, crochet*0.001*16, 'cubeOut')


        elseif section == 318 then --third duet build up
            tweenShaderProperty('barrel', 'barrel', 6, crochet*0.001*32, 'cubeIn')
            tweenStageColorSwap('hue', -0.1, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('hudColorSwap', 'hue', -0.1, crochet*0.001*32, 'cubeIn')
        elseif section == 319 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
        elseif section == 320 then --third duet start
            tweenShaderProperty('barrel', 'barrel', 0.25, crochet*0.001*8, 'cubeOut')

            tweenShaderProperty('sparks', 'scale', 1.2, crochet*0.001*16, 'cubeOut')
            tweenActorProperty('blackBG', 'alpha', 0.6, crochet*0.001*4, 'cubeOut')

            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(30*16, 0.008)
            perlinCamRange = {0.2,0.2,25,0}
            perlinSpeed = 3.5
            if keyCount == 4 then 
                triggerEvent('Change Scroll Speed','3.7','0')
            else 
                triggerEvent('Change Scroll Speed','3.2','0')
            end
            
        elseif section == 336 or section == 352 then
            bloomBurst(4, 4, 16, 'cubeOut')

        elseif section == 382 then
            tweenShaderProperty('bloom2', 'effect', 3, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 3, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('barrel', 'barrel', 4, crochet*0.001*32, 'cubeIn')
            if not opponentPlay then 
                tweenShaderProperty('wiggle', 'waveAmplitude', 1, crochet*0.001*32, 'expoIn')
            end
        elseif section == 383 then 
            if not opponentPlay then 
                tweenShaderProperty('mirror', 'angle', -360, crochet*0.001*32, 'cubeInOut')
            end
        elseif section == 384 then --third duet end
            bloomBurst(3, 3, 16, 'cubeOut')
            doShake(2, 0.01)
            perlinCamRange = {0.05,0.05,5,0}
            perlinSpeed = 1.5
            tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeOut')
            tweenShaderProperty('sparks', 'scale', 0.0, crochet*0.001*16, 'cubeOut')
            triggerEvent("change character", 'bf', startBF)
            tweenShaderProperty('barrel', 'barrel', 0.1, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0, crochet*0.001*4, 'cubeOut')
            triggerEvent('Camera Flash','White','1')
            
        elseif section == 112 or section == 252 then
            perlinCamRange = {0.05,0.05,5,0}
            perlinSpeed = 1.5
            bloomBurst(2, 2, 16, 'cubeOut')
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')
            doShake(2, 0.01)

        elseif section == 16 then --bloom
            bloomBurst(2, 2, 16, 'cubeOut')
        elseif section == 24 or section == 40 or section == 48 or section == 148 or section == 156 or section == 288 or section == 304 then --bloom with tilt
            bloomBurst(2, 2, 16, 'cubeOut')
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')
        elseif section == 32 or section == 88 or section == 140 or section == 196 or section == 280 or section == 296 then --bloom with tilt + shake
            bloomBurst(2, 2, 16, 'cubeOut')
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')
            doShake(2, 0.01)

        elseif section == 55 or section == 163 then 
            tweenShaderProperty('barrel', 'barrel', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*16, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*16, 'cubeIn')
        elseif section == 56 or section == 164 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('barrel', 'barrel', 0, crochet*0.001*8, 'cubeOut')
            doShake(2, 0.01)
        elseif section == 68 or section == 176 or section == 316 then 
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')

        elseif section == 128 or section == 268 then --fast shag sec
            doShake(32, 0.01)
            tweenShaderProperty('sparks', 'scale', 1.2, crochet*0.001*16, 'cubeOut')
        elseif section == 132 or section == 272 then
            tweenShaderProperty('sparks', 'scale', 0.0, crochet*0.001*16, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')

        elseif section == 400 then 
            bloomBurst(5, 5, 16, 'cubeOut')
        end
    end



    if (section >= 0 and section < 8) or (section >= 108 and section < 112) or (section >= 248 and section < 252) or (section >= 392 and section < 400) then --slow bump
        if secStep == 0 then 
            tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
        end
    end

    if (section >= 8 and section < 104) or (section >= 112 and section < 244) or (section >= 252 and section < 392)  then --bump
        if secStep8 == 0 then
            tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep8 == 4 then
            tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
        end
    end


    if section == 11 or section == 59 or section == 135 or section == 167 or section == 307 then --shake matt
        if secStep8 == 0 then 
            doShake(6, 0.01)
        end
    end

    if section == 15 or section == 35 or section == 43 or section == 47 or section == 143 or section == 151 or section == 155 or section == 283 or section == 291 or section == 295 then --zoom out and back
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        end
    end

    if section == 27 or section == 275 then --shake and zoom
        if secStep == 0 then 
            doShake(12, 0.01)
            tweenShaderProperty('mirror', 'zoom', 1.2, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        end
    end

    
    if section == 31 or section == 67 or section == 139 or section == 175 or section == 279 or section == 315 then --tilt
        if secStep == 0 then 
            setAndEaseBackShader('mirror', 'angle', -20, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            setAndEaseBackShader('mirror', 'angle', 20, crochet*0.001*8, 'cubeOut')
        end
    end


    if section == 104 or section == 244 then 
        if secStep == 0 then 
            tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001*8, 'elasticOut')
        elseif secStep == 8 then 
            tweenShaderProperty('barrel', 'zoom', 3, crochet*0.001*8, 'elasticOut')
        end
    elseif section == 105 or section == 245 then 
        if secStep == 0 then 
            tweenShaderProperty('barrel', 'zoom', 4, crochet*0.001*8, 'elasticOut')
        elseif secStep == 8 then 
            tweenShaderProperty('barrel', 'zoom', 5, crochet*0.001*8, 'elasticOut')
        end
    elseif section == 106 or section == 246 then 
        if secStep == 8 then 
            tweenShaderProperty('barrel', 'zoom', 4, crochet*0.001, 'cubeOut')
        elseif secStep == 9 then 
            tweenShaderProperty('barrel', 'zoom', 3, crochet*0.001, 'cubeOut')
        elseif secStep == 10 then 
            tweenShaderProperty('barrel', 'zoom', 2, crochet*0.001, 'cubeOut')
        elseif secStep == 11 then 
            tweenShaderProperty('barrel', 'zoom', 1.5, crochet*0.001, 'cubeOut')
        end
    elseif section == 107 or section == 247 then 
        if secStep == 0 then 
            tweenShaderProperty('barrel', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
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

function playerTwoSing1(data, time, type)
	if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
		FDGODMattTrail(data)
	end
end

function playerTwoSingHeld1(data, time, type)
	if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
		FDGODMattTrail(data)
	end
end

function playerTwoSing0(data, time, type)
	if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
		--FDGODShagTrail(data)
	end
end

function playerTwoSingHeld0(data, time, type)
	if getProperty('boyfriend', 'curCharacter') == 'DuetBF' then 
		--FDGODShagTrail(data)
	end
end

function playerOneSing1(data, time, type)
    bfDuetFade = 1
end

function playerOneSingHeld1(data, time, type)
    bfDuetFade = 1
end


local trailCount = 0
local trailLimit = 150
function FDGODMattTrail(data)
    destroySprite('trail'..trailCount)
    makeSpriteCopy('trail'..trailCount, 'dadCharacter1')
    tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
    tweenScaleX('trail'..trailCount, 4, crochet*0.001*16, 'cubeInOut', 'trailFinish')
    tweenScaleY('trail'..trailCount, 4, crochet*0.001*16, 'cubeInOut')
    tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
	--setActorShader('trail'..trailCount, 'colorShit')
    local angle = data*(math.pi/2)
    tweenActorProperty('trail'..trailCount, 'x', 150*math.sin(angle), crochet*0.001*16, 'cubeIn')
    tweenActorProperty('trail'..trailCount, 'y', 150*math.cos(angle), crochet*0.001*16, 'cubeIn')
    setActorLayer('trail'..trailCount, getActorLayer('dadCharacter1')-1)
    trailCount = trailCount + 1
    if trailCount >= trailLimit then 
        trailCount = 0
    end
end
function FDGODShagTrail(data)
    destroySprite('trail'..trailCount)
    makeSpriteCopy('trail'..trailCount, 'dadCharacter0')
    tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
    tweenScaleX('trail'..trailCount, 4, crochet*0.001*16, 'cubeInOut', 'trailFinish')
    tweenScaleY('trail'..trailCount, 4, crochet*0.001*16, 'cubeInOut')
    tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
	--setActorShader('trail'..trailCount, 'colorShit')
    local angle = data*(math.pi/2)
    tweenActorProperty('trail'..trailCount, 'x', 150*math.sin(angle), crochet*0.001*16, 'cubeIn')
    tweenActorProperty('trail'..trailCount, 'y', 150*math.cos(angle), crochet*0.001*16, 'cubeIn')
    setActorLayer('trail'..trailCount, getActorLayer('dadCharacter0')-1)
    trailCount = trailCount + 1
    if trailCount >= trailLimit then 
        trailCount = 0
    end
end