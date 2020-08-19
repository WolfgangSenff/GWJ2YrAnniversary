extends "res://Characters/Skills/BaseMagicAttack.gd"

const HealEffect = preload("res://Effects/Heal.tscn")
const JUMP_HEIGHT = 10
const DURATION = 0.3

onready var tween = $Tween


func execute(attack : MagicAttack) -> void:
    var start_position = attack.attacker.position
    var end_position = Vector2(start_position.x, start_position.y - JUMP_HEIGHT)
    tween.interpolate_property(attack.attacker, "position", start_position, end_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    tween.interpolate_property(attack.attacker, "position", end_position, start_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    for target in attack.targets:
        target.stats.hp += attack.magic_skill.attack_power
        var heal_effect = HealEffect.instance()
        add_child(heal_effect)
        heal_effect.global_position = target.global_position
        heal_effect.emitting = true
    yield(get_tree().create_timer(1.5), "timeout")
    queue_free()
