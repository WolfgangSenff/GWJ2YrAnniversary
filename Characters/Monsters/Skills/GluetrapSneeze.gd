extends BaseMagicAttack

func execute(_attack : MagicAttack):
    var children = get_children()
    var current_idx = 0
    for target in _attack.targets:
        var current_child = children[current_idx]
        current_child.gravity = (target.global_position - global_position)
        current_child.emitting = true
        current_idx += 1
        yield(get_tree().create_timer(.5), "timeout")
        
    yield(get_tree().create_timer(1.0), "timeout")
