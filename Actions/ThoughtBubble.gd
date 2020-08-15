extends Area2D

export (String, MULTILINE) var text

func _ready():
    connect("body_entered", self, '_on_body_entered')


func _on_body_entered(body : Dogtective) -> void:
    if body.is_in_group('Dogtective'):
        body.show_thought_bubble(text)
