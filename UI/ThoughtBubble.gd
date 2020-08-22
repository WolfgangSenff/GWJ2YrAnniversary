extends Node2D

signal text_done

onready var label = $Label
onready var char_tween = $Tween
var skip_pressed = false

func _ready():
    position.x -= label.get_combined_minimum_size().x / 2
    position.y -= label.get_combined_minimum_size().y
    char_tween.connect("tween_step", self, "_on_tween_step")

func load_text(text : String) -> void:
    label.visible_characters = 0
    label.text = text
    char_tween.interpolate_property(label, "visible_characters", 0, text.length(), 1.0)
    char_tween.start()

func _process(delta):
    if Input.is_action_just_pressed("skip_text") and !skip_pressed:
        skip_pressed = true
    elif skip_pressed:
        emit_signal("text_done")
        set_process(false)
        queue_free()

func _on_tween_step(_object, _key, _elapsed, _value):
    if skip_pressed:
        skip_pressed = false
        complete_text()
    else:
        label.visible_characters += 1
        if label.visible_characters == label.text.length():
            complete_text() # little hacky, it's okay
        
func complete_text():
    char_tween.stop_all()
    label.visible_characters = label.text.length()
