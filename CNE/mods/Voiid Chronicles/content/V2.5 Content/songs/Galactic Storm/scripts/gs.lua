--https://github.com/Wavalab/rgb-hsl-rgb/blob/master/rgbhsl.lua
local function hslToRgb(h, s, l)
    if s == 0 then return l, l, l end
    local function to(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < .16667 then return p + (q - p) * 6 * t end
        if t < .5 then return q end
        if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
        return p
    end
    local q = l < .5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function rgbToHsl(r, g, b)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local b = max + min
    local h = b / 2
    if max == min then return 0, 0, h end
    local s, l = h, h
    local d = max - min
    s = l > .5 and d / (2 - b) or d / b
    if max == r then h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    return h * .16667, s, l
end

function preGenerateArrows()
    --setProperty('', 'showKeyPopups', false)
end


function createPost()

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
	setShaderProperty('mirror', 'zoom', 0.5)
    makeSprite('black', '', 0, 0, 1)
    setObjectCamera('black', 'hud')
    makeGraphic('black', 4000, 2000, '0xFF000000')
    actorScreenCenter('black')
    --tweenActorProperty('black', 'alpha', 1, crochet*0.001*16, 'quadIn')


    initShader('raymarch', 'RaymarchDepthEffect')
    --setCameraShader('game', 'raymarch')
    setCameraShader('hud', 'raymarch')
    setShaderProperty('raymarch', 'boxDepth', 0.0)
	setShaderProperty('raymarch', 'boxAngleY0', 180)
	setShaderProperty('raymarch', 'z', -2.1)
	--setShaderProperty('raymarch', 'zoom', -2)

    --tweenShaderProperty('raymarch', 'boxAngleY0', 360, 5, 'linear')




    initShader('mirror2', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror2')
	setShaderProperty('mirror2', 'zoom', 1)

    initShader('blur', 'BlurEffect')
    setCameraShader('game', 'blur')
    setShaderProperty('blur', 'strength', 0)
    

    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.2)
    setShaderProperty('bloom2', 'strength', 0.2)

    initShader('sparks', 'SparkEffect')
    setCameraShader('game', 'sparks')
    setShaderProperty('sparks', 'red', 0.82)
    setShaderProperty('sparks', 'green', 0.1)
    setShaderProperty('sparks', 'blue', 0.82)
    setShaderProperty('sparks', 'warp', -450)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

    initShader('chromAb', 'ChromAbEffect')
    setCameraShader('game', 'chromAb')
    setCameraShader('hud', 'chromAb')
    setShaderProperty('chromAb', 'strength', 0.0005)

    local offsetShit = 0

    if keyCount == 12 then 
        offsetShit = 17
    end

    if not middlescroll then 
        for i = 0,keyCount-1 do 
            if opponentPlay then 
                setActorProperty(i+keyCount, 'x', -10000)
                setActorProperty(i, 'x', (getActorProperty(i, 'x')+320)-offsetShit)
            else 
                setActorProperty(i, 'x', -10000)
                setActorProperty(i+keyCount, 'x', (getActorProperty(i+keyCount, 'x')-320)-offsetShit)
            end

        end
    end

    

    --setStageColorSwap('hue', 0.5) --green

    --setStageColorSwap('hue', 0.7) --cyan

    --setStageColorSwap('hue', 0.2)

    --setStageColorSwap('hue', 0.5)


    --setStageColorSwap('hue', 0.25)

end

function updateSparks(hue)

    local r = 0.82
    local g = 0.1
    local b = 0.82

    r,g,b = rgbToHsl(r,g,b)

    r = r + hue --add hue

    r,g,b = hslToRgb(r,g,b)
    setShaderProperty('sparks', 'red', r)
    setShaderProperty('sparks', 'green', g)
    setShaderProperty('sparks', 'blue', b)
end


function lerp(a, b, ratio)
	return a + ratio * (b - a); --the funny lerp
end
local perlinX = 0
local perlinY = 0
local perlinZ = 0

local perlinSpeed = 0.5

local perlinXRange = 0.12
local perlinYRange = 0.12
local perlinZRange = 10

local depthStrength = 0
local depthAng = 0
local section = 0

local perlinXAng = 0
local perlinYAng = 0
local hueshiftTime = 0.75

function update(elapsed)
    perlinX = perlinX + elapsed*math.random()*perlinSpeed
	perlinY = perlinY + elapsed*math.random()*perlinSpeed
	perlinZ = perlinZ + elapsed*math.random()*perlinSpeed
    --local noiseX = perlin.noise(perlinX, 0, 0)
	--trace(perlin(perlinX, 0, 0)*0.1)
    setShaderProperty('mirror2', 'x', ((-0.5 + perlin(perlinX, 0, 0))*perlinXRange))
	setShaderProperty('mirror2', 'y', ((-0.5 + perlin(0, perlinY, 0))*perlinYRange))
	setShaderProperty('mirror2', 'angle', ((-0.5 + perlin(0, 0, perlinZ))*perlinZRange))

    updateSparks(getStageColorSwap('hue'))


    if section >= 128 and section < 137 then 

        depthStrength = lerp(depthStrength, 0.0, elapsed*5)

        setShaderProperty('raymarch', 'boxDepth', depthStrength)
    end


    if section >= 144 and section < 152 then 
        depthStrength = lerp(depthStrength, 0.1, elapsed*5)
        depthAng = lerp(depthAng, 0.0, elapsed*5)
        setShaderProperty('raymarch', 'boxAngleX0', depthAng)
        setShaderProperty('raymarch', 'boxDepth', depthStrength)
    end

    if section >= 170 and section < 186 then 
        perlinXAng = perlinXAng + elapsed*math.random()*2
        perlinYAng = perlinYAng + elapsed*math.random()*2
        setShaderProperty('raymarch', 'boxAngleX0', ((-0.5 + perlin(perlinXAng, 0, 0))*35))
	    setShaderProperty('raymarch', 'boxAngleY0', 180 + ((-0.5 + perlin(0, perlinYAng, 0))*35))

        hueshiftTime = (hueshiftTime + elapsed) % 1
        setStageColorSwap('hue', hueshiftTime)
    end
end

local coolsectionbeatshit = -1
local coolsectionhues = {0.0, 0.25, 0.5, 0.75}

function onEvent(name, position, value1, value2)
	if string.lower(name) == "add camera zoom" then
        if section >= 128 and section < 137 then
            depthStrength = depthStrength + 0.15 --cant to half steps with scripts so just using events that were already there
        end

        if section >= 144 and section < 152 then 
            coolsectionbeatshit = (coolsectionbeatshit + 1)%4
            depthStrength = depthStrength + 0.1

            if coolsectionbeatshit % 2 == 0 then 
                depthAng = 15
            else 
                depthAng = -15
            end

            tweenStageColorSwap('hue', coolsectionhues[coolsectionbeatshit+1], 0.001, 'cubeOut')
            
        end
	end
end

function rgbToHsv(r,g,b, h,s,v)

end


local swap = 1
function songStart()
    --showBinds();
    tweenActorProperty('black', 'alpha', 0.0, crochet*0.001*16*8, 'cubeInOut')
    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*16*8, 'cubeInOut')
end

function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32

    if section == 8 and secStep == 0 then 
        bloomBurst(0.3, 2, 16)
        tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*16, 'cubeOut')
        
    end


    if section == 15 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            setAndEaseBackShader('mirror', 'angle', 360.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 17 or section == 21 or section == 25 or section == 29 or section == 31 then 

        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 19 or section == 23 or section == 27 then 

        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
        end
    end

    if section >= 16 and section < 32 then 
        if section % 2 == 0 and secStep == 0 then 
            setAndEaseBackShader('blur', 'strength', 3.0, crochet*0.001*16, 'cubeIn')
            setAndEaseBackShaderTo('chromAb', 'strength', 0.005, crochet*0.001*16, 'cubeIn', 0.0005)
        end
    end

    if section == 32 and secStep == 0 then 
        perlinZRange = 20
        perlinSpeed = 1.0
    end


    if section == 35 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'x', 2.0, crochet*0.001*4, 'cubeInOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            setAndEaseBackShader('blur', 'strength', 6.0, crochet*0.001*4, 'cubeIn')
            setAndEaseBackShader('grey', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
           
        end
    elseif section == 39 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'x', 0.0, crochet*0.001*4, 'cubeInOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            setAndEaseBackShader('blur', 'strength', 6.0, crochet*0.001*4, 'cubeIn')
            setAndEaseBackShader('grey', 'strength', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            
        end

    end


    if section >= 40 and section < 43 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            setStageColorSwap('hue', 0.3)
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenStageColorSwap('hue', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 43 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*16, 'cubeIn')
    elseif section == 44 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
    end

    if section == 45 or section == 47 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            setAndEaseBackShader('blur', 'strength', 6.0, crochet*0.001*4, 'cubeIn')
            setStageColorSwap('hue', 0.3)
            tweenShaderProperty('mirror', 'y', 2.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            setAndEaseBackShader('blur', 'strength', 6.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenStageColorSwap('hue', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'y', 0.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
        end
    end

    if section >= 48 and section < 64 then 
        if secStep == 0 then 
            setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
            bloomBurst(1, 1, 16)
            --tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('raymarch', 'boxDepth', 0.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxDepth', 0.1, crochet*0.001*12, 'cubeIn')
            --tweenShaderProperty('mirror2', 'zoom', 0.7, crochet*0.001*12, 'cubeIn')
        end
    end

    if section == 51 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')

        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            
        end
    elseif section == 56 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            setAndEaseBackShader('blur', 'strength', 3.0, crochet*0.001*8, 'cubeIn')
            setAndEaseBackShaderTo('chromAb', 'strength', 0.005, crochet*0.001*8, 'cubeIn', 0.0005)
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end
    elseif section == 63 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            
        end
    end

    if section == 54 and secStep == 0 then 
        setStageColorSwap('hue', 0.3)
        tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeIn')
    end

    --if curStep == 32 then 
        --makeCameraSpriteClone('test', 'game')
        --setObjectCamera('test', 'hud')
        --setAndEaseBack('test', 'angle', 360, 2, 'cubeOut')
    --end

    if section == 64 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('raymarch', 'boxAngleY0', 180+30, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('raymarch', 'boxAngleY0', 180-30, crochet*0.001*8, 'cubeOut')
        end
    elseif section == 65 then 
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('raymarch', 'boxAngleX0', 30, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            setShaderProperty('raymarch', 'boxAngleX0', -360)
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section == 66 then 
        if secStep == 8 then 
            setShaderProperty('raymarch', 'boxAngleY0', 180+30)
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*2, 'cubeOut')
        elseif secStep == 10 then
            setShaderProperty('raymarch', 'boxAngleY0', 180-30)
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then 

            setShaderProperty('mirror', 'angle', 360)
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')

        end

    elseif section == 67 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'y', 6, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 71 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 68 or section == 69 or section == 70 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            setShaderProperty('raymarch', 'boxAngleX0', -360)
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*8, 'expoOut')
        end


    end

    if section == 67 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.3, crochet*0.001*16, 'cubeIn')
    elseif section == 71 and secStep == 0 then
        tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeIn')
    end

    if section == 73 then 
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', -20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 75 then 
            if secStep == 0 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180+20, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 4 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep == 8 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180-20, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 12 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 5.0, crochet*0.001*4, 'cubeOut')
                setAndEaseBackShader('mirror', 'angle', 360.0, crochet*0.001*4, 'cubeOut')
            end
    end

    if section == 76 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.3, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
    end

    if section == 78 then
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'x', -5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'x', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end

    elseif section == 79 then 
            if secStep == 0 then 
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 4 then 
                
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep == 8 then 
                setShaderProperty('raymarch', 'boxAngleY0', -180)
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 12 then 
                tweenShaderProperty('mirror', 'x', 0, crochet*0.001*8, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            end
    end

    if section == 80 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.0, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*16, 'cubeOut')
        bloomBurst(1, 1, 16)
        tweenShaderProperty('raymarch', 'boxDepth', 0.0, crochet*0.001*16, 'cubeOut')
    elseif section == 84 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*16*11, 'linear')
    elseif section == 88 and secStep == 0 then 
        bloomBurst(1, 1, 16)
    elseif section == 95 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('grey', 'strength', 0.4, crochet*0.001*4, 'cubeIn')
        end

    elseif section == 103 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 2.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', -0.15, crochet*0.001*4, 'cubeIn')
            tweenStageColorSwap('hue', 0.3, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 104 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 2, crochet*0.001*4, 'cubeInOut')
        end
    end

    function angShit()
        --trace('fyck')
        setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*4, 'cubeIn', 1.0)
        setAndEaseBackShader('mirror', 'angle', 20.0*swap, crochet*0.001*4, 'cubeOut')
        swap = swap * -1
    end

    if section == 112 and secStep == 0 then 
        setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
        setAndEaseBackShader('mirror', 'angle', 20.0*-swap, crochet*0.001*4, 'cubeOut')
    elseif section == 113 and (secStep == 4 or secStep == 12) then 
        angShit()
    elseif section == 114 and (secStep == 0 or secStep == 4 or secStep == 8) then 
        angShit()
    elseif section == 115 and (curStep % 4 == 0) then 
        angShit()
    elseif section == 116 and secStep == 0 then 
            setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
            setAndEaseBackShader('mirror', 'angle', 20.0*-swap, crochet*0.001*4, 'cubeOut')
    elseif section == 117 and (secStep == 4 or secStep == 12) then 
        angShit()
    elseif section == 118 and (secStep == 0 or secStep == 4 or secStep == 8) then 
        angShit()
    elseif section == 119 and (curStep % 4 == 0) then 
        angShit()

        if secStep == 0 then 
            tweenShaderProperty('mirror', 'y', 3, crochet*0.001*4, 'cubeInOut')
        elseif secStep == 4 then 
            tweenShaderProperty('mirror', 'y', 6, crochet*0.001*4, 'cubeInOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'y', 9, crochet*0.001*4, 'cubeInOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'y', 12, crochet*0.001*4, 'cubeInOut')
        end
    end
    if section == 120 and secStep == 0 then 
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'expoIn')
        tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'expoIn')
        setAndEaseBackShader('mirror', 'angle', 360, crochet*0.001*4, 'expoIn')
    end

    if section == 116 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.0, crochet*0.001*4, 'cubeOut')
    end


    if section == 124 and secStep == 0 then 
        setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
        tweenStageColorSwap('hue', 0.5, crochet*0.001*2, 'cubeOut')
        bloomBurst(0.3, 2, 16)
    elseif section == 125 and secStep == 0 then 
        setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
        tweenStageColorSwap('hue', 0.25, crochet*0.001*2, 'cubeOut')
        bloomBurst(0.3, 2, 16)
    elseif section == 126 and secStep == 0 then 
        setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
        tweenStageColorSwap('hue', 0.1, crochet*0.001*2, 'cubeOut')
        bloomBurst(0.3, 2, 16)
    elseif section == 127 then
        
        if secStep == 0 then 
            bloomBurst(0.3, 2, 16)
            setAndEaseBackToShader('grey', 'strength', 0.0, crochet*0.001*16, 'cubeIn', 1.0)
            tweenStageColorSwap('hue', 0.7, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
        end

    elseif section == 128 and secStep == 0 then 
        bloomBurst(0.3, 2, 16)
        tweenStageColorSwap('hue', 0.25, crochet*0.001*2, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'expoOut')
    elseif section == 136 and secStep == 0 then 
        bloomBurst(0.3, 2, 16)
        tweenShaderProperty('grey', 'strength', 1, crochet*0.001*4, 'expoOut')
    elseif section == 143 then 
       
        if secStep == 0 then 
            tweenShaderProperty('grey', 'strength', 0, crochet*0.001*4, 'expoOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'angle', 25.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.1, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'angle', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
        end

    elseif section == 144 and secStep == 0 then 
        bloomBurst(0.3, 2, 16)
    elseif section == 152 and secStep == 0 then 
        tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('raymarch', 'boxDepth', 0.1, crochet*0.001*8, 'cubeOut')

        setProperty('camGame', 'alpha', 0)
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
    elseif section == 154 and secStep == 0 then 
        setStageColorSwap('hue', 0.5)
        setProperty('camGame', 'alpha', 1)
        bloomBurst(0.3, 2, 16)
    end

    if section == 148 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.1, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 150 then 

        if secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.1, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 4, crochet*0.001*4, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 151 and secStep == 12 then 
        tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeIn')
        tweenShaderProperty('mirror', 'warp', -0.5, crochet*0.001*4, 'cubeIn')
    end



    local secOff = 90

    if section-secOff == 64 then 
        if secStep == 0 then 
            tweenShaderProperty('mirror2', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('raymarch', 'boxAngleY0', 180+30, crochet*0.001*8, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('raymarch', 'boxAngleY0', 180-30, crochet*0.001*8, 'cubeOut')
        end
    elseif section-secOff == 65 then 
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('raymarch', 'boxAngleX0', 30, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            setShaderProperty('raymarch', 'boxAngleX0', -360)
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
        end
    elseif section-secOff == 66 then 
        if secStep == 8 then 
            setShaderProperty('raymarch', 'boxAngleY0', 180+30)
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*2, 'cubeOut')
        elseif secStep == 10 then
            setShaderProperty('raymarch', 'boxAngleY0', 180-30)
            tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then 

            setShaderProperty('mirror', 'angle', 360)
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*8, 'cubeOut')

        end

    elseif section-secOff == 67 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'y', 6, crochet*0.001*4, 'cubeOut')
        end

    elseif section-secOff == 71 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'y', 3, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'y', 0, crochet*0.001*4, 'cubeOut')
        end

    elseif section-secOff == 68 or section-secOff == 69 or section-secOff == 70 then 

        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            setShaderProperty('raymarch', 'boxAngleX0', -360)
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*8, 'expoOut')
        end


    end

    if section-secOff == 67 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.75, crochet*0.001*16, 'cubeIn')
    elseif section-secOff == 71 and secStep == 0 then
        tweenStageColorSwap('hue', 0.5, crochet*0.001*16, 'cubeIn')
    end

    if section-secOff == 73 then 
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', -20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end

    elseif section-secOff == 75 then 
            if secStep == 0 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180+20, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 4 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep == 8 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180-20, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 12 then 
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 5.0, crochet*0.001*4, 'cubeOut')
                setAndEaseBackShader('mirror', 'angle', 360.0, crochet*0.001*4, 'cubeOut')
            end
    end

    if section-secOff == 76 and secStep == 0 then 
        tweenStageColorSwap('hue', 0.75, crochet*0.001*16, 'cubeOut')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
    end

    if section-secOff == 78 then
        if secStep == 0 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 20, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('raymarch', 'boxAngleX0', 0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('mirror', 'x', -5, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'x', 2, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
        end

    elseif section-secOff == 79 then 
            if secStep == 0 then 
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 4 then 
                
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
            elseif secStep == 8 then 
                setShaderProperty('raymarch', 'boxAngleY0', -180)
                tweenShaderProperty('raymarch', 'boxAngleY0', 180, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', -0.15, crochet*0.001*4, 'cubeOut')
            elseif secStep == 12 then 
                tweenShaderProperty('mirror', 'x', 0, crochet*0.001*8, 'cubeOut')
                tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeOut')
                tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeOut')
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


function bloomBurst(e, s, t)
    setShaderProperty('bloom2', 'effect', e)
    setShaderProperty('bloom2', 'strength', s)
    tweenShaderProperty('bloom2', 'effect', 0.0, crochet*0.001*t, 'cubeOut')
    tweenShaderProperty('bloom2', 'strength', 0.0, crochet*0.001*t, 'cubeOut')
end