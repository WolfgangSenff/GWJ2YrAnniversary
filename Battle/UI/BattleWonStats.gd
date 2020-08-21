extends VBoxContainer

onready var portrait := $HBoxContainer3/Portrait
onready var name_label := $HBoxContainer3/NameLabel
onready var level_label := $HBoxContainer3/LevelLabel
onready var xp_left_label := $HBoxContainer3/XPLeftLabel

var character : BaseCharacter


func load_character(_character : BaseCharacter) -> void:
    character = _character
    name_label.text = character._name
    level_label.text = str(character.level)
    xp_left_label.text = str(character.xp_until_next_level())

func update_xp(xp : int) -> void:
    level_label.text = str(character.level_after_xp(xp))
    xp_left_label.text = str(character.xp_until_next_level(xp))

