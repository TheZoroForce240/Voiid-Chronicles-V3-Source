function createPost()
    initShader('heat', 'HeatEffect')
    setCameraShader('game', 'heat')
    setCameraShader('hud', 'heat')

    initShader('sparks', 'SparkEffect')
    setCameraShader('hud', 'sparks')
    updateSparks()
end
function onEvent(name, position, value1, value2)
    if string.lower(name) == "change stage" then
        updateSparks()
    end
end
local warp = -400
function updateSparks()
    if curStage == 'GreedVolcano' then 
        setShaderProperty('sparks', 'red', 0.57)
        setShaderProperty('sparks', 'green', 1.0)
        setShaderProperty('sparks', 'blue', 0.66)
        warp = -500
    elseif curStage == 'IgnisGladius' or curStage == 'OGVolcano' then 
        setShaderProperty('sparks', 'red', 1.0)
        setShaderProperty('sparks', 'green', 0.4)
        setShaderProperty('sparks', 'blue', 0.1)
        warp = -450
    else 
        setShaderProperty('sparks', 'red', 0.8)
        setShaderProperty('sparks', 'green', 0.26)
        setShaderProperty('sparks', 'blue', 1.0)
        warp = -400
    end

    setShaderProperty('sparks', 'warp', warp)

end

function update(elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    setShaderProperty('heat', 'strength', 0.5 + math.sin(currentBeat)*0.25)
end