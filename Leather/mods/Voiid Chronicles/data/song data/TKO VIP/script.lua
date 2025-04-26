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

--based on code from andromeda engine, but with lua
local velChanges = {

	--step, speed mult
	{0, 1.0},
	{504, 2.0},
	{512, 1.0},
	{768, 1.15},
	{784, 1.0},
	{800, 1.15},
	{816, 1.0},
	{832, 1.15},
	{848, 1.0},
	{864, 1.15},
	{880, 1.0},
	{1024, 1.1},
	{1280, 1.0},

	{1566, 1.15},
	{1568, 0.8},
	{1574, 1.15},
	{1580, 1.0},

	--{1984, 0.8},
	--{1988, 1.0},
	--{2000, 0.8},
	--{2004, 1.0},
	--{2006, 0.8},
	--{2010, 1.0},
	--{2016, 0.8},
	--{2020, 1.0},

	{2204, 0.5},
	{2208, 0.9},
	{2301, 0.5},
	{2304, 1.1},
	{2368, 0.9},
	{2384, 0.8},
	{2400, 0.7},

	{2416, 0.2},
	{2418, 1.25},
	{2420, 0.2},
	{2422, 1.25},
	{2424, 0.2},
	{2426, 1.25},
	{2428, 0.2},
	{2432, 1.1},

	{2502, 0.65},
	{2504, 1.1},
	{2518, 0.65},
	{2520, 1.1},
	{2540, 0.65},
	{2544, 1.1},
	{2556, 0.65},
	{2560, 1.1},

	{2672, 0.6},
	{2680, 1.0},
	{2684, 0.4},
	{2688, 1.1},

	{2752, 0.4},
	{2756, 1.1},
	{2760, 0.4},
	{2764, 1.1},
	{2768, 0.4},
	{2772, 1.1},

	{2944, 0.95},

	{2972, 0.6},
	{2976, 0.95},

	{3184, 0.1},
	{3188, 0.8},
	{3200, 2},
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

	makeSprite('drunkSpeed', '', 1, 1)
	makeSprite('tipsySpeed', '', 1, 1)
	setActorAngle(1,'drunkSpeed')
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

    setupShaders()

	if opponentPlay then 
		curOpponent = 'player'
	end
end
							--x,y,z,w
local screenRotQuaternion = {0,0,0,1}


local perlinSpeed = 0.2
					--p2          p1
					--x,y,z,angle,x,y,z,angle
local perlinTime = {0,0,0,0,0,0,0,0}
local perlinRange = {50,50,50,10}


function updatePerlin(elapsed)

	for i = 1, #perlinTime do 
		perlinTime[i] = perlinTime[i] + elapsed*math.random()*perlinSpeed
	end

	--setActorX(getActorX('screenRot')+100*elapsed, 'screenRot')
	--setActorY(getActorY('screenRot')+60*elapsed, 'screenRot')
	--setActorAngle(getActorAngle('screenRot')+75*elapsed, 'screenRot')


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
    pos = pos + getActorX(p)
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
	pos = pos + (getActorY('reverse'..i)*scrollSwitch)

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
    pos = pos + getActorAngle(p)
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

function drunk(lane, curPos, speed)
	return (math.cos( ((songPos*0.001) + ((lane%4)*0.2) + 
        (curPos*0.45)*(10/720)) * (speed*0.2)) * 112*0.5);
end
function tipsy(lane, curPos, speed)
	return ( math.cos( songPos*0.001 *(1.2) + 
	(lane%4)*(2.0) + speed*(0.2) ) * 112*0.4 );
end
function boost(value, height, curPos, speed)
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
function clamp(val, min, max)
	if val < min then
		val = min
	elseif max < val then
		val = max
	end
	return val
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

--https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
function scale(valueIn, baseMin, baseMax, limitMin, limitMax)
	return ((limitMax - limitMin) * (valueIn - baseMin) / (baseMax - baseMin)) + limitMin
end

function setupShaders()

	initShader('mirror', 'MirrorRepeatEffect')
	setCameraShader('game', 'mirror')
    if modcharts then 
		setCameraShader('hud', 'mirror')
	end
	setShaderProperty('mirror', 'zoom', 0.1)

    
    initShader('color', 'ColorOverrideEffect')
    setCameraShader('game', 'color')
    if modcharts then 
        setCameraShader('hud', 'color')
	end
    --setShaderProperty('color', 'green', 0.3)

    --initShader('caBlue', 'ChromAbBlueSwapEffect')
    --setCameraShader('game', 'caBlue')
    --setCameraShader('hud', 'caBlue')
    --setShaderProperty('caBlue', 'strength', -0.001)
    --setShaderProperty('caBlue', 'strength', 0.0)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

    initShader('scanline', 'ScanlineEffect')
    setCameraShader('hud', 'scanline')
    setShaderProperty('scanline', 'strength', 0)
    setShaderProperty('scanline', 'pixelsBetweenEachLine', 5)

    initShader('vignette', 'VignetteEffect')
    setCameraShader('hud', 'vignette')
    setCameraShader('game', 'vignette')
    setShaderProperty('vignette', 'strength', 10)
    setShaderProperty('vignette', 'size', 0.5)


    initShader('burst', 'WaveBurstEffect')
    setCameraShader('game', 'burst')
    setCameraShader('hud', 'burst')
    setShaderProperty('burst', 'strength', 0)


end
function songStart()
    tweenShaderProperty('color', 'red', 0.9, crochet*0.001*16*8, 'circIn')
    tweenShaderProperty('color', 'green', 1.1, crochet*0.001*16*8, 'cubeIn')
    tweenShaderProperty('color', 'blue', 0.9, crochet*0.001*16*8, 'cubeIn')
    tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*16*16, 'cubeInOut')
end

--local noteThing = {0,6,2,7,1,5,3,4}

local noteZoomThing = {-40,-70,-160,-300, -300, -160, -70, -40}
local swap = 1
local noteRotShit = {-60,-30,30,60, -60,-30,30,60}

local invert = {112,-112,112,-112, 112,-112,112,-112}

function stepHit()
    local section = math.floor(curStep/16)
    if curStep % 16 == 0 then 
        sectionHit(section)
    end

    if (section >= 8 and section < 30) or (section >= 184 and section < 199) then 
        local n = curStep%8
        if section % 2 == 0 then 
            --n = noteThing[n+1]
            if curStep % 16 < 8 then 
                tweenActorProperty('note'..n, 'angle', -50, crochet*0.001, 'cubeOut')
                tweenActorProperty('angle'..n, 'angle', -180, crochet*0.001, 'cubeOut')
            else 
                tweenActorProperty('note'..n, 'y', -30, crochet*0.001, 'cubeOut')
                tweenActorProperty('angle'..n, 'angle', -360, crochet*0.001, 'cubeOut')
            end
        else 
            n = (0-n)+7
            --n = noteThing[n+1]
            if curStep % 16 < 8 then 
                tweenActorProperty('note'..n, 'angle', 0, crochet*0.001, 'cubeOut')
                tweenActorProperty('angle'..n, 'angle', -180, crochet*0.001, 'cubeOut')
            else 
                tweenActorProperty('note'..n, 'y', 0, crochet*0.001, 'cubeOut')
                tweenActorProperty('angle'..n, 'angle', 0, crochet*0.001, 'cubeOut')
            end
        end
    end

    if curStep == 180 or curStep == 186 or curStep == 192 then 
        triggerEvent('add camera zoom', 0.03, 0.03)
    elseif curStep == 212 then 
        triggerEvent('add camera zoom', 0.08, 0.08)
    elseif curStep == 224 or curStep == 230 or curStep == 242 or curStep == 248 then 
        triggerEvent('add camera zoom', 0.1, 0.1)
    elseif curStep == 244 or curStep == 252 then 
        triggerEvent('add camera zoom', 0.15, 0.1)
    elseif curStep == 256 then 
        setProperty('', 'camZooming', true)
    end

    if (section >= 16 and section < 31) then 

        if section % 2 == 0 then 
            if curStep % 16 == 0 then 
                triggerEvent('add camera zoom', 0.1, 0.1)
            end
        elseif section % 2 == 1 then 
            if curStep % 16 == 4 then 
                triggerEvent('add camera zoom', 0.1, 0.1)
            end
        end

        if section % 4 == 3 then 
            if curStep % 16 == 10 then 
                triggerEvent('add camera zoom', 0.1, 0.1)
            end
        end
        if section % 8 == 6 then 
            if curStep % 16 == 6 then 
                triggerEvent('add camera zoom', 0.1, 0.1)
            end
        end
        if section % 8 == 7 then 
            if curStep % 16 == 2 then 
                triggerEvent('add camera zoom', 0.05, 0.05)
            end
        end

        if (section % 2 == 0 and (curStep % 16 == 0 or curStep % 16 == 12)) or (section % 2 == 1 and (curStep % 16 == 4 or curStep % 16 == 10)) then
            for i = 0,7 do 
                setActorAngle(noteZoomThing[i+1], 'note2'..i)
                tweenActorProperty('note2'..i, 'angle', 0, crochet*0.001*4, 'cubeIn')
            end
            setShaderProperty('burst', 'strength', 0.007)
            tweenShaderProperty('burst', 'strength', 0, crochet*0.001*4, 'cubeIn')
        end
    end

	if (section >= 32 and section < 48) then 
		if section % 2 == 0 then 
			if curStep % 16 == 0 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		elseif section % 2 == 1 then 
			if curStep % 16 == 4 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end

		if section % 4 == 3 then 
			if curStep % 16 == 10 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end
		if section % 8 == 6 then 
			if curStep % 16 == 6 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end
		if section % 8 == 7 then 
			if curStep % 16 == 2 then 
				triggerEvent('add camera zoom', 0.05, 0.05)
			end
		end
		if (section % 2 == 0 and (curStep % 16 == 0 or curStep % 16 == 12)) or (section % 2 == 1 and (curStep % 16 == 4 or curStep % 16 == 10)) then
			if curStep ~= 512 then 
				for i = 0,7 do 
					setActorAngle(noteZoomThing[i+1], 'note2'..i)
					tweenActorProperty('note2'..i, 'angle', 0, crochet*0.001*4, 'cubeIn')
				end
			end
			setShaderProperty('burst', 'strength', 0.007)
			tweenShaderProperty('burst', 'strength', 0, crochet*0.001*4, 'cubeIn')
		end
	end

	if (section >= 96 and section < 128) then 
		if section % 2 == 0 then 
			if curStep % 16 == 0 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		elseif section % 2 == 1 then 
			if curStep % 16 == 4 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end

		if section % 4 == 3 then 
			if curStep % 16 == 10 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end
		if section % 8 == 6 then 
			if curStep % 16 == 6 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end
		if section % 8 == 7 then 
			if curStep % 16 == 2 then 
				triggerEvent('add camera zoom', 0.05, 0.05)
			end
		end
		if (section % 2 == 0 and (curStep % 16 == 0 or curStep % 16 == 12)) or (section % 2 == 1 and (curStep % 16 == 4 or curStep % 16 == 10)) then
			if curStep ~= 512 then 
				setActorX(45*swap*-1, 'opponentRot')
				tweenActorProperty('opponentRot', 'x', 0, crochet*0.001*4, 'cubeIn')
				setActorX(45*swap, 'playerRot')
				tweenActorProperty('playerRot', 'x', 0, crochet*0.001*4, 'cubeIn')
				swap = swap * -1
			end
			setShaderProperty('burst', 'strength', 0.007)
			tweenShaderProperty('burst', 'strength', 0, crochet*0.001*4, 'cubeIn')
		end
	end
	if curStep == 504 then 
		

		tweenShaderProperty('mirror', 'angle', 45, crochet*0.001*4, 'cubeOut')
		tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
		tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'cubeOut')

		tweenActorProperty('screenRot', 'y', 360, crochet*0.001*8, 'cubeInOut')
	elseif curStep == 508 then 
		tweenShaderProperty('mirror', 'angle', -30, crochet*0.001*4, 'cubeIn')
		tweenShaderProperty('mirror', 'zoom', 0.7, crochet*0.001*4, 'cubeIn')
		tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeIn')
	elseif curStep == 512 then 
		tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*4, 'cubeOut')
		tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
		tweenActorProperty('player', 'angle', -400, crochet*0.001*16, 'cubeOut')
		for i = 0,7 do 
			tweenActorProperty('note2'..i, 'angle', 0, crochet*0.001*8, 'cubeOut')
		end
		perlinSpeed = 1
	end

	if curStep == 524 or curStep == 556 or curStep == 588 then 
		tweenActorProperty('player', 'alpha', 1, crochet*0.001*4, 'cubeOut')
		tweenActorProperty('player', 'angle', 100, crochet*0.001*4, 'cubeOut')
		tweenActorProperty('opponent', 'angle', -400, crochet*0.001*8, 'cubeOut')
	elseif curStep == 540 or curStep == 572 or curStep == 604 or curStep == 636 or curStep == 668 or curStep == 700 or curStep == 732 then 
		tweenActorProperty('player', 'angle', -400, crochet*0.001*10, 'cubeOut')
		tweenActorProperty('opponent', 'angle', 100, crochet*0.001*4, 'cubeOut')
	elseif curStep == 656 or curStep == 688 or curStep == 720 then 
		tweenActorProperty('opponent', 'angle', -400, crochet*0.001*10, 'cubeOut')
		tweenActorProperty('player', 'angle', 100, crochet*0.001*4, 'cubeOut')
	elseif curStep == 748-2 or curStep == 620 then 
		tweenActorProperty('opponent', 'angle', 0, crochet*0.001*4, 'cubeOut')
		tweenActorProperty('player', 'angle', 0, crochet*0.001*4, 'cubeOut')
	end

	if curStep == 774 or curStep == 838 then 
		if not middlescroll then 
			tweenActorProperty('opponent', 'x', 640, crochet*0.001*16, 'cubeOut')
			tweenActorProperty('player', 'x', -640, crochet*0.001*16, 'cubeOut')
		end

		tweenActorProperty('opponentAngle', 'angle', 360, crochet*0.001*16, 'cubeOut')
		tweenActorProperty('playerAngle', 'angle', -360, crochet*0.001*16, 'cubeOut')

		tweenActorProperty(curOpponent, 'alpha', 0.2, crochet*0.001*4, 'cubeOut')
	elseif curStep == 806 or curStep == 870 then 
		tweenActorProperty('opponent', 'x', 0, crochet*0.001*16, 'cubeOut')
		tweenActorProperty('player', 'x', 0, crochet*0.001*16, 'cubeOut')
		tweenActorProperty('opponentAngle', 'angle', 0, crochet*0.001*16, 'cubeOut')
		tweenActorProperty('playerAngle', 'angle', 0, crochet*0.001*16, 'cubeOut')
		tweenActorProperty(curOpponent, 'alpha', 0.2, crochet*0.001*4, 'cubeOut')
	end
	if curStep == 806+8 or curStep == 838+8 or curStep == 774+8 or curStep == 870+8 then 
		tweenActorProperty(curOpponent, 'alpha', 1, crochet*0.001*4, 'cubeOut')
	end

	if (section >= 48 and curStep < 1016) or (section >= 80 and curStep <= 1408) then 
		function altShit()
			for i = 0,7 do 
				local alt = 1
				if i % 2 == 0 then 
					alt = -1
				end
				
				setActorAngle(200*alt*swap, 'note2'..i)
				tweenActorProperty('note2'..i, 'angle', 0, crochet*0.001*4, 'cubeOut')
			end
			swap = swap * -1
			setActorX(1.25, 'scale')
			tweenActorProperty('scale', 'x', 1, crochet*0.001*4, 'cubeOut')
		end
		if section % 2 == 0 then 
			if curStep % 16 == 0 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
				altShit()
			end
		elseif section % 2 == 1 then 
			if curStep % 16 == 4 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
				altShit()
			end
		end

		if section % 4 == 3 then 
			if curStep % 16 == 10 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
				altShit()
			end
		end
		if section % 8 == 6 then 
			if curStep % 16 == 6 then 
				triggerEvent('add camera zoom', 0.1, 0.1)
				altShit()
			end
		end
	end

	if (section >= 128 and section < 136) then 
		function altShit()
			for i = 0,7 do 
				local alt = 1
				if i % 2 == 0 then 
					alt = -1
				end
				
				setActorX(invert[i+1], 'note2'..i)
				tweenActorProperty('note2'..i, 'x', 0, crochet*0.001*4, 'cubeOut')
			end
			swap = swap * -1
			setActorX(1.25, 'scale')
			tweenActorProperty('scale', 'x', 1, crochet*0.001*4, 'cubeOut')
		end

		if section ~= 135 then 
			if section % 2 == 0 then 
				if curStep % 16 == 0 or curStep % 16 == 6 then 
					altShit()
					triggerEvent('add camera zoom', 0.1, 0.1)
				end
			elseif section % 2 == 1 then 
				if curStep % 16 == 4 or curStep % 16 == 10 then 
					altShit()
					triggerEvent('add camera zoom', 0.1, 0.1)
				end
			end
	
			if section % 4 == 2 then 
				if curStep % 16 == 12 then 
					altShit()
					triggerEvent('add camera zoom', 0.1, 0.1)
				end
			end
		else 
			if curStep % 16 == 4 or curStep % 16 == 8 or curStep % 16 == 12 then 
				altShit()
				triggerEvent('add camera zoom', 0.1, 0.1)
			end
		end


	end

	if (section >= 148 and section < 151) then 
		if curStep % 16 == 0 then 
			for i = 0,7 do 
				tweenActorProperty('note2'..i, 'x', invert[i+1], crochet*0.001*4, 'cubeOut')
			end
		elseif curStep % 16 == 8 then 
			for i = 0,7 do 
				tweenActorProperty('note2'..i, 'x', 0, crochet*0.001*4, 'cubeOut')
			end
		end
	end

	if (section >= 64 and section < 80) or (section >= 152 and section < 184 and section ~= 167) then 

		function noteStuff(swaps, time)
			for i = 0,7 do 
				setActorAngle(noteRotShit[i+1]*2*swaps, 'note2'..i)
				tweenActorProperty('note2'..i, 'angle', 0, crochet*0.001*time, 'cubeOut')
				setActorY(noteRotShit[i+1]*1*swaps, 'note2'..i)
				tweenActorProperty('note2'..i, 'y', 0, crochet*0.001*time, 'cubeOut')

				setActorAngle(noteRotShit[i+1]*-swaps, 'angle'..i)
				tweenActorProperty('angle'..i, 'angle', 0, crochet*0.001*time, 'cubeOut')
			end
			setActorX(1.5, 'scale')
			tweenActorProperty('scale', 'x', 1, crochet*0.001*time, 'cubeOut')
		end

		if section % 2 == 0 then 
			local secStep = curStep % 16
			if secStep == 0 or secStep == 8 or secStep == 14 then 
				triggerEvent('add camera zoom', 0.08, 0.08)
				noteStuff(1, 2)
			elseif secStep == 4 or secStep == 11 then 
				triggerEvent('add camera zoom', 0.08, 0.08)
				noteStuff(-1, 2)
			end
		else 
			if section % 4 == 1 then 
				local secStep = curStep % 16
				if secStep == 0 or secStep == 8 then 
					triggerEvent('add camera zoom', 0.08, 0.08)
					noteStuff(1, 2)
				elseif secStep == 4 then 
					triggerEvent('add camera zoom', 0.08, 0.08)
					noteStuff(-1, 2)
				elseif secStep == 12 or secStep == 14 then 
					triggerEvent('add camera zoom', 0.05, 0.05)
					noteStuff(1, 1)
				elseif secStep == 13 then 
					triggerEvent('add camera zoom', 0.05, 0.05)
					noteStuff(-1, 1)
				end
			else 

				if section % 8 == 3 then 
					local secStep = curStep % 16
					if secStep == 0 or secStep == 4 or secStep == 8 or secStep == 12 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(1, 2)
					elseif secStep == 2 or secStep == 6 or secStep == 10 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(-1, 2)
					end
				elseif section % 8 == 7 then
					local secStep = curStep % 16
					if secStep == 0 or secStep == 12 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(1, 2)
					elseif secStep == 10 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(-1, 2)
					end

					if secStep == 2 or secStep == 4 or secStep == 7 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(-1, 1)
					elseif secStep == 3 or secStep == 6 or secStep == 8 then 
						triggerEvent('add camera zoom', 0.05, 0.05)
						noteStuff(1, 1)
					end
				end

			end
		end
	end

	if curStep == 752 then 
		tweenActorProperty('noteSine', 'angle', 100, crochet*0.001*16, 'circInOut')
	elseif curStep == 768 then 
		tweenActorProperty('noteSine', 'angle', 0, crochet*0.001*4, 'circOut')
		--tweenActorProperty('drunk', 'x', 1, crochet*0.001*4, 'circOut')
	elseif curStep == 896 then 
		--tweenActorProperty('drunk', 'x', 0, crochet*0.001*4, 'circOut')
	elseif curStep == 1008 then 
		tweenActorProperty('noteSine', 'x', 50, crochet*0.001*12, 'circInOut')
		tweenActorProperty('drunk', 'angle', 5, crochet*0.001*12, 'circInOut')
	elseif curStep == 1024 then 
		tweenActorProperty('noteSine', 'x', 0, crochet*0.001*4, 'circOut')
		tweenActorProperty('drunk', 'angle', 0, crochet*0.001*4, 'circOut')
	end
	if curStep == 2168 then 
		--tweenActorProperty('noteSine', 'angle', 90, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('tipsy', 'x', 0.4, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('tipsy', 'y', 0.3, crochet*0.001*8, 'cubeIn')
		tweenActorProperty('global', 'angle', -250, crochet*0.001*8, 'cubeIn')
	elseif curStep == 2300 then 
		setActorX(3, 'drunkSpeed')
		--tweenActorProperty('noteSine', 'angle', 150, crochet*0.001*4, 'cubeIn')
		tweenActorProperty('tipsy', 'x', 1, crochet*0.001*4, 'cubeIn')
		tweenActorProperty('drunk', 'x', 0.2, crochet*0.001*4, 'cubeIn')
		tweenActorProperty('tipsy', 'y', 0, crochet*0.001*4, 'cubeIn')
		tweenActorProperty('global', 'angle', -150, crochet*0.001*4, 'cubeIn')
	elseif curStep == 2368 then 
		tweenActorProperty('noteSine', 'angle', 0, crochet*0.001*16*3, 'cubeInOut')
		tweenActorProperty('drunk', 'x', 0, crochet*0.001*4*3, 'cubeInOut')
		tweenActorProperty('tipsy', 'x', 0, crochet*0.001*16*3, 'cubeInOut')
		tweenActorProperty('tipsy', 'y', 0, crochet*0.001*16*3, 'cubeInOut')
		tweenActorProperty('global', 'angle', 0, crochet*0.001*16*3, 'cubeInOut')
	elseif curStep == 2416 then 
		setProperty('camGame', 'alpha', 0)
	elseif curStep == 2432 then 
		setProperty('camGame', 'alpha', 1)
	end


	if curStep == 752 then 
		tweenActorProperty('global', 'angle', -150, crochet*0.001*16, 'cubeInOut')
	elseif curStep == 1024 then 
		perlinSpeed = 1.5
		perlinRange = {100, 100, 100, 25}
	elseif curStep == 1280 then 
		tweenActorProperty('global', 'angle', 0, crochet*0.001*16, 'cubeInOut')
		perlinSpeed = 1
		perlinRange = {50, 50, 50, 10}
	elseif curStep == 1536 then 
		tweenActorProperty('global', 'angle', -100, crochet*0.001*16, 'cubeInOut')
		perlinSpeed = 0.5
		perlinRange = {100, 100, 100, 25}

	elseif curStep == 2176 then 
		perlinSpeed = 0.3
		perlinRange = {200, 200, 300, 40}
	elseif curStep == 2304 then 
		perlinSpeed = 1.5
		perlinRange = {200, 200, 300, 40}
	elseif curStep == 2368 then 
		perlinSpeed = 1.5
		perlinRange = {100, 100, 200, 20}
	elseif curStep == 2384 then 
		perlinSpeed = 1.5
		perlinRange = {50, 50, 100, 5}
	elseif curStep == 2416 then 
		perlinSpeed = 1.5
		perlinRange = {0, 0, 0, 0}
	elseif curStep == 2432 or curStep == 2688 then 
		tweenActorProperty('global', 'angle', -200, crochet*0.001*16, 'cubeInOut')
		perlinSpeed = 2.5
		perlinRange = {200, 200, 300, 40}
	elseif curStep == 2672 then 
		perlinSpeed = 0
	elseif curStep == 2944 then 
		perlinSpeed = 0.5
		perlinRange = {100, 100, 200, 20}
	end


	if curStep > 1288 and curStep < 1376 then 
		if curStep % 16 == 0 then 
			if section % 2 == 0 then 
				if downscrollBool then 
					setActorY(160, 'player')
				else 
					setActorY(-160, 'player')
				end
				tweenActorProperty('player', 'y', 0, crochet*0.001*8, 'expoOut')
			else 
				if downscrollBool then 
					setActorY(160, 'opponent')
				else 
					setActorY(-160, 'opponent')
				end
				tweenActorProperty('opponent', 'y', 0, crochet*0.001*8, 'expoOut')
			end
		elseif curStep % 16 == 8 then 
			if section % 2 == 0 then 
				tweenActorProperty('opponent', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
			else 
				tweenActorProperty('player', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
			end
		end
	end


	if curStep == 1288 then 
		tweenActorProperty('opponent', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
	elseif curStep == 1380 then 
		if downscrollBool then 
			setActorY(160, 'player')
		else 
			setActorY(-160, 'player')
		end
		tweenActorProperty('player', 'y', 0, crochet*0.001*8, 'expoOut')
	elseif curStep == 1400 then
		tweenActorProperty('player', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
	elseif curStep == 1416 or curStep == 1432 then 
		if downscrollBool then 
			setActorY(160, 'opponent')
		else 
			setActorY(-160, 'opponent')
		end
		tweenActorProperty('opponent', 'y', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
	elseif curStep == 1424 or curStep == 1440 or curStep == 1408 then 
		if downscrollBool then 
			setActorY(160, 'player')
		else 
			setActorY(-160, 'player')
		end
		tweenActorProperty('player', 'y', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'y', -720*downscrollDiff, crochet*0.001*8, 'expoIn')
	elseif curStep == 1448 then 
		if downscrollBool then 
			setActorY(160, 'opponent')
		else 
			setActorY(-160, 'opponent')
		end
		tweenActorProperty('opponent', 'y', 0, crochet*0.001*8, 'expoOut')
	elseif curStep == 1472 then 
		tweenShaderProperty('grey', 'strength', 1, crochet*0.001*16*3.5, 'cubeIn')
	elseif curStep == 1528 then 
		tweenShaderProperty('mirror', 'zoom', 2, crochet*0.001*4, 'cubeOut')
	elseif curStep == 1532 then 
		tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*4, 'cubeIn')
		tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'cubeIn')
		tweenShaderProperty('mirror', 'zoom', 1, crochet*0.001*4, 'cubeOut')
	end

	if curStep == 2560 or curStep == 2688 or curStep == 2816 or curStep == 2880 then 
		--tweenActorProperty('global', 'x', 320, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'angle', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'angle', -350, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'x', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'x', 0, crochet*0.001*8, 'expoOut')
	elseif curStep == 2624 or curStep == 2848 or curStep == 2912 then 
		--tweenActorProperty('global', 'x', -320, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'angle', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'angle', -350, crochet*0.001*8, 'expoOut')
	elseif curStep == 2752 then 
		tweenActorProperty('global', 'x', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'angle', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'angle', 0, crochet*0.001*8, 'expoOut')
		if not middlescroll then 
			tweenActorProperty('player', 'x', -100, crochet*0.001*8, 'expoOut')
			tweenActorProperty('opponent', 'x', 100, crochet*0.001*8, 'expoOut')
		end

	elseif curStep == 2944 then 
		tweenActorProperty('global', 'x', 0, crochet*0.001*32, 'expoOut')
		tweenActorProperty('player', 'angle', 0, crochet*0.001*32, 'expoOut')
		tweenActorProperty('opponent', 'angle', 0, crochet*0.001*32, 'expoOut')
		tweenActorProperty('player', 'x', 0, crochet*0.001*32, 'expoOut')
		tweenActorProperty('opponent', 'x', 0, crochet*0.001*32, 'expoOut')
	end

	if curStep == 3040 then 
		tweenActorProperty('global', 'alpha', 0.75, crochet*0.001*4, 'expoOut')
	elseif curStep == 3044 then 
		tweenActorProperty('global', 'alpha', 0.5, crochet*0.001*4, 'expoOut')
	elseif curStep == 3048 then 
		tweenActorProperty('global', 'alpha', 0.25, crochet*0.001*4, 'expoOut')
	elseif curStep == 3052 then 
		tweenActorProperty('global', 'alpha', 0, crochet*0.001*4, 'expoOut')
	elseif curStep == 3164 then 
		setActorAlpha(0, 'opponent')
		tweenActorProperty('global', 'alpha', 1, crochet*0.001*20, 'expoIn')
		if not middlescroll then 
		tweenActorProperty('player', 'x', -320, crochet*0.001*20, 'expoIn')
		end
	end

	if section == 201 then 
		if curStep % 16 == 0 then 
			for i = 0,7 do 
				setActorAngle(90, 'angle'..i)
			end
		elseif curStep % 16 == 2 then 
			for i = 0,7 do 
				setActorAngle(-90, 'angle'..i)
			end
		elseif curStep % 16 == 4 then 
			for i = 0,7 do 
				setActorAngle(180, 'angle'..i)
			end
		elseif curStep % 16 == 6 then 
			for i = 0,7 do 
				setActorAngle(90, 'angle'..i)
			end
		elseif curStep % 16 == 8 then 
			tweenActorProperty('tipsy', 'y', 10, crochet*0.001*8, 'expoIn')
			for i = 0,7 do 
				setActorAngle(0, 'angle'..i)
			end
		elseif curStep % 16 == 9 then 
			for i = 0,7 do 
				setActorAngle(90, 'angle'..i)
			end
		elseif curStep % 16 == 10 then 
			for i = 0,7 do 
				setActorAngle(180, 'angle'..i)
			end
		elseif curStep % 16 == 11 then 
			for i = 0,7 do 
				setActorAngle(270, 'angle'..i)
			end
		elseif curStep % 16 == 12 then 
			for i = 0,7 do 
				setActorAngle(360, 'angle'..i)
			end
		end
	end
	if curStep == 3232 then 
		for i = 0,7 do 
			setActorX(-4000, 'note2'..i)
		end
	end

	if curStep == 3192 then 
		tweenActorProperty('drunk', 'angle', 5, crochet*0.001*4, 'expoOut')
	elseif curStep == 3200 then 
		
		tweenActorProperty('playerRot', 'x', 720, crochet*0.001*16, 'expoOut')
		tweenActorProperty('playerIA', 'y', 360, crochet*0.001*16, 'expoOut')
		setActorX(90, 'playerIA')
	end

	--didnt like it
	--[[if curStep == 1568 then 
		setActorY(0, 'screenRot')
		tweenActorProperty('screenRot', 'y', 45, crochet*0.001*6, 'expoOut')
	elseif curStep == 1574 then 
		tweenActorProperty('screenRot', 'x', -45, crochet*0.001*6, 'expoOut')
	elseif curStep == 1580 then 
		tweenActorProperty('screenRot', 'x', 0, crochet*0.001*6, 'expoOut')
		tweenActorProperty('screenRot', 'y', 0, crochet*0.001*6, 'expoOut')
	end

	if curStep == 1664 then 
		--tweenActorProperty('player', 'x', -100, crochet*0.001*8, 'expoOut')
		--tweenActorProperty('opponent', 'x', 100, crochet*0.001*8, 'expoOut')
	elseif curStep == 1676 or curStep == 1714 or curStep == 1740 or curStep == 1778 then 
		tweenActorProperty('screenRot', 'x', -10, crochet*0.001*6, 'expoOut')
	elseif curStep == 1682 or curStep == 1708 or curStep == 1746 or curStep == 1772 then 
		tweenActorProperty('screenRot', 'x', 10, crochet*0.001*6, 'expoOut')
	elseif curStep == 1688 or curStep == 1752 then 
		tweenActorProperty('screenRot', 'angle', 15, crochet*0.001*8, 'expoOut')
	elseif curStep == 1720 then 
		tweenActorProperty('screenRot', 'angle', -15, crochet*0.001*8, 'expoOut')
	elseif curStep == 1696 or curStep == 1728 or curStep == 1760 then 
		tweenActorProperty('screenRot', 'x', 0, crochet*0.001*8, 'expoOut')
	elseif curStep == 1784 then 
		tweenActorProperty('screenRot', 'angle', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('screenRot', 'x', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('player', 'x', 0, crochet*0.001*8, 'expoOut')
		tweenActorProperty('opponent', 'x', 0, crochet*0.001*8, 'expoOut')
	end]]--
end
function sectionHit(section)

    if section == 8 then 
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*16*8, 'cubeIn')
    end
end
