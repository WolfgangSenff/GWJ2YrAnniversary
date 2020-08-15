extends Node2D


func _ready():
    position.x -= $Label.get_combined_minimum_size().x / 2
    yield(get_tree().create_timer(1), "timeout")
    queue_free()


func load_text(text : String) -> void:
    $Label.text = text
