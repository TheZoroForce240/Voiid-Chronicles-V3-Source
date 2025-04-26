local songTable = {
    --song, composer, charter, og song composer, popuptime, textsize

    --Tutorial
    {"Warm Up", "NunsStop", "Xyriax", "RozeBud"},

    --Wiik 1
    {"Light It Up", "ImPaper", "RhysRJJ", "TheOnlyVolume", 6620},
    {"Ruckus", "Singular and Lord Voiid", "Xyriax", "TheOnlyVolume", 8170},
    {"Target Practice", "Lord Voiid", "Wolfinu", "TheOnlyVolume"},
    
    --Wiik 2
    {"Burnout", "Lord Voiid", "RhysRJJ (Voiid), bruvDiego (7K)", ""},
    {"Sporting", "Invalid", "Xyriax", "Biddle3"},
    {"Boxing Match", "Lord Voiid", "Official_YS", "TheOnlyVolume", 11330},

    --Matt With Hair
    {"Flaming Glove", "ImPaper", "Wolfinu (Voiid), RhysRJJ (7K)", ""},
    {"Punch and Gun", "Mineformer, DeltaMoai", "RhysRJJ (Voiid, 7K)", "MLOM"},
    {"Venom", "Lord Voiid", "RhysRJJ (Voiid, 7K)", "k-net"},

    --Wiik 3
    {"Fisticuffs", "Lord Voiid", "RhysRJJ", "HamillUn"},
    {"Blastout", "Revilo", "RhysRJJ", ""},
    {"Immortal", "Hippo0824 and Lord Voiid", "RhysRJJ", ""},
    {"King Hit", "Lord Voiid", "RhysRJJ", "TheOnlyVolume"},
    {"King Hit Wawa", "Lord Voiid", "Official_YS", "TheOnlyVolume"},
    {"TKO", "Lord Voiid and Invalid", "RhysRJJ (Voiid), Wolfinu (7K)", "HamillUn and Shteque"},

    --Wiik 4
    {"Disadvantage", "Lord Voiid", "Ushear & RhysRJJ", "Revilo"},
    {"Champion", "Lord Voiid (Voices), NobodyKnows (Inst)", "RhysRJJ", "Box of Rocks"},
    {"Last Combat", "Lord Voiid and NobodyKnows", "RhysRJJ", "BoxOfRocks"},
    {"Purgatory", "Lord Voiid and NobodyKnows", "Wolfinu", "BoxOfRocks"},
    {"Krakatoa", "NobodyKnows", "bruvDiego", ""},
    {"Sweet Dreams", "Lord Voiid, ImPaper, FZ Green, Lightor, Revilo, Spurk, NobodyKnows, Tomz_, Antarkh, MLOM", "RhysRJJ (4K/10K), Official_YS (7K)", "", 0, 16},

    --Greed Wiik
    {"Greedoom", "Lord Voiid and NobodyKnows", "RhysRJJ", ""},
    {"Purgatory", "Lord Voiid and NobodyKnows", "Wolfinu", "BoxOfRocks"},
    {"Krakatoa", "NobodyKnows", "bruvDiego", ""},

    --Cval Wiik 4
    {"Showdown", "Revilo", "RhysRJJ", "fluffyhairs music and Foodieti"},
    {"Take It", "NobodyKnows", "RhysRJJ", ""},

    --Wiik 100
    {"Mat", "Joa (Inst) and Hippo0824 (Voices)", "needs rechart (Voiid), RhysRJJ (7K)", "st4rcannon"},
    {"Banger", "Lord Voiid", "bruvDiego (Voiid), MLOM (7K)", "st4rcannon"},
    {"Edgy", "Lord Voiid (Voices) and MLOM (Inst)", "RhysRJJ", "st4rcannon", 18460},

    --Extras
    {"Recovery", "Lord Voiid and Joa", "RhysRJJ", ""},
    {"Rejected", "Lord Voiid", "Official_YS", "CrazyCake", 11320},
    {"Mattpurgation", "Invalid and DeltaMoai", "Xyriax", "JADS", 4000},
    {"Fishycuffs", "Lord Voiid", "Official_YS", "HamillUn"},
    {"Alter Ego", "Lord Voiid and Revilo", "RhysRJJ", ""},
    {"1CORE KILLER", "Lord Voiid", "RhysRJJ", "Lyfer MuSICK"},
    {"Bombastic", "Lord Voiid", "RhysRJJ", "Oofator"},
    {"Edgelord", "Lord Voiid and Joa", "bruvDiego, RhysRJJ, Official_YS", "Joa"},
    {"Ballin", "Lord Voiid, MLOM, and Revilo", "Official_YS", "AngryRacc"},
    {"Interregnum", "ImPaper (Inst, Voices) and Lord Voiid (Voices)", "RhysRJJ", "Tomz_ and Singular"},
    {"Ignis Gladius", "LegendaryPlz and Spring", "needs rechart (Hard), Ushear and Official_YS (Broke)", "CrazyCake"},
    {"Wii Remote", "VoiidicMelody (Voices)", "RhysRJJ", "JPR"},
    {"Average Voiid Song", "Fallnnn", "Xyriax", ""},

    --VIP Remixes
    {"TKO VIP", "Lord Voiid, NobodyKnows (Voices) and AngryRacc (Inst)", "RhysRJJ", "HamillUn and Shteque", 20480, 20},
    {"Alter Ego VIP", "Lord Voiid, ImPaper (Voices) and NobodyKnows (Inst)", "RhysRJJ", "Lord Voiid and Revilo", 0, 22},
    {"Burnout VIP", "Janemusic, Joa, Invalid, Revilo, and Lord Voiid", "RhysRJJ", "Lord Voiid"},
    {"Rejected VIP", "Lord Voiid, NobodyKnows, Revilo, ImPaper, and Invalid", "RhysRJJ, Wolfinu, and DiegoBruv", "CrazyCake"},

    --Shaggy X Matt
    {"Revenge", "Lord Voiid and Invalid", "Wolfinu (Mania), Offcial_YS (6K)", "TheOnlyVolume", 3000},
    {"Final Destination", "Lord Voiid", "RhysRJJ (Canon, God, God Mania), Wolfinu (Mania)", "srPerez", 6400},
    {"Final Destination Old", "Lord Voiid", "Medo and MarkC645 (Canon, God, God Mania), TheZoroForce240 and RhysRJJ (Mania)", "srPerez", 0, 19},

    --Antarkh X Voiid
    {"Glowing Collision", "Antarkh (Inst, Voices) and Lord Voiid (Voices)", "Official_YS (Mania), RhysRJJ (Canon)", ""},
    {"Paired Entities", "Antarkh (Voices) and Lord Voiid (Inst, Voices)", "RhysRJJ (Canon)", ""},
    {"Multiversal Slash", "Antarkh (Inst, Voices) and Lord Voiid (Voices)", "bruvDiego (Mania), RhysRJJ (Canon), TheZoroForce240 (Easy)", "", 0, 22},

    --Galactic Showdown
    {"Cosmic Memories", "Lord Voiid", "RhysRJJ (Mania, Canon)", ""},
    {"New Horizon", "SmokeCannon", "RhysRJJ (Mania, Canon)", ""},
    {"Galactic Storm", "Lord Voiid (Voices), and NobodyKnows (Inst, Voices)", "RhysRJJ (Mania, Canon), TheZoroForce240 (Easy)", "", 0, 20},

    --2k Specials
    {"Cleverness", "Lord Voiid", "Ushear", ""},
    {"Tempo Slayer", "Lord Voiid", "RhysRJJ", ""},
    {"Total Bravery", "Lord Voiid", "Ushear", ""},

    --Collabs
    {"Defamation Of Reality", "AngryRacc and Lord Voiid", "RhysRJJ", ""},
    {"Radical Showdown", "Singular and Lord Voiid", "RhysRJJ (Canon), Official_YS (Mania)", ""},

    --Agoti
    {"Exodus", "Lord Voiid", "needs rechart", ""},

    --Tricky
    {"Wastelands", "Lord Voiid", "Wolfinu", ""},
    {"Toxic", "Invalid", "RhysRJJ", ""},
    
}
local song = {"Song Not Found", "", "", ""}
function createPost()
    for i = 1,#songTable do 
        if songLower == string.lower(songTable[i][1]) then 
            song = songTable[i]
            --trace(song)
        end
    end

    local songFont = "dumbnerd.ttf"
    if song[1] == "1CORE KILLER" then 
        songFont = "Contb___.ttf"
    elseif song[1] == "Flaming Glove 2" then 
        song[1] = "Flaming Glove ii"
    end

    makeSprite('songBG', 'songPopupThingy')
    setActorScroll(0,0,'songBG')
    setObjectCamera('songBG', 'hud')
    actorScreenCenter('songBG')
    makeText("songText", song[1], 0, 0, 128)
    setActorFont("songText", songFont)
    setActorScroll(0,0,'songText')
    setObjectCamera('songText', 'hud')
    actorScreenCenter('songText')
    setActorY(getActorY("songText")-15, 'songText')
    local textShit = "Composer: "..song[2].."      Charter: "..song[3]
    if song[4] ~= "" then
        textShit = textShit.."      Original Song: "..song[4]
    end
    --trace(textShit)
    local textSize = 24 
    if song[6] ~= nil then 
        textSize = song[6]
    end
    makeText("extraText", textShit, 0, 0, textSize)
    setActorFont("extraText", "Contb___.ttf")
    setActorScroll(0,0,'extraText')
     setObjectCamera('extraText', 'hud')
    actorScreenCenter('extraText')
    setActorY(getActorY("extraText")+60, 'extraText')
    setActorOutlineColor('extraText', "0xFFFFFFFF")
    setProperty('extraText', 'borderSize', 30)
    setActorOutlineColor('songText', "0xFFFFFFFF")

    --setActorTextColor("songText", "0xFF6A17EB")
    --setActorTextColor("extraText", "0xFF6A17EB")
    setActorTextColor("songText", "0xFF000000")
    setActorTextColor("extraText", "0xFF000000")

    setActorX(getActorX("songBG")+2000, 'songBG')
    setActorX(getActorX("songText")+2000, 'songText')
    setActorX(getActorX("extraText")+2000, 'extraText')
end
local showedPopups = false
function songStart()
    if song[5] == nil then 
        showedPopups = true
        tweenActorProperty("songBG", 'x', getActorX("songBG")-2000, crochet*0.001*8, 'expoOut')
        tweenActorProperty("songText", 'x', getActorX("songText")-2000, crochet*0.001*8, 'expoOut')
        tweenActorProperty("extraText", 'x', getActorX("extraText")-2000, crochet*0.001*8, 'expoOut')
    end
end

local hiddenPopups = false 
local killedPopups = false
function stepHit()
    local delay = 0
    if song[5] ~= nil then  --delay timer thingy
        delay = song[5]
        if songPos > song[5] and not showedPopups then 
            showedPopups = true
            tweenActorProperty("songBG", 'x', getActorX("songBG")-2000, crochet*0.001*8, 'expoOut')
            tweenActorProperty("songText", 'x', getActorX("songText")-2000, crochet*0.001*8, 'expoOut')
            tweenActorProperty("extraText", 'x', getActorX("extraText")-2000, crochet*0.001*8, 'expoOut')
        end
    end
    if songPos > 5000+delay and not hiddenPopups then 
        hiddenPopups = true
        tweenActorProperty("songBG", 'x', getActorX("songBG")-2000, crochet*0.001*4, 'expoIn')
        tweenActorProperty("songText", 'x', getActorX("songText")-2000, crochet*0.001*4, 'expoIn')
        tweenActorProperty("extraText", 'x', getActorX("extraText")-2000, crochet*0.001*4, 'expoIn')
    elseif songPos > 10000+delay and not killedPopups then 
        killedPopups = true 
        destroySprite("songBG")
        destroySprite("songText")
        destroySprite("extraText")
    end
end