local blimpPos = 0
local blimpMaxX = 1200
local blimpMinX = 0

local reverse = false

function createPost()
    --if randomBool(50) then 
        blimpPos = randomFloat(800, 1200)
    --else 
       --blimpPos = randomFloat(0, 600)
        --reverse = true
        --setActorProperty('blimp', 'flipX', true) --forgot the text would be flipped lol
    --end
    
end
function update(elapsed)
    if reverse then 
        blimpPos = blimpPos + elapsed*4
    else 
        blimpPos = blimpPos - elapsed*4
    end
    
    setActorProperty('blimp', 'x', blimpPos)
end