extends Node2D


onready var sprite := $Sprite

var attacker : Attacker


# Loads the attacker object and pulls the sprite into the
# sprite texture.
func load_attacker(_attacker : Attacker) -> void:
    attacker = _attacker
    sprite.texture = attacker.sprite_sheet
