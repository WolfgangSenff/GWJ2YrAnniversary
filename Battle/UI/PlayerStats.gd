extends NinePatchRect

onready var tween = $Tween
onready var name_label = $VBoxContainer/HBoxContainer/NameLabel
onready var level_label = $VBoxContainer/HBoxContainer/LevelLabel
onready var hp_label = $VBoxContainer/HPContainer/HPLabel
onready var max_hp_label = $VBoxContainer/HPContainer/MaxHPLabel
onready var bp_label = $VBoxContainer/BPContainer/BPLabel
onready var max_bp_label = $VBoxContainer/BPContainer/MaxBPLabel

var start_rect_position : Vector2


func load_player(player : BasePlayer) -> void:
    var _e = player.connect("hp_changed", self, "_on_hp_changed")
    _e = player.connect("mp_changed", self, "_on_mp_changed")
    _e = player.connect("active_changed", self, "_on_active_changed")
    name_label.text = player._name
    level_label.text = str(player.level)
    hp_label.text = str(player.hp)
    max_hp_label.text = str(player.max_hp)
    bp_label.text = str(player.mp)
    max_bp_label.text = str(player.max_mp)

func _on_hp_changed(old_hp, new_hp) -> void:
    tween.interpolate_method(self, "_set_hp_text", old_hp, new_hp, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()

func _set_hp_text(value : int) -> void:
    hp_label.text = str(value)    

func _on_mp_changed(old_mp, new_mp) -> void:
    tween.interpolate_method(self, "_set_mp_text", old_mp, new_mp, .4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()

func _set_mp_text(value : int) -> void:
    bp_label.text = str(value)

func _on_active_changed(active : bool) -> void:
    var end_position : Vector2
    if active:
        end_position = rect_position
        end_position.y = -12
    else:
        end_position = rect_position
        end_position.y = 0
    tween.interpolate_property(self, "rect_position", rect_position, end_position, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
