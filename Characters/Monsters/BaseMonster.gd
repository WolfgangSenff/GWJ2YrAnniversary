extends BaseCharacter

class_name BaseMonster

func _ready():
    hp = max_hp
    mp = max_mp

func select_attack(targets):
    var living_targets := []
    for target in targets:
        if target.alive:
            living_targets.append(target)
    var index = randi() % living_targets.size()
    var target = living_targets[index]
    
    
    if magic_skills.size() > 0 and randi() % 10 > 4 and mp > 10:
        var magic_skill : BaseMagicAttack = magic_skills[randi() % magic_skills.size()]
        var magic_attack = MagicAttack.new()
        if magic_skill.hit_all:
            magic_attack.targets = targets
        else:
            magic_attack.targets = [target]
        magic_attack.attacker = self
        magic_attack.magic_skill = magic_skills[randi() % magic_skills.size()]
        return magic_attack
    else:
        var physical_attack = PhysicalAttack.new()
        physical_attack.target = target
        physical_attack.attacker = self
        return physical_attack
        
func _character_died() -> void:
    ._character_died()
    visible = false
