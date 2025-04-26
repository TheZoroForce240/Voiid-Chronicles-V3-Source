
local fade = 1
local targetFade = 0
function createPost()

    if mobile then 
        return
    end

    --initShader('colorFill', 'ColorFillEffect')
    --setActorShader('dad', 'colorFill')
    --setActorShader('boyfriend', 'colorFill')
    --setActorShader('girlfriend', 'colorFill')

    --setShaderProperty('colorFill', 'fade', 1)

    --makeSprite('colorBG', '', 0,0)
    --makeGraphicRGB('colorBG', 1500/getCamZoom(),1000/getCamZoom(), '0,0,0')
    --actorScreenCenter('colorBG')
    --setActorScroll(0,0,'colorBG')
    --setActorLayer('colorBG', 0)

    makeSprite('colorBG', '', 0,0)
    makeGraphicRGB('colorBG', 3000/getCamZoom(),3000/getCamZoom(), '255,255,255')
    actorScreenCenter('colorBG')
    setActorScroll(0,0,'colorBG')
    setActorAlpha(0, 'colorBG')
    setActorLayer('colorBG', getActorLayer('girlfriend'))
end
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local enabled = false
function onEvent(name, position, value1, value2)

    if mobile then 
        return
    end
    if string.lower(name) == "colorfill" then
        
        enabled = not enabled
        local charCol = split(value1, ",")
        --local str = easeStuff[2]
        --trace(charCol)
        local easeStuff = split(value2, ",")
        if enabled then 
            --targetFade = 0
            
            setActorColorRGB('colorBG', charCol[4]..','..charCol[5]..','..charCol[6])
            tweenActorProperty('colorBG', 'alpha', 1, tonumber(easeStuff[1]), easeStuff[2])
            
            --use dad object so it does the whole group
            setActorRTXProperty('dadObject', 'CFred', tonumber(charCol[1]))
            setActorRTXProperty('dadObject', 'CFgreen', tonumber(charCol[2]))
            setActorRTXProperty('dadObject', 'CFblue', tonumber(charCol[3]))
            tweenActorRTXProperty('dadObject', 'CFfade', 0, tonumber(easeStuff[1]), easeStuff[2])

            setActorRTXProperty('girlfriend', 'CFred', tonumber(charCol[1]))
            setActorRTXProperty('girlfriend', 'CFgreen', tonumber(charCol[2]))
            setActorRTXProperty('girlfriend', 'CFblue', tonumber(charCol[3]))
            tweenActorRTXProperty('girlfriend', 'CFfade', 0, tonumber(easeStuff[1]), easeStuff[2])

            setActorRTXProperty('boyfriendObject', 'CFred', tonumber(charCol[1]))
            setActorRTXProperty('boyfriendObject', 'CFgreen', tonumber(charCol[2]))
            setActorRTXProperty('boyfriendObject', 'CFblue', tonumber(charCol[3]))
            tweenActorRTXProperty('boyfriendObject', 'CFfade', 0, tonumber(easeStuff[1]), easeStuff[2])


            
        else 
            tweenActorRTXProperty('boyfriendObject', 'CFfade', 1, tonumber(easeStuff[1]), easeStuff[2])
            tweenActorRTXProperty('girlfriend', 'CFfade', 1, tonumber(easeStuff[1]), easeStuff[2])
            tweenActorRTXProperty('dadObject', 'CFfade', 1, tonumber(easeStuff[1]), easeStuff[2])
            tweenActorProperty('colorBG', 'alpha', 0, tonumber(easeStuff[1]), easeStuff[2])
            --targetFade = 1
        end
    end
end