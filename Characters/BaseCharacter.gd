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

const DamageText = preload("res://Battle/UI/DamageText.tscn")

onready var animation_player = $AnimationPlayer
onready var tween = $Tween

#var stats : Attacker setget _set_stats
var targeted := false setget _set_targeted
var alive := true
var in_battle := false

signal character_died()
signal hp_changed(old_hp, new_hp)
signal mp_changed(old_mp, new_mp)

func _ready() -> void:
    var built_skills : Array
    for skill in magic_skills:
        built_skills.append(skill.instance())
    magic_skills = built_skills

func in_battle() -> void:
    in_battle = true

func _move_to_target(destination) -> void:
    tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()

func physical_attack(target : BaseCharacter) -> void:
    var starting_position = position
    _move_to_target(target.position)
    yield(tween, "tween_completed")
    _deal_physical_damage_to(target)
    print(_name + ' attacked ' + target._name + ' for ' + str(attack) + ' dmg: ' + str(target.hp) + '/' + str(target.max_hp))
    _move_to_target(starting_position)
    yield(tween, "tween_completed")

func _deal_physical_damage_to(target : BaseCharacter) -> void:
    var dmg : int = int(attack * (attack + level) * 100 / (100 + 2 * target.defense + target.level))
    dmg *= randf() * .1 + 1.0
    target.hp -= dmg

func magic_attack(_attack) -> void:
    var skill : BaseMagicAttack = _attack.magic_skill.duplicate()
    add_child(skill)
    mp -= skill.mp_used
    yield(skill.execute(_attack), "completed")

func reset_modulate() -> void:
    modulate.a = 1.0
    modulate.r = 1.0
    if animation_player.is_playing():
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
        if animation_player.is_playing():
            animation_player.seek(0, true)
            animation_player.stop()

func _set_hp(_hp):
    print('hit')
    if in_battle:
        var damage_text = DamageText.instance()
        damage_text.damage = hp - _hp
        damage_text.glob_position = global_position
        damage_text.glob_position.y -= 56
        get_parent().add_child(damage_text)
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
