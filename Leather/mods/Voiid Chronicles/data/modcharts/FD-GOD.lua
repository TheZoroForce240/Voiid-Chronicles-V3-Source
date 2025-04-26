--Setup stuff-- dont mess with

local noteXPos = {}
local targetnoteXPos = {}
local noteYPos = {}
local targetnoteYPos = {}
local noteZPos = {}
local noteZScale = {}
local targetnoteZPos = {}
local noteAngle = {}
local targetnoteAngle = {}
local startSpeed = 1
local zoomShit = 1
local startBF = ''
function createPost()
	startBF = player1
	startSpeed = getProperty('', 'speed')
	for i = 0, (keyCount*2)-1 do 
		table.insert(noteXPos, 0) --setup default pos and whatever
		table.insert(noteYPos, 0)
		
		if i >= keyCount then 
			table.insert(noteZPos, 1000*((0-(i%keyCount))+keyCount))
		else 
			table.insert(noteZPos, 1000*i)
		end
		table.insert(noteZScale, 1)
		table.insert(noteAngle, 0)
		table.insert(targetnoteXPos, 0)
		table.insert(targetnoteYPos, 0)
		table.insert(targetnoteZPos, 0)
		table.insert(targetnoteAngle, 0) --start angle at weird number for start
		noteXPos[i+1] = getActorX(i)
		targetnoteXPos[i+1] = getActorX(i)
		targetnoteYPos[i+1] = _G['defaultStrum'..i..'Y']
		noteYPos[i+1] = _G['defaultStrum'..i..'Y']
	end

	makeSprite('blackBG', '', 0, 0, 1)
	defaultZoom = getCamZoom()
    makeGraphic('blackBG', 1920/defaultZoom, 1080/defaultZoom, '0xFF000000')
	actorScreenCenter('blackBG')
	setActorScroll(0,0, 'blackBG')
	setActorAlpha(0, 'blackBG')
	
    local layerShit = getActorLayer('girlfriend')
	setActorLayer('blackBG', layerShit)

	initShader('barrel', 'BarrelBlurEffect')
	setCameraShader('game', 'barrel')
	setCameraShader('hud', 'barrel')
	setShaderProperty('barrel', 'barrel', 0.0)
	setShaderProperty('barrel', 'zoom', 1.0)
	setShaderProperty('barrel', 'doChroma', true)

	--initShader('colorShit', 'ColorFillEffect')
	--setShaderProperty('colorShit', 'red', 141)
	--setShaderProperty('colorShit', 'green', 44)
	--setShaderProperty('colorShit', 'blue', 204)
	--setShaderProperty('colorShit', 'fade', 0.0)
	--setActorShader('dadCharacter0', 'colorShit')
	--setActorColor('trail'..trailCount, 253, 36, 255)
end
local noteScale = 1
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local defaultNoteScale = -1
local lerpX = true
local lerpY = false
local lerpAngle = true
local lerpScale = true

local defaultWidth = -1
local defaultSusWidth = -1
local defaultSusHeight = -1
local defaultSusEndHeight = -1

local notesSeen = {}

local noteRotX = 0
local targetNoteRotX = 0

local lerpSpeedScale = 5
local lerpSpeedX = 4
local lerpSpeedY = 10
local lerpSpeedZ = 4
local lerpSpeedAngle = 3
local lerpSpeednoteRotX = 5

function create(stage)
    setActorAlpha(0, 'bfCharacter1')
end

function start(song)
    makeSprite('PhantomBF', 'PhantomBF',  getActorX('iconP1') + 150, getActorY('iconP1'), 1)
    setActorScroll(0, 0, 'PhantomBF')
    setActorAlpha(0, 'PhantomBF')
    setObjectCamera('PhantomBF', "camHUD")
	--setSongPosition('240000')
end
local rotCam = false
local rotCamSpd = 0
local rotCamRange = 0
local rotCamInd = 0
local shit = 0
function update(elapsed)
    setActorX(getActorX('iconP1') + 50, 'PhantomBF')
	setActorY(getActorY('iconP1') + -20, 'PhantomBF')
	setActorScaleX('PhantomBF', getActorScaleX('iconP1'))
	setActorScaleY('PhantomBF', getActorScaleY('iconP1'))
	updateHitbox('PhantomBF')
    setActorAlpha(getActorAlpha('PhantomBF'), 'bfCharacter1')
    if curStep == 1408 then
        setActorAlpha(0.5, 'PhantomBF')
    end
    if curStep == 1664 then
        setActorAlpha(0, 'PhantomBF')
    end
    if curStep == 3136 then
        setActorAlpha(0.5, 'PhantomBF')
    end
    if curStep == 3456 then
        setActorAlpha(0, 'PhantomBF')
    end
	if curStep == 3520 then
        setActorAlpha(0.5, 'PhantomBF')
    end
	if curStep == 3584 then
        setActorAlpha(0, 'PhantomBF')
    end
    if curStep == 3648 then
        setActorAlpha(0.5, 'PhantomBF')
    end
    if curStep == 3712 then
        setActorAlpha(0, 'PhantomBF')
    end
    if curStep == 3776 then
        setActorAlpha(0.5, 'PhantomBF')
    end
    if curStep == 3840 then
        setActorAlpha(0, 'PhantomBF')
    end
	if curStep == 5632 then
        setActorAlpha(0.5, 'PhantomBF')
    end
    if curStep == 6144 then
        setActorAlpha(0, 'PhantomBF')
    end

	if rotCam then
        rotCamInd = rotCamInd + (elapsed / (1 / 120))
		setShaderProperty('barrel', 'angle', math.sin(rotCamInd / 100 * rotCamSpd) * rotCamRange)
    else
        --rotCamInd = 0
		--shit = shit + elapsed*40
		setShaderProperty('barrel', 'angle', 0)
		--rotCamInd = rotCamInd + (elapsed / (1 / 120))
		--setShaderProperty('barrel', 'zoom', 3 + math.sin(rotCamInd / 100 * 2) * 3)
    end
end

function updatePost(elapsed)
	if not modcharts then 
		return
	end
	if lerpScale then 
		noteScale = lerp(noteScale, 1, elapsed*lerpSpeedScale)
	end
	noteRotX = lerp(noteRotX, targetNoteRotX, elapsed*lerpSpeednoteRotX)

	local currentBeat = (songPos / 1000)*(bpm/60)

	
	for i = 0,(keyCount*2)-1 do 
		if curStep >= 5120 and curStep < 6144 then 
			--if not middlescroll then 
			if targetnoteZPos[i+1] == 0 then
				local waveI = i 
				if i > 4 then 
					waveI = i-1
				end
				if (i%keyCount) ~= 4 then 
					targetnoteYPos[i+1] = _G['defaultStrum'..((i))..'Y']+ 7 * math.cos((currentBeat + waveI*0.25) * math.pi)
				end
			else 
				targetnoteYPos[i+1] = _G['defaultStrum'..((i))..'Y']+ 7 * math.cos((currentBeat + i*0.25) * math.pi)
			end

			--end
		end
		noteXPos[i+1] = lerp(noteXPos[i+1], targetnoteXPos[i+1], elapsed*lerpSpeedX)
		noteYPos[i+1] = lerp(noteYPos[i+1], targetnoteYPos[i+1], elapsed*lerpSpeedY)
		noteZPos[i+1] = lerp(noteZPos[i+1], targetnoteZPos[i+1], elapsed*lerpSpeedZ)

		local thisnotePosX = noteXPos[i+1] + getXOffset(i, 0)
		local thisnotePosY = noteYPos[i+1]
		local noteRotPos = getNoteRot(thisnotePosX, thisnotePosY, noteRotX)

		thisnotePosX = noteRotPos[1]
		thisnotePosY = noteRotPos[2]
		local thisnotePosZ = noteRotPos[3]+(noteZPos[i+1]/1000)
		--local thisnotePosX = noteXPos[i+1]
		--local thisnotePosY = noteYPos[i+1]
		--local thisnotePosZ = (noteZPos[i+1]/1000)-1

		noteAngle[i+1] = lerp(noteAngle[i+1], targetnoteAngle[i+1], elapsed*lerpSpeedAngle)
		setActorModAngle(noteAngle[i+1], i)

		local totalNotePos = calculatePerspective(thisnotePosX, thisnotePosY, thisnotePosZ)
		
		--setActorX(noteXPos[i+1], i)
		--setActorY(noteYPos[i+1], i)
		setActorX(totalNotePos[1], i)
		setActorY(totalNotePos[2], i)
		
		noteZScale[i+1] = totalNotePos[3]
		setActorScaleXY(noteScale * (1/-noteZScale[i+1]), noteScale * (1/-noteZScale[i+1]), i)
		if getPlayingActorAnimation(i) == 'confirm' then 
			setActorScaleXY(noteScale*1.45 * (1/-noteZScale[i+1]), noteScale*1.45 * (1/-noteZScale[i+1]), i) --confirm is weird ig
		end
		
	end
	local noteCount = getRenderedNotes()
	if noteCount>0 then 
		for i = 0, noteCount-1 do 
			local data = getRenderedNoteType(i)
			if getRenderedNoteHit(i) then 
				data = data + keyCount --player notes
			end
			if defaultWidth == -1 then 
				defaultWidth = getRenderedNoteWidth(i)
			end
			if defaultNoteScale == -1 then 
				defaultNoteScale = getRenderedNoteScaleX(i)
			end
			local offsetX = getRenderedNoteOffsetX(i)
			local strumTime = getRenderedNoteStrumtime(i)
			if downscrollBool then 
				if isRenderedNoteSustainEnd(i) then 
					strumTime = getRenderedNotePrevNoteStrumtime(i)
				end
			end
			local songSpeed = getProperty('', 'speed')
			local curPos = ((songPos-strumTime)*songSpeed)
			offsetX = offsetX + getXOffset(data, curPos)
			local thisnoteYPos = noteYPos[data+1]
			if downscrollBool then 
				thisnoteYPos = thisnoteYPos + (0.45*curPos) - (getRenderedNoteOffsetY(i))
				if isRenderedNoteSustainEnd(i) then 
					thisnoteYPos = thisnoteYPos - (getRenderedNoteHeight(i))+2
				end
			else 
				thisnoteYPos = thisnoteYPos - (0.45*curPos) - (getRenderedNoteOffsetY(i))
			end
			local thisnoteXPos = noteXPos[data+1]+offsetX
			
			local noteRotPos = getNoteRot(thisnoteXPos, thisnoteYPos, noteRotX)
	
			thisnoteXPos = noteRotPos[1]
			thisnoteYPos = noteRotPos[2]
			local thisnotePosZ = noteRotPos[3]+(noteZPos[data+1]/1000)
			local totalNotePos = calculatePerspective(thisnoteXPos, thisnoteYPos, thisnotePosZ)

			if not isSustain(i) then 
				--setRenderedNoteScale(getRenderedNoteWidth(i)*,getRenderedNoteHeight(i)*noteScale * (1/-totalNotePos[3]), i)
				setRenderedNoteScaleX(defaultNoteScale*noteScale * (1/-totalNotePos[3]), i)
				setRenderedNoteScaleY(defaultNoteScale*noteScale * (1/-totalNotePos[3]), i)
				setRenderedNoteAlpha(1,i)
				setRenderedNoteAngle(noteAngle[data+1],i)
			else
				--offsetX = 37 * (1/-totalNotePos[3]) * (defaultWidth/112)
				setRenderedNoteAlpha(0.6,i)
				if defaultSusWidth == -1 then 
					defaultSusWidth = getRenderedNoteWidth(i)
				end
				if defaultSusHeight == -1 then 
					defaultSusHeight = getRenderedNoteScaleY(i)
				end
				if isRenderedNoteSustainEnd(i) then --sustain ends
					if defaultSusEndHeight == -1 then 
						defaultSusEndHeight = getRenderedNoteScaleY(i)
					end
					
					setRenderedNoteScale(defaultSusWidth*noteScale * (1/-totalNotePos[3]),1, i)
					setRenderedNoteScaleY(defaultSusEndHeight* (1/-totalNotePos[3]), i)
				else 
					setRenderedNoteScale(defaultSusWidth*noteScale * (1/-totalNotePos[3]),1, i)
					setRenderedNoteScaleY(defaultSusHeight* (1/-totalNotePos[3])* (songSpeed/startSpeed), i)
				end

				setRenderedNoteAngle(0,i)

				
				--susOffset = 37*noteScale
			end
			
			setRenderedNotePos(totalNotePos[1],totalNotePos[2], i)
		end
	end

end

local drunk = 0
local drunkSpeed = 1

function getXOffset(data, curPos)

	local xOffset = 0
	if drunk ~= 0 then 
		xOffset = xOffset + drunk * (math.cos( ((songPos*0.001) + ((data%keyCount)*0.2) + (curPos*0.45)*(10/720)) * (drunkSpeed*0.2)) * 112*0.5);
	end

	return xOffset
end


function getSustainAngle(i)

	local data = getRenderedNoteType(i)
	local mustPress = getRenderedNoteHit(i)
	if mustPress then 
		data = data + keyCount --player notes
	end

	local noteYPos = ((songPos-getRenderedNoteStrumtime(i))*songSpeed)
	local nextYPos = noteYPos + crochet

	local noteOffsetX = getXOffset(data, noteYPos)
	local nextOffsetX = getXOffset(data, nextYPos)

	local thisNoteX = getRenderedNoteCalcX(i)+noteOffsetX
	local nextNoteX = getRenderedNoteCalcX(i)+nextOffsetX

	local thisNoteY = getRenderedNoteY(i)
	

	local ang = 0
	if downscrollBool then 
		local nextNoteY = getRenderedNoteY(i) + (0.45*crochet*songSpeed)
		ang = math.deg(math.atan2( (nextNoteY-thisNoteY), (nextNoteX-thisNoteX) ) - (math.pi/2))
		--debugPrint(ang)
	else 
		local nextNoteY = getRenderedNoteY(i) - (0.45*crochet*songSpeed)
		ang = math.deg(math.atan2( (nextNoteY-thisNoteY), (nextNoteX-thisNoteX) ) + (math.pi/2))
	end
	return ang
end

--the funny perspective math

local zNear = 0
local zFar = 1000
local zRange = zNear - zFar 
local tanHalfFOV = math.tan(math.pi/4) -- math.pi/2 = 90 deg, then half again

function calculatePerspective(x,y,z)

	if (z >= 1) then
		z = 1 --stop weird shit
	end

	x = x - (1280/2) + (defaultWidth/2)
	y = y - (720/2) + (defaultWidth/2)

	local zPerspectiveOffset = (z+(2 * zFar * zNear / zRange));

	local xPerspective = x*(1/tanHalfFOV);
	local yPerspective = y/(1/tanHalfFOV);
	xPerspective = xPerspective/-zPerspectiveOffset;
	yPerspective = yPerspective/-zPerspectiveOffset;

	xPerspective = xPerspective + (1280/2) - (defaultWidth/2)
	yPerspective = yPerspective + (720/2) - (defaultWidth/2)

	return {xPerspective,yPerspective,zPerspectiveOffset}
end
local rad = math.pi/180;
function getNoteRot(XPos, YPos, rotX)
	local x = 0
	local y = 0
	local z = -1

	--fucking math
	local strumRotX = getCartesianCoords3D(rotX,90, XPos-(1280/2))
	x = strumRotX[1]+(1280/2)
	local strumRotY = getCartesianCoords3D(90,0, YPos-(720/2))
	y = strumRotY[2]+(720/2)
	--notePosY = _G['default'..strum..'Y'..i%keyCount]+strumRot[2]
	z = z + strumRotX[3] + strumRotY[3]
	return {x,y,z}
end
--the funny spherical to cartesian for 3d angles
function getCartesianCoords3D(theta, phi, radius)

	local x = 0
	local y = 0
	local z = 0

	x = math.cos(theta*rad)*math.sin(phi*rad);
	y = math.cos(phi*rad);
	z = math.sin(theta*rad)*math.sin(phi*rad);
	x = x*radius;
	y = y*radius;
	z = z*radius;

	return {x,y,z/1000}
end

--https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
function scale(valueIn, baseMin, baseMax, limitMin, limitMax)
	return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin
end

function stepHit(curStep)
    if curStep == 1152 or curStep == 2880 then
        --triggerEvent('camera rotate on','2','2')
		--triggerEvent('hud rotate on','2','2')
		rotCam = true
		rotCamSpd = 2
		rotCamRange = 2
		end
	if curStep == 5120 then
        --triggerEvent('camera rotate on','3','2')
		--triggerEvent('hud rotate on','3','2')
		rotCam = true
		rotCamSpd = 3
		rotCamRange = 2
		end
	if curStep == 5120 then
		triggerEvent('Change Scroll Speed','3.2','0')
		end
	if curStep == 1664 or curStep == 3904 or curStep == 6144 then
		--triggerEvent('camera rotate on','0','0')
		--triggerEvent('hud rotate on','0','0')
		rotCamSpd = 0
		rotCamRange = 0
		rotCam = false
		triggerEvent('Camera Flash','White','1')
		setShaderProperty('barrel', 'barrel', 0.0)
		triggerEvent("change character", 'bf', startBF)
	end
	if curStep == 952 or curStep == 1016 or curStep == 1080 or curStep == 1144 or curStep == 1208 or curStep == 1272 or curStep == 1336 or curStep == 1400 or curStep == 1464 or curStep == 1528 or curStep == 1592 or curStep == 1656 or curStep == 1680 or curStep == 1704 or curStep == 1706 or curStep == 1708 or curStep == 1712 then
        triggerEvent('Add Camera Zoom','0.015','0.03')
	end
	if curStep == 2680 or curStep == 2744 or curStep == 2808 or curStep == 2872 or curStep == 2936 or curStep == 3000 or curStep == 3064 or curStep == 3128 or curStep == 3192 or curStep == 3256 or curStep == 3320 or curStep == 3384 or curStep == 3448 or curStep == 3512 or curStep == 3576 or curStep == 3640 or curStep == 3704 or curStep == 3768 or curStep == 3832 or curStep == 3896 or curStep == 3920 or curStep == 3944 or curStep == 3946 or curStep == 3948 or curStep == 3952 then
        triggerEvent('Add Camera Zoom','0.015','0.03')
	end
	if curStep == 4920 or curStep == 4984 or curStep == 5048 or curStep == 5112 or curStep == 5176 or curStep == 5240 or curStep == 5304 or curStep == 5368 or curStep == 5432 or curStep == 5496 or curStep == 5560 or curStep == 5624 or curStep == 5688 or curStep == 5752 or curStep == 5816 or curStep == 5880 or curStep == 5944 or curStep == 6008 or curStep == 6072 or curStep == 6136 or curStep == 6200 or curStep == 6264 or curStep == 6328 or curStep == 6392 or curStep == 6400 then
        triggerEvent('Add Camera Zoom','0.015','0.03')
	end

	if curStep == 104-8 then 
		tweenShaderProperty('barrel', 'barrel', -4, crochet*0.001*32, 'cubeIn')
		--tweenCameraAngleIn(35, crochet*0.001*32)
		--tweenHudAngleIn(35, crochet*0.001*32)
		--tweenCameraZoomIn(defaultZoom*3, crochet*0.001*32)
		--tweenHudZoomIn(1.7, crochet*0.001*32)
	elseif curStep == 104+8+16 then 
		resetShit(0)
	end

	if curStep == 1152-32 then 
		tweenShaderProperty('barrel', 'barrel', 3, crochet*0.001*32, 'cubeIn')
	elseif curStep == 1152 then 
		resetShit(0.1)
	end
	if curStep == 2880-32 then 
		tweenShaderProperty('barrel', 'barrel', 7, crochet*0.001*32, 'cubeIn')
		--triggerEvent("change character", 'bf', 'DuetBF')
	elseif curStep == 2880 then 
		resetShit(0.25)
	end
	if curStep == 3392-32 then 
		tweenShaderProperty('barrel', 'barrel', 1.5, crochet*0.001*32, 'cubeIn')
		tweenFadeIn('blackBG', 0.75, crochet*0.001*32)
		tweenCameraZoom(defaultZoom*1.6, crochet*0.001*32)
		--triggerEvent("change character", 'bf', 'DuetBF')
	elseif curStep == 3392 then 
		resetShit(0.25)
	end

	if curStep == 5632-32 then 
		tweenShaderProperty('barrel', 'barrel', 1.5, crochet*0.001*32, 'cubeIn')
		tweenFadeIn('blackBG', 0.95, crochet*0.001*32)
		tweenCameraZoom(defaultZoom*1.6, crochet*0.001*32)
		
	elseif curStep == 5632 then 
		resetShit(0.45)
	end
	if curStep == 5120-32 then 
		tweenShaderProperty('barrel', 'barrel', -3, crochet*0.001*32, 'cubeIn')
		--triggerEvent("change character", 'bf', 'DuetBF')
	elseif curStep == 5120 then 
		resetShit(0.45)
		tweenFadeIn('blackBG', 0.3, crochet*0.001*16)
	end

	if curStep == 6112 then 
		tweenShaderProperty('barrel', 'barrel', 5, crochet*0.001*32, 'cubeIn')
		--triggerEvent("change character", 'bf', 'DuetBF')
	elseif curStep == 6112+32 then 
		tweenShaderProperty('barrel', 'barrel', 0, crochet*0.001*8, 'backOut')
	end


	if curStep == 3392 then 
		
	elseif curStep == 5632 then 

	elseif curStep == 3904 or curStep == 6144 then
		tweenCameraZoom(defaultZoom, crochet*0.001*16)
		tweenFadeOut('blackBG', 0, crochet*0.001*16)
	end

	if modcharts then 
		modchartShit(curStep)
	end
end
function resetShit(val)
	
	triggerEvent('Camera Flash','White','1')
	tweenShaderProperty('barrel', 'barrel', val, crochet*0.001*8, 'backOut')
	

end

function playerTwoSing(data, time, type)
    if getHealth() - 0.008 > 0.09 then
        setHealth(getHealth() - 0.014)
    else
        setHealth(0.039)
    end
    triggerEvent('Screen Shake','0.1,0.0025','0.1,0.0025')
end
--[[
function playerTwoSingHeld(data, time, type)
    if getHealth() - 0.008 > 0.09 then
        setHealth(getHealth() - 0.006)
    else
        setHealth(0.039)
    end
end
]]--

function modchartShit(curStep)
	local section = math.floor(curStep/16)

	--intro beats
	if curStep == 64 or curStep == 76 or curStep == 80 or curStep == 92 or curStep == 96 or curStep == 102 or curStep == 104 or curStep == 108 then 
		triggerEvent('Add Camera Zoom','0.07','0.03')
	end

	if (section >= 8 and section < 104) or (section >= 112 and section < 244) or (section >= 252 and section < 384) then 
		--repeated for whole song pretty much
		if curStep % 32 == 0 or curStep % 32 == 8 or curStep % 32 == 20 or curStep % 32 == 24 or curStep % 32 == 30 then 
			triggerEvent('Add Camera Zoom','0.07','0.03')
		end
		if curStep % 64 == 0 then 
			for i = 0,(keyCount)-1 do  
				local movement = scale(i%keyCount, 0, keyCount, keyCount, 0)
				noteZPos[i+1] = noteZPos[i+1] - 20-(10*movement)
				noteZPos[i+1+keyCount] = noteZPos[i+1+keyCount] - 20-(20*movement)
			end
		elseif curStep % 64 == 56 then
			for i = 0,(keyCount)-1 do  
				noteZPos[i+1] = noteZPos[i+1] - 20-(10*i)
				noteZPos[i+1+keyCount] = noteZPos[i+1+keyCount] - 20-(20*i)
			end
		end
		triggerEvent('change camera speed',1.6)
	else
		triggerEvent('change camera speed',0.7)
	end

	if curStep == 1152 or curStep == 2880 or curStep == 3456 or curStep == 3584 or curStep == 3712 or curStep == 3840 or curStep == 5120 then --duet start
		for i = 0,(keyCount)-1 do  
			if not middlescroll then 
				if keyCount == 9 and i == 4 then 
					if not downscrollBool then 
						targetnoteYPos[i+1] = -3000
						targetnoteYPos[i+1+keyCount] = _G['defaultStrum'..((i))..'Y']
					else 
						targetnoteYPos[i+1] = 3000
						targetnoteYPos[i+1+keyCount] = _G['defaultStrum'..((i))..'Y']
					end
				end

				targetnoteXPos[i+1] = _G['defaultStrum'..((i%keyCount))..'X']+320
				targetnoteXPos[i+1+keyCount] = _G['defaultStrum'..((i%keyCount)+keyCount)..'X']+320
				if keyCount == 9 and i > 4 then 
					targetnoteXPos[i+1] = targetnoteXPos[i+1]-(66.8/2)
					--targetnoteXPos[i+1+keyCount] = targetnoteXPos[i+1+keyCount]-(76.8/2)
				end
				if keyCount == 9 and i < 4 then 
					targetnoteXPos[i+1] = targetnoteXPos[i+1]+(66.8/2)
					--targetnoteXPos[i+1+keyCount] = targetnoteXPos[i+1+keyCount]+(76.8/2)
				end
			else 
				targetnoteXPos[i+1+keyCount] = _G['defaultStrum'..((i%keyCount)+keyCount)..'X']
				targetnoteYPos[i+1+keyCount] = _G['defaultStrum'..((i))..'Y']
				--targetnoteXPos[i+1] = _G['defaultStrum'..((i%keyCount))..'X']
			end
			targetnoteZPos[i+1] = 0
			targetnoteZPos[i+1+keyCount] = -500
		end
	elseif curStep == 1400 or curStep == 3128 or curStep == 3512 or curStep == 3640 or curStep == 3768 or curStep == 5616 then --bf swap
		for i = 0,(keyCount)-1 do  
			if keyCount == 9 and i == 4 then 
				if not downscrollBool then 
					targetnoteYPos[i+1] = _G['defaultStrum'..((i))..'Y']
					targetnoteYPos[i+1+keyCount] = -3000
				else 
					targetnoteYPos[i+1] = _G['defaultStrum'..((i))..'Y']
					targetnoteYPos[i+1+keyCount] = 3000
				end
			end

			if not middlescroll then 
				targetnoteXPos[i+1+keyCount] = _G['defaultStrum'..((i%keyCount)+keyCount)..'X']-320
				targetnoteXPos[i+1] = _G['defaultStrum'..((i%keyCount))..'X']-320
			else 
				targetnoteXPos[i+1+keyCount] = _G['defaultStrum'..((i%keyCount)+keyCount)..'X']
				--targetnoteXPos[i+1] = _G['defaultStrum'..((i%keyCount))..'X']
			end
			targetnoteZPos[i+1+keyCount] = 0
			targetnoteZPos[i+1] = -500

			if keyCount == 9 and i > 4 then 
				--targetnoteXPos[i+1] = targetnoteXPos[i+1]-(76.8/2)
				targetnoteXPos[i+1+keyCount] = targetnoteXPos[i+1+keyCount]-(66.8/2)
			end
			if keyCount == 9 and i < 4 then 
				--targetnoteXPos[i+1] = targetnoteXPos[i+1]+(76.8/2)
				targetnoteXPos[i+1+keyCount] = targetnoteXPos[i+1+keyCount]+(66.8/2)
			end
		end
	elseif curStep == 1664-16 or curStep == 3904-16 or curStep == 6144 then --duet end
		for i = 0,(keyCount*2)-1 do
			--if not middlescroll then 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
			--end
			targetnoteYPos[i+1] = _G['defaultStrum'..((i))..'Y']
			targetnoteZPos[i+1] = 0
		end
	end
end
local trailCount = 0
local trailLimit = 150
function beatHit(spr)
    for i = 0,trailLimit do --pool of 150 trails, check for cleanup
        if getActorHeight('trail'..i) ~= 0 then 
            if getActorAlpha('trail'..i) == 0 then 
                --trace('cleaned up trail '..i)
                destroySprite('trail'..i)
            end
        end
    end
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

function FDGODMattTrail(data)
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