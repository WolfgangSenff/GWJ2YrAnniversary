extends "res://Maps/LevelBase.gd"


func _ready():
    if SnifferPower.current_sniffer_level >= 4:
        Events.change_map("BossRoom", Vector2(4, 8), Vector2.UP)
