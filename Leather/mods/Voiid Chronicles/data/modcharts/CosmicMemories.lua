function createPost()
    setActorAlpha(0, 'dadCharacter1')
end

function beatHit()
	if curBeat == 287 or curBeat == 575 then
		setActorAlpha(0.5, 'dadCharacter1')
	elseif curBeat == 415 or curBeat == 703 then
		setActorAlpha(0, 'dadCharacter1')
	end
end