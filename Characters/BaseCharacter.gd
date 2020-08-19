extends Node2D

class_name BaseCharacter

var stats : Attacker setget _set_stats

onready var animation_player = $AnimationPlayer
onready var tween = $Tween

var targeted := false setget _set_targeted
var alive := true

func _move_to_target(destination) -> void:
    tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()

func physical_attack(target : BaseCharacter) -> void:
    var starting_position = position
    _move_to_target(target.position)
    yield(tween, "tween_completed")
    target.stats.hp -= stats.attack
    print(stats._name + ' attacked ' + target.stats._name + ' for ' + str(stats.attack) + ' dmg: ' + str(target.stats.hp) + '/' + str(target.stats.max_hp))
    _move_to_target(starting_position)
    yield(tween, "tween_completed")

func magic_attack(attack) -> void:
    var skill : MagicSkill = attack.magic_skill
    var magic_resource = load('res://Characters/Skills/' + skill.battle_resource_name + '.tscn').instance()
    add_child(magic_resource)
    stats.mp -= skill.mp_used
    yield(magic_resource.execute(attack), "completed")

func reset_modulate() -> void:
    modulate.a = 1.0
    modulate.r = 1.0
    animation_player.stop()
    animation_player.seek(0, true)

func _on_no_health() -> void:
    alive = false

func _set_targeted(value) -> void:
    targeted = value
    modulate.a = 1.0 if targeted else 0.5
    modulate.r = 0.5 if targeted else 1.0
    if targeted:
        animation_player.play("Targeted")
    else:
        animation_player.stop()
        animation_player.seek(0, true)

func _set_stats(value : Attacker) -> void:
    if not stats:
        var _e = value.connect("no_health", self, "_on_no_health")
    stats = value
