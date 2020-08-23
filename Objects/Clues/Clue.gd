extends Area2D

export (int) var SniffLevel
export (Color) onready var SniffColor setget set_sniff_color

func set_sniff_color(value):
    if value:
        SniffColor = value

export (int) var sniffer_level

signal thought_done
export (Resource) var DialogRes
const ThoughtBubble = preload("res://UI/ThoughtBubble.tscn")

func _ready() -> void:
    var _e = connect("body_entered", self, "_on_body_entered")
    visible = SnifferPower.current_sniffer_level >= sniffer_level
    _e = SnifferPower.connect("update_sniffer_level", self, "_on_sniffer_level_updated")

func _on_sniffer_level_updated():
    visible = SnifferPower.current_sniffer_level >= sniffer_level

func _on_body_entered(body):
    if SnifferPower.current_sniffer_level >= sniffer_level:
        get_tree().paused = true
        yield(DialogRes.init_dialog(self, self), "completed")
        body.show_thought_bubble("Sniffer leveled up!")
        SnifferPower.raise_sniffer_level()
        disconnect("body_entered", self, "_on_body_entered")
        SnifferPower.disconnect("update_sniffer_level", self, "_on_sniffer_level_updated")
        get_tree().paused = false
    
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
    

