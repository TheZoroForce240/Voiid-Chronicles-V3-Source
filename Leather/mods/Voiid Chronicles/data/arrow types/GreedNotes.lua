
local doChrom = true
function create()
	if doChrom then 
		triggerEvent('ca burst', '0', '') --make sure its loaded
	end
end
function createPost()
	local noteCount = getUnspawnNotes()
    for i = 0,noteCount-1 do 
        local nt = getUnspawnedNoteNoteType(i)
		if nt == 'GreedNotes' then 
			setUnspawnedNoteSingAnimPrefix(i, 'dodge')
		end
    end
end

function playerOneSing(data, time, noteType) --the
	
	
	if noteType == 'GreedNotes' then
		if doChrom then 
			triggerEvent('ca burst', '0.01', '0.01')
		end
	end
end
function playerOneMiss(data, time, noteType, isSus)
	if noteType == 'GreedNotes' then
		stun()
	end
end
local stunTime = 0
function stun()
	if stunTime <= 0 then --dont restun
		--trace('stunned')
		stunTime = 3
		runHaxeCode([[
			Note.stunned = true;
			for (i in 0...PlayState.playerStrums.members.length)
			{
				PlayState.playerStrums.members[i].color = 0xFF666666;
			}
		]])
	end
end
function unStun()
	--trace('unstun')
	runHaxeCode([[
		Note.stunned = false;
		for (i in 0...PlayState.playerStrums.members.length)
		{
			PlayState.playerStrums.members[i].color = 0xFFFFFFFF;
		}
	]])
end
function updatePost(elapsed)
	if stunTime > 0 then 
		stunTime = stunTime - elapsed
		if stunTime <= 0 then 
			unStun()
		end
	end
end