
function start(song)

	--setProperty('', 'playCountdown', false)
end
function create()
	--triggerEvent('vignette', 25, 0.5)
	--setProperty('', 'playCountdown', false)
	
end

local hardmode = false

function createShaders()

	setGlobalVar('showOnlyStrums', true)
    initShader('greyscale', 'GreyscaleEffect')
    setCameraShader('game', 'greyscale')
    setCameraShader('hud', 'greyscale')
    setShaderProperty('greyscale', 'strength', 1)

	initShader('mirrorBack', 'MirrorRepeatWarpBackBlendEffect')
	setCameraShader('hud', 'mirrorBack')
	setShaderProperty('mirrorBack', 'blend', 0.0)
	setShaderProperty('mirrorBack', 'zoom', 0.5)

	initShader('mirrorP', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirrorP')
	if modcharts then 
		setCameraShader('hud', 'mirrorP')
	end
	setShaderProperty('mirrorP', 'zoom', 1)


	initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
	if hardmode then 
		setCameraShader('hud', 'mirror')
	end
	setShaderProperty('mirror', 'zoom', 1.0)
	setShaderProperty('mirror', 'angle', -45.0)

	initShader('mirrorHUD', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirrorHUD')
	if modcharts then 
		setCameraShader('hud', 'mirrorHUD')
	end
	setShaderProperty('mirrorHUD', 'zoom', 1.0)

	initShader('bars', 'BarsEffect')
    setCameraShader('game', 'bars')
	setCameraShader('hud', 'bars')
    setShaderProperty('bars', 'effect', 0.0)

	initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
	setCameraShader('other', 'mirror2')
	if modcharts then 
		setCameraShader('hud', 'mirror2')
	end
	setShaderProperty('mirror2', 'zoom', 1.0)

	initShader('mirror3', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror3')
	setCameraShader('other', 'mirror3')
	if modcharts then 
		setCameraShader('hud', 'mirror3')
	end
	setShaderProperty('mirror3', 'zoom', 1.0)

	
    initShader('wiggle', 'WiggleEffect')
    setCameraShader('game', 'wiggle')
    setCameraShader('hud', 'wiggle')
	setShaderProperty('wiggle', 'effectType', 4)
    setShaderProperty('wiggle', 'waveSpeed', 3)
    setShaderProperty('wiggle', 'waveFrequency', 5.0)
    setShaderProperty('wiggle', 'waveAmplitude', 0.01)

	setShaderProperty('wiggle', 'waveSpeed', 0)
    setShaderProperty('wiggle', 'waveFrequency', 0.0)
    setShaderProperty('wiggle', 'waveAmplitude', 0.0)

	initShader('pixel', 'MosaicEffect')
    setCameraShader('game', 'pixel')
    setCameraShader('hud', 'pixel')
    setShaderProperty('pixel', 'strength', 0)
   
	initShader('hudColorSwap', 'ColorSwapEffect')
    setCameraShader('hud', 'hudColorSwap')


	initShader('glitch', 'GlitchEffect')
    setCameraShader('game', 'glitch')
    setCameraShader('hud', 'glitch')
    setShaderProperty('glitch', 'strength', 0.02)

	initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0)
    setShaderProperty('bloom2', 'strength', 0)


	initShader('police', 'PopoEffect')
    setCameraShader('game', 'police')
	setShaderProperty('police', 'strength', 0)
	setShaderProperty('police', 'speed', crochet*0.001*32)

	initShader('vig', 'VignetteEffect')
    setCameraShader('other', 'vig')
    setShaderProperty('vig', 'strength', 5)
	setShaderProperty('vig', 'size', 1.0)

	



	initShader('scanline', 'ScanlineEffect')
    setCameraShader('game', 'scanline')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 0.25)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 10)



	makeSprite('blackBG', '', 0, 0, 1)
	defaultZoom = getCamZoom()
    makeGraphic('blackBG', 1920/defaultZoom, 1080/defaultZoom, '0xFF000000')
	actorScreenCenter('blackBG')
	setActorScroll(0,0, 'blackBG')
	setActorAlpha(1, 'blackBG')

	makeSprite('whiteBG', '', 0, 0, 1)
	defaultZoom = getCamZoom()
    makeGraphic('whiteBG', 1920/defaultZoom, 1080/defaultZoom, '0xFFFFFFFF')
	actorScreenCenter('whiteBG')
	setActorScroll(0,0, 'whiteBG')
	setActorAlpha(0, 'whiteBG')
	--setNoteCameras('other')
	--setProperty('camGame', 'alpha', 0)
	--setProperty('camHUD', 'alpha', 0)


	--initShader('trailGame', 'TrailEffect')
	--setCameraShader('game', 'trailGame')
	--setShaderCameraSampler('trailGame', 'trailSpr', 'game')


	--showOnlyStrums = true

	changeHealthRange(0, 10)
	setHealth(5)

	makeText("bring", "Bring", 0, 0, 96)
    setActorFont("bring", 'dumbnerd.ttf')
    setActorScroll(0,0,'bring')
    setObjectCamera('bring', 'other')
    actorScreenCenter('bring')
	setActorY(570, 'bring')
	setActorX(getActorX('bring')-320, 'bring')
	setActorTextColor('bring', '0xFFFFFFFF')

	makeText("in", "In", 0, 0, 96)
    setActorFont("in", 'dumbnerd.ttf')
    setActorScroll(0,0,'in')
    setObjectCamera('in', 'other')
    actorScreenCenter('in')
	setActorY(570, 'in')
	setActorTextColor('in', '0xFFFFFFFF')

	makeText("the", "The", 0, 0, 96)
    setActorFont("the", 'dumbnerd.ttf')
    setActorScroll(0,0,'the')
    setObjectCamera('the', 'other')
    actorScreenCenter('the')
	setActorY(570, 'the')
	setActorX(getActorX('the')+320, 'the')
	setActorTextColor('the', '0xFFFFFFFF')

	makeText("bring2", "Bring", 0, 0, 96)
    setActorFont("bring2", 'dumbnerd.ttf')
    setActorScroll(0,0,'bring2')
    setObjectCamera('bring2', 'other')
    actorScreenCenter('bring2')
	setActorY(80, 'bring2')
	setActorX(getActorX('bring2')-320, 'bring2')
	setActorTextColor('bring2', '0xFFFFFFFF')

	makeText("in2", "In", 0, 0, 96)
    setActorFont("in2", 'dumbnerd.ttf')
    setActorScroll(0,0,'in2')
    setObjectCamera('in2', 'other')
    actorScreenCenter('in2')
	setActorY(80, 'in2')
	setActorTextColor('in2', '0xFFFFFFFF')

	setActorAlpha(0, 'bring')
	setActorAlpha(0, 'in')
	setActorAlpha(0, 'the')
	setActorAlpha(0, 'bring2')
	setActorAlpha(0, 'in2')

end
local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.2

local perlinXRange = 0.12
local perlinYRange = 0.12
local perlinZRange = 10

local section = 0
local hue = 0

function updateShit(elapsed)
    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('mirrorP', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange))
	setShaderProperty('mirrorP', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange))
	setShaderProperty('mirrorP', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange))

	

	if section >= 246 and section < 266 then 
		hue = hue + elapsed*2
		hue = hue % 1
		setStageColorSwap('hue', hue)
	end
	setShaderProperty('hudColorSwap', 'hue', getStageColorSwap('hue'))
end

local downscrollDiff = 1

function createPost()
	
	if not middlescroll then 
		for i = 0, (keyCount*2)-1 do
			local pos = 0 
			if opponentPlay then 
				if i < keyCount then 
					pos = getActorX(i)+320
				else 
					pos = getActorX(i)+1500
				end
			else 
				if i < keyCount then 
					pos = getActorX(i)-1500
				else 
					pos = getActorX(i)-320
				end
			end
			setActorX(pos, i)
		end
	end


	if not downscrollBool then 
		downscrollDiff = -1
	end

    createShaders()
	
end
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end

function updatePost(elapsed)



    updateShit(elapsed)

	if not modcharts then 
		return
	end

end

--https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
function scale(valueIn, baseMin, baseMax, limitMin, limitMax)
	return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin
end

function playerTwoSingHeld(data, time, type)
    if getHealth() - 0.008 > 0.25 then
        setHealth(getHealth() - 0.02)
    else
        setHealth(0.1)
    end
end

function songStart()
	--tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*16*8, 'cubeIn')
	tweenShaderProperty('vig', 'size', 0.5, crochet*0.001*16*8, 'cubeIn')
	tweenShaderProperty('vig', 'strength', 15, crochet*0.001*16*8, 'cubeIn')
	tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*16*8, 'cubeIn')
	tweenActorProperty('blackBG', 'alpha', 0, crochet*0.001*16*8, 'cubeIn')
	stepHit()
end

local swap = 1

function stepHit()

	section = math.floor(curStep/16)
	local secStep = curStep%16
	local secStep8 = curStep%8
	local secStep32 = curStep%32


	--countdowns

	--[[
	if section == 15 or section == 31 or section == 71 or section == 129 or section == 217 or section == 261 then
		if secStep == 0 then 
			triggerEvent('doubleimagemove', 'uno-god,x,-1000,0,4,quintOut', '')
		elseif secStep == 4 then 
			triggerEvent('doubleimagemove', 'uno-god,x,0,-1000,4,quintOut', 'dos-god,x,1000,0,4,quintOut')
		elseif secStep == 8 then 
			triggerEvent('doubleimagemove', 'dos-god,x,0,1000,4,quintOut', 'tres-god,x,-1000,0,4,quintOut')
		elseif secStep == 12 then 
			triggerEvent('doubleimagemove', 'tres-god,x,0,-1000,4,quintOut', 'cuatro-god,x,1000,0,4,quintOut')
		end
	elseif (section == 16 or section == 32 or section == 72 or section == 130 or section == 218 or section == 262) and secStep == 0 then 
		triggerEvent('doubleimagemove', 'cuatro-god,x,0,1000,4,quintOut', '')
	end
	]]--
	if section == 15 or section == 31 or section == 71 or section == 129 or section == 217 or section == 261 or section == 282 then
		if secStep == 0 then 
			triggerEvent('doubleimagemove', 'uno-god,x,-1000,0,2,quintOut', '')
		elseif secStep == 2 then 
			triggerEvent('doubleimagemove', 'uno-god,x,0,-1000,2, quintIn', '')
		elseif secStep == 4 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,1000,0,2,quintOut')
		elseif secStep == 6 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,0,1000,2,quintIn')
		elseif secStep == 8 then 
			triggerEvent('doubleimagemove', '', 'tres-god,x,-1000,0,2,quintOut')
		elseif secStep == 10 then 
			triggerEvent('doubleimagemove', '', 'tres-god,x,0,-1000,2,quintIn')
		elseif secStep == 12 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,1000,0,2,quintOut')
		elseif secStep == 14 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,0,1000,2,quintIn')
		end
	elseif (section == 16 or section == 32 or section == 72 or section == 130 or section == 218 or section == 262) and secStep == 0 then 
		--triggerEvent('doubleimagemove', 'cuatro-god,x,0,1000,4,quintOut', '')
	end

	if section == 47 or section == 161 or section == 249 then 
		if secStep == 0 then 
			triggerEvent('doubleimagemove', 'uno-god,x,-1000,0,2,quintOut', '')
		elseif secStep == 2 then 
			triggerEvent('doubleimagemove', 'uno-god,x,0,-1000,2, quintIn', '')
		elseif secStep == 4 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,1000,0,2,quintOut')
		elseif secStep == 6 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,0,1000,2,quintIn')
		elseif secStep == 12 then 

		end
	elseif section == 267 then 
		if secStep == 12 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,1000,0,2,quintOut')
		elseif secStep == 14 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,0,1000,2,quintIn')
		end 
	elseif section == 271 then 
		if secStep == 8 then 
			triggerEvent('doubleimagemove', 'uno-god,x,-1000,0,2,quintOut', '')
		elseif secStep == 10 then 
			triggerEvent('doubleimagemove', 'uno-god,x,0,-1000,2, quintIn', '')
		elseif secStep == 12 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,1000,0,2,quintOut')
		elseif secStep == 14 then 
			triggerEvent('doubleimagemove', '', 'dos-god,x,0,1000,2,quintIn')
		end 
	elseif section == 272 then 
		if secStep == 0 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,1000,0,2,quintOut')
		elseif secStep == 2 then 
			triggerEvent('doubleimagemove', '', 'cuatro-god,x,0,1000,2,quintIn')
		end 
	end

	if section == 7 then 
		if secStep == 4 then 
			setAndEaseBackToShader('mirrorHUD', 'zoom', 0.9, crochet*0.001*3, 'cubeOut', 1.0)
			setAndEaseBackShader('mirrorHUD', 'angle', 15, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackToShader('mirrorHUD', 'zoom', 0.9, crochet*0.001*3, 'cubeOut', 1.0)
			setAndEaseBackShader('mirrorHUD', 'angle', -15, crochet*0.001*3, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackToShader('mirrorHUD', 'zoom', 0.9, crochet*0.001*2, 'cubeOut', 1.0)
			setAndEaseBackShader('mirrorHUD', 'angle', 15, crochet*0.001*2, 'cubeOut')
		elseif secStep == 14 then 
			setAndEaseBackToShader('mirrorHUD', 'zoom', 0.0, crochet*0.001*2, 'cubeOut', 1.0)
			setAndEaseBackShader('mirrorHUD', 'angle', -15, crochet*0.001*2, 'cubeOut')
		end
	end

	--start sections (voiid)
	if section == 8 or section == 122 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'angle', 180, crochet*0.001*8, 'cubeOut')
			bloomBurst(2, 2, 16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0)
			setShaderProperty('police', 'strength', 0.5)
			perlinSpeed = 2
			setGlobalVar('showOnlyStrums', false)
		end
	elseif section == 10 or section == 124 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		end
	elseif section == 11 or section == 125 then 
		if secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.7, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 12 or section == 126 then
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*3, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 15, crochet*0.001*3, 'cubeOut')
		end
	elseif section == 14 or section == 128 then 
		if secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.7, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			--tweenActorProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 15 or section == 129 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.15)
			tweenShaderProperty('mirror2', 'warp', -0.8, crochet*0.001*16, 'cubeInOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*4, 'cubeOut')
		end
	elseif section == 16 or section == 36 or section == 64 then 
		if secStep == 0 then 
			tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*16, 'cubeOut')
			bloomBurst(2, 2, 16, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'angle', 360, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'expoInOut')
		end
	elseif section == 17 or section == 37 or section == 65 then 
		if secStep == 8 then 
			setShaderProperty('glitch', 'strength', 0.15)
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*3, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoOut')
		elseif secStep == 11 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*3, 'cubeOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*3, 'cubeOut')
		elseif secStep == 0 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*3, 'cubeOut')
		end

	elseif section == 18 or section == 38 or section == 66 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'angle', -360, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'expoInOut')
		end
	elseif section == 19 or section == 39 or section == 67 then 
		if secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'expoInOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*3, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
		end
	elseif section == 20 or section == 28 or section == 40 or section == 44 or section == 303 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.05)
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.8, crochet*0.001*8, 'expoIn')

		elseif secStep == 4 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeInOut')
		
		elseif secStep == 10 then 
			tweenShaderProperty('mirror', 'x', 3.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 8 then 
			
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
			tweenShaderProperty('mirror', 'x', 0.0, crochet*0.001*2, 'expoOut')
			
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*4, 'expoIn')
		end

	elseif section == 21 or section == 29 or section == 41 or section == 45 or section == 304 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'cubeOut')
			
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 0.8, crochet*0.001*4, 'expoIn')
			
		elseif secStep == 8 then 
			setShaderProperty('glitch', 'strength', 0.15)
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'expoIn')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeInOut')
		end

		if secStep == 8 or secStep == 10 or secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001, 'cubeOut')
		elseif secStep == 0 or secStep == 11 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001, 'cubeOut')
		end

	elseif section == 22 or section == 30 or section == 42 or section == 46 or section == 305 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.05)
			--setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'circInOut')
			tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*8, 'expoIn')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
		elseif secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*8, 'expoIn')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeInOut')
			
		end
	elseif section == 23 or section == 31 or section == 43 or section == 47 or section == 306 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.5)
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 5, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.9, crochet*0.001*16, 'expoIn')
			--setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'circInOut')
		end

		if secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -35, crochet*0.001*2, 'expoOut')
		elseif secStep == 10 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.2, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 35, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.3, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -70, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.5, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 70, crochet*0.001*2, 'expoOut')
		end

	elseif section == 24 or section == 32 or section == 68 or section == 299 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			setShaderProperty('glitch', 'strength', 0.0)
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 1, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirror', 'y', 2, crochet*0.001*4, 'expoOut')

		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*2, 'expoOut')
		elseif secStep == 10 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*2, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'cubeOut')
		elseif secStep == 14 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 0.8, crochet*0.001*2, 'expoIn')
		end
	elseif section == 25 or section == 33 or section == 69 or section == 300 then 

		if secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.7, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror', 'y', 1, crochet*0.001*8, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*4, 'cubeIn')
		end

		if section ~= 69 then 
			if secStep == 0 then 
				setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'cubeOut')
			elseif secStep == 8 then 
				setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'cubeOut')
			elseif secStep == 12 then 
				setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'cubeOut')
			end
		end

	elseif section == 26 or section == 34 or section == 70 or section == 301 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.15)
			tweenShaderProperty('mirror', 'y', 1, crochet*0.001*4, 'expoIn')
		end
		if secStep == 4 then 
			tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*4, 'cubeIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
		elseif secStep == 14 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 27 or section == 35 or section == 71 or section == 302 then 
		if secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.05, crochet*0.001*4, 'expoIn')
		end
	end


	--first/thrid drop (voiid)
	if section == 48 or section == 50 or section == 52 or section == 54 or section == 56 or section == 58 or section == 60 or section == 62 or
		section == 162 or section == 164 or section == 166 or section == 168 or section == 170 or section == 172 or section == 174 or section == 176 then 
		if secStep == 0 then 
			perlinSpeed = 3.5
			bloomBurst(2, 2, 16, 'cubeOut')
			setActorProperty('blackBG', 'alpha', 0.5)
			setShaderProperty('greyscale', 'strength', 0)
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.25, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror', 'y', 1, crochet*0.001*4, 'expoIn')
		end

		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 0.9, crochet*0.001*2, 'cubeIn')
		end

	elseif section == 49 or section == 51 or section == 53 or section == 57 or section == 59 or section == 61 or
		section == 163 or section == 165 or section == 167 or section == 171 or section == 173 or section == 175 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 1)
			setAndEaseBackShader('glitch', 'strength', 0.4, crochet*0.001*16, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 6 then 
			tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		end

		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 0.9, crochet*0.001*2, 'cubeIn')
		end

	elseif section == 55 or section == 169 then 

		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 1)
			setAndEaseBackShader('glitch', 'strength', 0.5, crochet*0.001*16, 'cubeIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'expoOut')
		end

		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.25, crochet*0.001*2, 'cubeOut')
			if curStep % 8 < 4 then 
				setAndEaseBackShader('mirrorHUD', 'x', 0.2, crochet*0.001*4, 'cubeOut')
				setAndEaseBackShader('mirrorHUD', 'angle', -15, crochet*0.001*4, 'cubeOut')
			else 
				setAndEaseBackShader('mirrorHUD', 'x', -0.2, crochet*0.001*4, 'cubeOut')
				setAndEaseBackShader('mirrorHUD', 'angle', 15, crochet*0.001*4, 'cubeOut')
			end
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 62 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0)
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.25, crochet*0.001*8, 'expoOut')
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 0.9, crochet*0.001*2, 'cubeIn')
		end

	elseif section == 63 or section == 177 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'y', 10, crochet*0.001*16, 'cubeIn')
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeIn')
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 0.9, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 64 then 
		if secStep == 0 then 
			perlinSpeed = 2
			tweenShaderProperty('mirrorP', 'zoom', 1, crochet*0.001*2, 'cubeOut')
		end
	end



	if (section >= 72 and section < 79) or (section >= 274 and section < 280) then 

		if secStep == 0 then 
			bloomBurst(1, 1, 16, 'cubeOut')
			setShaderProperty('glitch', 'strength', 0.0)
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 0.85, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeIn')
			if section % 2 == 1 then 
				setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeIn')
			end
		end
	elseif section == 79 then 
		if secStep == 0 then 
			bloomBurst(1, 1, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 4, crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 180, crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.8, crochet*0.001*16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
		end
	elseif section == 80 then 
		if secStep == 0 then 
			tweenActorProperty('blackBG', 'alpha', 0.5, crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 360, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*16, 'expoIn')
		end

	elseif section == 281 then 
		if secStep == 0 then 
			bloomBurst(1, 1, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3, crochet*0.001*12, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*16, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 0.5, crochet*0.001*16, 'cubeIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 282 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*16, 'cubeIn')
		end
	end

	--second drop (invalid)
	if section == 81 or section == 82 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setShaderProperty('bloom2', 'brightness', -0.15)
			tweenShaderProperty('mirror2', 'warp', -0.6, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*8, 'expoOut')
		end
	elseif section == 83 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.6, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror', 'y', -1.0, crochet*0.001*16, 'expoOut')
		end
	elseif section == 84 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 85 or section == 86 or section == 87 then 
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*16, 'expoOut')
		end

		if section == 87 then 
			if secStep == 12 then 
				tweenShaderProperty('mirror', 'y', -1.0, crochet*0.001*4, 'expoIn')
				--tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'expoIn')
			end
		end
	elseif section == 88 then 
		if secStep == 0 then 
			setShaderProperty('glitch', 'strength', 0.5)
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('glitch', 'strength', 0.0, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*16, 'expoIn')
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end

	elseif section == 89 or section == 90 or section == 91 or section == 92 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
			if curStep % 8 < 4 then 
				tweenShaderProperty('mirrorHUD', 'angle', 10.0, crochet*0.001*2, 'cubeIn')
				tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'cubeIn')
			else 
				tweenShaderProperty('mirrorHUD', 'angle', -10.0, crochet*0.001*2, 'cubeIn')
				tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'cubeIn')
			end
		end
		if section == 92 and secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'expoOut')
		end

	elseif section == 93 or section == 94 or section == 95 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'expoIn')
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorP', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
			if curStep % 8 < 4 then 
				tweenShaderProperty('mirrorHUD', 'angle', 10.0, crochet*0.001*2, 'cubeIn')
				tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'cubeIn')
			else 
				tweenShaderProperty('mirrorHUD', 'angle', -10.0, crochet*0.001*2, 'cubeIn')
				tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'cubeIn')
			end
		end
	elseif section == 96 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('bloom2', 'brightness', 0.0, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 4.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorP', 'zoom', 1.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*8, 'expoOut')
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'expoIn')
		end
	end

	if section == 102 then 
		if secStep == 4 or secStep == 10 or secStep == 14 then 
			bloomBurst(1, 1, 2, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'cubeOut')
		elseif secStep == 8 or secStep == 12 then 
			bloomBurst(1, 1, 2, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'cubeOut')
		end
	end


	--nk section
	if section == 104 then 
		if secStep == 0 then 
			tweenShaderProperty('police', 'strength', 0.5, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('bloom2', 'brightness', -0.1, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror', 'y', 2.0, crochet*0.001*8, 'cubeIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'expoIn')
		end
	elseif section == 105 or section == 106 or section == 107 or section == 108 or section == 109 or section == 110 or section == 111 or section == 117 or section == 118 or section == 119 or section == 120 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', -20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			if section == 108 then 
				setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'expoIn')
			end
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 112 then 

		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror', 'angle', 180, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*8, 'cubeIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'expoIn')
		end

	elseif section == 113 or section == 114 or section == 115 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 116 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', -20, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		end
	elseif section == 121 then 
		if secStep == 0 then 
			tweenShaderProperty('bloom2', 'brightness', 0.0, crochet*0.001*16, 'cubeIn')
		
		elseif secStep == 8 then 
			tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'expoIn')
		end
	elseif section == 122 and secStep == 0 then 
		tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoOut')
		tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*4, 'expoOut')
	end


	--rev section
	if section == 130 or section == 146 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.3, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*4, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*4, 'expoIn')
		end
	elseif section == 131 or section == 147 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 8, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 2 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*2, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'expoOut')
			bloomBurst(2, 2, 2, 'cubeOut')
		elseif secStep == 10 or secStep == 14 then 
			bloomBurst(2, 2, 2, 'cubeOut')
		elseif secStep == 12 then 
			bloomBurst(2, 2, 2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 132 or section == 148 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 8, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*4, 'expoIn')
			tweenActorProperty('blackBG', 'alpha', 1.0, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 8, 'cubeOut')
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*8, 'expoIn')
		end
	elseif section == 133 or section == 149 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'angle', -30.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'expoIn')
		elseif secStep == 10 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		end
	elseif section == 134 or section == 150 then 

		if secStep == 0 then 
			bloomBurst(2, 2, 8, 'cubeOut')
			tweenActorProperty('blackBG', 'alpha', 1.0, crochet*0.001*4, 'expoOut')
			setShaderProperty('glitch', 'strength', 0.0)
		elseif secStep == 8 then 
			bloomBurst(2, 2, 8, 'cubeOut')

		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'x', -0.25, crochet*0.001*2, 'expoIn')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*2, 'expoIn', 1.0)
			bloomBurst(2, 2, 2, 'cubeOut')
		elseif secStep == 14 then 
			bloomBurst(2, 2, 2, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', 0.25, crochet*0.001*2, 'expoIn')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*2, 'expoIn', 1.0)
		end

		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 135 or section == 151 then 
		if secStep == 0 or secStep == 8 then 
			bloomBurst(2, 2, 4, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*4, 'expoIn', 1.0)
		end
		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 136 or section == 152 then 

		if secStep == 0 or secStep == 4 then 
			bloomBurst(2, 2, 4, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*4, 'expoIn', 1.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'expoOut')
		end

		if curStep % 4 == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.2, crochet*0.001*2, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 137 or section == 153 then 

		if secStep == 0 then 
			tweenShaderProperty('glitch', 'strength', 0.5, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -1.0, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 8, 'linear')
			tweenShaderProperty('mirrorHUD', 'zoom', 4.5, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -5.0, crochet*0.001*8, 'expoIn')
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*8, 'expoIn')
		end

	--after powerup part 1
	elseif section == 138 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'linear')
			tweenShaderProperty('glitch', 'strength', 0.1, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.4, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'y', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -25, crochet*0.001*8, 'cubeOut')

			setAndEaseBackShader('mirror', 'x', 30, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirror', 'y', 25, crochet*0.001*16, 'expoInOut')
		elseif secStep == 4 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 139 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 8, 'linear')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*6, 'expoInOut')
		elseif secStep == 6 then
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*6, 'expoInOut')
		elseif secStep == 12 then
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*4, 'expoInOut')
		end
	elseif section == 140 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 4, 'cubeOut')
		elseif secStep == 4 then 
			bloomBurst(2, 2, 6, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
		elseif secStep == 10 then 
			bloomBurst(2, 2, 6, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 141 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*8, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'cubeIn')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirror', 'y', -1, crochet*0.001*8, 'expoIn')
		elseif secStep == 10 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		end
	elseif section == 142 or section == 144 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*8, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirror', 'y', 0, crochet*0.001*8, 'expoIn')

		elseif secStep == 4 then 
			bloomBurst(2, 2, 6, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
		elseif secStep == 10 then 
			bloomBurst(2, 2, 6, 'cubeOut')
			setShaderProperty('greyscale', 'strength', 0.0)
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 143 then 
		if secStep == 0 then 
			
		elseif secStep == 8 then 
			tweenShaderProperty('mirror', 'y', -1, crochet*0.001*8, 'expoIn')
		end
	elseif section == 145 then 
		if secStep == 0 then 
			
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			setAndEaseBackShader('mirror', 'angle', 360, crochet*0.001*8, 'cubeInOut')
		end


	--after powerup part 2
	elseif section == 154 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*16, 'expoIn', 1.0)
			tweenShaderProperty('glitch', 'strength', 0.2, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.4, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'y', 0.0, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			
		elseif secStep == 8 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 155 or section == 156 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*16, 'expoIn', 1.0)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 157 then 

		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*16, 'expoIn', 1.0)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 10 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoIn')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		end

	elseif section == 158 or section == 159 or section == 160 then 
		if secStep == 0 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 0.3, crochet*0.001*16, 'expoIn', 1.0)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 161 then 
		if secStep == 0 then 
			tweenShaderProperty('blackBG', 'alpha', 0.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeOut')
			
		elseif secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.9, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('bloom2', 'effect', 3, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('bloom2', 'strength', 3, crochet*0.001*8, 'cubeIn')
		end
	end

	--ln section
	if section == 178 then 
		if secStep == 0 then 
			setShaderProperty('police', 'strength', 0.0)
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*4, 'expoOut')
			tweenActorProperty('blackBG', 'alpha', 0.8, crochet*0.001*4, 'expoOut')

			tweenShaderProperty('vig', 'size', 1, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('vig', 'strength', 5, crochet*0.001*4, 'expoOut')

			tweenShaderProperty('wiggle', 'waveSpeed', 3, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('wiggle', 'waveFrequency', 5.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('wiggle', 'waveAmplitude', 0.01, crochet*0.001*4, 'expoOut')
		end
	elseif section == 185 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('vig', 'strength', 15, crochet*0.001*16, 'cubeIn')
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('bloom2', 'effect', 5, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('bloom2', 'strength', 5, crochet*0.001*16, 'cubeIn')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'angle', 360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 186 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'angle', -360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 187 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'y', -2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 188 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'y', 2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 189 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 190 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', 2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 191 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'angle', 360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 192 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'angle', -360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 193 or section == 197 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 194 or section == 196 or section == 198 or section == 200 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 195 or section == 199 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 201 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end


	elseif section == 202 then 
		if secStep == 0 then 
			setShaderProperty('police', 'strength', 0.5)
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 203 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'y', -2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 204 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'y', 2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 205 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'x', -2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 206 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'x', 2, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 207 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 208 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*16, 'expoInOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -360, crochet*0.001*16, 'expoInOut')
			tweenScrollSpeed(0.05, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 209 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 16, 'cubeOut')
			tweenScrollSpeed(getScrollSpeed(), crochet*0.001*8, 'cubeOut')
			setAndEaseBackToShader('glitch', 'strength', 1.0, crochet*0.001*16, 'expoOut', 0.05)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*16, 'expoInOut')
		end

	elseif section == 210 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*16, 'expoOut')
		end
	elseif section == 213 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*16*4, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*16*4, 'expoIn')
		end
	elseif section == 218 then 
		if secStep == 0 then 
			setShaderProperty('wiggle', 'waveSpeed', 0)
			setShaderProperty('wiggle', 'waveFrequency', 0.0)
			setShaderProperty('wiggle', 'waveAmplitude', 0.0)
		end
	end


	--invalid (part 2)
	if section == 218 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
		elseif secStep == 2 then 
			setAndEaseBackShader('mirror', 'x', -0.5, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirror', 'y', -0.5, crochet*0.001*2, 'expoOut')
			setAndEaseBackShader('mirror', 'angle', 25, crochet*0.001*2, 'expoOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoIn')
			tweenActorProperty('blackBG', 'alpha', 1.0, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('bloom2', 'brightness', -0.15, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('mirror', 'x', 1.0, crochet*0.001*2, 'expoIn')
		elseif secStep == 8 then 
			tweenActorProperty('blackBG', 'alpha', 0.0, crochet*0.001*2, 'expoOut')
			setShaderProperty('glitch', 'strength', 0.2)
		elseif secStep == 12 then 
			tweenShaderProperty('mirror', 'x', 0.0, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirror', 'y', 1.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 219 then 
		if secStep == 4 then 
			tweenShaderProperty('mirror', 'angle', 180.0, crochet*0.001*4, 'expoOut')

		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 220 then 
		if secStep == 0 then 
			
			setShaderProperty('glitch', 'strength', 0.05)
			bloomBurst(3, 3, 6, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*6, 'cubeOut')
		elseif secStep == 6 then 
			bloomBurst(3, 3, 6, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*6, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*6, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.5, crochet*0.001*6, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*6, 'cubeOut')
		end
	elseif section == 221 then 
		if secStep == 8 then 
			setShaderProperty('glitch', 'strength', 0.2)
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 222 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*3, 'expoOut')
			tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*6, 'expoInOut')
		elseif secStep == 9 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*3, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*3, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 223 then 

		if secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*2, 'expoIn')
		elseif secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*3, 'cubeOut')
		end
	elseif section == 224 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'angle', 180, crochet*0.001*32, 'expoIn')
			tweenShaderProperty('mirror', 'x', 2, crochet*0.001*16, 'expoIn')
		end
	elseif section == 225 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'zoom', 10, crochet*0.001*16, 'expoIn')
			tweenShaderProperty('bars', 'effect', 0.15, crochet*0.001*16, 'cubeIn')
		end
	elseif section == 226 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*8, 'expoOut')

			tweenShaderProperty('mirror', 'x', -1, crochet*0.001*4, 'expoIn')
		elseif secStep == 4 then 
			tweenShaderProperty('mirror', 'y', 1, crochet*0.001*4, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror', 'x', 0, crochet*0.001*4, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'expoIn')
		end

	elseif section == 227 then 
		if secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'cubeOut')
			bloomBurst(3, 3, 3, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -20, crochet*0.001*3, 'cubeOut')
		elseif secStep == 11 then 
			bloomBurst(3, 3, 3, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 20, crochet*0.001*3, 'cubeOut')
		elseif secStep == 14 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -20, crochet*0.001*3, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 228 then 

		if secStep == 0 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*16, 'cubeOut')
			bloomBurst(3, 3, 16, 'cubeOut')

			setAndEaseBackShader('mirror', 'x', -10, crochet*0.001*16, 'cubeInOut')
			tweenShaderProperty('mirror', 'angle', 180.0, crochet*0.001*16, 'expoIn')
		elseif secStep == 8 then 
			
		end
	elseif section == 229 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*16, 'expoIn')
			setAndEaseBackShader('mirror', 'x', -10, crochet*0.001*16, 'cubeInOut')
		elseif secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('bars', 'effect', 0.15, crochet*0.001*8, 'cubeOut')
		end
	elseif section == 230 or section == 231 then 

		if curStep % 4 == 0 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif curStep % 4 == 2 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		end
		if section == 231 and secStep == 8 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
		end
	elseif section == 232 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoIn')
		end
	elseif section == 233 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.5, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('bloom2', 'brightness', -0.05, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*8, 'expoIn')
		end
	end

	--paper section
	if section == 234 then 
		if secStep == 0 then 
			tweenShaderProperty('mirror', 'y', 1.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirror', 'angle', 360, crochet*0.001*16, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeOut')
		elseif secStep == 12 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		end
	elseif section == 235 then 
		if secStep == 0 then 
			tweenShaderProperty('mirror', 'y', -1.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*8, 'expoInOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 236 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 15.0, crochet*0.001*6, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
		elseif secStep == 10 then 
			tweenShaderProperty('mirrorHUD', 'angle', -15.0, crochet*0.001*6, 'cubeIn')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'x', -10, crochet*0.001*4, 'expoOut')
		end
	elseif section == 237 then 

		if secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'angle', 15.0, crochet*0.001*6, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 10 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*6, 'cubeIn')

			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*6, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*6, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*12, 'cubeInOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*4, 'expoOut')
		end
	elseif section == 238 then 

		if secStep == 4 then 
			setAndEaseBackShader('mirror2', 'y', -2, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 239 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.5)
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.75)
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.25)
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
		elseif secStep == 10 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.5)
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.0)
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.2, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 240 then 
		if secStep == 2 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		end
	elseif section == 241 then 
		if secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.1, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('bloom2', 'brightness', -0.2, crochet*0.001*4, 'expoIn')
		end

	elseif section == 242 or section == 243 or section == 244 or section == 245 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			if section == 244 then 
				tweenShaderProperty('pixel', 'strength', 50, crochet*0.001*32, 'cubeIn')
			end
		end
	elseif section == 246 then 
		if secStep == 0 then 
			tweenShaderProperty('bloom2', 'brightness', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 

			setAndEaseBackShader('pixel', 'strength', 50, crochet*0.001*4, 'expoOut')
		end
	elseif section == 247 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.33, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('pixel', 'strength', 30, crochet*0.001*8, 'cubeIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*8, 'cubeOut')
		end
	elseif section == 248 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'cubeOut')
			setAndEaseBackTo('blackBG', 'alpha', 1.0, crochet*0.001*16, 'cubeIn', 0.0)
		end
	elseif section == 249 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -15, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 15, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('pixel', 'strength', 15, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 250 then --drop
		if secStep == 0 then 
			tweenShaderProperty('mirrorBack', 'blend', 0.25, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*8, 'cubeInOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -25.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*16, 'expoInOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'angle', 10.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 251 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'angle', -25.0, crochet*0.001*6, 'cubeIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
		end

	elseif section == 252 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.75, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25*0.75, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25*0.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.25, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25*0.25, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*4, 'expoOut')
		end
	elseif section == 253 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25*0.5, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*8, 'cubeOut')

			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
		end
	elseif section == 254 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
			--tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('pixel', 'strength', 10, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirror', 'angle', -30.0, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirror', 'angle', 360.0, crochet*0.001*8, 'cubeInOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror2', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 255 then 
		if secStep == 0 or secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 14 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		end
	elseif section == 256 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
		end
	elseif section == 257 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeIn')
			--tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*4, 'expoIn')
		end

	elseif section == 258 or section == 259 or section == 260 or section == 261 or section == 262 or section == 263 then 
		if secStep == 0 then 
			setAndEaseBackToShader('greyscale', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)

			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror', 'y', 1.0, crochet*0.001*8, 'expoOut')
		end
		if curStep % 8 == 0 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
		elseif curStep % 8 == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
		end


		if section == 263 or section == 262 then 
			if secStep == 0 or secStep == 6 then 
				setAndEaseBackTo('bring', 'alpha', 1.0, crochet*0.001*4, 'cubeOut', 0.0)
				setAndEaseBackTo('bring', 'y', 570, crochet*0.001*4, 'cubeOut', 550)
			elseif secStep == 2 or secStep == 8 then 
				setAndEaseBackTo('in', 'alpha', 1.0, crochet*0.001*4, 'cubeOut', 0.0)
				setAndEaseBackTo('in', 'y', 570, crochet*0.001*4, 'cubeOut', 550)
			elseif secStep == 4 or secStep == 10 then 
				setAndEaseBackTo('the', 'alpha', 1.0, crochet*0.001*4, 'cubeOut', 0.0)
				setAndEaseBackTo('the', 'y', 570, crochet*0.001*4, 'cubeOut', 550)
			elseif secStep == 12 then 
				setAndEaseBackTo('bring2', 'alpha', 1.0, crochet*0.001*4, 'cubeOut', 0.0)
				setAndEaseBackTo('bring2', 'y', 80, crochet*0.001*4, 'cubeOut', 100)
			elseif secStep == 14 then 
				setAndEaseBackTo('in2', 'alpha', 1.0, crochet*0.001*4, 'cubeOut', 0.0)
				setAndEaseBackTo('in2', 'y', 80, crochet*0.001*4, 'cubeOut', 100)
			end
		end


		if section == 261 then 
			if secStep == 0 then 
				tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*6, 'cubeIn')
			elseif secStep == 6 then 
				tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*6, 'cubeIn')
			elseif secStep == 12 then 
				tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeIn')
				tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*4, 'cubeIn')
				tweenShaderProperty('mirror2', 'warp', -0.25, crochet*0.001*8, 'cubeIn')
				tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'cubeIn')
			end
		elseif section == 263 then 
			if secStep == 0 then 
				tweenShaderProperty('mirror3', 'zoom', 2.5, crochet*0.001*8, 'expoOut')
			elseif secStep == 8 then 
				tweenShaderProperty('mirror3', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
				tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'expoIn')
				tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'expoIn')
			end
		end
	elseif section == 264 or section == 265 then 
		if section == 264 or secStep == 0 then 
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('glitch', 'strength', 0.25, crochet*0.001*4, 'expoOut')
		end
		if section == 265 and secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
		end

		if curStep % 4 == 0 then 
			if curStep % 8 == 0 then 
				tweenShaderProperty('mirrorHUD', 'angle', 10, crochet*0.001*2, 'cubeOut')
			elseif curStep % 8 == 4 then 
				tweenShaderProperty('mirrorHUD', 'angle', -10, crochet*0.001*2, 'cubeOut')
			end
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*2, 'cubeIn')
		end


	elseif section == 266 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'y', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorBack', 'blend', 0.0, crochet*0.001*4, 'cubeOut')
			hue = 0
			setStageColorSwap('hue', 0.0)
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*4, 'cubeOut')
			setStageColorSwap('hue', 0.75)
		elseif secStep == 8 then 
			bloomBurst(3, 3, 8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
			setStageColorSwap('hue', 0.0)
		elseif secStep == 12 then 
			tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
			setStageColorSwap('hue', -0.1)
		elseif secStep == 14 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*2, 'cubeIn')
		end
	elseif section == 267 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.5)
			setAndEaseBackShader('mirror', 'x', -0.1, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', -0.1)
			setAndEaseBackShader('mirror', 'x', 0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*4, 'expoIn')
		elseif secStep == 10 then 

			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'expoOut')
			setStageColorSwap('hue', 0.0)
		elseif secStep == 14 then 
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*2, 'cubeOut')
		end

	elseif section == 268 then 
		if secStep == 0 then 
			tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*2, 'cubeOut')
		elseif secStep == 2 then 
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*2, 'cubeOut')
			setStageColorSwap('hue', 0.5)
			bloomBurst(3, 3, 4, 'cubeOut')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*2, 'cubeOut')
			
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*2, 'cubeOut')
			setStageColorSwap('hue', 0.0)
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*4, 'cubeOut')
			setStageColorSwap('hue', -0.1)
			bloomBurst(3, 3, 4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 269 then 
		if secStep == 0 then 
			setStageColorSwap('hue', 0.5)
			bloomBurst(3, 3, 4, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 15.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setStageColorSwap('hue', -0.1)
			bloomBurst(3, 3, 4, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 15.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'angle', 20.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			
		end
	elseif section == 270 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
			setStageColorSwap('hue', 0.0)
			bloomBurst(3, 3, 4, 'cubeOut')
		elseif secStep == 4 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.75)
			setAndEaseBackShader('mirror', 'x', 0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 6 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.75)
			setAndEaseBackShader('mirror', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
		elseif secStep == 10 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*2, 'cubeIn')
		elseif secStep == 12 then 
			bloomBurst(3, 3, 2, 'cubeOut')
			setStageColorSwap('hue', 0.25)
			tweenShaderProperty('mirror', 'x', 1, crochet*0.001*4, 'expoOut')
		end
	elseif section == 271 then 
		if secStep == 0 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*2, 'cubeOut')
		elseif secStep == 2 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*2, 'cubeIn')
		elseif secStep == 4 then 
			tweenShaderProperty('mirrorHUD', 'angle', 10.0, crochet*0.001*2, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*2, 'cubeOut')
		elseif secStep == 6 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*2, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')

		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', -15.0, crochet*0.001*4, 'cubeOut')
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.75)
			tweenStageColorSwap('hue', 0.5, crochet*0.001*4, 'expoIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'angle', 15.0, crochet*0.001*4, 'cubeOut')
			bloomBurst(3, 3, 4, 'cubeOut')
			tweenStageColorSwap('hue', 0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 272 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', 3, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', 15.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*2, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 15.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'cubeOut')
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', -0.1)
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'angle', -15.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'cubeOut')
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.5)
		end
	elseif section == 273 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.25)
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.25, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', -0.1)

			tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.35, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			bloomBurst(3, 3, 4, 'cubeOut')
			setStageColorSwap('hue', 0.0)

			tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
			tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*4, 'cubeIn')
		end
	end


	--nk drop
	if section == 283 or section == 291 then 
		if secStep == 0 then 
			tweenShaderProperty('mirrorBack', 'blend', 0.0, crochet*0.001*4, 'cubeOut')
			bloomBurst(3, 3, 16, 'cubeOut')
			setStageColorSwap('hue', 0.0)
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackToShader('mirror', 'x', 0, crochet*0.001*8, 'expoIn', 3)

			tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')

		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 284 or section == 292 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			setStageColorSwap('hue', 0.5)
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackToShader('mirror', 'x', -3, crochet*0.001*8, 'expoIn', 0)

			tweenShaderProperty('bars', 'effect', 0.2, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 285 or section == 293 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			setStageColorSwap('hue', -0.1)
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackToShader('mirror', 'x', 0, crochet*0.001*8, 'expoIn', 3)

			tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*8, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 286 or section == 294 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			setStageColorSwap('hue', 0.75)
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001*4, 'expoOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
			setAndEaseBackToShader('mirror', 'x', -3, crochet*0.001*8, 'expoIn', 0)

			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*8, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
		elseif secStep == 12 then 
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
		end


	elseif section == 287 or section == 289 or section == 295 or section == 297 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			setStageColorSwap('hue', 0.0)
			tweenStageColorSwap('hue', 1.0, crochet*0.001*16, 'cubeInOut')
			tweenShaderProperty('mirrorBack', 'blend', 0.25, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackToShader('mirror', 'y', 0, crochet*0.001*8, 'expoIn', 3)
		end
	elseif section == 288 or section == 290 or section == 296 or section == 298 then 
		if secStep == 0 then 
			bloomBurst(3, 3, 16, 'cubeOut')
			tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeInOut')
		elseif secStep == 8 then 
			setAndEaseBackToShader('mirror', 'y', -3, crochet*0.001*8, 'expoIn', 0)
			if section == 298 then 
				tweenShaderProperty('mirrorBack', 'blend', 0.0, crochet*0.001*8, 'cubeIn')
			end
		end


	end



	--pico jumpscare
	if section >= 307 and section < 314 then 
		if section == 307 and secStep == 0 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('glitch', 'strength', 0.1, crochet*0.001*4, 'cubeOut')
			flashCamera('game', '0xFFFFFFFF', 1)
			tweenShaderProperty('bloom2', 'brightness', -0.1, crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('police', 'strength', 0.0, crochet*0.001*16, 'cubeOut')
		end


		if secStep == 0 then 
			setAndEaseBackToShader('mirror', 'x', 1, crochet*0.001*16, 'expoInOut', -1)
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
		

		if section == 308 then 
			if secStep == 12 then 
				bloomBurst(5, 5, 4, 'expoOut')
			end
		elseif section == 309 then 
			if secStep == 0 then 
				bloomBurst(5, 5, 4, 'expoOut')
			end
		elseif section == 310 then 
			if secStep == 0 or secStep == 8 or secStep == 12 then 
				bloomBurst(5, 5, 4, 'expoOut')
			end
		elseif section == 311 then 
			if secStep == 0 then 
				tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*16, 'cubeOut')
				tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*16, 'cubeOut')
				tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*16, 'cubeOut')
			end
		elseif section == 312 then 
			if secStep == 0 then 
				bloomBurst(5, 5, 4, 'expoOut')
				tweenShaderProperty('bars', 'effect', 0.1, crochet*0.001*16, 'cubeOut')
				tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*16, 'cubeOut')
			end
		elseif section == 313 then 
			if secStep == 0 then 
				bloomBurst(5, 5, 4, 'expoOut')
				tweenShaderProperty('bars', 'effect', 0.25, crochet*0.001*16, 'cubeOut')
				tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*16, 'cubeOut')
			end
		end
	elseif section == 314 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 4, 'expoOut')
			tweenShaderProperty('bars', 'effect', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'expoOut')
			setAndEaseBackShader('mirror', 'x', -40, crochet*0.001*16, 'expoIn')
			tweenStageColorSwap('hue', -0.5, crochet*0.001*16, 'cubeIn')
		elseif secStep == 8 then 
			bloomBurst(5, 5, 4, 'expoOut')
			setAndEaseBackShader('mirror', 'angle', -360.0, crochet*0.001*8, 'expoInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', -0.0, crochet*0.001*4, 'expoIn')
		end
	elseif section == 315 then 
		if secStep == 0 then 
			bloomBurst(5, 5, 4, 'expoOut')
			tweenShaderProperty('mirrorBack', 'blend', 0.25, crochet*0.001*4, 'cubeOut')
			tweenStageColorSwap('hue', 0.0, crochet*0.001*64, 'linear')
		end
		if secStep == 0 then 
			setAndEaseBackToShader('mirror', 'x', 2, crochet*0.001*16, 'expoInOut', 0)
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 316 then 
		if secStep == 4 or secStep == 12 then 
			bloomBurst(5, 5, 4, 'expoOut')
		end
		if secStep == 0 then 
			setAndEaseBackToShader('mirror', 'x', 2, crochet*0.001*16, 'expoInOut', 0)
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 317 then 
		if secStep == 0 then 
			setAndEaseBackToShader('mirror', 'x', 2, crochet*0.001*16, 'expoInOut', 0)
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 318 then 
		if secStep == 8 then 
			bloomBurst(5, 5, 4, 'expoOut')
		end
		if secStep == 0 then 
			setAndEaseBackToShader('mirror', 'x', 2, crochet*0.001*16, 'expoInOut', 0)
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
			tweenShaderProperty('bloom2', 'brightness', 0.0, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorBack', 'blend', 0.0, crochet*0.001*8, 'expoIn')
		end


	elseif section == 319 then 
		if secStep == 4 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2, crochet*0.001*8, 'cubeInOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 1, crochet*0.001*4, 'cubeIn')
		elseif secStep == 0 then 
			bloomBurst(5, 5, 4, 'expoOut')
		end
	elseif section == 320 then 
		if secStep == 0 or secStep == 4 then 
			bloomBurst(5, 5, 4, 'expoOut')
		elseif secStep == 8 or secStep == 10 or secStep == 12 or secStep == 14 then 
			bloomBurst(6, 6, 2, 'expoOut')
		end
		if secStep == 12 then 
			setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*8, 'cubeInOut')
		end
	elseif section == 321 then 
		if secStep == 4 then 
			setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'cubeInOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoIn')
		end

	elseif section == 322 then 
		if secStep == 0 or secStep == 2 or secStep == 4 or secStep == 6 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 10, crochet*0.001, 'expoOut')
		elseif secStep == 1 or secStep == 3 or secStep == 5 or secStep == 7 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001, 'expoOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -10, crochet*0.001, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.5, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('pixel', 'strength', 25, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('pixel', 'strength', 0, crochet*0.001*4, 'expoIn')

			tweenShaderProperty('police', 'strength', 0.5, crochet*0.001*4, 'expoIn')
		end
	end

	--nk section (again)
	if section == 323 or section == 324 or section == 325 or section == 326 or section == 327 or section == 328 or section == 329 or section == 335 or section == 336 or section == 337 or section == 338 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', -20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			if section == 108 then 
				setAndEaseBackShader('mirror', 'y', 2, crochet*0.001*8, 'expoIn')
			end
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 330 then 

		if secStep == 0 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 2 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
		elseif secStep == 4 or secStep == 6 then 
			setAndEaseBackShader('mirrorHUD', 'x', -0.1, crochet*0.001, 'expoOut')
		elseif secStep == 5 or secStep == 7 then 
			setAndEaseBackShader('mirrorHUD', 'x', 0.1, crochet*0.001, 'expoOut')
		end

		if secStep == 8 then 
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 2.5, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror2', 'warp', -0.5, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'angle', 180, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'cubeIn')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('greyscale', 'strength', 0.0, crochet*0.001*4, 'expoIn')
		end

	elseif section == 331 or section == 332 or section == 333 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', 2, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 20, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoOut')
		end
	elseif section == 334 then 
		if secStep == 0 then 
			setAndEaseBackShader('mirror', 'x', -20, crochet*0.001*8, 'expoIn')
			tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'expoIn')
		elseif secStep == 8 then 
			bloomBurst(2, 2, 16, 'cubeOut')
		end
	end


	--the end
	if section == 338 then 
		if secStep == 8 or secStep == 10 or secStep == 12 or secStep == 13 or secStep == 14 or secStep == 15 then
			setAndEaseBack('blackBG', 'alpha', 1.0, crochet*0.001, 'expoIn')
		end
	elseif section == 339 or section == 343 then 

		if section == 339 then 
			flashCamera('game', '0xFFFFFFFF', 1)
			tweenShaderProperty('mirror2', 'warp', 0.0, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirrorBack', 'blend', 0.25, crochet*0.001*4, 'expoOut')
		end

		if secStep == 0 then 
			bloomBurst(4, 4, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', -0.2, crochet*0.001*16, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', -20 * downscrollDiff, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoIn')
		end

	elseif section == 340 or section == 342 or section == 344 then 
		if secStep == 0 then 
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*4, 'expoOut', 0.1)
			bloomBurst(4, 4, 6, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 20 * downscrollDiff, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoOut')
			setStageColorSwap('hue', 0.0)
			tweenStageColorSwap('hue', 1.0, crochet*0.001*6, 'expoInOut')
		elseif secStep == 6 then 
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*4, 'expoOut', 0.1)
			bloomBurst(4, 4, 6, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', -20 * downscrollDiff, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 1.0*downscrollDiff, crochet*0.001*4, 'expoOut')
			setStageColorSwap('hue', 0.0)
			tweenStageColorSwap('hue', 1.0, crochet*0.001*6, 'expoInOut')
		elseif secStep == 12 then 
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*4, 'expoOut', 0.1)
			bloomBurst(4, 4, 4, 'cubeOut')
			setAndEaseBackShader('mirrorHUD', 'angle', 20 * downscrollDiff, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'expoOut')
			setStageColorSwap('hue', 0.0)
			tweenStageColorSwap('hue', 1.0, crochet*0.001*6, 'expoInOut')
		end
	elseif section == 341 or section == 345 then 

		if secStep == 0 then 
			bloomBurst(4, 4, 16, 'cubeOut')
			tweenShaderProperty('mirrorHUD', 'x', 0.2, crochet*0.001*16, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'angle', 20 * downscrollDiff, crochet*0.001*8, 'expoOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirrorHUD', 'angle', 0, crochet*0.001*8, 'expoIn')
		end

	elseif section == 346 then 
		if secStep == 0 then 
			--tweenShaderProperty('glitch', 'strength', 0.25, crochet*0.001*4, 'expoOut')
			tweenShaderProperty('greyscale', 'strength', 1.0, crochet*0.001*4, 'expoOut')
		elseif secStep == 12 then 
			tweenShaderProperty('mirrorHUD', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'zoom', 1.0, crochet*0.001*4, 'expoIn')
		end

		if curStep % 4 == 0 then 
			if curStep % 8 < 4 then 
				tweenShaderProperty('mirrorHUD', 'x', -0.1, crochet*0.001*2, 'expoOut')
				tweenShaderProperty('mirrorHUD', 'angle', -20 * downscrollDiff, crochet*0.001*2, 'expoOut')
			else 
				tweenShaderProperty('mirrorHUD', 'x', 0.1, crochet*0.001*2, 'expoOut')
				tweenShaderProperty('mirrorHUD', 'angle', 20 * downscrollDiff, crochet*0.001*2, 'expoOut')
			end
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*4, 'expoOut', 0.1)
			bloomBurst(4, 4, 4, 'cubeOut')
		elseif curStep % 4 == 2 then 
			tweenShaderProperty('mirrorHUD', 'x', 0.0, crochet*0.001*2, 'expoIn')
			tweenShaderProperty('mirrorHUD', 'angle', 0.0, crochet*0.001*2, 'expoIn')
		end

	elseif section == 347 then 
		if secStep == 0 then 
			tweenShaderProperty('glitch', 'strength', 0.2, crochet*0.001*4, 'expoOut')
			tweenActorProperty('blackBG', 'alpha', 0.5, crochet*0.001*16, 'expoOut')
			tweenShaderProperty('mirrorHUD', 'zoom', 3.0, crochet*0.001*16*8, 'linear')
		end
	elseif section == 348 then 
		if secStep == 0 then 
			
		end
	elseif section == 355 then 
		if secStep == 0 then 
			tweenActorProperty('whiteBG', 'alpha', 1.0, crochet*0.001*16, 'cubeInOut')
			tweenActorProperty('camHUD', 'alpha', 0.0, crochet*0.001*16, 'cubeIn')
			tweenShaderProperty('police', 'strength', 0.0, crochet*0.001*16, 'cubeIn')
		end
	elseif section == 356 then 
		if secStep == 0 then 
			setActorAlpha(1, 'blackBG')
			tweenActorProperty('whiteBG', 'alpha', 0.0, crochet*0.001*16, 'cubeOut')
		end
	end



	--intro
	if section < 7 then 
		if secStep == 8 then 
			if section % 2 == 0 then 
				setAndEaseBackShader('mirror', 'x', -2, crochet*0.001*16, 'expoInOut')
			else 
				setAndEaseBackShader('mirror', 'y', -2, crochet*0.001*16, 'expoInOut')
			end
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
    tweenShaderProperty('bloom2', 'effect', 0.2, crochet*0.001*t, ease)
    tweenShaderProperty('bloom2', 'strength', 0.2, crochet*0.001*t, ease)
end

function doShake(steps, freq)
    triggerEvent('screen shake', (crochet*0.001*steps)..','..freq, (crochet*0.001*steps)..','..freq)
end
