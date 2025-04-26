local defaultX = {}
local defaultY = {}
function createPost()
	resizeWindow(1, 1)
	setWindowPos(0, -getScreenHeight() - 1)
	local w = resWidth
	local h = resHeight
	--if w > 2560 then 
	--	w = 2560
	--	h = 1440
	--end
	resizeWindow(w, h)
	setWindowPos(0, -1)

	

	initShader('raymarch', 'KrakatoaRaymarchEffect')

	
    setCameraShader('game', 'raymarch')
    setCameraShader('hud', 'raymarch')
	--setCameraShader('other', 'raymarch')

	setShaderProperty('raymarch', 'x', 0)
	setShaderProperty('raymarch', 'y', 0)
	setShaderProperty('raymarch', 'z', 3)

	setShaderProperty('raymarch', 'sphereZ', -50)
	--setShaderProperty('raymarch', 'sphereAngleZ', 0.25)

	setShaderProperty('raymarch', 'boxZ0', -50)
	setShaderProperty('raymarch', 'boxZ1', 100)

	setShaderProperty('raymarch', 'boxAngleY0', 0)
	--setShaderProperty('raymarch', 'boxZ0', 100)

	setShaderProperty('raymarch', 'floorY', 100)


	initShader('glitch', 'GlitchEffect')
	setCameraShader('game', 'glitch')
    setCameraShader('back', 'glitch')
    setCameraShader('hud', 'glitch')
    setShaderProperty('glitch', 'strength', 0.02)

	--setGameFilters('raymarch,glitch')

	initShader('mirrorBack', 'MirrorRepeatWarpEffect')
	setCameraShader('back', 'mirrorBack')
	setShaderProperty('mirrorBack', 'zoom', 0.5)
	setShaderProperty('mirrorBack', 'y', 0.5)
	setShaderProperty('mirrorBack', 'angle', -90)
	

	if not middlescroll then 
		if opponentPlay then 
			for i=0,3 do
				setActorX(getActorX(i)+320, i)
				setObjectCamera(i, 'hud')
			end
			for i=4,7 do
				setActorX(getActorX(i)-320, i)
				setActorY(getActorY(i)+120, i)
				setActorAlpha(0, i)
				setObjectCamera(i, 'back')
			end
		else 
			for i=0,3 do
				setActorX(getActorX(i)+320, i)
				setActorY(getActorY(i)+120, i)
				setActorAlpha(0, i)
				setObjectCamera(i, 'back')
			end
			for i=4,7 do
				setActorX(getActorX(i)-320, i)
				setObjectCamera(i, 'hud')
			end
		end

	end

	
	
	for i = 0, (keyCount+playerKeyCount)-1 do 
		table.insert(defaultX, getActorX(i))
		table.insert(defaultY, getActorY(i))
	end

	setActorProperty('camera3D', 'perspectiveEnabled', true)

	setActorProperty('camera3D', 'yaw', 180*(math.pi/180))
end

function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local section = 0

local spinDist = 1.25

local spinTime = 0
local spinSpeed = 0.1

local time = 0
local speedshit = 1
function update(elapsed)

	if section >= 92 and section < 98 then 

		if section >= 96 then 
			if section == 96 and curStep % 16 < 8 then 
			
			else
				spinTime = spinTime - elapsed*2
				spinDist = spinDist - elapsed
				if spinDist < 0 then 
					spinDist = 0
				end
			end
		else 
			spinTime = spinTime + elapsed*spinSpeed

			spinSpeed = spinSpeed + elapsed*5
			if spinSpeed > 6 then 
				spinSpeed = 6
			end
		end
		
		


		setShaderProperty('raymarch', 'boxX0', math.sin(spinTime)*spinDist)
		setShaderProperty('raymarch', 'boxZ0', (math.cos(spinTime)*spinDist)-(1*spinDist))

		setShaderProperty('raymarch', 'boxX1', math.sin(spinTime+math.pi)*spinDist)
		setShaderProperty('raymarch', 'boxZ1', (math.cos(spinTime+math.pi)*spinDist)-(1*spinDist))


	end


	if section >= 170 and section < 202 then 

		time = time + elapsed*speedshit
		
		

		--setShaderProperty('raymarch', 'boxZ0', -50)
		--setShaderProperty('raymarch', 'boxZ1', -50)

		local x = math.sin(time*2)*5
		local z = math.cos(time*2)*5
		local y = (math.sin(time)*0.5)+0.5


		local sphereX = 0
		local sphereY = 0
		local sphereZ = 0

		local tilt = 0

		local sphereAngleY = -(time*2)/(math.pi/180);


		if section >= 178 then 

			--tilt = math.sin(time)*0.2
			--sphereX = math.cos(songPos*0.0015)*10
			--sphereZ = math.sin(songPos*0.001)*15

			setShaderProperty('raymarch', 'floorX', -math.cos(time*0.75)*10)
			setShaderProperty('raymarch', 'floorZ', -math.sin(time*0.75)*10)

			speedshit = 1.25
			
		end
		if section >= 186 then 
			speedshit = 1.5

			sphereAngleY = sphereAngleY + math.sin(time*1.25)*5
		end

		setShaderProperty('raymarch', 'tilt', tilt)

		setShaderProperty('raymarch', 'x', x+sphereX)
		setShaderProperty('raymarch', 'y', y+sphereY)
		setShaderProperty('raymarch', 'z', z+sphereZ)

		setShaderProperty('raymarch', 'sphereX', sphereX)
		setShaderProperty('raymarch', 'sphereY', sphereY)
		setShaderProperty('raymarch', 'sphereZ', sphereZ)

		setShaderProperty('raymarch', 'sphereAngleY', sphereAngleY)



	end
end

function songStart()

	tweenShaderProperty('raymarch', 'boxZ0', 0.0, crochet*0.001*64, 'cubeOut')
	
	--resizeWindow(1280,720)
	stepHit()
end
local swap = 1
function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32
	local secStep8 = curStep % 8
    if curStep % 16 == 0 then 
        sectionHit(section)
    end

	if (section >= 4 and section < 24) or (section >= 80 and section < 92) or (section >= 106 and section < 114) or (section >= 154 and section < 169) then
		local val = 5
		if section >= 8 then 
			val = 20
		elseif section >= 7 then 
			val = 20
		elseif section >= 6 then 
			val = 15
		elseif section >= 5 then 
			val = 10
		end

		if secStep == 0 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', val, crochet*0.001*4, 'cubeOut')
		end

		if curStep % 4 == 0 then 
			setAndEaseBackToShader('glitch', 'strength', val*0.005, crochet*0.001*4, 'cubeOut', 0.02)
		end
	end

	if curStep == 376 then 
		tweenShaderProperty('raymarch', 'z', 4, crochet*0.001*8, 'cubeIn')
	end

	if (section >= 24 and section < 32) or (section >= 56 and section < 64) or (section >= 114 and section < 122) then

		local val = 1

		if secStep32 == 0 then 
			tweenShaderProperty('raymarch', 'x', val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 4 then 
			tweenShaderProperty('raymarch', 'x', -val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 8 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 12 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 16 then 
			tweenShaderProperty('raymarch', 'x', val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 20 then 
			tweenShaderProperty('raymarch', 'x', -val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 24 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 28 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'cubeOut')
		end

		if curStep % 4 == 0 then
			setAndEaseBackToShader('glitch', 'strength', 0.2, crochet*0.001*4, 'cubeOut', 0.03)
		end

		if section == 121 and secStep == 12 then 
			tweenShaderProperty('raymarch', 'boxX0', 0.0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'boxX1', 0.0, crochet*0.001*4, 'cubeOut')
		else 
			if section >= 114 then 
				if secStep32 == 0 then 
					tweenShaderProperty('raymarch', 'boxZ0', -1.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', 0.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 4 then 
					tweenShaderProperty('raymarch', 'boxZ0', 0.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', -1.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 8 then 
					tweenShaderProperty('raymarch', 'boxZ0', -1.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', 0.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 12 then 
					tweenShaderProperty('raymarch', 'boxX0', -1.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxX1', 1.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 16 then 
					tweenShaderProperty('raymarch', 'boxZ0', 0.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', -1.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 20 then 
					tweenShaderProperty('raymarch', 'boxZ0', -1.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', 0.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 24 then 
					tweenShaderProperty('raymarch', 'boxZ0', 0.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxZ1', -1.0, crochet*0.001*4, 'cubeOut')
				elseif secStep32 == 28 then 
					tweenShaderProperty('raymarch', 'boxX0', 1.0, crochet*0.001*4, 'cubeOut')
					tweenShaderProperty('raymarch', 'boxX1', -1.0, crochet*0.001*4, 'cubeOut')
				end
			end
		end



	end

	if (section >= 32 and section < 40) or (section >= 138 and section < 146) then

		local val = 1.0

		if secStep == 0 then 
			tweenShaderProperty('raymarch', 'x', val, crochet*0.001*8, 'sineInOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'boxAngleZ0', val, crochet*0.001*4, 'sineInOut')
		elseif secStep == 4 then 
			--setAndEaseBackShader('raymarch', 'x', -val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'boxAngleZ0', -val, crochet*0.001*4, 'sineInOut')
		elseif secStep == 8 then 
			tweenShaderProperty('raymarch', 'x', -val, crochet*0.001*8, 'sineInOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'boxAngleZ0', val, crochet*0.001*4, 'sineInOut')
		elseif secStep == 12 then 
			--setAndEaseBackShader('raymarch', 'x', -val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'sineInOut')
			tweenShaderProperty('raymarch', 'boxAngleZ0', -val, crochet*0.001*4, 'sineInOut')
		end

		if curStep % 4 == 0 then 
			setAndEaseBackToShader('glitch', 'strength', val*0.005, crochet*0.001*4, 'cubeOut', 0.02)
		end

		if section >= 138 then 
			if secStep32 == 0 then 
				tweenShaderProperty('raymarch', 'tilt', 0.2, crochet*0.001*16, 'sineInOut')
			elseif secStep32 == 16 then 
				tweenShaderProperty('raymarch', 'tilt', -0.2, crochet*0.001*16, 'sineInOut')
			end
		end

	end

	if section == 40 and secStep == 0 then 
		tweenShaderProperty('raymarch', 'boxAngleZ0', 0, crochet*0.001*4, 'cubeOut')
	end

	if (section >= 40 and section < 47) or (section >= 146 and section < 154)  then 

		if section == 41 or section == 45 or section == 147 or section == 151 then 
			if secStep32 == 24 then 
				setShaderProperty('raymarch', 'boxAngleY0', 0)
				setShaderProperty('raymarch', 'boxAngleZ0', 0)
				tweenShaderProperty('raymarch', 'boxAngleY0', -30, crochet*0.001*4, 'cubeOut')
				tweenShaderProperty('raymarch', 'boxAngleZ0', 30, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 28 then
				tweenShaderProperty('raymarch', 'boxAngleY0', 360, crochet*0.001*8, 'cubeOut')
				tweenShaderProperty('raymarch', 'boxAngleZ0', -360, crochet*0.001*8, 'cubeOut')
			end
		else 
			if secStep32 == 24 then 
				setShaderProperty('raymarch', 'boxAngleY0', 0)
				setShaderProperty('raymarch', 'boxAngleZ0', 0)
				tweenShaderProperty('raymarch', 'boxAngleY0', 30, crochet*0.001*4, 'cubeOut')
				tweenShaderProperty('raymarch', 'boxAngleZ0', -30, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 28 then
				tweenShaderProperty('raymarch', 'boxAngleY0', -360, crochet*0.001*8, 'cubeOut')
				tweenShaderProperty('raymarch', 'boxAngleZ0', 360, crochet*0.001*8, 'cubeOut')
			end
		end





		local val = 0.5

		if secStep32 == 0 then 
			tweenShaderProperty('raymarch', 'x', val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 4 then 
			tweenShaderProperty('raymarch', 'x', -val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 8 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 12 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 16 then 
			tweenShaderProperty('raymarch', 'x', val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 20 then 
			tweenShaderProperty('raymarch', 'x', -val, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 24 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep32 == 28 then 
			tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*4, 'cubeOut')
			tweenShaderProperty('raymarch', 'y', val, crochet*0.001*4, 'cubeOut')
		end



		if curStep % 4 == 0 then 
			setAndEaseBackToShader('raymarch', 'z', 3, crochet*0.001*4, 'cubeOut', 4)
			setAndEaseBackToShader('glitch', 'strength', 0.4, crochet*0.001*4, 'cubeOut', 0.02)
		end
	end
	
	if section == 47 and secStep == 0 then 
		tweenShaderProperty('glitch', 'strength', 2, crochet*0.001*4, 'cubeOut')
	end
	if section == 48 and secStep == 0 then 
		tweenShaderProperty('glitch', 'strength', 0.05, crochet*0.001*4, 'cubeOut')
		setShaderProperty('raymarch', 'boxZ1', 0)
		setShaderProperty('raymarch', 'boxX1', 10)

		tweenShaderProperty('raymarch', 'boxX0', -1.0, crochet*0.001*4, 'cubeOut')
		tweenShaderProperty('raymarch', 'boxX1', 1.0, crochet*0.001*4, 'cubeOut')
	end


	if section >= 48 and section < 56 then
		local val = 25

		if secStep == 0 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleX1', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY1', -val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 4 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleX1', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY1', val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 8 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleX1', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY1', val, crochet*0.001*4, 'cubeOut')
		elseif secStep == 12 then 
			setAndEaseBackShader('raymarch', 'boxAngleX0', -val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY0', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleX1', val, crochet*0.001*4, 'cubeOut')
			setAndEaseBackShader('raymarch', 'boxAngleY1', -val, crochet*0.001*4, 'cubeOut')
		end



		if curStep % 4 == 0 then 
			setAndEaseBackToShader('glitch', 'strength', val*0.005, crochet*0.001*4, 'cubeOut', 0.02)
		end
	end

	if section == 63 and secStep == 0 then 
		tweenShaderProperty('raymarch', 'boxX0', 0.0, crochet*0.001*16, 'cubeIn')
		tweenShaderProperty('raymarch', 'boxX1', 0.0, crochet*0.001*16, 'cubeIn')
	end


	if section >= 64 and section < 80 then

		if section == 79 and (secStep == 4 or secStep == 12) then 

		else 
			if secStep32 == 0 then 
				tweenShaderProperty('raymarch', 'tilt', 0.2, crochet*0.001*16, 'sineInOut')
			elseif secStep32 == 16 then 
				tweenShaderProperty('raymarch', 'tilt', -0.2, crochet*0.001*16, 'sineInOut')
			end
	
			local boxDist = 3.5
			local camOffset = 0.5
			local boxEase = 'expoOut'
	
			if secStep32 == 0 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
				tweenShaderProperty('raymarch', 'x', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 4 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
				tweenShaderProperty('raymarch', 'y', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 8 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
				tweenShaderProperty('raymarch', 'x', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 12 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
				tweenShaderProperty('raymarch', 'y', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 16 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
				tweenShaderProperty('raymarch', 'x', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 20 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
				tweenShaderProperty('raymarch', 'y', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 24 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
				tweenShaderProperty('raymarch', 'x', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 28 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
				tweenShaderProperty('raymarch', 'y', -camOffset, crochet*0.001*4, 'cubeOut')
			end
	
	
			if curStep % 4 == 0 then 
				--setAndEaseBackToShader('raymarch', 'z', 3, crochet*0.001*4, 'cubeOut', 4)
				setAndEaseBackToShader('glitch', 'strength', 0.8, crochet*0.001*4, 'cubeOut', 0.02)
			end
		end


		

	end

	if section == 80 and secStep == 0 then 
		tweenShaderProperty('raymarch', 'tilt', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*8, 'cubeOut')
		setShaderProperty('raymarch', 'boxAngleZ0', 0)
	end

	if section == 146 and secStep == 0 then 
		
		tweenShaderProperty('raymarch', 'tilt', 0, crochet*0.001*8, 'cubeOut')
	end

	if section == 98 and secStep == 0 then 
		
		setShaderProperty('raymarch', 'boxZ1', 50)
	end

	if section == 106 and secStep == 0 then 
		
		setShaderProperty('raymarch', 'boxZ1', 0)
	end

	if section >= 98 and section < 106 then 

		if section % 2 == 0 then 
			if secStep == 0 then 
				tweenShaderProperty('raymarch', 'boxZ0', -3, crochet*0.001*24, 'cubeOut')
				if section >= 102 then 
					--setAndEaseBackShader('raymarch', 'boxAngleY0', 360, crochet*0.001*32, 'cubeOut')
					--setAndEaseBackShader('raymarch', 'boxAngleY1', -360, crochet*0.001*32, 'cubeOut')
				else 
					--setAndEaseBackShader('raymarch', 'boxAngleY0', -360, crochet*0.001*32, 'cubeOut')
					--setAndEaseBackShader('raymarch', 'boxAngleY1', 360, crochet*0.001*32, 'cubeOut')
				end
				
			end
		else
			if secStep == 8 then 
				tweenShaderProperty('raymarch', 'boxZ0', 1, crochet*0.001*8, 'cubeIn')
				if section >= 101 then 
					setAndEaseBackShader('raymarch', 'boxAngleY0', 360, crochet*0.001*8, 'expoIn')
					setAndEaseBackShader('raymarch', 'boxAngleZ0', 360, crochet*0.001*8, 'expoIn')
				else 
					setAndEaseBackShader('raymarch', 'boxAngleY0', -360, crochet*0.001*8, 'expoIn')
					setAndEaseBackShader('raymarch', 'boxAngleZ0', -360, crochet*0.001*8, 'expoIn')
				end
			end
		end

		if section >= 102 then 
			if section == 105 then 
				if secStep == 4 then 
					setAndEaseBackShader('raymarch', 'boxX0', 2, crochet*0.001*4, 'cubeOut')
				end
			else 
				if secStep == 4 then 
					setAndEaseBackShader('raymarch', 'boxX0', 2, crochet*0.001*4, 'cubeOut')
				elseif secStep == 12 then 
					setAndEaseBackShader('raymarch', 'boxX0', -2, crochet*0.001*4, 'cubeOut')
				end
			end
		end

	
	
		if curStep % 4 == 0 then 
			setAndEaseBackToShader('glitch', 'strength', 0.1, crochet*0.001*4, 'cubeOut', 0.02)
		end
	end

	if section == 122 and secStep == 0 then 
		--tweenShaderProperty('raymarch', 'tilt', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'y', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'boxZ0', 0.0, crochet*0.001*4, 'cubeOut')
		tweenShaderProperty('raymarch', 'boxZ1', 0.0, crochet*0.001*4, 'cubeOut')
	end

	if section >= 122 and section < 138 then

		if section == 137 and (secStep == 4 or secStep == 12) then 

		else 
			if secStep32 == 0 then 
				tweenShaderProperty('raymarch', 'tilt', 0.2, crochet*0.001*16, 'sineInOut')
			elseif secStep32 == 16 then 
				tweenShaderProperty('raymarch', 'tilt', -0.2, crochet*0.001*16, 'sineInOut')
			end
	
			local boxDist = 3.5
			local camOffset = 0.5
			local boxEase = 'expoOut'
	
			if secStep32 == 0 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
				
			elseif secStep32 == 4 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
			
				tweenShaderProperty('raymarch', 'y', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 8 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)
		
				tweenShaderProperty('raymarch', 'x', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 12 then 
				setAndEaseBackShader('raymarch', 'boxX0', boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, -boxDist)

				tweenShaderProperty('raymarch', 'y', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 16 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
	
				tweenShaderProperty('raymarch', 'x', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 20 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
	
				tweenShaderProperty('raymarch', 'y', camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 24 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)
	
				tweenShaderProperty('raymarch', 'x', -camOffset, crochet*0.001*4, 'cubeOut')
			elseif secStep32 == 28 then 
				setAndEaseBackShader('raymarch', 'boxX0', -boxDist, crochet*0.001*4, boxEase)
				setAndEaseBackToShader('raymarch', 'boxX1', 0.0, crochet*0.001*4, boxEase, boxDist)

				tweenShaderProperty('raymarch', 'y', -camOffset, crochet*0.001*4, 'cubeOut')
			end
	
	
			if curStep % 4 == 0 then 
				--setAndEaseBackToShader('raymarch', 'z', 3, crochet*0.001*4, 'cubeOut', 4)
				setAndEaseBackToShader('glitch', 'strength', 0.8, crochet*0.001*4, 'cubeOut', 0.02)
			end
		end


		

	end


	if section >= 170 and section < 186 then 
		if section % 4 == 3 then 
			if section == 177 then 
				if secStep == 0 or secStep == 4 then 
					setAndEaseBackToShader('glitch', 'strength', 0.6, crochet*0.001*4, 'cubeOut', 0.02)
				elseif secStep == 8 then 
					tweenShaderProperty('glitch', 'strength', 2.0, crochet*0.001*8, 'cubeOut')
				end
			else 
				if secStep == 0 or secStep == 4 then 
					setAndEaseBackToShader('glitch', 'strength', 0.6, crochet*0.001*4, 'cubeOut', 0.02)
				elseif secStep == 10 or secStep == 12 or secStep == 8 or secStep == 14 then 
					setAndEaseBackToShader('glitch', 'strength', 0.6, crochet*0.001*2, 'cubeOut', 0.02)
				end
			end

		else 
			if secStep == 0 or secStep == 4 or secStep == 8 then 
				setAndEaseBackToShader('glitch', 'strength', 0.6, crochet*0.001*4, 'cubeOut', 0.02)
			elseif secStep == 14 or secStep == 12 then 
				setAndEaseBackToShader('glitch', 'strength', 0.6, crochet*0.001*2, 'cubeOut', 0.02)
			end
		end
	end

	if section == 169 and secStep == 8 then 
		tweenShaderProperty('raymarch', 'floorY', 2, crochet*0.001*8, 'cubeInOut')
		tweenShaderProperty('raymarch', 'boxZ0', -50, crochet*0.001*8, 'cubeIn')
		tweenShaderProperty('raymarch', 'boxZ1', -50, crochet*0.001*8, 'cubeIn')

		tweenShaderProperty('raymarch', 'sphereZ', 0, crochet*0.001*8, 'cubeOut')
		tweenShaderProperty('raymarch', 'z', 4, crochet*0.001*8, 'cubeOut')
		--tweenShaderProperty('raymarch', 'x', 4, crochet*0.001*8, 'cubeIn')
		tweenShaderProperty('raymarch', 'y', 0.5, crochet*0.001*8, 'cubeIn')
	end

	if section >= 186 and section < 202 then 
		if section == 79 and (secStep == 4 or secStep == 12) then 

		else 
	
			local angleShit = 45.0
			local camOffset = 0.5
			local boxEase = 'expoOut'
	
			if secStep == 0 then 
				setAndEaseBackShader('raymarch', 'sphereAngleZ', angleShit, crochet*0.001*4, boxEase)
			elseif secStep == 4 then 
				setAndEaseBackShader('raymarch', 'sphereAngleX', angleShit, crochet*0.001*4, boxEase)
			elseif secStep == 8 then 
				setAndEaseBackShader('raymarch', 'sphereAngleZ', -angleShit, crochet*0.001*4, boxEase)
			elseif secStep == 12 then 
				setAndEaseBackShader('raymarch', 'sphereAngleX', -angleShit, crochet*0.001*4, boxEase)
			end
	
	
			if curStep % 4 == 0 then 
				setAndEaseBackToShader('glitch', 'wobble', 5.0, crochet*0.001*4, 'cubeOut', 0)
				setAndEaseBackToShader('glitch', 'strength', 0.5, crochet*0.001*4, 'cubeOut', 0.02)
			end
		end
	end

	if section == 202 and secStep == 0 then 
		tweenShaderProperty('raymarch', 'x', 0, crochet*0.001*16*4, 'linear')
		tweenShaderProperty('raymarch', 'z', 0, crochet*0.001*16*4, 'linear')
		tweenShaderProperty('raymarch', 'y', 50, crochet*0.001*16*12, 'linear')
	end




	--arrow stuffs

	if section >= 4 and section < 8 then 

		local b = curBeat-12
		local v = b*b
		
		if secStep8 == 0 then
			setAndEaseArrowOffset(0, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'x', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'angle', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'angle', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'y', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'y', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'angle', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'angle', v, crochet*0.001*4, 'expoOut', 0)

			
			setAndEaseArrowOffset(3, 'z', -v*2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'z', -v*3.5, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'z', v*2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'z', v*3.5, crochet*0.001*4, 'expoOut', 0)
			

		elseif secStep8 == 4 then 
			setAndEaseArrowOffset(3, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'angle', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'angle', v, crochet*0.001*4, 'expoOut', 0)

			setAndEaseArrowOffset(0, 'y', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'y', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'x', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'angle', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'angle', -v, crochet*0.001*4, 'expoOut', 0)

			setAndEaseArrowOffset(3, 'z', v*2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'z', v*3.5, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'z', -v*2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'z', -v*3.5, crochet*0.001*4, 'expoOut', 0)
			
		end
		
	elseif (section >= 8 and section < 16) or (section >= 32 and section < 40) or (section >= 138 and section < 146) 
		or (section >= 154 and curStep < 2706) then 

		local v = 50
		if section >= 138 then 
			v = 100
		end
		if secStep8 == 0 then
			setAndEaseArrowOffset(0, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'x', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', v, crochet*0.001*4, 'expoOut', 0)



			if section >= 98 then 
				setAndEaseArrowOffset(3, 'z', v*1, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(2, 'z', v*3, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(1, 'z', v*5, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(0, 'z', v*7, crochet*0.001*4, 'expoOut', 0)
			end



		elseif secStep8 == 4 then 
			setAndEaseArrowOffset(3, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', -v, crochet*0.001*4, 'expoOut', 0)

			setAndEaseArrowOffset(0, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'y', v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'x', -v*1.3, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', -v, crochet*0.001*4, 'expoOut', 0)

			if section >= 98 then 
				setAndEaseArrowOffset(0, 'z', v*1, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(1, 'z', v*3, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(2, 'z', v*5, crochet*0.001*4, 'expoOut', 0)
				setAndEaseArrowOffset(3, 'z', v*7, crochet*0.001*4, 'expoOut', 0)
			end
			
		end
	
	elseif (section >= 16 and section < 32) or (section >= 40 and section < 47) or (section >= 48 and section < 64) or (section >= 106 and section < 122) 
		or (section >= 146 and section < 154)then 

		local v = 80
		local v2 = 250

		if section >= 106 then
			v = 130
			v2 = 350
		end

		if secStep8 == 0 then 
			setAndEaseArrowOffset(0, 'y', v*1.5, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'y', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'y', v*1.5, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'x', 112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', 112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', -112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', -112, crochet*0.001*4, 'expoOut', 0)

			setAndEaseArrowOffset(0, 'z', 1000, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'z', 500, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'z', 500, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'z', 1000, crochet*0.001*4, 'expoOut', 0)
		elseif secStep == 4 then 

			setAndEaseArrowOffset(0, 'x', v2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', v2-112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', v2-112-112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', v2-112-112-112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'angle', v2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'angle', v2-112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'angle', v2-112-112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'angle', v2-112-112-112, crochet*0.001*4, 'expoOut', 0)

		elseif secStep == 12 then 

			setAndEaseArrowOffset(0, 'x', -v2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'x', -v2+112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'x', -v2+112+112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'x', -v2+112+112+112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(0, 'angle', -v2, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'angle', -v2+112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'angle', -v2+112+112, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'angle', -v2+112+112+112, crochet*0.001*4, 'expoOut', 0)

		end
	elseif (section >= 64 and section < 79) or (section >= 122 and section < 137) or (section >= 186 and section < 202) then 

		local v = 1500
		if secStep8 == 0 then
			setAndEaseArrowOffset(0, 'z', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'z', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'z', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'z', -v, crochet*0.001*4, 'expoOut', 0)
		elseif secStep8 == 4 then 
			setAndEaseArrowOffset(0, 'z', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(1, 'z', -v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(2, 'z', v, crochet*0.001*4, 'expoOut', 0)
			setAndEaseArrowOffset(3, 'z', v, crochet*0.001*4, 'expoOut', 0)
			
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


function setArrowProperty(lane, prop, val)
	setActorProperty(lane, prop, val)
	setActorProperty(lane+keyCount, prop, val)
end
function tweenArrowProperty(lane, prop, val, time, ease)
	tweenActorProperty(lane, prop, val, time, ease)
	tweenActorProperty(lane+keyCount, prop, val, time, ease)
end

function setArrowOffset(lane, prop, val)
	local p0 = 0
	local p1 = 0

	if prop == 'x' then 
		p0 = defaultX[lane+1]
		p1 = defaultX[lane+1+keyCount]
	elseif prop == 'y' then 
		p0 = defaultY[lane+1]
		p1 = defaultY[lane+1+keyCount]
	end

	setActorProperty(lane, prop, val+p0)
	setActorProperty(lane+keyCount, prop, val+p1)
end

function tweenArrowOffset(lane, prop, val, time, ease)
	local p0 = 0
	local p1 = 0

	if prop == 'x' then 
		p0 = defaultX[lane+1]
		p1 = defaultX[lane+1+keyCount]
	elseif prop == 'y' then 
		p0 = defaultY[lane+1]
		p1 = defaultY[lane+1+keyCount]
	end

	tweenActorProperty(lane, prop, val+p0, time, ease)
	tweenActorProperty(lane+keyCount, prop, val+p1, time, ease)
end

function setAndEaseArrowOffset(lane, prop, val, time, ease, to)
	setArrowOffset(lane, prop, val)
	tweenArrowOffset(lane, prop, to, time, ease)
end



function sectionHit(section)

	if section == 1 then 
		
		--tweenActorProperty('playerIA', 'y', -720, crochet*0.001*16*4, 'linear')
	end

end


function onEvent(name, position, value1, value2)
	if string.lower(name) == "add camera zoom" then
        if section >= 170 and section < 186 then

			local t = 2

			if section == 177 then 
				if curStep % 16 >= 7 then 
					t = 1
					if curStep % 16 >= 11 then 
						t = 0.5
					end
				end
			end
            
			setAndEaseArrowOffset(0, 'y', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(1, 'y', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(2, 'y', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(3, 'y', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(0, 'x', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(1, 'x', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(2, 'x', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(3, 'x', math.random(-100, 100), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(0, 'angle', math.random(-400, 400), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(1, 'angle', math.random(-400, 400), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(2, 'angle', math.random(-400, 400), crochet*0.001*t, 'cubeOut', 0)
			setAndEaseArrowOffset(3, 'angle', math.random(-400, 400), crochet*0.001*t, 'cubeOut', 0)

			--setAndEaseArrowOffset(0, 'z', math.random(-1000, 1000), crochet*0.001*t, 'cubeOut', 0)
			--setAndEaseArrowOffset(1, 'z', math.random(-1000, 1000), crochet*0.001*t, 'cubeOut', 0)
			--setAndEaseArrowOffset(2, 'z', math.random(-1000, 1000), crochet*0.001*t, 'cubeOut', 0)
			--setAndEaseArrowOffset(3, 'z', math.random(-1000, 1000), crochet*0.001*t, 'cubeOut', 0)
        end
	end
end