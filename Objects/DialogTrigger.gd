extends Area2D

signal thought_done
export (Resource) var DialogRes
const ThoughtBubble = preload("res://UI/ThoughtBubble.tscn")

func _on_DialogTrigger_body_entered(body):
    get_tree().paused = true
    yield(DialogRes.init_dialog(body, self), "completed")
    get_tree().paused = false
    
func show_thought_bubble(text : String) -> void:
    var thought_bubble = ThoughtBubble.instance()
    add_child(thought_bubble)
    thought_bubble.load_text(text)
    yield(thought_bubble, "text_done")
    emit_signal("thought_done")
