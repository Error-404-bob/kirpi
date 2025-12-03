import raylib as rl
import tables


type 
    SoundType* = enum
        Static,
        Stream

    Sound* = object 
        sourceStatic*: rl.Sound
        sourceStreamID*: int = -1
        sourceType*: SoundType

    SoundStream = ptr rl.Music


var nextSourceStreamID:int=0
var soundStreamSources*: Table[int, rl.Music] =initTable[int, rl.Music]()

proc getSourceStreamID():int =
    nextSourceStreamID+=1
    result=nextSourceStreamID

proc `=destroy`(sound:var Sound) =
    if sound.sourceType==SoundType.Stream:
        if soundStreamSources.hasKey(sound.sourceStreamID) :
            soundStreamSources.del(sound.sourceStreamID)
    
    elif sound.sourceType==SoundType.Static:
        `=destroy`(sound.sourceStatic)
    
        
  


# Sound
proc newSound*(fileName:string, soundType:SoundType):Sound =
    result=Sound()
    if soundType==SoundType.Static:
        result.sourceStatic=rl.loadSound(fileName)
        result.sourceType=SoundType.Static
    elif soundType==SoundType.Stream:
        result.sourceStreamID=getSourceStreamID()
        soundStreamSources[result.sourceStreamID]=rl.loadMusicStream(fileName)
        result.sourceType=SoundType.Stream
        

proc playSound*(sound:Sound) =
    if sound.sourceType==SoundType.Static:
        rl.playSound(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        rl.playMusicStream(soundStreamSources[sound.sourceStreamID] )

proc stopSound*(sound:Sound) =
    if sound.sourceType==SoundType.Static:
        rl.stopSound(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        rl.stopMusicStream(soundStreamSources[sound.sourceStreamID])

proc pauseSound*(sound:Sound) =
    if sound.sourceType==SoundType.Static:
        rl.pauseSound(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        rl.pauseMusicStream(soundStreamSources[sound.sourceStreamID])

proc resumeSound*(sound:Sound) =
    if sound.sourceType==SoundType.Static:
        rl.resumeSound(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        rl.resumeMusicStream(soundStreamSources[sound.sourceStreamID])

proc isSoundPlaying*(sound:Sound):bool =
    if sound.sourceType==SoundType.Static:
        result=rl.isSoundPlaying(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        result=rl.isMusicStreamPlaying(soundStreamSources[sound.sourceStreamID])

proc isSoundValid*(sound:Sound):bool =
    if sound.sourceType==SoundType.Static:
        result=rl.isSoundValid(sound.sourceStatic)
    elif sound.sourceType==SoundType.Stream:
        result=rl.isMusicValid(soundStreamSources[sound.sourceStreamID])
    

proc setSoundVolume*(sound:Sound, volume:float) =
    if sound.sourceType==SoundType.Static:
        rl.setSoundVolume(sound.sourceStatic, volume)
    elif sound.sourceType==SoundType.Stream:
        rl.setMusicVolume(soundStreamSources[sound.sourceStreamID], volume)

proc setSoundPitch*(sound:Sound, pitch:float) =
    if sound.sourceType==SoundType.Static:
        rl.setSoundPitch(sound.sourceStatic, pitch)
    elif sound.sourceType==SoundType.Stream:
        rl.setMusicPitch(soundStreamSources[sound.sourceStreamID], pitch)

proc setSoundPan*(sound:Sound, pan:float) =
    if sound.sourceType==SoundType.Static:
        rl.setSoundPan(sound.sourceStatic, pan)
    elif sound.sourceType==SoundType.Stream:
        rl.setMusicPan(soundStreamSources[sound.sourceStreamID], pan)


export  rl.updateMusicStream
