extends Node2D

class_name BaseCharacter

export (String) var _name
export (int, 1, 999) var max_hp
export (int) var hp setget _set_hp
export (int, 1, 999) var max_mp
export (int) var mp setget _set_mp
export (int, 1, 100) var attack
export (int, 1, 100) var defense
export (int, 1, 100) var level
export (int) var xp
export (Array, Resource) var magic_skills

onready var animation_player = $AnimationPlayer
onready var tween = $Tween

#var stats : Attacker setget _set_stats
var targeted := false setget _set_targeted
var alive := true

signal character_died()
signal no_health(old_hp, new_hp)
signal hp_changed(old_hp, new_hp)
signal mp_changed(old_mp, new_mp)

func _ready() -> void:
    var built_skills : Array
    for skill in magic_skills:
        built_skills.append(skill.instance())
    magic_skills = built_skills

func _move_to_target(destination) -> void:
    tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()

func physical_attack(target : BaseCharacter) -> void:
    var starting_position = position
    _move_to_target(target.position)
    yield(tween, "tween_completed")
    target.hp -= attack
    print(_name + ' attacked ' + target._name + ' for ' + str(attack) + ' dmg: ' + str(target.hp) + '/' + str(target.max_hp))
    _move_to_target(starting_position)
    yield(tween, "tween_completed")

func magic_attack(_attack) -> void:
    var skill : BaseMagicAttack = _attack.magic_skill.duplicate()
    add_child(skill)
    mp -= skill.mp_used
    yield(skill.execute(_attack), "completed")

func reset_modulate() -> void:
    modulate.a = 1.0
    modulate.r = 1.0
    animation_player.stop()
    animation_player.seek(0, true)

func _character_died() -> void:
    alive = false
    emit_signal("character_died")

func _set_targeted(value) -> void:
    targeted = value
    modulate.a = 1.0 if targeted else 0.5
    modulate.r = 0.5 if targeted else 1.0
    if targeted:
        animation_player.play("Targeted")
    else:
        animation_player.stop()
        animation_player.seek(0, true)

func _set_hp(_hp):
    var clamped_hp = clamp(_hp, 0, max_hp)
    emit_signal("hp_changed", hp, clamped_hp)
    hp = clamped_hp
    # exporting causes it to run the setter upon initializing with a value of 0
    if max_hp and not hp:
        _character_died()

func _set_mp(_mp):
    var clamped_mp = clamp(_mp, 0, max_mp)
    emit_signal("mp_changed", mp, clamped_mp)
    mp = clamped_mp
