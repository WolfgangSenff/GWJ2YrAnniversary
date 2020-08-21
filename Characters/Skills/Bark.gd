extends "res://Characters/Skills/BaseMagicAttack.gd"

const BarkEffect = preload("res://Effects/Bark.tscn")
const DISTANCE = 10
const DURATION = 0.3

onready var tween = $Tween


func execute(attack : MagicAttack) -> void:
    var attacker : BaseCharacter = attack.attacker
    var start_position = attacker.position
    var end_position = Vector2(start_position.x + DISTANCE, start_position.y)
    tween.interpolate_property(attacker, "position", start_position, end_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    for target in attack.targets:
        var direction = attacker.position.direction_to(target.position)
        target.hp += attack.magic_skill.attack_power
        var bark_effect = BarkEffect.instance()
        bark_effect.rotation_degrees = rad2deg(direction.angle())
        add_child(bark_effect)
        bark_effect.emitting = true
    yield(get_tree().create_timer(1.5), "timeout")
    tween.interpolate_property(attack.attacker, "position", end_position, start_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    queue_free()
