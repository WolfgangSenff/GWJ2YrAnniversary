extends KinematicBody2D

class_name Dogtective

const ThoughtBubble = preload("res://UI/ThoughtBubble.tscn")

signal thought_done
signal sniffer_updated(sniffables)
onready var sniff_timer = $SniffTimer

onready var anim_tree = $AnimationTree
onready var is_idle setget set_is_idle, get_is_idle
onready var is_walking setget set_is_walking, get_is_walking
onready var blend_space setget set_blend_space

var _sniffables = []

export (bool) onready var PlayerControlled

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

export var speed := 140

var sound_name : String
onready var direction : Vector2 = Vector2.ZERO

func _ready() -> void:
    if PlayerControlled:
        position = Events.player_position
        direction = Party.direction
    else:
        direction = Vector2.DOWN
        
    self.blend_space = Vector2(direction.x, -direction.y)

func _exit_tree():
    SoundManager.stop_looping_sound(Party.walking_sound_name)

func _physics_process(_delta):
    if PlayerControlled:
        direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
        direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    else:
        direction.x = Input.get_action_strength("ai_right") - Input.get_action_strength("ai_left")
        direction.y = Input.get_action_strength("ai_down") - Input.get_action_strength("ai_up")
        
    if direction:
        var _e = move_and_slide(direction.normalized() * speed)
        self.blend_space = Vector2(direction.x, -direction.y)
        SoundManager.play_sound(Party.walking_sound_name, false, true)
        if PlayerControlled:
            Party.position = position
            Party.direction = direction
        self.is_walking = true
        self.is_idle = false
    else:
        SoundManager.stop_looping_sound(Party.walking_sound_name)
        self.is_idle = true
        self.is_walking = false

func press_skip_text():
    if current_thought_bubble:
        current_thought_bubble.skip_pressed = true
        
var current_thought_bubble

func show_thought_bubble(text : String) -> void:
    var thought_bubble = ThoughtBubble.instance()
    current_thought_bubble = thought_bubble
    add_child(thought_bubble)
    thought_bubble.load_text(text)
    yield(thought_bubble, "text_done")
    emit_signal("thought_done")
    
func set_all_sniffables(value):
    _sniffables = value

class SnifferSorter:
    var _location
    func _init(location):
        _location = location
        
    func sort_by_distance(a, b):
        return a.global_position.distance_squared_to(_location) < b.global_position.distance_squared_to(_location)
        
    func sort_by_level(a, b):
        return a.SniffLevel < b.SniffLevel

func _on_SniffTimer_timeout():
    if _sniffables and _sniffables.size() > 0 and PlayerControlled:
        var sorter = SnifferSorter.new(self.global_position)
        _sniffables.sort_custom(sorter, "sort_by_level")
        _sniffables.sort_custom(sorter, "sort_by_distance")
        var reverse_range = range(_sniffables.size())
        reverse_range.invert()
        var new_sniffables = []
        for idx in reverse_range:
            if _sniffables[idx].global_position.distance_to(global_position) <= SnifferPower.current_sniff_radius:
                new_sniffables.push_front(_sniffables[idx])
        emit_signal("sniffer_updated", new_sniffables)
