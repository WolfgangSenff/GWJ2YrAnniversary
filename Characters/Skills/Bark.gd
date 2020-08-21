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
    var target : BaseCharacter = attack.targets.pop_front()
    var direction = attacker.position.direction_to(target.position)
    var bark_effect = BarkEffect.instance()
    bark_effect.rotation_degrees = rad2deg(direction.angle())
    add_child(bark_effect)
    bark_effect.emitting = true
    yield(get_tree().create_timer(1), "timeout")
    _deal_damage(attack.attacker, target)
    tween.interpolate_property(attack.attacker, "position", end_position, start_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    queue_free()
