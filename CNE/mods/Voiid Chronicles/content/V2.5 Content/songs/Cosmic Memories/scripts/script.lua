function createPost()

    initShader('smoke', 'PerlinSmokeEffect')
    setCameraShader('game', 'smoke')
    setShaderProperty('smoke', 'waveStrength', 0.0)
    setShaderProperty('smoke', 'smokeStrength', 0.2)

    initShader('water', 'WaterEffect')
    setCameraShader('game', 'water')
    setCameraShader('hud', 'water')
    setShaderProperty('water', 'speed', 0.1)
    setShaderProperty('water', 'strength', 5.0)


    initShader('wiggle', 'WiggleEffect')
    setCameraShader('game', 'wiggle')
    setCameraShader('hud', 'wiggle')
    setShaderProperty('wiggle', 'waveSpeed', 0.5)
    setShaderProperty('wiggle', 'waveFrequency', 5.0)
    setShaderProperty('wiggle', 'waveAmplitude', 0.05)
    setShaderProperty('wiggle', 'waveFrequency', 0.0)
    setShaderProperty('wiggle', 'waveAmplitude', 0.0)

    initShader('blur', 'BlurEffect')
    setCameraShader('game', 'blur')
    setCameraShader('hud', 'blur')
    setShaderProperty('blur', 'strength', 20)

    initShader('blur2', 'BlurEffect')
    setCameraShader('game', 'blur2')
    setCameraShader('hud', 'blur2')
    setShaderProperty('blur2', 'strengthY', 20)

    initShader('mirror', 'MirrorRepeatWarpEffect')
    setCameraShader('game', 'mirror')
    if modcharts then 
        setCameraShader('hud', 'mirror')
    end
	setShaderProperty('mirror', 'zoom', 1.5)
    setShaderProperty('mirror', 'warp', -0.1)
    setShaderProperty('mirror', 'angle', 180)

    makeSprite('black', '', 0, 0, 1)
    setObjectCamera('black', 'hud')
    makeGraphic('black', 4000, 2000, '0xFF000000')
    actorScreenCenter('black')



    initShader('bloom2', 'BloomEffect')
    setCameraShader('game', 'bloom2')
    setCameraShader('hud', 'bloom2')

    setShaderProperty('bloom2', 'effect', 0.0)
    setShaderProperty('bloom2', 'strength', 0.0)

    initShader('grey', 'GreyscaleEffect')
    setCameraShader('game', 'grey')
    setCameraShader('hud', 'grey')
    setShaderProperty('grey', 'strength', 1.0)

end

function songStart()
    stepHit()

    tweenActorProperty('black', 'alpha', 0, crochet*0.001*16*7, 'cubeInOut')

    tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*16*7, 'cubeOut')
    tweenShaderProperty('blur', 'strength', 0, crochet*0.001*16*7, 'cubeOut')
    tweenShaderProperty('blur2', 'strengthY', 0, crochet*0.001*16*7, 'cubeOut')
    tweenShaderProperty('mirror', 'zoom', 1.05, crochet*0.001*16*7, 'cubeOut')
end
--change whenever stage is updated
local purpHue = 0.2
local orangHue = 0.5
local greenHue = 0.75

function stepHit()
    section = math.floor(curStep/16)
	local secStep = curStep % 16
	local secStep32 = curStep % 32
	local secStep64 = curStep % 32


    if section == 8 and secStep == 0 then 
        bloomBurst(1, 1, 16, 'cubeOut')
        tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
        tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
    end
    

    if secStep == 0 then 
        if section == 16 or section == 28 or section == 32 or section == 36 or section == 44 or section == 52 or section == 56 or section == 60 or section == 76 or section == 92 or section == 112 or section == 124 or section == 128 
             or section == 132 or section == 140 or section == 148 or section == 164 or section == 168 or section == 172 or section == 184 then 
            bloomBurst(1, 1, 16, 'cubeOut')
        elseif section == 23 then 
            tweenShaderProperty('mirror', 'warp', -0.2, crochet*0.001*16, 'cubeIn')
        elseif section == 24 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
        elseif section == 40 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*8, 'cubeOut')
        elseif section == 46 then 
            tweenShaderProperty('mirror', 'warp', -0.2, crochet*0.001*32, 'cubeIn')
        elseif section == 48 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
        elseif section == 64 or section == 136 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('grey', 'strength', 1.0)
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*16*4, 'linear')
        elseif section == 68 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
        elseif section == 71 or section == 143 then 
            setShaderProperty('grey', 'strength', 1.0)
        elseif section == 72 or section == 88 or section == 144 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*8, 'cubeOut')
        elseif section == 152 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            setStageColorSwap('hue', greenHue)
        elseif section == 80 or section == 96 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            setStageColorSwap('hue', purpHue)
        elseif section == 84 or section == 100 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            tweenStageColorSwap('hue', 0, crochet*0.001*64, 'cubeIn')
        elseif section == 156 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            tweenStageColorSwap('hue', orangHue, crochet*0.001*64, 'cubeIn')
        elseif section == 84 or section == 104 or section == 176 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('grey', 'strength', 1.0, crochet*0.001*8, 'cubeOut')
        elseif section == 116 then 
            tweenShaderProperty('grey', 'strength', 0.0, crochet*0.001*64, 'linear')
        elseif section == 120 or section == 160 then 
            bloomBurst(1, 1, 16, 'cubeOut')
            setShaderProperty('mirror', 'warp', -0.1)
            tweenShaderProperty('mirror', 'warp', 0.05, crochet*0.001*8, 'cubeOut')
            setStageColorSwap('hue', orangHue)
        elseif section == 192 then 
            bloomBurst(3, 3, 16, 'cubeInOut')
            tweenActorProperty('black', 'alpha', 1, crochet*0.001*24, 'cubeIn')
        end
    end

    if section == 39 or section == 87 or section == 159 or section == 175 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.2, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
        end
    elseif section == 47 then 
        if secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            setShaderProperty('mirror', 'angle', 0)
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            bumpEnd(2)
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 79 or section == 95 or section == 151 or section == 167 then 
        if secStep == 0 then 
            triggerEvent('screen shake', (crochet*0.001*12)..',0.003', (crochet*0.001*12)..',0.003')
        end
        if secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.5, crochet*0.001*2, 'cubeOut')
            setShaderProperty('mirror', 'angle', 0)
            tweenShaderProperty('mirror', 'angle', 30, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            bumpEnd(2)
            tweenShaderProperty('mirror', 'angle', 0, crochet*0.001*2, 'cubeIn')
        end
    elseif section == 71 or section == 143 then 
        if secStep == 8 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('mirror', 'warp', -0.2, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('mirror', 'warp', 0.0, crochet*0.001*4, 'cubeIn')
            setShaderProperty('mirror', 'angle', 0.0)
            tweenShaderProperty('mirror', 'angle', -360, crochet*0.001*8, 'cubeInOut')
        end
    elseif section == 119 then 

        if secStep == 0 then 
            tweenShaderProperty('mirror', 'zoom', 2.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('blur', 'strength', 10.0, crochet*0.001*8, 'cubeOut')
            tweenShaderProperty('blur2', 'strengthY', 10.0, crochet*0.001*8, 'cubeOut')
        end

        if secStep == 8 then 
            setShaderProperty('mirror', 'angle', 0.0)
            tweenShaderProperty('mirror', 'angle', 360, crochet*0.001*16, 'cubeInOut')
            tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('blur', 'strength', 0.0, crochet*0.001*8, 'cubeIn')
            tweenShaderProperty('blur2', 'strengthY', 0.0, crochet*0.001*8, 'cubeIn')
        end
    end

    if (section >= 8 and section < 64) or (section >= 104 and section < 119) or (section >= 120 and section < 136) or (section >= 176 and section < 192) then 
        if section % 2 == 0 then 
            if secStep == 0 then 
                bumpStart(2)
            elseif secStep == 2 then 
                bumpEnd(2)
            end
        else 
            if secStep == 4 then 
                bumpStart(2)
            elseif secStep == 6 then 
                bumpEnd(2)
            end
        end
    end

    if( section >= 64 and section < 68) or section == 86 or section == 102 or ( section >= 136 and section < 140) or section == 158 or section == 174 then 
        if secStep % 8 == 0 then 
            bumpStart(2)
        elseif secStep % 8 == 2 then 
            bumpEnd(2)
        end
    end
    if (section >= 68 and section < 70) or (section == 87 and secStep < 8) or (section == 103 and secStep < 8) or (section >= 140 and section < 142)  or (section == 159 and secStep < 8) or (section == 175) then 
        if secStep % 4 == 0 then 
            bumpStart(2)
        elseif secStep % 4 == 2 then 
            bumpEnd(2)
        end
    elseif (section == 70) or (section == 87 and secStep >= 8) or (section == 103 and secStep >= 8) or section == 142 or (section == 159 and secStep >= 8) then 
        if secStep % 2 == 0 then 
            bumpStart(1)
        elseif secStep % 2 == 1 then 
            bumpEnd(1)
        end
    end

    if (section >= 72 and section < 86) or (section >= 88 and section < 102) or (section >= 144 and section < 158) or (section >= 160 and section < 174) then 

        if secStep == 0 then 
            bumpStart(2)
        elseif secStep == 2 then 
            bumpEnd(2)
        end

        local stepList = {10, 22, 26, 42, 54, 70, 86, 106}
        local stepListShort = {30, 58, 62, 94, 122, 126}
        local step128 = curStep % 128
        for i = 1, #stepList do 
            if step128 == stepList[i] then 
                bumpStart(2)
            elseif step128 == stepList[i] + 2 then 
                bumpEnd(2)
            end
        end
        for i = 1, #stepListShort do 
            if step128 == stepListShort[i] then 
                bumpStart(1)
            elseif step128 == stepListShort[i] + 1 then 
                bumpEnd(1)
            end
        end
        
    end


    if section == 26 or section == 30 or section == 42 or section == 46 or section == 104 or section == 106 or section == 112 or section == 114 or section == 176 or section == 178 or section == 184 or section == 186 then 
        if secStep == 8 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 6.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.05, crochet*0.001*4, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.0, crochet*0.001*4, 'cubeIn')
        end
    end
    if section == 41 or section == 45 then 
        if secStep == 0 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 6.0, crochet*0.001*4, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.05, crochet*0.001*4, 'cubeOut')
        elseif secStep == 4 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 0.0, crochet*0.001*4, 'cubeIn')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.0, crochet*0.001*4, 'cubeIn')
        end
    end

    if section == 107 or section == 115 or section == 179 or section == 187 then 
        if secStep == 12 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 4.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.05, crochet*0.001*2, 'cubeOut')
        elseif secStep == 14 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 0.0, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.0, crochet*0.001*2, 'cubeIn')
        end
    end

    if section == 109 or section == 117 or section == 181 or section == 189 then 
        if secStep == 0 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 3.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.05, crochet*0.001*2, 'cubeOut')
        elseif secStep == 8 then 
            tweenShaderProperty('wiggle', 'waveFrequency', -3.0, crochet*0.001*2, 'cubeOut')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.05, crochet*0.001*2, 'cubeOut')
        elseif secStep == 12 then 
            tweenShaderProperty('wiggle', 'waveFrequency', 0.0, crochet*0.001*2, 'cubeIn')
            tweenShaderProperty('wiggle', 'waveAmplitude', 0.0, crochet*0.001*2, 'cubeIn')
        end
    end
end

function bumpStart(s)
    tweenShaderProperty('mirror', 'zoom', 0.9, crochet*0.001*s, 'cubeOut')
    if section >= 120 then 
        tweenShaderProperty('blur', 'strength', 2, crochet*0.001*s, 'cubeOut')
        tweenShaderProperty('blur2', 'strengthY', 2, crochet*0.001*s, 'cubeOut')
    end
end
function bumpEnd(s)
    tweenShaderProperty('mirror', 'zoom', 1.0, crochet*0.001*s, 'cubeIn')
    if section >= 120 then 
        tweenShaderProperty('blur', 'strength', 0, crochet*0.001*s, 'cubeIn')
        tweenShaderProperty('blur2', 'strengthY', 0, crochet*0.001*s, 'cubeIn')
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
    tweenShaderProperty('bloom2', 'effect', 0.0, crochet*0.001*t, ease)
    tweenShaderProperty('bloom2', 'strength', 0.0, crochet*0.001*t, ease)
end