extends Node2D

class_name BaseMagicAttack

export (String) var _name
export (String) var battle_resource_name
export (bool) var is_healing
export (bool) var hit_all
export (int, 0, 100) var mp_used
export (int, 0, 100) var attack_power

func execute(_attack : MagicAttack) -> void:
    print("-- Add execute method --")
