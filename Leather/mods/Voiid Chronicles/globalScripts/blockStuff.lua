local canBlockInThisSong = false
local anims = {'LEFT', 'DOWN', 'UP', 'RIGHT'}
local pushDist = 0
local pushLimit = 80
local bfPunchOffsets = {200,220,100,150}
local mattPunchOffsets = {190,250,110,140}
local disablePush = true
local disableBlock = false
local disableHealthDrain = false
local playDadParryAnims = false
local doSplahes = false
local doDadSplashes = false
local disableRanged = false
local disableBFBlock = false
local disableDadBlock = false
local doMattEchoTrail = false
local doBFEchoTrail = false
local trailCount = 0
local trailLimit = 100

local state = 'default'

local defaultBFX = 0
local defaultMattX = 0
local defaultBFY = 0
local defaultMattY = 0
local startPlayer1 = ''
local startPlayer2 = ''

local defaultRTXSatinCol = '0x00000000'


local bfShieldOffset = -240
local mattShieldOffset = -240

function getBFX()
    return defaultBFX+(pushDist*5)-getCharacterOffsetFromStageX('bfCharacter0') 
end
function getMattX()
    return defaultMattX+(pushDist*5)-getCharacterOffsetFromStageX('dadCharacter0')
end

function getBFCurrentX()
    return getActorX('bfCharacter0')+getCharacterOffsetFromStageX('bfCharacter0') 
end
function getMattCurrentX()
    return getActorX('dadCharacter0')+getCharacterOffsetFromStageX('dadCharacter0')
end

function getBFY()
    return defaultBFY-getCharacterOffsetFromStageY('bfCharacter0') 
end
function getMattY()
    return defaultMattY-getCharacterOffsetFromStageY('dadCharacter0')
end

function getBFCurrentY()
    return getActorY('bfCharacter0')+getCharacterOffsetFromStageY('bfCharacter0') 
end
function getMattCurrentY()
    return getActorY('dadCharacter0')+getCharacterOffsetFromStageY('dadCharacter0')
end


function createPost()
    local songList = 
	{
		'fisticuffs',
        'blastout',
        'immortal',
        'king hit',
        'king hit wawa',
        'tko',
        'edgelord',
        'revenge',
        'tko vip',
        'flaming glove'
	} 

	for i = 0,#songList-1 do
		if songLower == songList[i+1] then
			canBlockInThisSong = true
            addCharacterToMap('dad', 'Wiik3EchoParry')

            initShader('echo', 'EchoEffect')

            --addCharacterToMap('boyfriend', 'Wiik3BFAndEchoSing')
            --addCharacterToMap('dad', 'Wiik3MattAndEchoSing')

            setProperty('dad', 'followMainCharacter', true)
            setProperty('boyfriend', 'followMainCharacter', true)
            setProperty('', 'centerCamera', true)
		end
	end
    if songLower == 'edgelord' then
        disablePush = false
        pushLimit = 60
    elseif songLower == 'revenge' then 
        canBlockInThisSong = false
        setProperty('', 'centerCamera', false)
    elseif songLower == 'tko' then
        --addCharacterToMap('dad', 'TKOPowerupWithEcho')
        --addCharacterToMap('dad', 'TKOMattDark')
        makeAnimatedSprite('aura', 'characters/aura', -300, -650, 4)
        setActorLayer('aura', getActorLayer('dad')-1)
        addActorAnimation('aura', 'aura', 'aura', 24, true)
        playActorAnimation('aura', 'aura')
        setActorAlpha(0, 'aura')
    end

    
    --setCharacterShouldDance('dadCharacter4', false)
    --setActorAlpha(0, 'dadCharacter4')
    --setCharacterShouldDance('bfCharacter4', false)
    --setActorAlpha(0, 'bfCharacter4')
    --playCharacterAnimation('dadCharacter4', 'FadeIn', true)
    --playCharacterAnimation('dadCharacter4', 'idlemoment', true)
    --defaultBFX = getActorX('boyfriend')
    --defaultMattX = getActorX('dad')
    --defaultBFY = getActorY('boyfriend')
    --defaultMattY = getActorY('dad')

    defaultBFX = getCharacterX(0)
    defaultMattX = getCharacterX(1)
    defaultBFY = getCharacterY(0)
    defaultMattY = getCharacterY(1)

    startPlayer1 = player1
    startPlayer2 = player2

    

    --triggerEvent('change block state', 'bfshield', '')

    makeAnimatedSprite('bfShield', 'characters/ShieldStand_BF', defaultBFX+bfShieldOffset, defaultBFY-400, 1.5)
    addActorAnimation('bfShield', 'BF Shield0', 'BF Shield0', 24, true)
    playActorAnimation('bfShield', 'BF Shield0', true)
    makeAnimatedSprite('mattShield', 'characters/ShieldStand_Matt', defaultMattX+mattShieldOffset, defaultMattY-420, 1.5)
    addActorAnimation('mattShield', 'idle0', 'idle0', 24, true)
    playActorAnimation('mattShield', 'idle0', true)

    setActorAlpha(0, 'bfShield')
    setActorAlpha(0, 'mattShield')

    setActorLayer('mattShield', getActorLayer('dad')-1)
    setActorLayer('bfShield', getActorLayer('boyfriend')-1)


    --setSongPosition(62770)
end

local auraFadeTime = 0
local auraFaded = true
local doingPowerup = false
local floatTime = 0
--[[
--stupid tko stage change
local dad0X = 0
local dad1X = 0
local bfX = 0
local forceupdateCharPos = false
local forceupdateCharPosTime = 0
]]--
function update(elapsed)

    if not charsAndBGs then 
        return
    end

    
	if doingPowerup and not getActorProperty('dadCharacter0', 'hasPowerup') then 
		floatTime = floatTime + elapsed
		setActorProperty('dadCharacter0', 'y', getMattY()-150 + math.sin(floatTime)*50)
	end

    if songLower == 'tko' then 
        if not auraFaded then 
            auraFadeTime = auraFadeTime - elapsed
            if auraFadeTime < 0 then 
                auraFaded = true
                setActorAlpha(1, 'aura')
            end
        end
        if curStage == 'TKODark' then 
            local a = getActorAlpha('aura')
            --setActorAlpha((0-a)+1, 'tko-floor')
            --setActorProperty('tko-floorGlow', 'alpha', a)
            --trace(a)
            setActorAlpha(a, 'tko-floorGlow')
            --trace(getActorX('tko-floorGlow'))
        end
        --[[if forceupdateCharPos then 
            forceupdateCharPosTime = forceupdateCharPosTime - elapsed
            setActorX(bfX, 'boyfriend')
            setActorX(dad1X, 'dadCharacter1')
            setActorX(dad0X, 'dadCharacter0')
            --forceupdateCharPos = false
            if forceupdateCharPosTime < 0 then 
                forceupdateCharPos = false
            end
        end]]--
    else 
        if curStage == 'TKODark' then
            setActorAlpha(0, 'tko-floorGlow')
        end
    end
end

function dadBlock(data, doPush)

    if not charsAndBGs then 
        return
    end

    if not canBlockInThisSong then 
        return
    end
    destroySprite('punchSplash'..data)
    if doSplahes and doPush and getActorProperty('bfCharacter0', 'isBoxing') then
        makeAnimatedSprite('punchSplash'..data, 'characters/Splash', 0, 0, 0.5)
        addActorAnimation('punchSplash'..data, 'splash', 'splash', 24, false)
        playActorAnimation('punchSplash'..data, 'splash', true)
        setActorAngle(90, 'punchSplash'..data)
        setActorX(getBFCurrentX()-500,'punchSplash'..data)
        setActorY(getBFY()+bfPunchOffsets[getSingDirectionID(data)+1],'punchSplash'..data)
        tweenFadeIn('punchSplash'..data, 0, crochet/500)
        setActorLayer('punchSplash'..data, getActorLayer('dad')+2)
    end
    

    if disableBlock or disableDadBlock then
        return
    end

    if doBFEchoTrail then
        --playCharacterAnimation('bfCharacter2', 'sing'..anims[getSingDirectionID(data)+1], true)
        --setCharacterPreventDanceForAnim('bfCharacter2', true)

        makeSpriteCopy('trail'..trailCount, 'bfCharacter0')
        setActorShader('trail'..trailCount, "echo")
        setActorX(getActorX('boyfriend')-20, 'trail'..trailCount)
        setActorY(getActorY('boyfriend')-20, 'trail'..trailCount)
        tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
        setActorLayer('trail'..trailCount, getActorLayer('boyfriend')-1)
        trailCount = trailCount + 1
        if trailCount >= trailLimit then 
            trailCount = 0
        end
    end

    if playDadParryAnims then
        --playCharacterAnimation('dad', 'parry'..anims[getSingDirectionID(data)+1], true)
        --setCharacterPreventDanceForAnim('dad', true)
    end

    if not string.find(getPlayingActorAnimation('dad'), 'parry') and getActorProperty('bfCharacter0', 'isBoxing') then 
        playCharacterAnimation('dad', 'block'..anims[getSingDirectionID(data)+1], true)
        setCharacterPreventDanceForAnim('dad', true)
    end
    setActorLayer('boyfriend', getActorLayer('dad')+1)
    if pushDist >= -pushLimit and doPush and not disablePush then 
        pushDist = pushDist - 1
        setActorX(getActorX('boyfriend')-5, 'boyfriend')
        setActorX(getActorX('dad')-5, 'dad')
    end

    destroySprite('bfPunch'..data)
    

    local dist = math.abs((getMattCurrentX()+200) - getBFCurrentX())
    --trace(dist)
    local doRanged = true
    local rangeSpr = 'LongMatt'
    if dist < 220 then 
        doRanged = false
    elseif dist < 500 then 
        rangeSpr = 'MidMatt'
    end
    if doRanged and not disableRanged and getActorProperty('bfCharacter0', 'isBoxing') then 
        makeSprite('bfPunch'..data, 'punches/'..rangeSpr, 0, 0, 1)
        setActorFlipX(true,'bfPunch'..data)
        setActorX(getMattCurrentX(),'bfPunch'..data)
        setActorY(getBFCurrentY()+bfPunchOffsets[getSingDirectionID(data)+1]-400,'bfPunch'..data)
        tweenFadeIn('bfPunch'..data, 0, crochet/500)
        setActorStageShader('bfPunch'..data)
        setActorLayer('bfPunch'..data, getActorLayer('dad')+2)
    else 

    end
end
function bfBlock(data, doPush)

    if not charsAndBGs then 
        return
    end

    if disableBlock and playDadParryAnims then 
        playCharacterAnimation('dad', 'parry'..anims[getSingDirectionID(data)+1], true)
        setCharacterPreventDanceForAnim('dad', true)
    end

    destroySprite('punchSplash'..data)
    if doDadSplashes and doPush and getActorProperty('dadCharacter0', 'isBoxing') then
        makeAnimatedSprite('punchSplash'..data, 'characters/Splash', 0, 0, 0.5)
        addActorAnimation('punchSplash'..data, 'splash', 'splash', 24, false)
        playActorAnimation('punchSplash'..data, 'splash', true)
        setActorAngle(90, 'punchSplash'..data)
        setActorFlipX(true,'punchSplash'..data)
        setActorX(getMattCurrentX()+250,'punchSplash'..data)
        setActorY(getMattY()+mattPunchOffsets[getSingDirectionID(data)+1],'punchSplash'..data)
        tweenFadeIn('punchSplash'..data, 0, crochet/500)
        setActorLayer('punchSplash'..data, getActorLayer('bfCharacter0')+2)
        setActorLayer('dad', getActorLayer('bfCharacter0')+1)
    end

    if disableBlock or not canBlockInThisSong or disableBFBlock then 
        return
    end



 

    if playDadParryAnims then 
        playCharacterAnimation('dad', 'parry'..anims[getSingDirectionID(data)+1], true)
        setCharacterPreventDanceForAnim('dad', true)
        return
    end
    if doMattEchoTrail then
        --playCharacterAnimation('dadCharacter2', 'sing'..anims[getSingDirectionID(data)+1], true)
        --setCharacterPreventDanceForAnim('dadCharacter2', true)

        makeSpriteCopy('trail'..trailCount, 'dadCharacter0')
        setActorShader('trail'..trailCount, "echo")
        setActorX(getActorX('dad')-20, 'trail'..trailCount)
        setActorY(getActorY('dad')-20, 'trail'..trailCount)
        tweenFadeOut('trail'..trailCount, 0, crochet*0.001*16, 'trailFinish')
        setActorLayer('trail'..trailCount, getActorLayer('dad')-1)
        trailCount = trailCount + 1
        if trailCount >= trailLimit then 
            trailCount = 0
        end
    end

    setActorLayer('dad', getActorLayer('boyfriend')+1)
    if not string.find(getPlayingActorAnimation('boyfriend'), 'dodge') then 

        if getActorProperty('dadCharacter0', 'isBoxing') then --dont need to block if they dont punch
            playCharacterAnimation('boyfriend', 'block'..anims[getSingDirectionID(data)+1], true)
            setCharacterPreventDanceForAnim('boyfriend', true)
        end

        
        if pushDist <= pushLimit and doPush and not disablePush then
            pushDist = pushDist + 1
            setActorX(getActorX('boyfriend')+5, 'boyfriend')
            setActorX(getActorX('dad')+5, 'dad')
        end
    end
    
    destroySprite('dadPunch'..data)

    local dist = math.abs((getMattCurrentX()+200) - getBFCurrentX())
    --trace(dist)
    local doRanged = true
    local rangeSpr = 'LongMatt'
    if dist < 220 then 
        doRanged = false
    elseif dist < 500 then 
        rangeSpr = 'MidMatt'
    end
    if doRanged and not disableRanged and getActorProperty('dadCharacter0', 'isBoxing') then 
        makeSprite('dadPunch'..data, 'punches/'..rangeSpr, 0, 0, 1)
        setActorX(getBFCurrentX()-getActorWidth('dadPunch'..data),'dadPunch'..data)
        setActorY(getMattCurrentY()+mattPunchOffsets[getSingDirectionID(data)+1]-400,'dadPunch'..data)
        tweenFadeIn('dadPunch'..data, 0, crochet/500)
        setActorStageShader('dadPunch'..data)
        setActorLayer('dadPunch'..data, getActorLayer('boyfriend')+2)
    end    
end
function playerTwoSing(data, time, type)
	bfBlock(data, true)
    if not disableHealthDrain and canBlockInThisSong then 
        doHealthDrain()
    end
end
function playerTwoSingHeld(data, time, type)
	bfBlock(data, false)
end

function playerOneSing(data, time, ntype)
    if ntype ~= 'Wiik3Punch' and ntype ~= 'Wiik4Sword' then --dont block when dodging
        dadBlock(data, true)
    end
end
function playerOneSingHeld(data, time, type)
    if ntype ~= 'Wiik3Punch' and ntype ~= 'Wiik4Sword' then --dont block when dodging
        dadBlock(data, false)
    end
end
function onEvent(name, position, value1, value2)
    if string.lower(name) == "change stage" then
        pushDist = 0
        defaultBFX = getCharacterX(0)
        defaultMattX = getCharacterX(1)
        defaultBFY = getCharacterY(0)
        defaultMattY = getCharacterY(1)
        if value1 == 'VoiidArena-Edgelord' then 
            trace(value1)
            pushLimit = 80
            disablePush = true
        elseif value1 == 'Arena-Voiid' or value1 == 'Edgelord-Intro' then 
            trace(value1)
            pushLimit = 50
        end
    end

    if string.lower(name) == "change block state" then
        if value1 == state then 
            return
        end
        transOutState() --shitty state machine
        resetState()
        startState(value1)
        
    elseif string.lower(name) == 'toggle matt echo trail' then 
        doMattEchoTrail = not doMattEchoTrail
    elseif string.lower(name) == 'toggle bf echo trail' then 
        doBFEchoTrail = not doBFEchoTrail
    elseif string.lower(name) == 'change character' then 
        --[[if songLower == 'tko' then 
            if string.lower(value1) == 'bf' then 
                tweenActorProperty('boyfriend', 'x', bfX, 0.01, 'cubeOut')
            else 
                tweenActorProperty('dad', 'x', dad0X, 0.01, 'cubeOut')
            end
            
        end]]--
        --fix for shields
        --setCharacterShouldDance('dadCharacter4', false)
        --setCharacterShouldDance('bfCharacter4', false)
    elseif string.lower(name) == 'change stage' then 



        if songLower == 'revenge' then 
            canBlockInThisSong = true
            setProperty('', 'centerCamera', true)
            if curStage == 'VoiidBoxingRingFar' then 
                canBlockInThisSong = false
                setProperty('', 'centerCamera', false)
            end
        elseif songLower == 'tko' then
            if doingPowerup then 
                defaultRTXSatinCol = getActorRTXColor('dadCharacter0', 'satinColor')
                tweenActorRTXColor('dadCharacter0', 'satinColor', '0xB29B42C8', (crochet/1000)*16, 'cubeOut')
            end

            --trace('yahosdljhasdshjal')
            --forceupdateCharPos = true
            --forceupdateCharPosTime = 2 --stupid character offset bullshit with stage change
            --setActorX(defaultMattX+(pushDist*5)+290, 'dad')
            --setActorX(defaultMattX+(pushDist*5)+290, 'dadCharacter1')
            
            --tweenActorProperty('dadCharacter0', 'x', dad0X, 0.01, 'cubeOut')
            --tweenActorProperty('dadCharacter1', 'x', dad1X, 0.01, 'cubeOut')
            --tweenActorProperty('boyfriend', 'x', bfX, 0.01, 'cubeOut')
            --setActorX(bfX, 'boyfriend')
            --setActorX(dad1X, 'dadCharacter1')
            --setActorX(dad0X, 'dadCharacter0')

            --startPlayer2 = 'TKOMattDark'
            
        end
    end
end




function transOutState()
    if state == 'shield' then 

        --local currentMattPos = getActorX('dadCharacter0')        
        --triggerEvent('change character', 'dad', startPlayer2)
        --setActorX(currentMattPos, 'dadCharacter0')

        setCharacterExtraSuffix("dad", "")
        

        tweenActorProperty('dad', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
        tweenActorProperty('mattShield', 'alpha', 0, crochet*0.001*4, 'cubeOut')
        tweenActorProperty('boyfriend', 'x', getBFX(), crochet*0.001*4, 'cubeOut')
    elseif state == 'bfshield' then 

        --local currentBFPos = getActorX('bfCharacter0')        
        --triggerEvent('change character', 'boyfriend', startPlayer1)
        --setActorX(currentBFPos, 'bfCharacter0')

        setCharacterExtraSuffix("boyfriend", "")

        tweenActorProperty('boyfriend', 'x', getBFX(), crochet*0.001*4, 'cubeOut')
        tweenActorProperty('bfShield', 'alpha', 0, crochet*0.001*4, 'cubeOut')
        tweenActorProperty('dad', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
    elseif state == 'doubleshield' then 

        --im stupid i dont even need this
        --[[local currentMattPos = getActorX('dadCharacter0')
        local currentMattShieldPos = getActorX('dadCharacter4')
        
        triggerEvent('change character', 'dad', startPlayer2)
        setActorX(currentMattPos, 'dadCharacter0')
        setActorX(currentMattShieldPos, 'dadCharacter4')
        setActorAlpha(1, 'dadCharacter4')

        local currentBFPos = getActorX('bfCharacter0')
        local currentBFShieldPos = getActorX('bfCharacter4')
        
        triggerEvent('change character', 'boyfriend', startPlayer1)
        setActorX(currentBFPos, 'bfCharacter0')
        setActorX(currentBFShieldPos, 'bfCharacter4')
        setActorAlpha(1, 'bfCharacter4')]]--

        --setCharacterExtraSuffix("dad", "")
        --setCharacterExtraSuffix("boyfriend", "")

        tweenActorProperty('boyfriend', 'x',  getBFX(), crochet*0.001*8, 'cubeOut')
        tweenActorProperty('bfShield', 'alpha', 0, crochet*0.001*8, 'cubeOut')
        tweenActorProperty('mattShield', 'alpha', 0, crochet*0.001*8, 'cubeOut')
        tweenActorProperty('dad', 'x',  getMattX(), crochet*0.001*8, 'cubeOut')
    elseif state == 'duet' then 
        tweenActorProperty('dad', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
        tweenActorProperty('boyfriend', 'x', getBFX(), crochet*0.001*4, 'cubeOut')
    elseif state == 'duet-tko' or state == 'tko-closeup' then 
        tweenActorProperty('dad', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
        tweenActorProperty('boyfriend', 'x', getBFX(), crochet*0.001*4, 'cubeOut')
    elseif state == 'echoInFront' or state == 'echoInFront-tko' then 
       -- triggerEvent('change character', 'dad', startPlayer2)
       -- flashCamera('game', '#FFFFFF', crochet*0.001*4, true)
        --tweenActorProperty('dad', 'x', getOriginalCharX(1)+(pushDist*5), crochet*0.001*4, 'cubeOut')
    elseif state == 'tko-powerup' then 
        --local currentMattPos = getActorX('dad')
        setCharacterPlayFullAnim('dadCharacter0', false)
        tweenActorProperty('dadCharacter0', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
        --tweenActorProperty('dadCharacter0', 'alpha', 0, crochet*0.001*8, 'cubeIn')
        playCharacterAnimation('dadCharacter0', 'destrans', true)
        tweenActorProperty('aura', 'alpha', 0, crochet*0.001*8, 'cubeOut')

        doingPowerup = false
		tweenActorProperty('dadCharacter0', 'y', getMattY(), (crochet/1000)*8, 'sineOut')

        tweenActorRTXColor('dadCharacter0', 'satinColor', defaultRTXSatinCol, (crochet/1000)*16, 'cubeOut')

    elseif state == 'duet parry' then
        setCharacterSingPrefix('dad', 'sing')
    end
end

function resetState()
    doSplahes = false
    doDadSplashes = false
    disableRanged = true
    disablePush = true
    playDadParryAnims = false
    disableBlock = true
    disableHealthDrain = false
end

function startState(value1)
    state = value1
    if value1 == 'pushing' then
        disablePush = false
        disableBlock = false
    elseif value1 == 'duet parry' then 
        playDadParryAnims = true
        setCharacterSingPrefix('dad', 'parry')
        disableBlock = false
    elseif value1 == 'no ranged' then --so they dont use it after duet/shield
        disableRanged = true
        disableBlock = false
    elseif value1 == 'duet' then
        doSplahes = true
        disableRanged = true
        disableBlock = true
        tweenActorProperty('dad', 'x', getMattX()-130, crochet*0.001*4, 'cubeIn')
        tweenActorProperty('boyfriend', 'x', getBFX()+130, crochet*0.001*4, 'cubeIn')
    elseif value1 == 'duet-tko' then
        doSplahes = true
        disableRanged = true
        disableBlock = true
        tweenActorProperty('dad', 'x', getMattX()+100, crochet*0.001*4, 'cubeIn')
        tweenActorProperty('boyfriend', 'x', getBFX()-100, crochet*0.001*4, 'cubeIn')
    elseif value1 == 'tko-closeup' then
        disableRanged = true
        disableBlock = false
        tweenActorProperty('dad', 'x', getMattX()+290, crochet*0.001*4, 'cubeIn')
        tweenActorProperty('boyfriend', 'x', getBFX()-290, crochet*0.001*4, 'cubeIn')
    elseif value1 == 'tko-bfmoveright' then
        disableBlock = false
        disableRanged = false
        tweenActorProperty('boyfriend', 'x', getBFX()+200, crochet*0.001*31, 'cubeIn')
    elseif value1 == 'tko-mattmoveleft' then
        disableBlock = false
        disableRanged = false
        tweenActorProperty('dad', 'x', getMattX()-200, crochet*0.001*31, 'cubeIn')
    elseif value1 == 'shield' then 

        --local currentMattPos = getActorX('dadCharacter0')
        --startPlayer2 = player2
        --triggerEvent('change character', 'dad', 'Wiik3MattAndEchoSing')
        --setActorX(currentMattPos, 'dadCharacter0')

        setCharacterExtraSuffix("dad", "-mic")

        --setActorAlpha(0, 'dadCharacter4')

        tweenActorProperty('dad', 'x', getMattX()-450, crochet*0.001*4, 'cubeIn')
        tweenActorProperty('boyfriend', 'x', getBFX()+70, crochet*0.001*4, 'cubeIn')

        tweenActorProperty('mattShield', 'alpha', 1, crochet*0.001*4, 'cubeIn')
        setActorX(defaultMattX+(pushDist*5)+mattShieldOffset, 'mattShield')


        --playDadParryAnims = true
        doSplahes = true
        disableHealthDrain = true
    elseif value1 == 'bfshield' then 

        --local currentBFPos = getActorX('bfCharacter0')
        --startPlayer1 = player1
        --triggerEvent('change character', 'boyfriend', 'Wiik3BFAndEchoSing')
        --setActorX(currentBFPos, 'bfCharacter0')

        setCharacterExtraSuffix("boyfriend", "-mic")

        --setActorAlpha(0, 'bfCharacter4')

        tweenActorProperty('boyfriend', 'x', getBFX()+450, crochet*0.001*4, 'cubeIn')
        tweenActorProperty('dad', 'x', getMattX()-150, crochet*0.001*4, 'cubeIn')

        tweenActorProperty('bfShield', 'alpha', 1, crochet*0.001*4, 'cubeIn')
        setActorX(defaultBFX+(pushDist*5)+bfShieldOffset, 'bfShield')

        
        --tweenActorProperty('dadCharacter4', 'x', , crochet*0.001*8, 'cubeIn')

        doDadSplashes = true
        disableHealthDrain = true
    elseif value1 == 'echoInFront' then
        --disableRanged = true
        --disableBlock = false
        --local currentMattPos = getActorX('dadCharacter0')
        --startPlayer2 = player2
        --triggerEvent('change character', 'dad', 'Wiik3EchoParry')
        --setActorX(currentMattPos, 'dadCharacter1')
        --tweenActorProperty('dadCharacter0', 'x', defaultMattX+(pushDist*5), crochet*0.001*8, 'cubeIn')
        --tweenActorProperty('dadCharacter1', 'x', defaultMattX+(pushDist*5)-450, crochet*0.001*8, 'cubeOut')
        --tweenActorProperty('dad', 'x', getOriginalCharX(1)-450+(pushDist*5), crochet*0.001*8, 'cubeOut')
    elseif value1 == 'echoInFront-tko' then
        --disableRanged = true
        --disableBlock = false
        --local currentMattPos = getActorX('dad')
        --startPlayer2 = player2
        --triggerEvent('change character', 'dad', 'Wiik3EchoParry')
        --setActorX(currentMattPos, 'dad')
        --tweenActorProperty('dad', 'x', defaultMattX+(pushDist*5)+290, crochet*0.001*8, 'cubeIn')
        --tweenActorProperty('dadCharacter1', 'x', defaultMattX+(pushDist*5)+290-450, crochet*0.001*8, 'cubeOut')
        --tweenActorProperty('boyfriend', 'x', defaultBFX+(pushDist*5)-290, crochet*0.001*4, 'cubeIn')
        --tweenActorProperty('dad', 'x', getOriginalCharX(1)-450+(pushDist*5), crochet*0.001*8, 'cubeOut')
    elseif value1 == 'doubleshield' then 

        --[[local currentMattPos = getActorX('dadCharacter0')
        startPlayer2 = player2
        triggerEvent('change character', 'dad', 'Wiik3MattAndEchoSing')
        setActorX(currentMattPos, 'dadCharacter0')

        local currentBFPos = getActorX('bfCharacter0')
        startPlayer1 = player1
        triggerEvent('change character', 'boyfriend', 'Wiik3BFAndEchoSing')
        setActorX(currentBFPos, 'bfCharacter0')]]--

        --setActorAlpha(0, 'bfCharacter4')
        --setActorAlpha(0, 'dadCharacter4')

        --setCharacterExtraSuffix("dad", "-mic")
        --setCharacterExtraSuffix("boyfriend", "-mic")

        tweenActorProperty('dad', 'x', getMattX()-450, crochet*0.001*8, 'cubeIn')
        tweenActorProperty('boyfriend', 'x', getBFX()+450, crochet*0.001*8, 'cubeIn')
        
        tweenActorProperty('bfShield', 'alpha', 1, crochet*0.001*4, 'cubeIn')
        setActorX(defaultMattX+(pushDist*5)+mattShieldOffset, 'bfShield')
        tweenActorProperty('mattShield', 'alpha', 1, crochet*0.001*4, 'cubeIn')
        setActorX(defaultBFX+(pushDist*5)+bfShieldOffset, 'mattShield')

        doSplahes = true
        doDadSplashes = true
        disableHealthDrain = true
    elseif value1 == 'resetpush' then
        pushDist = 0
        tweenActorProperty('dad', 'x', getMattX(), crochet*0.001*4, 'cubeOut')
        tweenActorProperty('boyfriend', 'x', getBFX(), crochet*0.001*4, 'cubeOut')
        disableRanged = false
        disableBlock = false
    elseif value1 == 'disable' then 
        canBlockInThisSong = false
    elseif value1 == 'enable' then 
        canBlockInThisSong = true
    elseif value1 == 'tko-powerup' then 
        disableRanged = true
        disableBlock = true
        disableBFBlock = true

        --[[
        local currentMattPos = getActorX('dad')
        local currentBFPos = getActorX('boyfriend')
        startPlayer2 = player2
        dad0X = currentMattPos+200
        dad1X = currentMattPos+200-400
        bfX = currentBFPos+200
        triggerEvent('change character', 'dad', 'TKOPowerupWithEcho')
        setActorX(currentMattPos, 'dad')
        setActorX(currentBFPos, 'boyfriend')
        --]]



		playCharacterAnimation('dadCharacter0', 'trans', true)
        setCharacterPlayFullAnim('dadCharacter0', true)
        tweenActorProperty('dadCharacter0', 'x', getMattX()+290-40, crochet*0.001*8, 'cubeIn')
        tweenActorProperty('bfCharacter0', 'x', getBFX()-290, crochet*0.001*8, 'cubeIn')

        tweenActorProperty('mattShield', 'alpha', 1, crochet*0.001*16, 'cubeIn')
        setActorX(defaultBFX+(pushDist*5)+mattShieldOffset-450, 'mattShield')

        doingPowerup = true
        floatTime = 0
        if not getActorProperty('dadCharacter0', 'hasPowerup') then 
			tweenActorProperty('dadCharacter0', 'y', getMattY() - 150, (crochet/1000)*16, 'cubeIn')
		end

        --0xB29B42C8 
        auraFadeTime = crochet*0.001*16
        auraFaded = false

    elseif state == 'tko-powerupEnd' then 
        disableBFBlock = false
        disableRanged = true
        disableBlock = false
        local currentMattPos = getActorX('dadCharacter1')
        local currentBFPos = getActorX('boyfriend')
        --triggerEvent('change character', 'dad', startPlayer2)
        tweenActorProperty('dadCharacter0', 'x', getMattX()+290, crochet*0.001*8, 'cubeIn')
        tweenActorProperty('bfCharacter0', 'x', getBFX()-290, crochet*0.001*8, 'cubeIn')
        tweenActorProperty('mattShield', 'alpha', 0, crochet*0.001*8, 'cubeOut')
        --tweenActorProperty('boyfriend', 'x', defaultBFX+(pushDist*5), crochet*0.001*4, 'cubeOut')
    else 
        disableRanged = false
        disableBlock = false
    end
end

function beatHit(spr)
    if canBlockInThisSong then 
        for i = 0,trailLimit do --pool of 150 trails, check for cleanup
            if getActorHeight('trail'..i) ~= 0 then 
                if getActorAlpha('trail'..i) == 0 then 
                    --trace('cleaned up trail '..i)
                    destroySprite('trail'..i)
                end
            end
        end
    end

end



function doHealthDrain()
    if getHealth() - 0.008 > 0.09 then
        setHealth(getHealth() - 0.008)
    else
        setHealth(0.035)
    end
end