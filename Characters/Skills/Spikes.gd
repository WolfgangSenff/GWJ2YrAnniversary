extends "res://Characters/Skills/BaseMagicAttack.gd"

const BarkEffect = preload("res://Effects/Bark.tscn")
const DISTANCE = 10
const DURATION = 0.3

onready var tween = $Tween
onready var cpu_particles = $CPUParticles2D


func execute(attack : MagicAttack) -> void:
    var start_position = attack.attacker.position
    var end_position = Vector2(start_position.x, start_position.y - DISTANCE)
    tween.interpolate_property(attack.attacker, "position", start_position, end_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    SoundManager.play_sound("magic attack")
    tween.interpolate_property(attack.attacker, "position", end_position, start_position, DURATION, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
    tween.start()
    yield(tween, "tween_completed")
    cpu_particles.emitting = true
    yield(get_tree().create_timer(1.5), "timeout")
    for target in attack.targets:
        _deal_damage(attack.attacker, target)
    queue_free()
