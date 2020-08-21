extends Node

onready var music := {
    "boss theme" : $Music/BossTheme,
    "battle" : $Music/Battle,
    "victory music" : $Music/VictoryMusic,
    "nostalgia theme" : $Music/NostalgiaTheme,
    "nostalgia theme (upbeat)" : $Music/NostalgiaThemeUpbeat
}

onready var sounds := {
    "default" : $SoundEffects/default
}

var queued_music : AudioStreamPlayer
var current_music : AudioStreamPlayer
var fade_out_tween := Tween.new()

func _ready() -> void:
    fade_out_tween.connect("tween_completed", self, "tween_completed")
    add_child(fade_out_tween)

func tween_completed(_object: Object, _key: NodePath) -> void:
    var _e = fade_out_tween.reset_all()
    _e = fade_out_tween.remove_all()
    stop_music()

func stop_music() -> void:
    current_music.stop()
    current_music = null

func play_music(song_name : String, play_intro := true, loop := true, interrupt := true, transition_in := 0.0) -> void:
    var audio_player : AudioStreamPlayer = music[song_name]
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
            
            _e = current_music.connect("finished", self, "play_music", [song_name, play_intro, loop, transition_in, true])
            return
        
        else:
            queued_music = null
            
            if(current_music.is_connected("finished", self, "play_music")):
                current_music.disconnect("finished", self, "play_music")
            
            current_music.stop()
    
    audio_player.stream.set_loop(loop)
    
    var start_pos : float
    if(play_intro):
        start_pos = 0
    else:
        start_pos = audio_player.stream.loop_offset
    
    current_music = audio_player
    current_music.play(start_pos)

func play_sound(sound_name : String, interrupt = false) -> void:
    var audio_player : AudioStreamPlayer = sounds[sound_name]
    audio_player.stream.set_loop(false)
    
    if(!interrupt and audio_player.playing):
        if(!audio_player.is_connected("finished", self, "play_sound")):
            var _e = audio_player.connect("finished", self, "play_sound", [sound_name, true])
    else:
        if(audio_player.is_connected("finished", self, "play_sound")):
            audio_player.disconnect("finished", self, "play_sound")
        audio_player.play()
