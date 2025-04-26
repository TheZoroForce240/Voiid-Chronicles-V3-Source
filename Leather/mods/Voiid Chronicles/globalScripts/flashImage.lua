local imageCount = 0
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function onEvent(name, position, value1, value2)
    if string.lower(name) == "flashimage" then
        --trace('asdhjalsdlj')
        makeSprite('image'..imageCount, value1, 0, 0, 1)
        setObjectCamera('image'..imageCount, 'hud')
        actorScreenCenter('image'..imageCount)
        tweenFadeCubeInOut('image'..imageCount, 0, tonumber(value2))
        setActorScroll(0, 0, 'image'..imageCount)
        imageCount = imageCount + 1
    elseif string.lower(name) == "uno" then
        local name = 'uno'
        if value1 == '1' then 
            name = name..'-god'
        end
        triggerEvent('flashimage', name, crochet/250)
    elseif string.lower(name) == "dos" then
                local name = 'dos'
        if value1 == '1' then 
            name = name..'-god'
        end
        triggerEvent('flashimage', name, crochet/250)
    elseif string.lower(name) == "tres" then
                local name = 'tres'
        if value1 == '1' then 
            name = name..'-god'
        end
        triggerEvent('flashimage', name, crochet/250)
    elseif string.lower(name) == "cuatro" then
                local name = 'cuatro'
        if value1 == '1' then 
            name = name..'-god'
        end
        triggerEvent('flashimage', name, crochet/250)
    elseif string.lower(name) == "gato" then
        triggerEvent('flashimage', 'que opinas de este gato', crochet/250)

    elseif string.lower(name) == "3" then
        triggerEvent('flashimage', 'ui skins/default/countdown/3????', crochet/250)
    elseif string.lower(name) == "2" then
        triggerEvent('flashimage', 'ui skins/default/countdown/ready', crochet/250)
        setActorY(getActorY('image'..(imageCount-1))+100, 'image'..(imageCount-1))
        --tweenActorProperty('image'..(imageCount-1), 'y', getActorY('image'..(imageCount-1))+100, crochet/250, 'cubeInOut')
        setObjectCamera('image'..(imageCount-1), 'game')
        actorScreenCenter('image'..(imageCount-1))
    elseif string.lower(name) == "1" then
        triggerEvent('flashimage', 'ui skins/default/countdown/set', crochet/250)
        setActorY(getActorY('image'..(imageCount-1))+100, 'image'..(imageCount-1))
        --tweenActorProperty('image'..(imageCount-1), 'y', , crochet/250, 'cubeInOut')
        setObjectCamera('image'..(imageCount-1), 'game')
        actorScreenCenter('image'..(imageCount-1))
    elseif string.lower(name) == "go" then
        triggerEvent('flashimage', 'ui skins/default/countdown/go', crochet/250)
        setActorY(getActorY('image'..(imageCount-1))+100, 'image'..(imageCount-1))
        --tweenActorProperty('image'..(imageCount-1), 'y', getActorY('image'..(imageCount-1))+100, crochet/250, 'cubeInOut')
        setObjectCamera('image'..(imageCount-1), 'game')
        actorScreenCenter('image'..(imageCount-1))

    elseif string.lower(name) == "imagemovex" then 

        destroySprite(value1)
        makeSprite(value1, value1, 0, 0, 1)
        setObjectCamera(value1, 'hud')
        actorScreenCenter(value1)

        local data = split(value2, ",")

        local start = data[1]
        local offset = data[2]
        local steps = data[3]
        local ease = data[4]

        local finalPos = getActorX(value1)+offset
        setActorX(getActorX(value1)+start, value1) --set to start
        tweenActorProperty(value1, 'x', finalPos, crochet*0.001*steps, ease)

    elseif string.lower(name) == "imagemovey" then 
        destroySprite(value1)
        makeSprite(value1, value1, 0, 0, 1)
        setObjectCamera(value1, 'hud')
        actorScreenCenter(value1)

        local data = split(value2, ",")

        local start = data[1]
        local offset = data[2]
        local steps = data[3]
        local ease = data[4]

        local finalPos = getActorY(value1)+offset
        setActorY(getActorY(value1)+start, value1) --set to start
        tweenActorProperty(value1, 'y', finalPos, crochet*0.001*steps, ease)
    elseif string.lower(name) == "doubleimagemove" then 
        --trace('hi')
        if value1 ~= '' then 
            local i1 = split(value1, ',')
            if i1[2] == 'x' then 
                triggerEvent('imagemovex', i1[1], i1[3]..','..i1[4]..','..i1[5]..','..i1[6])
            else 
                triggerEvent('imagemovey', i1[1], i1[3]..','..i1[4]..','..i1[5]..','..i1[6])
            end
        end

        if value2 ~= '' then 
            local i2 = split(value2, ',')
            if i2[2] == 'x' then 
                triggerEvent('imagemovex', i2[1], i2[3]..','..i2[4]..','..i2[5]..','..i2[6])
            else 
                triggerEvent('imagemovey', i2[1], i2[3]..','..i2[4]..','..i2[5]..','..i2[6])
            end
        end
    end
end