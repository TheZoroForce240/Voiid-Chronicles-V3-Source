function createPost()
	initShader('sobel', 'SobelEffect')
    setCameraShader('game', 'sobel')
    setCameraShader('hud', 'sobel')
    setShaderProperty('sobel', 'strength', 0)
    setShaderProperty('sobel', 'intensity', 3)

    initShader('greyscale', 'GreyscaleEffect')
    setCameraShader('game', 'greyscale')
    setCameraShader('hud', 'greyscale')
    setShaderProperty('greyscale', 'strength', 0)

    initShader('caBlue', 'ChromAbBlueSwapEffect')
    setCameraShader('game', 'caBlue')
    setCameraShader('hud', 'caBlue')
    setShaderProperty('caBlue', 'strength', 0.001)

    initShader('pixel', 'MosaicEffect')
    setCameraShader('game', 'pixel')
    setCameraShader('hud', 'pixel')
    setShaderProperty('pixel', 'strength', 50)

    initShader('barrel', 'BarrelBlurEffect')
	setCameraShader('game', 'barrel')
    if modcharts then 
		setCameraShader('hud', 'barrel')
	end
	
	setShaderProperty('barrel', 'zoom', 0.05)
	setShaderProperty('barrel', 'barrel', 0.0)
    --setShaderProperty('barrel', 'angle', 720.0)
	makeSprite('barrelOffset', '', 0, 0) --so i can tween while still having the perlin stuff
	setActorAlpha(0, 'barrelOffset')
end

local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.5

local perlinXRange = 0.02
local perlinYRange = 0.02
local perlinZRange = 0.5

function updatePost(elapsed)

    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('barrel', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange)+getActorX('barrelOffset'))
	setShaderProperty('barrel', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange)+getActorY('barrelOffset'))
	setShaderProperty('barrel', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange)+getActorAngle('barrelOffset'))
end
function songStart()
    tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*63, 'cubeInOut')
    setActorAngle(720, 'barrelOffset')
    tweenActorProperty('barrelOffset', 'angle', 0, crochet*0.001*64, 'cubeInOut')
    tweenShaderProperty('pixel', 'strength', 1, crochet*0.001*64, 'backIn')
end

local beatinSteps = {63, 92, 108, 128, 156,172,188,220,236,252,264,272,280}
local beatInMore = {96, 160,192,224,284,288,292,296,300,304,308,310,312,314,316,318}
local leftPunchNoGrey = {80,568,576,592, 1414}
local rightPunchNoGrey = {192, 320,440,572,584,596,928, 1408, 1420,1632,1696}
local leftPunchGrey = {120,342,1478,1654}
local rightPunchGrey = {124,336,348,1472, 1484,1648,1660}
function stepHit()

    for i = 1,#beatinSteps do 
        if curStep == beatinSteps[i]-1 then 
            tweenShaderProperty('barrel', 'zoom', 0.8, crochet*0.001, 'cubeIn')
        elseif curStep == beatinSteps[i] then 
            tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*3.8, 'cubeOut')
        end
    end
    for i = 1,#beatInMore do 
        if curStep == beatInMore[i]-1 then 
            tweenShaderProperty('barrel', 'zoom', 0.75, crochet*0.001, 'cubeIn')
        elseif curStep == beatInMore[i] then 
            tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*1.8, 'cubeOut')
            --triggerEvent("add camera zoom", 0.13, 0.13)
        end
       
    end

    for i = 1,#leftPunchNoGrey do 
        if curStep == leftPunchNoGrey[i]-1 then 
            tweenActorProperty('barrelOffset', 'angle', 25, crochet*0.001, 'cubeIn')
        elseif curStep == leftPunchNoGrey[i] then 
            tweenActorProperty('barrelOffset', 'angle', 0, crochet*0.001*3.5, 'cubeOut')
        end
    end
    for i = 1,#rightPunchNoGrey do 
        if curStep == rightPunchNoGrey[i]-1 then 
            tweenActorProperty('barrelOffset', 'angle', -25, crochet*0.001, 'cubeIn')
        elseif curStep == rightPunchNoGrey[i] then 
            tweenActorProperty('barrelOffset', 'angle', 0, crochet*0.001*3.5, 'cubeOut')
        end
    end

    for i = 1,#leftPunchGrey do 
        if curStep == leftPunchGrey[i]-1 then
            tweenActorProperty('barrelOffset', 'angle', 25, crochet*0.001, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001, 'cubeOut')
        elseif curStep == leftPunchGrey[i] then 
            tweenActorProperty('barrelOffset', 'angle', 0, crochet*0.001*3.5, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*3.5, 'cubeOut')
        end
    end
    for i = 1,#rightPunchGrey do 
        if curStep == rightPunchGrey[i]-1 then
            tweenActorProperty('barrelOffset', 'angle', -25, crochet*0.001, 'cubeIn')
            tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001, 'cubeOut')
        elseif curStep == rightPunchGrey[i] then 
            tweenActorProperty('barrelOffset', 'angle', 0, crochet*0.001*3.5, 'cubeOut')
            tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*3.5, 'cubeOut')
        end
    end

    local section = math.floor(curStep/16)

    if ((section >= 20 and section < 70) and section ~= 45) or ((section >= 86 and section < 118))then
        if ((section == 69 or section == 101) and curStep % 16 >= 8) then 
            
        else 
            if curStep % 8 == 0 then 
                tweenShaderProperty('barrel', 'zoom', 0.9, crochet*0.001*4, 'cubeIn')
            elseif curStep % 8 == 4 then 
                tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*4, 'cubeOut')
            end
        end

    end

    if curStep == 592 and not opponentPlay then 
        tweenShaderProperty('barrel', 'barrel', -10, crochet*0.001*16, 'cubeIn')
    elseif curStep == 608 then 
        tweenShaderProperty('barrel', 'barrel', 0, crochet*0.001*12, 'cubeOut')
        flashCamera('game', '#FFFFFF', crochet*0.001*4)
    elseif curStep == 720 then 
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*2, 'cubeOut')
    elseif curStep == 720+16 then 
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*2, 'cubeOut')
    end

    if curStep == 1120 then 
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('sobel', 'strength', 0.8, crochet*0.001*4, 'cubeIn')
    elseif curStep == 1232 then 
        tweenShaderProperty('sobel', 'strength', 0, crochet*0.001*8, 'cubeOut')
        --tweenShaderProperty('greyscale', 'strength', 0.8, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('caBlue', 'strength', 0.003, crochet*0.001*8, 'cubeOut')
    elseif curStep == 1352 then 
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*8, 'cubeOut')
    elseif curStep == 1360 and not opponentPlay then 
        tweenShaderProperty('barrel', 'zoom', 0.8, crochet*0.001*1, 'backInOut')
    elseif curStep == 1360+4 and not opponentPlay then 
        tweenShaderProperty('barrel', 'zoom', 0.6, crochet*0.001*1, 'backInOut')
    elseif curStep == 1360+8 and not opponentPlay then 
        tweenShaderProperty('barrel', 'zoom', 0.4, crochet*0.001*1, 'backInOut')
    elseif curStep == 1360+12 and not opponentPlay then 
         tweenShaderProperty('barrel', 'zoom', 0.25, crochet*0.001*1, 'backInOut')
    elseif curStep == 1360+16 then 
        tweenShaderProperty('barrel', 'zoom', 1, crochet*0.001*1, 'backInOut')
        perlinZRange = 20
        perlinXRange = 0.1
        perlinYRange = 0.1
        perlinSpeed = 3.5
    end

    if curStep == 1624 then 
        tweenShaderProperty('barrel', 'zoom', 0.5, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('greyscale', 'strength', 1, crochet*0.001*8, 'cubeIn')
        tweenShaderProperty('caBlue', 'strength', 0.001, crochet*0.001*8, 'cubeIn')
    elseif curStep == 1632 then 
        tweenShaderProperty('greyscale', 'strength', 0, crochet*0.001*4, 'cubeOut')
        perlinSpeed = 0.5
        perlinXRange = 0.02
        perlinYRange = 0.02
        perlinZRange = 0.5
    end


    if curStep == 1888 then 
        tweenShaderProperty('pixel', 'strength', 70, crochet*0.001*64, 'backIn')
        tweenShaderProperty('sobel', 'strength', 1, crochet*0.001*64, 'cubeIn')
    end

end