extends Node2D

onready var dog = $YSortTileMap/Dogtective

export (String) var music_track
export (bool) var walking_on_wood = true

#var random_sniffer_history = [SnifferPower.SnifferLevelRecord.Fight, SnifferPower.SnifferLevelRecord.Investigation, SnifferPower.SnifferLevelRecord.Memory]

onready var PoopDialog = load("res://resources/Dialogs/DogPoop.tres")

func _ready():
    SoundManager.play_music(music_track, true, false, 1)
    #dog.connect("sniffer_updated", self, "_on_sniffer_updated")

    var walking_sound_name = "walk on wood" if walking_on_wood else "walk on grass"
    Party.walking_sound_name = walking_sound_name
    
func _on_sniffer_updated(sniffables):
    SnifferPower.current_sniffables = sniffables

# Temporary
func _on_Button_pressed():
    #SnifferPower.raise_sniffer_level(random_sniffer_history[randi() % random_sniffer_history.size()])
    SnifferPower.raise_sniffer_level()

