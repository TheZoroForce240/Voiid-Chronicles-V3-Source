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
local defaultZoom = 0.53
local curOpponent = 'opponent'
local downscrollDiff = 1
local rad = math.pi/180;
local middlescrollOffset = 0
local middlescrollOpponentOffset = 0

--based on code from andromeda engine, but with lua
local velChanges = {

	--step, speed mult
	{0, 1.0},
}
local velMarkers = {

}
function mapVelChanges()

	for i = 1, #velChanges do  --convert from step to millseconds
		velChanges[i][1] = getStrumTimeFromStep(velChanges[i][1])
	end


	local pos = 0

	velMarkers[1] = (velChanges[1][1]*velChanges[1][2])

	for i = 2, #velChanges do 
		pos = pos + ((velChanges[i][1]-velChanges[i-1][1])*velChanges[i-1][2]) --precalc scaled time
		velMarkers[i] = pos
	end
end
function getVelIdx(time)
	local idx = 1
	for i = 1, #velChanges do 
		if time >= velChanges[i][1] then 
			idx = i
		end
	end
	return idx
end
function getTime(time)

	local i = getVelIdx(time)

	local pos = velMarkers[i]
	pos = pos + ((time-velChanges[i][1])*(velChanges[i][2]));

	return pos

end

function getSpeed(time)
	local i = getVelIdx(time)
	return velChanges[i][2]
end

local noteWidth = 112


function createPost()
	mapVelChanges()
	startSpeed = getProperty('', 'speed')
	for i = 0, (keyCount+playerKeyCount)-1 do 
		table.insert(noteXPos, 0) --setup default pos and whatever
		table.insert(noteYPos, 0)
		table.insert(noteZPos, 0)
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


        
        makeSprite('note'..i, '', 0, 0)
        makeSprite('note2'..i, '', 0, 0)
        makeSprite('angle'..i, '', 0, 0)
		makeSprite('reverse'..i, '', 0, 0)
	end


    makeSprite('scale', '', 1, 1)

    makeSprite('playerAngle', '', 0, 0)
    makeSprite('opponentAngle', '', 0, 0)
    makeSprite('angle', '', 0, 0)


	makeSprite('drunk', '', 0, 0)
	makeSprite('tipsy', '', 0, 0)

	makeSprite('drunkSpeed', '', 25, 15)
	makeSprite('tipsySpeed', '', 1, 1)
	setActorAngle(25,'drunkSpeed')
	setActorAngle(1,'tipsySpeed')


	makeSprite('noteSine', '', 0, 0)
	makeSprite('noteSineSpeed', '', 6, 6)
	setActorAngle(6,'noteSineSpeed')

	makeSprite('brake', '', 0, 0)
	makeSprite('boost', '', 0, 0)

   

    makeSprite('global', '', 0, 0)
    makeSprite('player', '', 0, 0)
    makeSprite('opponent', '', 0, 0)

	makeSprite('playerIA', '', 0, 0)
    makeSprite('opponentIA', '', 0, 0)
	makeSprite('playerRot', '', 0, -90)
    makeSprite('opponentRot', '', 0, -90)


	makeSprite('screenRot', '', 0, 0)

	makeSprite('songPosOffset', '', 0, 0)

	defaultZoom = getProperty('', 'defaultCamZoom')
	--trace(defaultZoom)

	if not downscrollBool then 
		downscrollDiff = -1
	end
	if middlescroll then 
		middlescrollOffset = 320
		middlescrollOpponentOffset = -320
	end

    setupShaders()

	if opponentPlay then 
		curOpponent = 'player'
	end

	if modcharts then 

	end



	--setActorProperty('noteCam1', 'x', -112*4)
	--setActorProperty('noteCam2', 'x', 112*4)
	--setActorProperty('noteCam3', 'x', 112*8)
end

function updateCams(elapsed)
	

end

							--x,y,z,w
local screenRotQuaternion = {0,0,0,1}

local notePerlinSpeed = 0
local notePerlinRange = {0,0,0,0}
local noteRangeBoost = 1

local perlinSpeed = 0.3
					--p2          p1
					--x,y,z,angle,x,y,z,angle
local perlinTime = {0,0,0,0,0,0,0,0}
local perlinRange = {0,0,0,5}

local perlinCamRange = {0.05,0.05,2,0}

function updatePerlin(elapsed)

	updateCams(elapsed)

	for i = 1, #perlinTime do 
		perlinTime[i] = perlinTime[i] + elapsed*math.random()*perlinSpeed
	end

	--setActorX(getActorX('screenRot')+100*elapsed, 'screenRot')
	--setActorY(getActorY('screenRot')+60*elapsed, 'screenRot')
	--setActorAngle(getActorAngle('screenRot')+75*elapsed, 'screenRot')

	--setShaderProperty('mirror2', 'x', ((-0.5 + perlin(perlinTime[1], 0, 0))*perlinCamRange[1]))
	--setShaderProperty('mirror2', 'y', ((-0.5 + perlin(0, perlinTime[2], 0))*perlinCamRange[2]))
	--setShaderProperty('mirror2', 'angle', ((-0.5 + perlin(0, 0, perlinTime[3]))*perlinCamRange[3]))


	screenRotQuaternion = updateQuaternion('screenRot', screenRotQuaternion)
end
--https://github.com/topameng/CsToLua/blob/master/tolua/Assets/Lua/Quaternion.lua
function updateQuaternion(vec3, q)
	local x = getActorX(vec3)*rad*0.5
	local y = getActorY(vec3)*rad*0.5
	local z = getActorAngle(vec3)*rad*0.5

	local sinX = math.sin(x)
    local cosX = math.cos(x)
    local sinY = math.sin(y)
    local cosY = math.cos(y)
    local sinZ = math.sin(z)
    local cosZ = math.cos(z)
    
    q[4] = cosY * cosX * cosZ + sinY * sinX * sinZ
    q[1] = cosY * sinX * cosZ + sinY * cosX * sinZ
    q[2] = sinY * cosX * cosZ - cosY * sinX * sinZ
    q[3] = cosY * cosX * sinZ - sinY * sinX * cosZ
	return q
end
function applyQuaternion(xyz, q)

	local num 	= q[1] * 2
	local num2 	= q[2] * 2
	local num3 	= q[3] * 2
	local num4 	= q[1] * num
	local num5 	= q[2] * num2
	local num6 	= q[3] * num3
	local num7 	= q[1] * num2
	local num8 	= q[1] * num3
	local num9 	= q[2] * num3
	local num10 = q[4] * num
	local num11 = q[4] * num2
	local num12 = q[4] * num3

	local point = {xyz[1], xyz[2], xyz[3]} --copy
	
	xyz[1] = (((1 - (num5 + num6)) * point[1]) + ((num7 - num12) * point[2])) + ((num8 + num11) * point[3])
	xyz[2] = (((num7 + num12) * point[1]) + ((1 - (num4 + num6)) * point[2])) + ((num9 - num10) * point[3])
	xyz[3] = (((num8 - num11) * point[1]) + ((num9 + num10) * point[2])) + ((1 - (num4 + num5)) * point[3])

	return xyz
end
function rotateVector(xyz, q)

	xyz[1] = xyz[1] - (1280*0.5) + (112*0.5)
	xyz[2] = xyz[2] - (720*0.5) + (112*0.5)
	--xyz[3] = xyz[3] - (1000)

	xyz = applyQuaternion(xyz, screenRotQuaternion)

	xyz[1] = xyz[1] + (1280*0.5) - (112*0.5)
	xyz[2] = xyz[2] + (720*0.5) - (112*0.5)
	--xyz[3] = xyz[3] + (1000)

	return xyz
end
function getPerlin(player, axis)
	local p = 0
	player = player*4
	if axis == 0 then 
		p = perlin(perlinTime[axis+player], player, player)
	elseif axis == 1 then 
		p = perlin(player, perlinTime[axis+player], player)
	elseif axis == 2 then 
		p = perlin(player, player, perlinTime[axis+player])
	else 
		p = perlin(perlinTime[axis+player], player, perlinTime[axis+player])
	end
	return ((-0.5 + p)*perlinRange[axis])
end

local noteScale = 1
function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local defaultNoteScale = -1

local defaultWidth = -1
local defaultSusWidth = -1
local defaultSusHeight = -1
local defaultSusEndHeight = -1

function getNoteX(i)
    local pos = targetnoteXPos[i+1] + getActorX('global') + getActorX('note'..i) + getActorX('note2'..i)
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		pos = pos + getPerlin(0, 1)
	else 
		pos = pos + getPerlin(1, 1)
    end
    pos = pos + getActorX(p) + ((-0.5 + perlin((songPos*notePerlinSpeed)+i, 0, 0))*notePerlinRange[1]*noteRangeBoost)
    return pos
end
function getNoteY(i)
    local pos = targetnoteYPos[i+1] + getActorY('global') + getActorY('note'..i) + getActorY('note2'..i)
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		pos = pos + getPerlin(0, 2)
	else 
		pos = pos + getPerlin(1, 2)
    end
    pos = pos + getActorY(p)

	local scrollSwitch = 520
	if downscrollBool then 
		scrollSwitch = -520
	end
	pos = pos + (getActorY('reverse'..i)*scrollSwitch) + ((-0.5 + perlin(0, (songPos*notePerlinSpeed)+i, 0))*notePerlinRange[2]*noteRangeBoost)

    return pos
end
function getNoteZ(i)
    local pos = getActorAngle('global') + getActorAngle('note'..i) + getActorAngle('note2'..i)
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		pos = pos + getPerlin(0, 3)
	else 
		pos = pos + getPerlin(1, 3)
    end
    pos = pos + getActorAngle(p) + ((-0.5 + perlin(0, 0, (songPos*notePerlinSpeed)+i))*notePerlinRange[3]*noteRangeBoost)
    return pos
end
function getNoteAngle(i)
    local pos = getActorAngle('angle') + getActorAngle('angle'..i)
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		pos = pos - getPerlin(0, 4)
	else 
		pos = pos - getPerlin(1, 4)
    end
    pos = pos + getActorAngle(p..'Angle')
    return pos
end
function getNoteAlpha(i)
    local pos = getActorAlpha('global') * getActorAlpha('note'..i)
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
    end
    pos = pos * getActorAlpha(p)
    return pos
end

function getNoteDist(i)
	local dist = -0.45 
	dist = dist * (1-(getActorY('reverse'..i)*2));
	if downscrollBool then 
		dist = dist * -1
	end
	return dist
end

function getIAX(i)
	local x = 0
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
    end
	x = x + getActorX(p..'IA')
	return x
end
function getIAY(i)
	local y = 0
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		y = y + getPerlin(0, 4)
	else 
		y = y + getPerlin(1, 4)
    end
	y = y + getActorY(p..'IA')
	return y
end
function getStrumRot(i)
	local x = 0
	local y = 0
    local p = 'player'
    if i < keyCount then 
        p = 'opponent'
		y = y + getPerlin(0, 4)
	else 
		y = y + getPerlin(1, 4)
    end
	x = x + getActorX(p..'Rot')
	y = y + getActorY(p..'Rot')
	return {x, y}
end

function clamp(val, min, max)
	if val < min then
		val = min
	elseif max < val then
		val = max
	end
	return val
end
--https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
function scale(valueIn, baseMin, baseMax, limitMin, limitMax)
	return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin
end

function drunk(lane, curPos, speed)
	return (math.cos( ((songPos*0.001) + ((lane%4)*0.2) + 
        (curPos*0.45)*(10/720)) * (speed*0.2)) * 112*0.5);
end
function tipsy(lane, curPos, speed)
	return ( math.cos( songPos*0.001 *(1.2) + 
	(lane%4)*(2.0) + speed*(0.2) ) * 112*0.4 );
end
function boost(value, height, curPos, speed)
	local yOffset = 0
	local fYOffset = -curPos / speed --idk why its minus it just is
	local fEffectHeight = height
	local fNewYOffset = fYOffset * 1.5 / ((fYOffset+fEffectHeight/1.2)/fEffectHeight); 
	local fAccelYAdjust = value * (fNewYOffset - fYOffset);
	fAccelYAdjust = clamp(fAccelYAdjust*speed, -400, 400);
	yOffset = yOffset - (fAccelYAdjust);

	curPos = curPos + yOffset
	return curPos
end
function brake(value, height, curPos, speed)
	--trace(curPos)
	local yOffset = 0
	local fYOffset = -curPos / speed
	local fEffectHeight = height
	local fScale = scale(fYOffset, 0, fEffectHeight, 0, 1);
	local fNewYOffset = fYOffset * fScale; 
	local fBrakeYAdjust = value * (fNewYOffset - fYOffset);
	fBrakeYAdjust = clamp( fBrakeYAdjust, -400, 400 );
	yOffset = yOffset - fBrakeYAdjust*speed;

	curPos = curPos + yOffset
	
	return curPos
end
function getCurPos(curPos, speed)


	if getActorX('boost') ~= 0 then 
		curPos = boost(getActorX('boost'), 720, curPos, speed)
	end
	if getActorX('brake') ~= 0 then 
		curPos = brake(getActorX('brake'), 720, curPos, speed)
	end

	return curPos
end


function updatePost(elapsed)
	if not modcharts then 
		return
	end
	songSpeed = getProperty('', 'speed')
	local songVisualPos = getTime(songPos) + getActorX('songPosOffset')

	noteScale = getActorX('scale')

	updatePerlin(elapsed)

	--drunk = lerp(drunk, drunkLerp, elapsed*5)

	local currentBeat = (songPos / 1000)*(bpm/60)

	for i = 0,(keyCount+playerKeyCount)-1 do 
		noteXPos[i+1] = getNoteX(i)
		noteYPos[i+1] = getNoteY(i)
		noteZPos[i+1] = getNoteZ(i)

		local thisnotePosX = noteXPos[i+1] + getXOffset(i, 0)
		local thisnotePosY = noteYPos[i+1] + getYOffset(i, 0)
		local thisnotePosZ = noteZPos[i+1] + getZOffset(i, 0)


		local rotatedPos = rotateVector({thisnotePosX, thisnotePosY, thisnotePosZ}, screenRotQuaternion)

		--local thisnotePosX = noteXPos[i+1]
		--local thisnotePosY = noteYPos[i+1]
		--local thisnotePosZ = (noteZPos[i+1]/1000)-1

		--noteAngle[i+1] = lerp(noteAngle[i+1], targetnoteAngle[i+1], elapsed*lerpSpeedAngle)
		setActorModAngle(getNoteAngle(i), i)
        setActorAlpha(getNoteAlpha(i), i)

		local totalNotePos = calculatePerspective(rotatedPos[1], rotatedPos[2], (rotatedPos[3]*0.001)-1)
		
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
	local s = getSpeed(songPos)
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
			local dist = getNoteDist(data)
			if dist > 0 then --downscroll
				if isRenderedNoteSustainEnd(i) then 
					strumTime = getRenderedNotePrevNoteStrumtime(i)
				end
			end
			
			strumTime = getTime(strumTime)
			local curPos = ((songVisualPos-strumTime)) * songSpeed
			curPos = getCurPos(curPos, songSpeed)
			offsetX = offsetX + getXOffset(data, curPos)
			local thisnoteYPos = noteYPos[data+1]

			local incomingAngleRotation = getCartesianCoords3D(getIAX(data), getIAY(data), (dist*curPos))

			thisnoteYPos = thisnoteYPos + incomingAngleRotation[2] - (getRenderedNoteOffsetY(i)) + getYOffset(data, curPos)
			if dist > 0 then --downscroll
				if isRenderedNoteSustainEnd(i) then 
					thisnoteYPos = thisnoteYPos - (getRenderedNoteHeight(i))+2
				end
			--else 
				--thisnoteYPos = thisnoteYPos - (0.45*curPos) - (getRenderedNoteOffsetY(i))
			end
            
			local thisnoteXPos = noteXPos[data+1]+offsetX+incomingAngleRotation[1]
			local thisnotePosZ = (noteZPos[data+1] + getZOffset(data, curPos) + incomingAngleRotation[3])

			local rotatedPos = rotateVector({thisnoteXPos, thisnoteYPos, thisnotePosZ}, screenRotQuaternion)

			local totalNotePos = calculatePerspective(rotatedPos[1], rotatedPos[2], (rotatedPos[3]*0.001)-1)

            local zScale = (1/-totalNotePos[3])

            local alpha = getNoteAlpha(data)

			if not isSustain(i) then 
				--setRenderedNoteScale(getRenderedNoteWidth(i)*,getRenderedNoteHeight(i)*noteScale * (1/-totalNotePos[3]), i)
				setRenderedNoteScaleX(defaultNoteScale*noteScale * zScale, i)
				setRenderedNoteScaleY(defaultNoteScale*noteScale * zScale, i)
				setRenderedNoteAlpha(alpha,i)
				setRenderedNoteAngle(getNoteAngle(data),i)
			else
				--offsetX = 37 * (1/-totalNotePos[3]) * (defaultWidth/112)
				setRenderedNoteAlpha(alpha*0.6,i)
				if defaultSusWidth == -1 then 
					defaultSusWidth = getRenderedNoteWidth(i)
				end
				if isRenderedNoteSustainEnd(i) then --sustain ends
					setRenderedNoteScale(defaultSusWidth*noteScale * zScale,1, i)
					setRenderedNoteScaleY(getRenderedNoteSustainScaleY(i)* zScale, i)
				else 
					setRenderedNoteScale(defaultSusWidth*noteScale * zScale,1, i)
					setRenderedNoteScaleY(getRenderedNoteSustainScaleY(i)* zScale * (songSpeed/startSpeed) * s, i)
				end

				setRenderedNoteAngle(0,i)
				--susOffset = 37*noteScale
			end
			
			setRenderedNotePos(totalNotePos[1],totalNotePos[2], i)
		end
	end

end

local distFromCenter = {1.5, 0.5, -0.5, -1.5}

function getXOffset(data, curPos)
	local off = 0
	if getActorX('drunk') ~= 0 then 
		off = off + (getActorX('drunk')*drunk(data, curPos, getActorX('drunkSpeed')))
	end
	if getActorX('tipsy') ~= 0 then 
		off = off + (getActorX('tipsy')*tipsy(data, curPos, getActorX('tipsySpeed')))
	end
	if getActorX('noteSine') ~= 0 and curPos ~= 0 then 
		off = off + (getActorX('noteSine')*math.sin((getActorX('noteSineSpeed')*curPos*0.001)+data))
	end

	local strumRot = getStrumRot(data)
	if strumRot[1] ~= 0 or strumRot[2] ~= 0 then 
		off = off + (distFromCenter[(data%4)+1]*112) -- move to center

		off = off + getCartesianCoords3D(strumRot[1], strumRot[2], (distFromCenter[(data%4)+1]*112))[1]

	end


	return off
end
function getYOffset(data, curPos)
	local off = 0
	if getActorY('drunk') ~= 0 then 
		off = off + (getActorY('drunk')*drunk(data, curPos, getActorY('drunkSpeed')))
	end
	if getActorY('tipsy') ~= 0 then 
		off = off + (getActorY('tipsy')*tipsy(data, curPos, getActorY('tipsySpeed')))
	end
	if getActorY('noteSine') ~= 0 and curPos ~= 0 then 
		off = off + (getActorY('noteSine')*math.sin((getActorY('noteSineSpeed')*curPos*0.001)+data))
	end
	local strumRot = getStrumRot(data)
	if strumRot[1] ~= 0 or strumRot[2] ~= 0 then 
		off = off + getCartesianCoords3D(strumRot[1], strumRot[2], (distFromCenter[(data%4)+1]*112))[2]
	end
	return off
end
function getZOffset(data, curPos)
	local off = 0
	if getActorAngle('drunk') ~= 0 then 
		off = off + (getActorAngle('drunk')*drunk(data, curPos, getActorAngle('drunkSpeed')))
	end
	if getActorAngle('tipsy') ~= 0 then 
		off = off + (getActorAngle('tipsy')*tipsy(data, curPos, getActorAngle('tipsySpeed')))
	end
	if getActorAngle('noteSine') ~= 0 and curPos ~= 0 then 
		off = off + (getActorAngle('noteSine')*math.sin((getActorAngle('noteSineSpeed')*curPos*0.001)+data))
	end
	local strumRot = getStrumRot(data)
	if strumRot[1] ~= 0 or strumRot[2] ~= 0 then 
		off = off + getCartesianCoords3D(strumRot[1], strumRot[2], (distFromCenter[(data%4)+1]*112))[3]
	end
	return off
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

	return {x,y,z}
end


function inverseKeys(i)
	return (0-i)+keyCount
end


function setupShaders()
	--setGlobalVar('showOnlyStrums', true)
	setActorProperty('gameHUD', 'alpha', 0)
	initShader('mirror', 'MirrorRepeatWarpEffect')
	setCameraShader('game', 'mirror')
    if modcharts then 
		setCameraShader('hud', 'mirror')
	end
	setShaderProperty('mirror', 'zoom', 1.0)

	initShader('mirror2', 'MirrorRepeatWarpEffect')
	setCameraShader('game', 'mirror2')
    if modcharts then 
		setCameraShader('hud', 'mirror2')
	end
	setShaderProperty('mirror2', 'zoom', 1.0)

	initShader('vhs', 'VHSEffect')
    setCameraShader('game', 'vhs')
    setCameraShader('hud', 'vhs')
    setShaderProperty('vhs', 'effect', 1)
    setShaderProperty('vhs', 'chromaStrength', -0.005)

	initShader('glitch', 'GlitchEffect')
    setCameraShader('game', 'glitch')
    setCameraShader('hud', 'glitch')
    setShaderProperty('glitch', 'strength', 0.02)

    --initShader('grey', 'GreyscaleEffect')
    --setCameraShader('game', 'grey')
    --setCameraShader('hud', 'grey')
    --setShaderProperty('grey', 'strength', 1.0)

    initShader('vignette', 'VignetteEffect')
    setCameraShader('other', 'vignette')
    --setCameraShader('game', 'vignette')
    --setShaderProperty('vignette', 'strength', 15)
    --setShaderProperty('vignette', 'size', 0.25)

	setShaderProperty('vignette', 'strength', 0)
    setShaderProperty('vignette', 'size', 1.0)


	--setShaderProperty('vignette', 'strength', 200)
    --setShaderProperty('vignette', 'size', -1.0)
	--if true then 
	--	return;
	--end
	--setShaderProperty('mirror', 'zoom', 2.0)
	--setShaderProperty('mirror', 'angle', -30.0)
	
	--makeSprite('colorBG', '', 0,0)
    --makeGraphicRGB('colorBG', 3000/getCamZoom(),3000/getCamZoom(), '0,0,0')
    --actorScreenCenter('colorBG')
    --setActorScroll(0,0,'colorBG')
    --setActorAlpha(1, 'colorBG')
    --setActorLayer('colorBG', getActorLayer('girlfriend'))
	--setActorProperty('stage', 'alpha', 0)

	local stageList = getStageObjectList()
	
	for i = 1, #stageList-1 do 
		setActorProperty(stageList[i], 'alpha', 0)
	end

	setActorRTXProperty('dadObject', 'CFred', 0)
	setActorRTXProperty('dadObject', 'CFgreen', 0)
	setActorRTXProperty('dadObject', 'CFblue', 0)
	setActorRTXProperty('dadObject', 'CFfade', 0)

	setActorRTXProperty('girlfriend', 'CFred', 0)
	setActorRTXProperty('girlfriend', 'CFgreen', 0)
	setActorRTXProperty('girlfriend', 'CFblue', 0)
	setActorRTXProperty('girlfriend', 'CFfade', 0)

	setActorRTXProperty('boyfriendObject', 'CFred', 0)
	setActorRTXProperty('boyfriendObject', 'CFgreen', 0)
	setActorRTXProperty('boyfriendObject', 'CFblue', 0)
	setActorRTXProperty('boyfriendObject', 'CFfade', 0)

	--tweenActorColor

	for i = 0, (keyCount)-1 do 
		--setActorProperty('note'..i, 'angle', 100*(inverseKeys(i)+1))
		--setActorProperty('note'..i, 'x', -400)
		--setActorProperty('angle'..i, 'angle', 180*(inverseKeys(i)+1))


		--setActorProperty('note'..(i+playerKeyCount), 'angle', 100*(i+1))
		--setActorProperty('note'..(i+playerKeyCount), 'x', 400)
		--setActorProperty('angle'..(i+playerKeyCount), 'angle', 180*(i+1))
	end
end
function songStart()
    --tweenShaderProperty('color', 'red', 0.9, crochet*0.001*16*8, 'circIn')
    --tweenShaderProperty('color', 'green', 1.1, crochet*0.001*16*8, 'cubeIn')
    --tweenShaderProperty('color', 'blue', 0.9, crochet*0.001*16*8, 'cubeIn')
    --tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*16*16, 'cubeInOut')

	--flashCamera('game','#000000',''..crochet*0.001*8*16)
	stepHit()

	local t = 30

	tweenShaderProperty('vignette', 'strength', 15, crochet*0.001*16*t, 'linear')
	tweenShaderProperty('vignette', 'size', 0.75, crochet*0.001*16*t, 'linear')
	--tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16*t, 'linear')
	--tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*16*t, 'linear')
	--tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*16*t, 'linear')

	for i = 0, (keyCount+playerKeyCount)-1 do 
		--tweenActorProperty('note'..i, 'angle', 0, crochet*0.001*16*8, 'expoIn')
		--tweenActorProperty('note'..i, 'x', 0, crochet*0.001*16*8, 'expoIn')
		--tweenActorProperty('note'..i, 'y', 0, crochet*0.001*16*8, 'expoIn')
		--tweenActorProperty('angle'..i, 'angle', 0, crochet*0.001*16*8, 'expoIn')
	end
end
local swap = 1
local pianoShit = {0,2,1,3}
function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
	local secStep8 = curStep % 8
	local secStep32 = curStep % 32
	local secStep64 = curStep % 64

	--[[if section >= 112 and section < 122 then 
		local secStep8 = curStep % 8
		if curStep % 2 == 0 then 
			local n = (secStep8 / 2) % 4

			if section % 2 == 0 then 
				n = (0-n)+4
			end

			setAndEaseBack('note'..pianoShit[n+1], 'y', 50, crochet*0.001*4, 'cubeOut')
			setAndEaseBack('note'..(pianoShit[n+1]+4), 'y', 50, crochet*0.001*4, 'cubeOut')
		end
	end]]--

    if curStep % 16 == 0 then 
        sectionHit(section)

		if section == 16 then 
			tweenActorRTXProperty('dadObject', 'CFred', 255, crochet*0.001*32*4, 'cubeOut')
			tweenActorRTXProperty('dadObject', 'CFgreen', 255, crochet*0.001*32*4, 'cubeOut')
			tweenActorRTXProperty('dadObject', 'CFblue', 255, crochet*0.001*32*4, 'cubeOut')
		elseif section == 8 then 
			tweenActorRTXProperty('boyfriendObject', 'CFred', 255, crochet*0.001*32*4, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFgreen', 255, crochet*0.001*32*4, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFblue', 255, crochet*0.001*32*4, 'cubeOut')
		elseif section == 24 then 
			--tweenActorRTXProperty('girlfriend', 'CFred', 255, crochet*0.001*32, 'cubeOut')
			--tweenActorRTXProperty('girlfriend', 'CFgreen', 255, crochet*0.001*32, 'cubeOut')
			--tweenActorRTXProperty('girlfriend', 'CFblue', 255, crochet*0.001*32, 'cubeOut')
		elseif section == 32 then
			
			--setGlobalVar('showOnlyStrums', false)
			perlinSpeed = 0.6
			perlinRange = {25, 25, 60, 8}
			
		elseif section == 48 then
			tweenShaderProperty('vignette', 'size', 0.5, crochet*0.001*16, 'cubeOut') 
			tweenShaderProperty('mirror', 'warp', -0.1, crochet*0.001*16, 'cubeOut')
			perlinSpeed = 1
			perlinRange = {80, 80, 150, 25}
			
		elseif section == 80 then 
			perlinSpeed = 0.2
			tweenShaderProperty('vhs', 'effect', 0.6, crochet*0.001*16, 'cubeOut')
			tweenActorProperty('gameHUD', 'alpha', 0, crochet*0.001*64, 'linear')
			tweenShaderProperty('vignette', 'size', 0.75, crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('vignette', 'strength', 5.0, crochet*0.001*16, 'cubeOut') 
			local stageList = getStageObjectList()
			for i = 1, #stageList-1 do 
				tweenActorProperty(stageList[i], 'alpha', 0, crochet*0.001*16, 'cubeOut')
			end
			tweenActorRTXProperty('dadObject', 'CFfade', 0, crochet*0.001*64, 'cubeIn')
			tweenActorRTXProperty('girlfriend', 'CFfade', 0, crochet*0.001*64, 'cubeIn')
			tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, crochet*0.001*64, 'cubeIn')

			tweenActorProperty('screenRot', 'x', 720+180, crochet*0.001*64, 'cubeOut')

		elseif section == 186 then 
			local stageList = getStageObjectList()
			for i = 1, #stageList-1 do 
				tweenActorProperty(stageList[i], 'alpha', 0, crochet*0.001*32, 'cubeIn')
			end
			--tweenShaderProperty('vhs', 'effect', 0.6, crochet*0.001*32, 'cubeIn')
			--tweenActorRTXProperty('dadObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('girlfriend', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
			--tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')

		elseif section == 204 then 
			tweenShaderProperty('vhs', 'effect', 0.6, crochet*0.001*16, 'cubeOut')
			tweenActorProperty('gameHUD', 'alpha', 0, crochet*0.001*16, 'cubeOut')

			tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, crochet*0.001*16, 'cubeOut')

			tweenActorProperty('global', 'alpha', 0, crochet*0.001*16*12, 'cubeIn')

		elseif section == 85 then 
			tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
		elseif section == 88 or section == 104 then 
			tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, crochet*0.001*64, 'cubeIn')
			if section == 88 then 
				tweenShaderProperty('mirror', 'angle', 720-90, crochet*0.001*64, 'cubeOut')
				tweenActorProperty('angle', 'angle', -(720-90), crochet*0.001*64, 'cubeOut')
				tweenActorProperty('screenRot', 'x', 720, crochet*0.001*64, 'cubeOut')
			else 
				tweenActorProperty('screenRot', 'x', 180, crochet*0.001*32, 'cubeOut')
			end
		elseif section == 96 then 
			tweenActorRTXProperty('dadObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
			tweenActorProperty('angle', 'angle', -(720), crochet*0.001*16, 'cubeOut')
			tweenShaderProperty('mirror', 'angle', 720, crochet*0.001*16, 'cubeOut')
		elseif section == 100 then 
			tweenActorRTXProperty('dadObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
		elseif section == 108 then 
			tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('dadObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
			tweenActorProperty('angle', 'angle', -(720-90), crochet*0.001*32, 'cubeOut')
			tweenShaderProperty('mirror', 'angle', 720-90, crochet*0.001*32, 'cubeOut')
			tweenActorProperty('screenRot', 'x', 0, crochet*0.001*32, 'cubeOut')
			--tweenActorProperty('angle', 'angle', -720, crochet*0.001*32, 'cubeOut')
			--tweenActorProperty('screenRot', 'y', 0, crochet*0.001*32, 'cubeOut')
		elseif section == 110 then 
			--tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFred', 255, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('boyfriendObject', 'CFgreen', 255, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('boyfriendObject', 'CFblue', 255, crochet*0.001*32, 'cubeIn')
		elseif section == 112 then 
			tweenShaderProperty('mirror', 'angle', 720, crochet*0.001*32, 'cubeOut')
			tweenActorProperty('angle', 'angle', -(720), crochet*0.001*32, 'cubeOut')
			--tweenActorProperty('screenRot', 'x', 0, crochet*0.001*32, 'cubeOut')
			
		elseif section == 120 then 
			--tweenActorProperty('screenRot', 'y', 720, crochet*0.001*56, 'cubeOut')
			tweenActorProperty('screenRot', 'x', 720, crochet*0.001*56, 'cubeOut')
			--tweenActorProperty('screenRot', 'x', 720, crochet*0.001*56, 'cubeOut')
			--tweenActorProperty('screenRot', 'angle', 720, crochet*0.001*56, 'cubeOut')
		elseif section == 124 then 
			tweenShaderProperty('glitch', 'strength', 0.02, crochet*0.001*4, 'cubeOut')
			perlinSpeed = 1.25
			perlinRange = {80, 80, 200, 30}
		end
    end

	if section == 92 and secStep == 12 then 
		tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
	elseif section == 105 and secStep == 8 then 
		tweenActorRTXProperty('dadObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
	elseif section == 106 and secStep == 7 then 
		tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
	elseif section == 123 and secStep == 8 then 
		local stageList = getStageObjectList()
		for i = 1, #stageList-1 do 
			tweenActorProperty(stageList[i], 'alpha', 1, crochet*0.001*8, 'cubeIn')
		end
		tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*8, 'cubeIn')
		tweenActorRTXProperty('girlfriend', 'CFfade', 1, crochet*0.001*8, 'cubeIn')
		tweenActorRTXProperty('dadObject', 'CFfade', 1, crochet*0.001*8, 'cubeIn')

		tweenActorProperty('screenRot', 'x', 0, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('screenRot', 'y', 0, crochet*0.001*8, 'cubeIn')
		tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('angle', 'angle', 0, crochet*0.001*8, 'cubeIn')

		tweenShaderProperty('vhs', 'effect', 0, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('gameHUD', 'alpha', 1, crochet*0.001*8, 'cubeIn')

		tweenShaderProperty('vignette', 'strength', 15, crochet*0.001*8, 'cubeIn')
		tweenShaderProperty('vignette', 'size', 0.75, crochet*0.001*8, 'cubeIn')

		tweenShaderProperty('glitch', 'strength', 5, crochet*0.001*7, 'cubeIn')
	end

	if section == 30 then 
		if secStep == 0 then 
			setProperty('', 'camZooming', true)
			local stageList = getStageObjectList()
			for i = 1, #stageList-1 do 
				tweenActorProperty(stageList[i], 'alpha', 1, crochet*0.001*32, 'cubeIn')
			end
			tweenShaderProperty('vhs', 'effect', 0, crochet*0.001*32, 'cubeIn')
			tweenActorProperty('gameHUD', 'alpha', 1, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFred', 0, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFgreen', 0, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('boyfriendObject', 'CFblue', 0, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('dadObject', 'CFred', 0, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('dadObject', 'CFgreen', 0, crochet*0.001*32, 'cubeOut')
			tweenActorRTXProperty('dadObject', 'CFblue', 0, crochet*0.001*32, 'cubeOut')

			tweenActorRTXProperty('dadObject', 'CFfade', 1, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('girlfriend', 'CFfade', 1, crochet*0.001*32, 'cubeIn')
			tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, crochet*0.001*32, 'cubeIn')
		end
	end

	if section >= 32 and section < 40 then 
		if secStep32 == 0 then 
			makeTrails(0.5)
			setAndEaseBackTo('drunk', 'angle', 3, crochet*0.001*16, 'elasticOut')
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*16, 'expoOut', 0.02)
		elseif secStep32 == 24 then 
			makeTrails(0.5)
			setAndEaseBackTo('drunk', 'angle', -3, crochet*0.001*8, 'elasticOut')
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*8, 'expoOut', 0.02)
		end
	elseif section >= 40 and section < 48 then 
		if secStep32 == 0 then 
			makeTrails(0.5)
			setAndEaseBackTo('drunk', 'angle', 4, crochet*0.001*16, 'elasticOut')
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*16, 'expoOut', 0.02)
		elseif secStep32 == 24 then 
			makeTrails(0.5)
			setAndEaseBackTo('drunk', 'angle', -4, crochet*0.001*8, 'elasticOut')
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*8, 'expoOut', 0.02)
		elseif secStep32 == 16 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
		end
	elseif (section >= 48 and section < 80) or (section >= 156 and section < 172) then 
		if secStep == 8 or secStep64 == 60 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
			makeTrails(0.4)
			if secStep64 ~= 60 then 
				
				setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*16, 'expoOut', 0.02)
				--setAndEaseBackToShader('glitch', 'strength', 1, crochet*0.001*16, 'elasticOut', 0.02)
			end
		end

		if secStep64 == 0 then 
			triggerEvent('add camera zoom', '0.05', '0.05')
			setAndEaseBackTo('noteSine', 'angle', 300, crochet*0.001*8, 'cubeOut')
		elseif secStep64 == 20 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('noteSine', 'angle', 300, crochet*0.001*8, 'cubeOut')
			--setAndEaseBackTo('drunk', 'angle', -4, crochet*0.001*16, 'cubeOut')
		elseif secStep64 == 28 or secStep64 == 29 or secStep64 == 30 or secStep64 == 31 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			--setAndEaseBackTo('drunk', 'x', 2, crochet*0.001, 'cubeOut')
		elseif secStep64 == 32 or secStep64 == 36 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('noteSine', 'angle', 300, crochet*0.001*4, 'cubeOut')
			--setAndEaseBackTo('drunk', 'angle', 4, crochet*0.001*4, 'cubeOut')
		elseif secStep64 == 44 or secStep64 == 46 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('noteSine', 'angle', 300, crochet*0.001*2, 'cubeOut')
			--setAndEaseBackTo('drunk', 'x', 2, crochet*0.001*2, 'cubeOut')
		elseif secStep64 == 53 then
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('noteSine', 'angle', 300, crochet*0.001*4, 'cubeOut')

		end
	elseif (section >= 124 and section < 156) then 
		if secStep == 8 or secStep64 == 60 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
			makeTrails(0.4)
			if secStep64 ~= 60 then 
				
				setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*16, 'expoOut', 0.02)
				--setAndEaseBackToShader('glitch', 'strength', 1, crochet*0.001*16, 'elasticOut', 0.02)
			end
			setAndEaseBackTo('drunk', 'angle', 2, crochet*0.001*8, 'cubeOut')
		end

		if secStep64 == 0 then 
			triggerEvent('add camera zoom', '0.05', '0.05')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*8, 'cubeOut')
		elseif secStep64 == 20 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*8, 'cubeOut')
			--setAndEaseBackTo('drunk', 'angle', -4, crochet*0.001*16, 'cubeOut')
		elseif secStep64 == 28 or secStep64 == 29 or secStep64 == 30 or secStep64 == 31 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			--setAndEaseBackTo('drunk', 'x', 2, crochet*0.001, 'cubeOut')
		elseif secStep64 == 32 or secStep64 == 36 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*4, 'cubeOut')
			--setAndEaseBackTo('drunk', 'angle', 4, crochet*0.001*4, 'cubeOut')
		elseif secStep64 == 44 or secStep64 == 46 then 
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*2, 'cubeOut')
			--setAndEaseBackTo('drunk', 'x', 2, crochet*0.001*2, 'cubeOut')
		elseif secStep64 == 53 then
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*4, 'cubeOut')

		end

		if secStep64 == 0 then 
			tweenActorProperty('player', 'x', -520 + middlescrollOffset, crochet*0.001*32, 'smoothStepInOut')
			tweenActorProperty('opponent', 'x', 520 + middlescrollOpponentOffset, crochet*0.001*32, 'smoothStepInOut')

		elseif secStep64 == 32 then 
			if section == 154 then 
				tweenActorProperty('player', 'x', -320 + middlescrollOffset, crochet*0.001*32, 'smoothStepInOut')
				tweenActorProperty('opponent', 'x', 320 + middlescrollOpponentOffset, crochet*0.001*32, 'smoothStepInOut')
			else 
				tweenActorProperty('player', 'x', -100 + middlescrollOffset, crochet*0.001*32, 'smoothStepInOut')
				tweenActorProperty('opponent', 'x', 100 + middlescrollOpponentOffset, crochet*0.001*32, 'smoothStepInOut')
			end

		elseif secStep32 == 24 then 

		end
	end

	if section == 48-1 or section == 56-1 then 
		if secStep == 8 then 
			tweenActorProperty('player', 'x', -560 + middlescrollOffset, crochet*0.001*16, 'cubeInOut')
			tweenActorProperty('opponent', 'x', 560 + middlescrollOpponentOffset, crochet*0.001*16, 'cubeInOut')
			for i = 0, (keyCount+playerKeyCount)-1 do 
				if i % 2 == 0 then 
					tweenActorProperty('angle'..i, 'angle', -360, crochet*0.001*16, 'cubeInOut')
				else 
					tweenActorProperty('angle'..i, 'angle', 360, crochet*0.001*16, 'cubeInOut')
				end
			end
		end
	elseif section == 52-1 or section == 60-1 then 
		if secStep == 8 then 
			tweenActorProperty('player', 'x', -80 + middlescrollOffset, crochet*0.001*16, 'cubeInOut')
			tweenActorProperty('opponent', 'x', 80 + middlescrollOpponentOffset, crochet*0.001*16, 'cubeInOut')
			for i = 0, (keyCount+playerKeyCount)-1 do 
				tweenActorProperty('angle'..i, 'angle', 0, crochet*0.001*16, 'cubeInOut')
			end
		end
	elseif section == 62 then 
		if secStep == 8 then 
			tweenActorProperty('player', 'x', -320 + middlescrollOffset, crochet*0.001*16, 'cubeInOut')
			tweenActorProperty('opponent', 'x', 320 + middlescrollOpponentOffset, crochet*0.001*16, 'cubeInOut')
			tweenActorProperty(curOpponent, 'alpha', 0.15, crochet*0.001*16, 'cubeInOut')
			for i = 0, (keyCount+playerKeyCount)-1 do 
				if i % 2 == 0 then 
					tweenActorProperty('angle'..i, 'angle', -360, crochet*0.001*16, 'cubeInOut')
				else 
					tweenActorProperty('angle'..i, 'angle', 360, crochet*0.001*16, 'cubeInOut')
				end
			end
		end
	end

	local doReverse = 1
	local dontReverse = 0
	if opponentPlay then 
		dontReverse = 1
		doReverse = 0
	end


	if (section == 64-1 and not opponentPlay) or section == 76-1 or (section == 156-1 and not opponentPlay) or section == 168-1 then 
		if secStep == 8 then 
			for i = 0, (keyCount+playerKeyCount)-1 do
				if i < keyCount then 
					tweenActorProperty('reverse'..i, 'y', dontReverse, crochet*0.001*16, 'cubeInOut')
				else 
					tweenActorProperty('reverse'..i, 'y', doReverse, crochet*0.001*16, 'cubeInOut')
				end
				tweenActorProperty('angle'..i, 'angle', 0, crochet*0.001*16, 'cubeInOut')
			end
		end
	elseif section == 68-1 or section == 77-1 or section == 160-1 or section == 169-1 then 
		if secStep == 8 then 
			for i = 0, (keyCount+playerKeyCount)-1 do 
				if i < keyCount then 
					tweenActorProperty('reverse'..i, 'y', doReverse, crochet*0.001*16, 'cubeInOut')
				else 
					tweenActorProperty('reverse'..i, 'y', dontReverse, crochet*0.001*16, 'cubeInOut')
				end
				if i % 2 == 0 then 
					tweenActorProperty('angle'..i, 'angle', -360, crochet*0.001*16, 'cubeInOut')
				else 
					tweenActorProperty('angle'..i, 'angle', 360, crochet*0.001*16, 'cubeInOut')
				end
			end
		end

	end


	if section == 62 and secStep == 0 then 
		tweenShaderProperty('mirror2', 'zoom', 2, crochet*0.001*16, 'cubeOut')
	elseif section == 63 then 
		if secStep == 0 then 
			tweenShaderProperty('mirror2', 'zoom', 1, crochet*0.001*16, 'cubeIn')
			setAndEaseBackShader('mirror2', 'angle', -360, crochet*0.001*16, 'cubeInOut')
		elseif secStep == 8 then 
			
		end
	end


	if section == 76 or section == 168 then 
		if secStep == 0 then 
			tweenShaderProperty('mirror2', 'angle', 25, crochet*0.001*8, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror2', 'angle', -25, crochet*0.001*8, 'cubeOut')
		end
	elseif section == 77 or section == 169 then 
		if secStep == 0 then 
			tweenShaderProperty('mirror2', 'angle', 25, crochet*0.001*8, 'cubeOut')
		elseif secStep == 8 then 
			tweenShaderProperty('mirror2', 'angle', 0, crochet*0.001*8, 'cubeOut')
		end
	end


	if section >= 80 and section < 96 then 
		if secStep32 == 0 or secStep64 == 48 or secStep64 == 24 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
			makeTrails(1.0)
		end
	elseif (section >= 112 and section < 124) or (section >= 204 and section < 216) then 
		if secStep8 == 0 then 
			setAndEaseBack('angle0', 'angle', -360, crochet*0.001*8, 'cubeOut')
			setAndEaseBack('angle4', 'angle', -360, crochet*0.001*8, 'cubeOut')
		elseif secStep8 == 4 then 
			setAndEaseBack('angle1', 'angle', -360, crochet*0.001*8, 'cubeOut')
			setAndEaseBack('angle5', 'angle', -360, crochet*0.001*8, 'cubeOut')
		elseif secStep8 == 2 then 
			setAndEaseBack('angle2', 'angle', -360, crochet*0.001*8, 'cubeOut')
			setAndEaseBack('angle6', 'angle', -360, crochet*0.001*8, 'cubeOut')
		elseif secStep8 == 6 then 
			setAndEaseBack('angle3', 'angle', -360, crochet*0.001*8, 'cubeOut')
			setAndEaseBack('angle7', 'angle', -360, crochet*0.001*8, 'cubeOut')
		end
	end
	if section == 112 or section == 113 or section == 116 or section == 118 or section == 120
		or section == 204 or section == 205 or section == 206 or section == 208 or section == 210 or section == 212 then 
		if secStep == 0 then 
			makeTrails(1.0)
			setAndEaseBack('tipsy', 'y', 2, crochet*0.001*8, 'cubeOut')
		end
	end
	if section == 114 or section == 115 or section == 117 or section == 119 
		or section == 207 or section == 209 or section == 211 then 
		if secStep8 == 0 then 
			makeTrails(1.0)
			setAndEaseBack('tipsy', 'y', 2, crochet*0.001*8, 'cubeOut')
		end
	end


	if secStep == 0 and not opponentPlay then 
		if section == 124 or section == 132 then 
			tweenActorProperty('screenRot', 'x', 180, crochet*0.001*32, 'cubeOut')
			tweenActorProperty('screenRot', 'y', 360, crochet*0.001*32, 'cubeOut')
		elseif section == 128 or section == 136 then 
			setAndEaseBack('screenRot', 'x', -180, crochet*0.001*32, 'cubeOut')
			setAndEaseBack('screenRot', 'y', -360, crochet*0.001*32, 'cubeOut')
		elseif section == 138 then 
			setAndEaseBack('screenRot', 'x', -360, crochet*0.001*32, 'cubeOut')
		elseif section == 139 then 
			setAndEaseBack('screenRot', 'y', 360, crochet*0.001*16, 'cubeOut')
			--setAndEaseBack('screenRot', 'y', -360, crochet*0.001*32, 'cubeOut')
		elseif section == 154 then 
			setAndEaseBack('screenRot', 'x', 360, crochet*0.001*32, 'cubeOut')
		elseif section == 155 then 
			setAndEaseBack('screenRot', 'y', -360, crochet*0.001*32, 'cubeOut')
			--setAndEaseBack('screenRot', 'y', -360, crochet*0.001*32, 'cubeOut')
		end
	end

	if section >= 172 and section < 188 then 
		if secStep == 8 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
			makeTrails(0.4)
			setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*16, 'expoOut', 0.02)
			setAndEaseBackTo('drunk', 'angle', 2, crochet*0.001*8, 'cubeOut')
		elseif secStep32 == 0 or secStep32 == 20 then 
			setAndEaseBackTo('drunk', 'x', 2, crochet*0.001*4, 'cubeOut')
			makeTrails(0.4)
		end
	end
	if section >= 188 and section < 204 then 
		if secStep32 == 16 then 
			triggerEvent('add camera zoom', '0.1', '0.1')
			makeTrails(0.5)
			setAndEaseBackTo('drunk', 'x', 2, crochet*0.001*8, 'cubeOut')
		elseif secStep64 == 0 or secStep64 == 28 then
			triggerEvent('add camera zoom', '0.03', '0.03')
			setAndEaseBackTo('drunk', 'x', 1, crochet*0.001*4, 'cubeOut')
			makeTrails(0.4)
		end
	end

	if section == 188 or section == 192 or section == 196 or section == 200 then 
		if secStep == 0 then 
			tweenActorRTXProperty('dadObject', 'CFfade', 0, crochet*0.001*32, 'cubeIn')
		end
	elseif section == 191 or section == 195 or section == 199 then 
		if secStep == 8 then 
			tweenActorRTXProperty('dadObject', 'CFfade', 1, crochet*0.001*16, 'cubeOut')
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
function sectionHit(section)

	if section == 36 then 
		--tweenActorProperty('playerIA', 'y', -720, crochet*0.001*16*4, 'linear')
		
	end

	if section < 32 then 
		makeTrails(0.8)
	end
	

	
end

function onEvent(name, position, value1, value2)

end

function makeTrails(a)
	trailAlpha = a
	for i = 0, (keyCount+playerKeyCount)-1 do 
		makeStrumTrail(i)
	end

	local noteCount = getRenderedNotes()
	if noteCount>0 then 
		for i = 0, noteCount-1 do 
			makeNoteTrail(i)
		end
	end


end

local trailAlpha = 0.5

local noteTrailCount = 0
local noteTrailCap = 100
function makeNoteTrail(id)

    local trail = 'noteTrail'..noteTrailCount

    local yVal = 150
    if not downscrollBool then 
        yVal = yVal * -1
    end

	local a = trailAlpha * getNoteAlpha(getRenderedNoteType(id))

    destroySprite(trail)
    makeNoteCopy(trail, id)
    setActorAlpha(a, trail)
	tweenActorProperty(trail, 'y', getActorY(trail)+randomFloat(-100, 100), crochet*0.001*32, 'linear')
	tweenActorProperty(trail, 'x', getActorX(trail)+randomFloat(-100, 100), crochet*0.001*32, 'linear')
    --tweenActorProperty(trail, 'y', getActorY(trail)+yVal, crochet*0.001*16, 'linear')
    tweenActorProperty(trail, 'alpha', 0, crochet*0.001*16, 'cubeOut')

    setObjectCamera(trail, 'hud')

    noteTrailCount = noteTrailCount + 1
    if noteTrailCount > noteTrailCap then 
        noteTrailCount = 0
    end
end

function makeStrumTrail(id)

    local trail = 'noteTrail'..noteTrailCount

    local yVal = 150
    if not downscrollBool then 
        yVal = yVal * -1
    end

	local a = trailAlpha * getNoteAlpha(id)

    destroySprite(trail)
    makeSpriteCopy(trail, id)
    setActorAlpha(a, trail)
    tweenActorProperty(trail, 'y', getActorY(trail)+randomFloat(-100, 100), crochet*0.001*32, 'linear')
	tweenActorProperty(trail, 'x', getActorX(trail)+randomFloat(-100, 100), crochet*0.001*32, 'linear')
    tweenActorProperty(trail, 'alpha', 0, crochet*0.001*32, 'cubeOut')

    setObjectCamera(trail, 'hud')

    noteTrailCount = noteTrailCount + 1
    if noteTrailCount > noteTrailCap then 
        noteTrailCount = 0
    end
end

