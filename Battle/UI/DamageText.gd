extends Node2D

onready var tween = $Tween
onready var label = $Label

var damage : int
var glob_position : Vector2

func _ready():
    global_position = glob_position
    if damage < 0:
        damage *= -1
        label.set("custom_colors/font_color", Color(.03,.56,.29))
        yield(get_tree().create_timer(1), "timeout")
    label.text = str(damage)
    var rand_x = randi() % 20 - 10
    var rand_y = -randi() % 10 - 20
    tween.interpolate_property(self, "position", position, position + Vector2(rand_x, rand_y), .3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()
    tween.connect("tween_completed", self, "_on_tween_done")

func _on_tween_done(object, key) -> void:
    queue_free()
