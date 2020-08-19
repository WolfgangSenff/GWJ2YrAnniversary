extends Resource

class_name Attacker

export (String) var _name
export (String) var battle_resource_name
export (int, 1, 999) var max_hp
export (int) var hp setget _set_hp
export (int, 1, 999) var max_mp
export (int) var mp setget _set_mp
export (int, 1, 100) var attack
export (int, 1, 100) var defense
export (int, 1, 100) var level
export (int) var xp
export (Resource) var sprite_sheet
export (Array, Resource) var magic_skills

signal no_health(old_hp, new_hp)
signal hp_changed(old_hp, new_hp)
signal mp_changed(old_mp, new_mp)

func _set_hp(_hp):
    var clamped_hp = clamp(_hp, 0, max_hp)
    emit_signal("hp_changed", hp, clamped_hp)
    hp = clamped_hp
    if not hp:
        emit_signal("no_health")

func _set_mp(_mp):
    var clamped_mp = clamp(_mp, 0, max_mp)
    emit_signal("mp_changed", mp, clamped_mp)
    mp = clamped_mp
