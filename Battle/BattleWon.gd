extends Node2D

const BattleOverStats = preload("res://Battle/UI/BattleWonStats.tscn")

onready var vboxcontainer = $CanvasLayer/MarginContainer/VBoxContainer
onready var xp_label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/XPLabel
onready var cheeze_label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/CheezeLabel
onready var total_cheeze_label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer3/TotalCheezeLabel
onready var tween = $Tween

var monster_group : MonsterGroup
var ready_to_quit := false
var stat_boxes : Array

# Make sure the Events.parameters variable still holds the MonsterGroup!
func _ready():
    monster_group = Events.parameters
    xp_label.text = str(monster_group.xp)
    cheeze_label.text = str(monster_group.cheeze)
    total_cheeze_label.text = str(Party.cheeze)
    for player in Party.members:
        var stats = BattleOverStats.instance()
        vboxcontainer.add_child(stats)
        stats.load_character(player)
        stat_boxes.append(stats)

func _unhandled_key_input(event) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        if not tween.is_active():
            _add_xp_and_gold()
        if ready_to_quit:
            _end_battle()

func _add_xp_and_gold() -> void:
    tween.interpolate_method(self, "_add_cheeze", 0, monster_group.cheeze, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    tween.interpolate_method(self, "_add_xp", 0, monster_group.xp, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
    tween.start()
    tween.connect("tween_all_completed", self, "_xp_and_cheeze_added")

func _end_battle() -> void:
    Events.end_battle()

func _add_cheeze(value) -> void:
    cheeze_label.text = str(int(monster_group.cheeze - value))
    total_cheeze_label.text = str(int(Party.cheeze + value))

func _add_xp(value) -> void:
    xp_label.text = str(int(monster_group.xp - value))
    for stat_box in stat_boxes:
        stat_box.update_xp(value)

func _xp_and_cheeze_added() -> void:
    Party.cheeze += monster_group.cheeze
    Party.give_xp(monster_group.xp)
    ready_to_quit = true
