extends BaseMonster

func _ready():
    Party.add_meester()
    hp = max_hp

func select_attack(targets):
    var living_targets := []
    for target in targets:
        if target.alive:
            living_targets.append(target)
    var magic_attack = MagicAttack.new()
    magic_attack.targets = living_targets
    magic_attack.attacker = self
    magic_attack.magic_skill = load("res://Characters/Monsters/Skills/GluetrapSneeze.tscn").instance()
    return magic_attack
    
