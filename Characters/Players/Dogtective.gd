extends KinematicBody2D

class_name Dogtective

const ThoughtBubble = preload("res://UI/ThoughtBubble.tscn")

onready var anim_tree = $AnimationTree
onready var is_idle setget set_is_idle, get_is_idle
onready var is_walking setget set_is_walking, get_is_walking
onready var blend_space setget set_blend_space

func set_blend_space(value):
    anim_tree.set("parameters/IdleBlendSpace/blend_position", value)
    anim_tree.set("parameters/WalkBlendSpace/blend_position", value)

func set_is_idle(value):
    anim_tree.set("parameters/conditions/is_idle", value)

func get_is_idle():
    anim_tree.get("parameters/conditions/is_idle")
    
func set_is_walking(value):
    anim_tree.set("parameters/conditions/is_walking", value)

func get_is_walking():
    anim_tree.get("parameters/conditions/is_walking")

export var speed := 100

var direction : Vector2

func _ready() -> void:
    position = Events.player_position

func _physics_process(_delta):
    direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    if direction:
        var _e = move_and_slide(direction.normalized() * speed)
        self.blend_space = Vector2(direction.x, -direction.y)
        Party.position = position
        self.is_walking = true
        self.is_idle = false
    else:
        self.is_idle = true
        self.is_walking = false

func show_thought_bubble(text : String) -> void:
    var thought_bubble = ThoughtBubble.instance()
    thought_bubble.load_text(text)
    add_child(thought_bubble)
