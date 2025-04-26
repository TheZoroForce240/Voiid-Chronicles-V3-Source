
local startBF = ""
function createPost()
    startBF = player1

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    setShaderProperty('smoke', 'waveStrength', 0.0)
    setShaderProperty('smoke', 'smokeStrength', 0.7)

    initShader('sparks', 'SparkEffect')
    setCameraShader('hud', 'sparks')
    setShaderProperty('sparks', 'red', 1.0)
    setShaderProperty('sparks', 'green', 0.3)
    setShaderProperty('sparks', 'blue', 0.2)
    setShaderProperty('sparks', 'speed', 2.0)
    setShaderProperty('sparks', 'warp', -250.0)
    setShaderProperty('sparks', 'scale', 1.2)
    --setShaderProperty('sparks', 'waveAmplitude', 0.0)

    initShader('barrel', 'BarrelBlurEffect')
	setCameraShader('game', 'barrel')
	setCameraShader('hud', 'barrel')
	setShaderProperty('barrel', 'barrel', 0.0)
	setShaderProperty('barrel', 'zoom', 1.0)
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

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.0)
    setShaderProperty('bloom2', 'strength', 0.0)

    initShader('bv', 'BloomVerticalEffect')
    setCameraShader('game', 'bv')
    setCameraShader('hud', 'bv')



    initShader('hudColorSwap', 'ColorSwapEffect')
    setCameraShader('hud', 'hudColorSwap')

    initShader('chroma', 'ChromAbBlueSwapEffect')
    setCameraShader('game', 'chroma')
    setCameraShader('hud', 'chroma')
    --setShaderProperty('chroma', 'strength', -0.01)

    initShader('vignette', 'VignetteEffect')
    setCameraShader('hud', 'vignette')
    setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 15)
    setShaderProperty('vignette', 'size', 0.25)

    makeSprite('PhantomBF', 'PhantomBF',  getActorX('iconP1') + 150, getActorY('iconP1')-5000, 1)
    setActorScroll(0, 0, 'PhantomBF')
    setActorAlpha(0, 'PhantomBF')
    setObjectCamera('PhantomBF', "camHUD")

    setStageColorSwap('hue', -0.05)
    setShaderProperty('hudColorSwap', 'hue', -0.05)

    addCharacterToMap('bf', 'DuetBF')
end
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local bfDuetFade = 0

local perlinSpeed = 1.5
					--p2          p1
					--x,y,z,angle,x,y,z,angle
local perlinTime = {0,0,0,0,0,0,0,0}

local perlinCamRange = {0.05,0.05,10,0}

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
        if section == 8 or section == 96 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
            perlinCamRange = {0.08,0.08,10,0}
            perlinSpeed = 3.5

            
        elseif section == 56 or section == 148 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
        elseif section == 72 or section == 164 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
            perlinCamRange = {0.1,0.1,15,0}
            perlinSpeed = 4.5
            triggerEvent("change character", 'bf', "DuetBF")
            
        elseif section == 88 then 
            perlinSpeed = 1
            triggerEvent('Camera Flash','White','2')
            triggerEvent("change character", 'bf', startBF)

        elseif section == 178 then 
            tweenShaderProperty('barrel', 'barrel', 6, crochet*0.001*32, 'cubeIn')
            tweenStageColorSwap('hue', 0.04, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('hudColorSwap', 'hue', 0.04, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*32, 'cubeIn')

        elseif section == 180 then 
            tweenShaderProperty('barrel', 'barrel', 0.2, crochet*0.001*8, 'cubeOut')
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')

            perlinCamRange = {0.125,0.125,20,0}
            perlinSpeed = 5.5
        elseif section == 210 then 
            tweenShaderProperty('barrel', 'barrel', 3, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*32, 'cubeIn')
        elseif section == 212 then 
            triggerEvent('Camera Flash','White','1')
            bloomBurst(2, 2, 16, 'cubeOut')
            tweenShaderProperty('barrel', 'barrel', 0.0, crochet*0.001*8, 'cubeOut')
            perlinCamRange = {0.05,0.05,10,0}
            perlinSpeed = 4
            triggerEvent("change character", 'bf', startBF)
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