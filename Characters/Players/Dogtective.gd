extends KinematicBody2D

class_name Dogtective

const ThoughtBubble = preload("res://UI/ThoughtBubble.tscn")

export var speed := 100

var direction : Vector2

func _ready() -> void:
    position = Events.player_position


func _process(_delta):
    if direction:
        var _e = move_and_slide(direction.normalized() * speed)
        Party.position = position


func _unhandled_key_input(_event):
    direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    Party.direction = direction


func show_thought_bubble(text : String) -> void:
    var thought_bubble = ThoughtBubble.instance()
    thought_bubble.load_text(text)
    add_child(thought_bubble)
