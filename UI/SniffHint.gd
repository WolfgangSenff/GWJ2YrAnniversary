extends MarginContainer

onready var sniff_color_rect = $SniffColor
var sniff_color := Color.antiquewhite setget set_sniff_color

func set_sniff_color(value):
    if value:
        sniff_color_rect.color = value
