extends Node

onready var music := {
    "boss theme" : [$Music/BossTheme, 0],
    "battle" : [$Music/Battle, 3],
    "victory music" : [$Music/VictoryMusic, 5.5],
    "nostalgia theme" : [$Music/NostalgiaTheme, 0],
    "nostalgia theme (upbeat)" : [$Music/NostalgiaThemeUpbeat, 0],
    "game over" : [$Music/GameOver, 2.5],
    "generic background" : [$Music/GenericBackground, 0],
}

onready var sounds := {
    "bark" : $SoundEffects/Bark,
    "heal" : $SoundEffects/Heal,
    "magic attack" : $SoundEffects/MagicAttack,
    "magic cast" : $SoundEffects/MagicCast,
    "open door" : $SoundEffects/OpenDoor,
    "physical attack" : $SoundEffects/PhysicalAttack,
    "purr" : $SoundEffects/Purr,
    "walk on grass" : $SoundEffects/WalkOnGrass,
    "walk on wood" : $SoundEffects/WalkOnWood
}

var queued_music : AudioStreamPlayer
var current_music : AudioStreamPlayer
onready var fade_out_tween := Tween.new()

func _ready() -> void:
    var _e = fade_out_tween.connect("tween_completed", self, "tween_completed")
    add_child(fade_out_tween)

func tween_completed(_object: Object, _key: NodePath) -> void:
    var _e = fade_out_tween.reset_all()
    _e = fade_out_tween.remove_all()
    stop_music()

func stop_music() -> void:
    current_music.stop()
    current_music = null

func play_music(song_name : String, loop := true, interrupt := true, transition_in := 0.0) -> void:
    var music_data : Array = music[song_name]
    var audio_player : AudioStreamPlayer = music_data[0]
    var loop_offset : float = music_data[1]
    audio_player.stream.loop_offset = loop_offset
    var _e
    
    if(current_music != null):
        if(audio_player == current_music):
            return
        
        # if interrupt is false, then the music is queued up to play when the current music finishes
        # queue is one large so any new songs (where interrupt is false) replace it.
        # if a new song is played and interrupt is true the queue is emptied
        if(!interrupt and current_music.playing):
            queued_music = audio_player
            
            if(transition_in > 0 and fade_out_tween.is_active() == false):
                # tween the volume down, then back up after the music stops
                _e = fade_out_tween.interpolate_property(current_music, "volume_db", current_music.volume_db, -60, transition_in)
                _e = fade_out_tween.start()
            
            # replace any songs that may be queued up to play, not the cleanest way to do things but I'm tired
            if(current_music.is_connected("finished", self, "play_music")):
                current_music.disconnect("finished", self, "play_music")
            
            _e = current_music.connect("finished", self, "play_music", [song_name, loop, transition_in, true])
            return
        
        else:
            queued_music = null
            
            if(current_music.is_connected("finished", self, "play_music")):
                current_music.disconnect("finished", self, "play_music")
            
            current_music.stop()
    
    audio_player.stream.set_loop(loop)
    
    current_music = audio_player
    current_music.play()

func play_sound(sound_name : String, interrupt = false, loop = false) -> void:
    var audio_player : AudioStreamPlayer = sounds[sound_name]
    audio_player.stream.set_loop(loop)
    
    if(!interrupt and audio_player.playing):
        if(!audio_player.is_connected("finished", self, "play_sound")):
            var _e = audio_player.connect("finished", self, "play_sound", [sound_name, true])
    elif (not loop or not audio_player.playing):
        if(audio_player.is_connected("finished", self, "play_sound")):
            audio_player.disconnect("finished", self, "play_sound")
        audio_player.play()

func stop_looping_sound(sound_name : String) -> void:
    var audio_player : AudioStreamPlayer = sounds[sound_name]
    if audio_player:
        if(audio_player.is_connected("finished", self, "play_sound")):
            audio_player.disconnect("finished", self, "play_sound")
        audio_player.stop()
