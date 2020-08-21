extends BaseCharacter

class_name BaseMonster

func _ready():
    hp = max_hp

func select_attack(targets):
    var living_targets := []
    for target in targets:
        if target.alive:
            living_targets.append(target)
    var index = randi() % living_targets.size()
    var target = living_targets[index]
    var physical_attack = PhysicalAttack.new()
    physical_attack.target = target
    physical_attack.attacker = self
    return physical_attack

func _character_died() -> void:
    ._character_died()
    visible = false
