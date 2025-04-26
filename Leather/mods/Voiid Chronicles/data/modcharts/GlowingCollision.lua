function start(song)
    tweenFadeIn('bfCharacter2',0,0.001)
    tweenFadeIn('bfCharacter3',0,0.001)
end

function stepHit(curStep)
    if curStep == 832 or curStep == 2368 then
        tweenFadeIn('bfCharacter3',0.5,0.1)
    elseif curStep == 896 or curStep == 2432 then
        tweenFadeIn('bfCharacter3',0,0.1)
    elseif curStep == 960 or curStep == 2496 then
        tweenFadeIn('bfCharacter2',0.5,0.1)
    elseif curStep == 1024 or curStep == 2560 then
        tweenFadeIn('bfCharacter2',0,0.1)
    elseif curStep == 1088 or curStep == 1216 or curStep == 2624 or curStep == 2752 then
        tweenFadeIn('bfCharacter2',0.5,0.1)
        tweenFadeIn('bfCharacter3',0.5,0.1)
    elseif curStep == 1152 or curStep == 1280 or curStep == 2688 or curStep == 2816 then
        tweenFadeIn('bfCharacter2',0,0.1)
        tweenFadeIn('bfCharacter3',0,0.1)
    end
end