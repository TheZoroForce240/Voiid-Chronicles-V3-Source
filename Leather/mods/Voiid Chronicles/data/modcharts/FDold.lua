
local startBF = ""
function createPost()
    startBF = player1

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    setShaderProperty('smoke', 'waveStrength', 0.0)
    setShaderProperty('smoke', 'smokeStrength', 0.5)

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

    initShader('chroma', 'ChromAbBlueSwapEffect')
    setCameraShader('game', 'chroma')
    setCameraShader('hud', 'chroma')
    --setShaderProperty('chroma', 'strength', -0.01)

    makeSprite('PhantomBF', 'PhantomBF',  getActorX('iconP1') + 150, getActorY('iconP1')-5000, 1)
    setActorScroll(0, 0, 'PhantomBF')
    setActorAlpha(0, 'PhantomBF')
    setObjectCamera('PhantomBF', "camHUD")

    addCharacterToMap('bf', 'DuetBF')
end
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local bfDuetFade = 0

local perlinSpeed = 1.0
					--p2          p1
					--x,y,z,angle,x,y,z,angle
local perlinTime = {0,0,0,0,0,0,0,0}

local perlinCamRange = {0.05,0.05,8,0}

function update(elapsed)

	for i = 1, #perlinTime do 
		perlinTime[i] = perlinTime[i] + elapsed*math.random()*perlinSpeed
	end

	setShaderProperty('mirror', 'x', ((-0.5 + perlin(perlinTime[1], 0, 0))*perlinCamRange[1]))
	setShaderProperty('mirror', 'y', ((-0.5 + perlin(0, perlinTime[2], 0))*perlinCamRange[2]))
	setShaderProperty('mirror', 'angle', ((-0.5 + perlin(0, 0, perlinTime[3]))*perlinCamRange[3]))
		
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
            perlinCamRange = {0.07,0.07,10,0}
            perlinSpeed = 2

            
        elseif section == 56 or section == 148 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
        elseif section == 72 or section == 164 then 
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
            perlinCamRange = {0.1,0.1,15,0}
            perlinSpeed = 3
            triggerEvent("change character", 'bf', "DuetBF")
            
        elseif section == 88 then 
            perlinSpeed = 1
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
            triggerEvent("change character", 'bf', startBF)

        elseif section == 178 then 
            tweenShaderProperty('bloom2', 'effect', 2, crochet*0.001*32, 'cubeIn')
            tweenShaderProperty('bloom2', 'strength', 2, crochet*0.001*32, 'cubeIn')
        elseif section == 180 then
            bloomBurst(2, 2, 16, 'cubeOut')
            doShake(2, 0.01)
            setAndEaseBackShader('chroma', 'strength', 0.01, crochet*0.001*8, 'cubeOut')
            perlinCamRange = {0.07,0.07,10,0}
            perlinSpeed = 2
            triggerEvent("change character", 'bf', startBF)           
        end
    end 

    if curStep == 1135 or curStep == 2607 then 
        flashCamera('game', '#B700ff', crochet/100)
        triggerEvent('screen shake', ((crochet/1000)*8)..',0.02', '0,0')
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

function playerOneSing1(data, time, type)
    bfDuetFade = 1
end

function playerOneSingHeld1(data, time, type)
    bfDuetFade = 1
end

function beatHit()
	if curBeat == 279 or curBeat == 647 then 
		setCharacterShouldDance('dadCharacter1', false)
		playCharacterAnimation('dadCharacter1', 'trans', true)
	elseif curBeat == 287 or curBeat == 655 then 
		setCharacterShouldDance('dadCharacter1', true)
	elseif curBeat == 351 or curBeat == 719 then
		flashCamera('game', '#FFFFFF', crochet/100)
	elseif curBeat == 359 or curBeat == 703 then
		playCharacterAnimation('dadCharacter1', 'destrans', true)
	end
end

