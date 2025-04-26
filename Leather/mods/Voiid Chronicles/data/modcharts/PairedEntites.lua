function start(song)
    tweenFadeIn('bfCharacter2',0,0.001)
    tweenFadeIn('bfCharacter3',0,0.001)
end

function stepHit(curStep)
    if curStep == 576 or curStep == 1728 then
        tweenFadeIn('bfCharacter2',0.5,0.1)
    elseif curStep == 640 or curStep == 1792 then
        tweenFadeIn('bfCharacter2',0,0.1)
    elseif curStep == 704 or curStep == 1856 then
        tweenFadeIn('bfCharacter3',0.5,0.1)
    elseif curStep == 768 or curStep == 1920 then
        tweenFadeIn('bfCharacter3',0,0.1)
    elseif curStep == 832 or curStep == 960 or curStep == 1984 or curStep == 2112 then
        tweenFadeIn('bfCharacter2',0.5,0.1)
        tweenFadeIn('bfCharacter3',0.5,0.1)
    elseif curStep == 896 or curStep == 1024 or curStep == 2048 or curStep == 2176 then
        tweenFadeIn('bfCharacter2',0,0.1)
        tweenFadeIn('bfCharacter3',0,0.1)
    end
end