extends BaseMonster

func _ready():
    Party.members.append(Party.Meester.instance())
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
    $CPUParticles2D.gravity = (target.global_position - global_position)
    $CPUParticles2D.emitting = true
    return physical_attack
