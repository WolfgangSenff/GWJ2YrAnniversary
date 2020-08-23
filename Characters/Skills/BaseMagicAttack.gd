extends Node2D

class_name BaseMagicAttack

export (String) var _name
export (bool) var is_healing
export (bool) var hit_all
export (int, 0, 100) var mp_used
export (int, 0, 100) var attack_power

func execute(_attack : MagicAttack) -> void:
    print("-- Add execute method --")

func _deal_damage(attacker, target) -> void:
    var attack = attacker.max_mp / 10 + attack_power
    var defense = target.max_mp / 10
    var dmg : int = int(attack * (attack + attacker.level) * 100 / (100 + 2 * defense + target.level))
    dmg *= randf() * .1 + 1
    target.hp -= dmg
