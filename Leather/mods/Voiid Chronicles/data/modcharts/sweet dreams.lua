


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
local songSpeed = 1
function createPost()
	songSpeed = getProperty('', 'speed')
	for i = 0, (keyCount*2)-1 do 
		table.insert(noteXPos, 0) --setup default pos and whatever
		table.insert(noteYPos, 0)
		table.insert(noteZPos, 0)
		table.insert(noteZScale, 1)
		table.insert(noteAngle, 0)
		table.insert(targetnoteXPos, 0)
		table.insert(targetnoteYPos, 0)
		table.insert(targetnoteZPos, -200)
		table.insert(targetnoteAngle, 0) --start angle at weird number for start
		noteXPos[i+1] = getActorX(i)
		targetnoteXPos[i+1] = getActorX(i)
		targetnoteYPos[i+1] = _G['defaultStrum'..i..'Y']
		noteYPos[i+1] = _G['defaultStrum'..i..'Y']
	end
end
local noteScale = 0.7
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end

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
local lerpSpeedY = 4
local lerpSpeedZ = 4
local lerpSpeedAngle = 3
local lerpSpeednoteRotX = 5

function updatePost(elapsed)
	if not modcharts then 
		return
	end
	if lerpScale then 
		noteScale = lerp(noteScale, 1, elapsed*lerpSpeedScale)
	end
	noteRotX = lerp(noteRotX, targetNoteRotX, elapsed*lerpSpeednoteRotX)
	
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
				thisnoteYPos = thisnoteYPos + (0.45*curPos) - getRenderedNoteOffsetY(i)
				if isRenderedNoteSustainEnd(i) then 
					thisnoteYPos = thisnoteYPos - (getRenderedNoteHeight(i))+2
				end
			else 
				thisnoteYPos = thisnoteYPos - (0.45*curPos) - getRenderedNoteOffsetY(i)
			end
			local thisnoteXPos = noteXPos[data+1]+offsetX
			
			local noteRotPos = getNoteRot(thisnoteXPos, thisnoteYPos, noteRotX)
	
			thisnoteXPos = noteRotPos[1]
			thisnoteYPos = noteRotPos[2]
			local thisnotePosZ = noteRotPos[3]+(noteZPos[data+1]/1000)
			local totalNotePos = calculatePerspective(thisnoteXPos, thisnoteYPos, thisnotePosZ)

			if not isSustain(i) then 
				setRenderedNoteScale(defaultWidth*noteScale * (1/-totalNotePos[3]),defaultWidth*noteScale * (1/-totalNotePos[3]), i)
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
					setRenderedNoteScaleY(defaultSusHeight* (1/-totalNotePos[3]), i)
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








---actual events stuff here---

local thingsHit = 0

local slices = {408}

local strings1 = {0,12,16,32,40,44,48,60,64,72,76,80,88,96,104,108,112,116,120,124}
local git1 = {0,4,6,8,12,18,20,22,24,28}

local bfFocusSteps = {476,732,1500,1628,1756,1884,2044,2172,2300,2428,3004,3132,3260}
local dadFocusSteps = {416, 540, 672,796,988,1440,1564,1692,1820,1984,2108,2236,2364,2940,3072,3200}


function stepHit(curStep)


	--intro part
	if (curStep < 256) or (curStep >= 1184 and curStep < 1440) or (curStep >= 2496 and curStep < 2752) or (curStep >= 3328 and curStep < 3456) then 
		if curStep % 16 == 0 then 
			for i = 0,(keyCount*2)-1 do 
				local movement = 0
				if i < keyCount then 
					movement = 10*(i+1)
				else 
					
					movement = 10 * scale(i%keyCount, 0, keyCount, keyCount, 0)+1
				end
				noteYPos[i+1] = targetnoteYPos[i+1] + movement
			end
		end
		if curStep % 16 == 0 or curStep % 16 == 4 or curStep % 16 == 9 or curStep % 16 == 13 then 
			noteYPos[thingsHit+1] = targetnoteYPos[thingsHit+1] - 20
			thingsHit = (thingsHit + 1)
			if thingsHit > (keyCount*2)-1 then 
				thingsHit = 0
			end
		end
	end


	
	if curStep == 233 then 
		for i = 0,(keyCount*2)-1 do 
			targetnoteZPos[i+1] = -1200 
		end
		lerpSpeedZ = 0.5
	elseif curStep == 256-16 then
		noteRotX = 720
	elseif curStep == 256 then 
		lerpSpeedZ = 5
		for i = 0,(keyCount*2)-1 do 
			targetnoteZPos[i+1] = -200
		end
		

	elseif curStep == 856 then 
		goMiddlescroll()
	elseif curStep == 916 then 
		resetNotePos()
	elseif curStep == 1976 then 
		lerpSpeedZ = 8
		for i = 0,(keyCount*2)-1 do 
			noteZPos[i+1] = -8000
		end
	elseif curStep == 2480 then 
		for i = 0,(keyCount*2)-1 do 
			noteZPos[i+1] = -1000
		end
	elseif curStep == 2497 or curStep == 3328 then 
		for i = 0,(keyCount*2)-1 do 
			targetnoteZPos[i+1] = -200
		end
		drunk = 1
		drunkSpeed = 0.5
	elseif curStep == 2752 or curStep == 3456 then 
		for i = 0,(keyCount*2)-1 do 
			targetnoteZPos[i+1] = 1000
		end
	elseif curStep == 2800 then 
		for i = 0,(keyCount*2)-1 do 
			targetnoteZPos[i+1] = -200
		end
		noteRotX = 360
		drunk = 0
	elseif curStep == 1184 then 
		for j = 0,(keyCount*2)-1 do 
			targetnoteZPos[j+1] = -200
		end
	end


	for i = 0,#slices-1 do 
		if curStep == slices[i+1] then 
			noteRotX = 180
		end
	end

	for i = 0,#bfFocusSteps-1 do 
		if curStep == bfFocusSteps[i+1] then 
			lerpSpeedZ = 2
			lerpSpeedAngle = 6
			for j = 0,(keyCount*2)-1 do 
				if j < keyCount then 
					targetnoteZPos[j+1] = -500
				else 
					targetnoteZPos[j+1] = -100
				end
				local ang = 360
				if j % 2 == 0 then 
					ang = -360
				end
				noteAngle[j+1] = ang
			end
		end
	end

	for i = 0,#dadFocusSteps-1 do 
		if curStep == dadFocusSteps[i+1] then 
			lerpSpeedZ = 2
			lerpSpeedAngle = 6
			for j = 0,(keyCount*2)-1 do 
				if j < keyCount then 
					targetnoteZPos[j+1] = -100
				else 
					targetnoteZPos[j+1] = -500
				end
				local ang = -360
				if j % 2 == 0 then 
					ang = 360
				end
				noteAngle[j+1] = ang
			end
		end
	end

	if curStep >= 256 and curStep < 384 then 
		if curStep % 16 == 0 or curStep % 16 == 2 or curStep % 16 == 4 or curStep % 16 == 6 or curStep % 16 == 8 or curStep % 16 == 12 then
			noteScale = noteScale + 0.15
		end
	end


	if curStep >= 416 and curStep <= 1184 then 
		for i = 0,#git1-1 do 
			if curStep % 32 == git1[i+1] then 
				noteScale = noteScale + 0.12
			end
		end
		if (curStep >= 416 and curStep < 672) or (curStep >= 928 and curStep < 1184) then 
			for i = 0,#strings1-1 do 
				if (curStep-32) % 128 == strings1[i+1] then 
					for j = 0,(keyCount*2)-1 do 
						local movement = 0
						if j < keyCount then 
							movement = -20*(j+1)
						else 
							
							movement = -20 * scale(j%keyCount, 0, keyCount, keyCount, 0)+1
						end
						noteZPos[j+1] = noteZPos[j+1] + movement
					end
				end
			end
		end

		if curStep >= 672 then 
			if curStep % 16 == 4 or curStep % 16 == 12 then
				for j = 0,(keyCount*2)-1 do  
					noteZPos[j+1] = noteZPos[j+1] + -50
				end
			end
			if curStep % 16 == 8 then 
				for j = 0,(keyCount*2)-1 do  
					noteZPos[j+1] = noteZPos[j+1] + 50
				end
			end
		end

		if curStep % 512 == 128 then 
			for i = 0,(keyCount*2)-1 do 
				targetnoteZPos[i+1] = -900
			end
			drunkSpeed = 3
		elseif curStep % 512 == 128+16 then
			for i = 0,(keyCount*2)-1 do 
				targetnoteZPos[i+1] = -1600
			end
			drunkSpeed = 7.5
		elseif curStep % 512 == 128+32 then
			for i = 0,(keyCount*2)-1 do 
				--targetnoteZPos[i+1] = -200
			end
			drunk = 0
			drunkSpeed = 1


		elseif curStep % 512 == 128-32 then
			for i = 0,(keyCount*2)-1 do 
				targetnoteZPos[i+1] = -50
			end
			drunk = 0.4
		elseif curStep % 512 == 128-16 then
			for i = 0,(keyCount*2)-1 do 
				targetnoteZPos[i+1] = -200
			end
		elseif curStep % 512 == 128-8 then
			for i = 0,(keyCount*2)-1 do 
				targetnoteZPos[i+1] = -400
			end
		end
	end



	if curStep >= 1440 and curStep < 1952 then 
		for i = 0,#git1-1 do 
			if curStep % 32 == git1[i+1] then 
				noteScale = noteScale + 0.12
			end
		end
		if curStep < 1824 then 
			if curStep % 16 == 4 or curStep % 16 == 12 then
				for j = 0,(keyCount*2)-1 do  
					noteZPos[j+1] = noteZPos[j+1] + -50
				end
			end
			if curStep % 16 == 8 then 
				for j = 0,(keyCount*2)-1 do  
					noteZPos[j+1] = noteZPos[j+1] + 50
				end
			end
		end

	end

	if (curStep >= 1984 and curStep < 2496) or (curStep >= 2816 and curStep < 3328) then 
		for i = 0,#git1-1 do 
			if curStep % 32 == git1[i+1] then 
				noteScale = noteScale + 0.12
			end
		end
		for i = 0,#strings1-1 do 
			if (curStep-32) % 128 == strings1[i+1] then 
				for j = 0,(keyCount*2)-1 do 
					local movement = 0
					if j < keyCount then 
						movement = -20*(j+1)
					else 
						
						movement = -20 * scale(j%keyCount, 0, keyCount, keyCount, 0)+1
					end
					noteZPos[j+1] = noteZPos[j+1] + movement
				end
			end
		end

	end
	


end
local noteMovementThing = {-25, -15, 15, 25, -25, -15, 15, 25}
function noteBeatMoveThing()
	for i = 0,7 do 
		noteXPos[i+1] = targetnoteXPos[i+1] + noteMovementThing[i+1]
	end
end

local beatSwap = 1
local noteMovementThingAngle = {-25, -15, 15, 25, -25, -15, 15, 25}
function noteBeatAngleThing()
	for i = 0,7 do 
		noteAngle[i+1] = noteMovementThingAngle[i+1]*beatSwap
	end
	beatSwap = beatSwap * -1
end

function noteBeatMoveThingAlt()
	for i = 0,7 do 
		noteYPos[i+1] = targetnoteYPos[i+1] + noteMovementThing[i+1]*beatSwap
	end
	beatSwap = beatSwap * -1
end

function goMiddlescroll()
	if middlescroll then 
		return
	end
	for i = 0,(keyCount*2)-1 do 
		targetnoteXPos[i+1] = _G['defaultStrum'..((i%keyCount)+keyCount)..'X']-320
		if i < keyCount then 
			targetnoteZPos[i+1] = -500
		else 
			targetnoteZPos[i+1] = -100
		end
	end
end
function resetNotePos()
	for i = 0,(keyCount*2)-1 do 
		targetnoteXPos[i+1] = _G['defaultStrum'..i..'X']
	end
end

