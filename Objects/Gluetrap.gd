extends StaticBody2D

export (int) var SniffLevel
export (Color) onready var SniffColor setget set_sniff_color

func set_sniff_color(value):
    if value:
        SniffColor = value
