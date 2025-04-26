

function create()
    triggerEvent('ca burst','0','0')
end
function playerTwoSing(data, time, type)
    if getHealth() - 0.008 > 0.09 then
        setHealth(getHealth() - 0.020)
    else
        setHealth(0.035)
    end
    triggerEvent('ca burst','0.001','0.001')
    triggerEvent('Screen Shake','0.1,0.005','0.1,0.005')
end


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

local downscrollDiff = 1

function createPost()
	startSpeed = getProperty('', 'speed')
	for i = 0, (keyCount*2)-1 do 
		table.insert(noteXPos, 0) --setup default pos and whatever
		table.insert(noteYPos, 0)
		table.insert(noteZPos, 0)
		table.insert(noteZScale, 1)
		table.insert(noteAngle, 0)
		table.insert(targetnoteXPos, 0)
		table.insert(targetnoteYPos, 0)
		table.insert(targetnoteZPos, 0)
		table.insert(targetnoteAngle, 0) 
		noteXPos[i+1] = getActorX(i)
		targetnoteXPos[i+1] = getActorX(i)
		targetnoteYPos[i+1] = _G['defaultStrum'..i..'Y']
		noteYPos[i+1] = _G['defaultStrum'..i..'Y']
	end

	initShader('barrel', 'MirrorRepeatEffect')
	--initShader('barrelHUD', 'BarrelBlurEffect')
	setCameraShader('game', 'barrel')
	setCameraShader('hud', 'barrel')
	--setShaderProperty('barrel', 'barrel', 0.0)
	setShaderProperty('barrel', 'zoom', 1.0)
	--setShaderProperty('barrelHUD', 'barrel', 0.0)
	--setShaderProperty('barrelHUD', 'zoom', 1.0)
	makeSprite('barrelOffset', '', 0, 0) --so i can tween while still having the perlin stuff
	setActorAlpha(0, 'barrelOffset')

	if not downscrollBool then 
		downscrollDiff = -1
	end
	
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

local drunkLerp = 0
local drunk = 0
local drunkSpeed = 8

local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.5

local perlinXRange = 0.05
local perlinYRange = 0.05
local perlinZRange = 1.5

function updatePost(elapsed)
	if not modcharts then 
		return
	end

    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('barrel', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange)+getActorX('barrelOffset'))
	setShaderProperty('barrel', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange)+getActorY('barrelOffset'))
	setShaderProperty('barrel', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange)+getActorAngle('barrelOffset'))





	if lerpScale then 
		noteScale = lerp(noteScale, 1, elapsed*lerpSpeedScale)
	end
	noteRotX = lerp(noteRotX, targetNoteRotX, elapsed*lerpSpeednoteRotX)

	drunk = lerp(drunk, drunkLerp, elapsed*5)

	local currentBeat = (songPos / 1000)*(bpm/60)

	for i = 0,(keyCount*2)-1 do 
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
    local songSpeed = getProperty('', 'speed')
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

				if isRenderedNoteSustainEnd(i) then --sustain ends
					if defaultSusEndHeight == -1 then 
						defaultSusEndHeight = getRenderedNoteScaleY(i)
					end
					
					setRenderedNoteScale(defaultSusWidth*noteScale * (1/-totalNotePos[3]),1, i)
					setRenderedNoteScaleY(defaultSusEndHeight* (1/-totalNotePos[3]), i)
				else 
                    if defaultSusHeight == -1 then 
                        defaultSusHeight = getRenderedNoteScaleY(i)
                    end
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


function stepHit()
	--perlin cam movement stuff
	if curStep == 256 or curStep == 1792 or curStep == 3136 or curStep == 4448 then 
		perlinSpeed = 1
		perlinXRange = 0.07
		perlinYRange = 0.07
		perlinZRange = 1.5
	end
	if curStep == 544 or curStep == 1056 or curStep == 2112 or curStep == 4480 then 
		perlinSpeed = 2
		perlinXRange = 0.15
		perlinYRange = 0.15
		perlinZRange = 8
	end
	if curStep == 768 or curStep == 1280 or curStep == 2336 or curStep == 4704 then 
		perlinSpeed = 5
		perlinXRange = 0.2
		perlinYRange = 0.2
		perlinZRange = 15
	end
	if curStep == 800 or curStep == 1824 or curStep == 2368 then 
		perlinSpeed = 1.25
		perlinXRange = 0.1
		perlinYRange = 0.1
		perlinZRange = 2
	end

	if curStep == 1312 or curStep == 4736 then 
		perlinSpeed = 0.5
		perlinXRange = 0.05
		perlinYRange = 0.05
		perlinZRange = 1.5
	end

	
	if curStep == 2624 or curStep == 3936 then 
		perlinSpeed = 2.5
		perlinXRange = 0.2
		perlinYRange = 0.2
		perlinZRange = 15
	end
	if curStep == 2880 or curStep == 4192 then 
		perlinSpeed = 4
		perlinZRange = 30
	end


	if curStep == 768-4 or curStep == 1280-4 or curStep == 2336-4 or curStep == 4704-4 then 
		for i = 0,3 do 
			targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.5)
			targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.5)
			noteAngle[i+1] = -360
			noteAngle[i+1+4] = 360
		end
	end
	if curStep == 768+32 or curStep == 1280+32 or curStep == 2336+32 or curStep == 4704+32 then 
		for i = 0,3 do 
			targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
			targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
			noteAngle[i+1] = 360
			noteAngle[i+1+4] = -360
		end
	end

	local section = math.floor(curStep/16)

	--intro section and first break section
	if (section < 16) or (section >= 82 and section < 98) then 
		if curStep % 4 == 0 then 
			local note = math.floor((curStep%16)/4)
			local flippedNote = (0-note)+4
			noteZPos[note+1] = noteZPos[note+1] + -100
			noteZPos[flippedNote+4] = noteZPos[flippedNote+4] + -100

			noteAngle[note+1] = -45
			noteAngle[flippedNote+4] = 45
		end
		if curStep % 16 == 0 then 
			noteScale = noteScale - 0.2
		end
	end

	--regular beat sections or whatever
	if (section >= 34 and section < 50) or (section >= 66 and section < 82) or (section >= 132 and section < 148) or (section >= 214 and section < 246) or (section >= 280 and section < 296) then 
		if curStep % 2 == 0 or curStep % 32 == 7 or curStep % 32 == 15 then 
			noteScale = noteScale + 0.06
			triggerEvent("add camera zoom", 0.03, 0.03)
		end
	end

	--section after first break
	if (section >= 98 and section < 114) then 
		if curStep % 8 == 0 or curStep % 32 == 20 then 
			noteScale = noteScale + 0.2
			drunk = 0.35
			triggerEvent("add camera zoom", 0.08, 0.08)
		end
	end

	--the "hard" part
	if (section >= 164 and section < 178) or (section >= 246 and section < 260) then 
		if curStep % 32 > 16 and curStep % 2 == 0 then 
			noteScale = noteScale + 0.2
			triggerEvent("add camera zoom", 0.04, 0.04)
			if section >= 262 then 
				setShaderProperty('barrel', 'zoom', 1.4)
				tweenShaderProperty('barrel', 'zoom', 1.3, crochet*0.001*2, 'cubeOut')
			else 
				setShaderProperty('barrel', 'zoom', 1.2)
				tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
			end
		elseif curStep % 16 == 0 or curStep % 16 == 4 or curStep % 16 == 6 or curStep % 16 == 10 or curStep % 16 == 12 or curStep % 16 == 14 then 
			noteScale = noteScale + 0.2
			triggerEvent("add camera zoom", 0.04, 0.04)
			if section >= 262 then 
				setShaderProperty('barrel', 'zoom', 1.4)
				tweenShaderProperty('barrel', 'zoom', 1.3, crochet*0.001*2, 'cubeOut')
			else 
				setShaderProperty('barrel', 'zoom', 1.2)
				tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
			end
		end
	end

	if (section >= 180 and section < 194) or (section >= 262 and section < 276) then 
		if curStep % 2 == 0 then 
			noteScale = noteScale + 0.1
			triggerEvent("add camera zoom", 0.03, 0.03)
			if section >= 262 then 
				setShaderProperty('barrel', 'zoom', 1.7)
				tweenShaderProperty('barrel', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
			else 
				setShaderProperty('barrel', 'zoom', 1.4)
				tweenShaderProperty('barrel', 'zoom', 1.3, crochet*0.001*2, 'cubeOut')
			end

		end
	end

	--just before first break ends
	if section == 97 then 
		if curStep % 16 == 0 or curStep % 16 == 4 or curStep % 16 == 6 or curStep % 16 == 10 or curStep % 16 == 12 then 
			triggerEvent("add camera zoom", 0.08, 0.08)
			setProperty('', 'camZooming', false)
		end
		if curStep % 16 == 8 then 
			triggerEvent("add camera zoom", 0.02, -0.1)
		end
	end

	if section == 96 or section == 97 then 
		if curStep % 32 == 0 then 
			targetnoteZPos[4+4] = 1000
		elseif curStep % 32 == 8 then 
			targetnoteZPos[3+4] = 1000
		elseif curStep % 32 == 16 then 
			targetnoteZPos[2+4] = 1000
		elseif curStep % 32 == 24 then 
			targetnoteZPos[1+4] = 1000
		end
	end

	if section == 101 or section == 109 then 
		for i = 0,3 do 
			targetnoteZPos[i+1] = 1000
			targetnoteZPos[i+1+4] = 0
		end
	end
	if section == 105 then 
		for i = 0,3 do 
			targetnoteZPos[i+1] = 0
			targetnoteZPos[i+1+4] = 1000
		end
	end
	if curStep == 1788 then 
		for i = 0,3 do 
			targetnoteZPos[i+1] = 0
		end
	end

	--more stuff for the "hard" part	
	if section == 178 or section == 260 then 
		if curStep % 16 == 0 or curStep % 16 == 6 or curStep % 16 == 12 then 
			tweenShaderProperty('barrel', 'zoom', 1.35, crochet*0.001*4, 'cubeOut')
			if curStep % 16 == 0 or curStep % 16 == 12 then 
				for i = 0,3 do 
					targetnoteZPos[i+1] = -200
					targetnoteZPos[i+1+4] = 50
				end
			else 
				for i = 0,3 do 
					targetnoteZPos[i+1] = 50
					targetnoteZPos[i+1+4] = -200
				end
			end
		end
		if curStep % 16 == 4 or curStep % 16 == 10 then
			tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
			if curStep % 16 == 12 then 
				for i = 0,3 do 
					targetnoteZPos[i+1] = -200
					targetnoteZPos[i+1+4] = 50
				end
			else 
				for i = 0,3 do 
					targetnoteZPos[i+1] = 50
					targetnoteZPos[i+1+4] = -200
				end
			end
		end
	elseif section == 178+1 or section == 260+1 then 
		if curStep % 16 == 2 or curStep % 16 == 8 then 
			tweenShaderProperty('barrel', 'zoom', 1.35, crochet*0.001*4, 'cubeOut')
		end
		if curStep % 16 == 0 or curStep % 16 == 6 then
			tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
		end
		if curStep % 16 == 12 then
			tweenShaderProperty('barrel', 'zoom', 4, crochet*0.001*4, 'cubeIn')
		end
	elseif section == 178+2 or section == 260+2 then 
		if curStep % 16 == 0 then
			tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*4, 'cubeOut')
		end
		for i = 0,3 do 
			targetnoteZPos[i+1] = 50
			targetnoteZPos[i+1+4] = -200
		end
	end

	if section == 194 or section == 276 then 
		if curStep % 16 == 0 or curStep % 16 == 6 or curStep % 16 == 12 then 
			tweenShaderProperty('barrel', 'zoom', 1.35, crochet*0.001*4, 'cubeOut')
		end
		if curStep % 16 == 4 or curStep % 16 == 10 then
			tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
		end
	elseif section == 194+1 or section == 276+1 then 
		if curStep % 16 == 2 or curStep % 16 == 8 then 
			tweenShaderProperty('barrel', 'zoom', 1.35, crochet*0.001*4, 'cubeOut')
		end
		if curStep % 16 == 0 or curStep % 16 == 6 then
			tweenShaderProperty('barrel', 'zoom', 1.1, crochet*0.001*2, 'cubeOut')
		end
		if curStep % 16 == 12 then
			tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*4, 'cubeIn')
		end
	end




	if curStep % 16 == 0 then --start of each section
		if section == 164 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = 50
				targetnoteZPos[i+1+4] = -200
			end
		end
		if section == 184 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = -200
				targetnoteZPos[i+1+4] = 50
			end
		end

		if section == 246 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = 50
				targetnoteZPos[i+1+4] = -200
			end
		end
		if section == 266 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = -200
				targetnoteZPos[i+1+4] = 50
			end
		end
	end
	--middlescroll during the "hard" part
	if section == 188-1 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.5)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.5)
				noteAngle[i+1] = -360
				noteAngle[i+1+4] = 360
				targetnoteZPos[i+1] = 200
				targetnoteZPos[i+1+4] = 200
			end
		end
	end
	if section == 193 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
				noteAngle[i+1] = 360
				noteAngle[i+1+4] = -360
				targetnoteZPos[i+1] = 0
				targetnoteZPos[i+1+4] = 0
			end
		end
	end
	if section == 270-1 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.5)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.5)
				noteAngle[i+1] = -360
				noteAngle[i+1+4] = 360
				targetnoteZPos[i+1] = 200
				targetnoteZPos[i+1+4] = 200
			end
			targetnoteXPos[1] = targetnoteXPos[1]-(112*2)
			targetnoteXPos[2] = targetnoteXPos[2]-(112)
			targetnoteXPos[3] = targetnoteXPos[3]
			targetnoteXPos[4] = targetnoteXPos[4]+(112)

			targetnoteXPos[5] = targetnoteXPos[5]-(112)
			targetnoteXPos[6] = targetnoteXPos[6]
			targetnoteXPos[7] = targetnoteXPos[7]+112
			targetnoteXPos[8] = targetnoteXPos[8]+(112*2)
		end
	end
	if section == 275 then
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
				noteAngle[i+1] = 360
				noteAngle[i+1+4] = -360
				targetnoteZPos[i+1] = 0
				targetnoteZPos[i+1+4] = 0
			end
		end
	end

	--long note sections
	if (section >= 50 and section < 66) or (section >= 114 and section < 130) then 
		if curStep % 32 > 16 and curStep % 2 == 0 then 
			noteScale = noteScale + 0.1
			triggerEvent("add camera zoom", 0.04, 0.04)
		elseif curStep % 16 == 0 or curStep % 16 == 4 or curStep % 16 == 6 or curStep % 16 == 10 or curStep % 16 == 12 or curStep % 16 == 14 then 
			noteScale = noteScale + 0.1
			triggerEvent("add camera zoom", 0.04, 0.04)
		end
	end

	--swap/scroll switch thingy
	if section == 50+5 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.333)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.333)
			end
		end
	elseif section == 50+6 then 
		if curStep % 16 == 4 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.666)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.666)
			end
		elseif curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640)
			end
		end
	elseif section == 50+7 then 
		if section == 148+7 then 

		else 
			if curStep % 16 == 4 then 
				tweenActorProperty('barrelOffset', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoOut')
			elseif curStep % 16 == 8 then 
				tweenActorProperty('barrelOffset', 'y', 1*downscrollDiff, crochet*0.001*4, 'expoOut')
			end
		end


	elseif section == 50+9 then 
		if curStep % 16 == 4 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = 200
				targetnoteZPos[i+1+4] = -200
			end
		elseif curStep % 16 == 6 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = -200
				targetnoteZPos[i+1+4] = 200
			end
		elseif curStep % 16 == 8 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = 400
				targetnoteZPos[i+1+4] = -400
			end
		elseif curStep % 16 == 10 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = -400
				targetnoteZPos[i+1+4] = 400
			end
		elseif curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteZPos[i+1] = 0
				targetnoteZPos[i+1+4] = 0
			end
		end
	end

	--reset back
	if section == 50+13 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.666)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.666)
			end
		end
	elseif section == 50+14 then 
		if curStep % 16 == 4 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.333)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.333)
			end
		elseif curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
			end
		end
	elseif section == 50+15 then
		if section == 114+15 then 
			if curStep % 16 == 0 then 
				tweenActorProperty('barrelOffset', 'y', 0.5*downscrollDiff, crochet*0.001*8, 'expoOut')
			elseif curStep % 16 == 8 then 
				tweenActorProperty('barrelOffset', 'y', 0, crochet*0.001*8, 'expoOut')
			end
		elseif section == 148+15 then 
			--if curStep % 16 == 0 then 
			--	tweenActorProperty('barrelOffset', 'y', 0, crochet*0.001*16, 'expoOut')
			--end
		else 
			if curStep % 16 == 4 then 
				tweenActorProperty('barrelOffset', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoOut')
			elseif curStep % 16 == 8 then 
				tweenActorProperty('barrelOffset', 'y', 0, crochet*0.001*4, 'expoOut')
			end
		end

	end



	--second time
	if section == 114+5 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.25)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.25)
			end
		end
	elseif section == 114+6 then 
		if curStep % 16 == 4 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.5)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.5)
			end
		elseif curStep % 16 == 12 then 
			for i = 0,7 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i%4))..'X']+(640*0.5)
			end
			targetnoteXPos[1] = targetnoteXPos[1]-(112*2)
			targetnoteXPos[2] = targetnoteXPos[2]-(112)
			targetnoteXPos[3] = targetnoteXPos[3]
			targetnoteXPos[4] = targetnoteXPos[4]+(112)

			targetnoteXPos[5] = targetnoteXPos[5]-(112)
			targetnoteXPos[6] = targetnoteXPos[6]
			targetnoteXPos[7] = targetnoteXPos[7]+112
			targetnoteXPos[8] = targetnoteXPos[8]+(112*2)


			--  < < / / ^ ^ > > 
			--      < / ^ >
			-- just to help visualize it
		end
	elseif section == 114+7 then 
		if curStep % 16 == 4 then 
			tweenActorProperty('barrelOffset', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoOut')
		elseif curStep % 16 == 8 then 
			tweenActorProperty('barrelOffset', 'y', 1*downscrollDiff, crochet*0.001*4, 'expoOut')
		end
	elseif section == 114+9 then
		if curStep % 16 == 4 then
			for i = 0,3 do 
				targetnoteAngle[i+1] = 45
				targetnoteAngle[i+1+4] = -45
			end
		elseif curStep % 16 == 6 then 
			for i = 0,3 do 
				targetnoteAngle[i+1] = -45
				targetnoteAngle[i+1+4] = 45
			end
		elseif curStep % 16 == 8 then 
			for i = 0,3 do 
				targetnoteAngle[i+1] = 90
				targetnoteAngle[i+1+4] = -90
			end
		elseif curStep % 16 == 10 then 
			for i = 0,3 do 
				targetnoteAngle[i+1] = -90
				targetnoteAngle[i+1+4] = 90
			end
		elseif curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteAngle[i+1] = 0
				targetnoteAngle[i+1+4] = 0
			end
		end
	end

	--reset back
	if section == 114+13 then 
		if curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']+(640*0.5)
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']-(640*0.5)
			end
		end
	elseif section == 114+14 then 
		if curStep % 16 == 4 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
			end
		elseif curStep % 16 == 12 then 
			for i = 0,3 do 
				targetnoteXPos[i+1] = _G['defaultStrum'..((i))..'X']
				targetnoteXPos[i+1+4] = _G['defaultStrum'..((i+4))..'X']
			end
		end
	elseif section == 130 then
		if curStep % 16 == 0 then 
			tweenActorProperty('barrelOffset', 'y', 0, crochet*0.001*16, 'expoOut')
		end
	end


	--third time
	if section == 148+5 then 
		if curStep % 16 == 12 then 

		end
	elseif section == 148+6 then 
		if curStep % 16 == 4 then 
	
		elseif curStep % 16 == 12 then 

		end
	elseif section == 148+7 then 
		if curStep % 16 == 4 then 
			--tweenActorProperty('barrelOffset', 'y', 0.5*downscrollDiff, crochet*0.001*4, 'expoOut')
		elseif curStep % 16 == 8 then 
			--tweenActorProperty('barrelOffset', 'y', 1*downscrollDiff, crochet*0.001*4, 'expoOut')
		end
	elseif section == 148+9 then 
		if curStep % 16 == 4 then 

		elseif curStep % 16 == 6 then 

		elseif curStep % 16 == 8 then 

		elseif curStep % 16 == 10 then 

		elseif curStep % 16 == 12 then 

		end
	end

	--reset back
	if section == 148+13 then 
		if curStep % 16 == 12 then 

		end
	elseif section == 148+14 then 
		if curStep % 16 == 4 then 

		elseif curStep % 16 == 12 then 

		end
	elseif section == 148+15 then
		if curStep % 16 == 0 then 

		elseif curStep % 16 == 8 then 
			
		end
	end


end