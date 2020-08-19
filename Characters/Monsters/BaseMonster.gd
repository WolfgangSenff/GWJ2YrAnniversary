extends BaseCharacter

class_name BaseMonster

func select_attack(targets):
    var living_targets : Array 
    for target in targets:
        if target.stats.hp:
            living_targets.append(target)
    var index = randi() % living_targets.size()
    var target = living_targets[index]
    var physical_attack = PhysicalAttack.new()
    physical_attack.target = target
    physical_attack.attacker = self
    return physical_attack

func _on_no_health() -> void:
    ._on_no_health()
    visible = false
