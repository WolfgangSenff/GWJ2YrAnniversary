extends Area2D

export (String) var map_name
export (Vector2) var coordinates
export (Vector2) var direction # direction the player is facing when entering

func _ready() -> void:
    var _e = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body : KinematicBody2D) -> void:
    if body.is_in_group('Dogtective'):
        Events.change_map(map_name, coordinates, direction)
