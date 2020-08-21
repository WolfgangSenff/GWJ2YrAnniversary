extends BaseCharacter

class_name BasePlayer

const XP_PER_LEVEL = 200

signal attack_selected(attack)
signal attack_canceled()
signal active_changed(active)

export (bool) var is_magician = false
export (bool) var is_physical = false

var active := false setget _set_active
var targets : Array
var current_target : BaseCharacter
var target_selected_callback : FuncRef
var accept_key_released = false
var magic_skill : BaseMagicAttack
var single_target : bool

# handle stats and leveling up

func add_xp(_xp) -> void:
    xp += _xp
    while xp >= level * XP_PER_LEVEL:
        _level_up()

func _level_up() -> void:
    xp -= level * XP_PER_LEVEL
    level += 1
    max_hp += 50 * (level + level % 3) / 10
    var mag = 4
    var atk = 4
    var def = 4
    if is_physical:
        mag -= 3
        atk += 2
        def += 1
    elif is_magician:
        atk -= 2
        mag += 2
    max_mp += mag * level / 100 + 3
    attack += atk
    defense += def


func xp_until_next_level(xp_offset : int = 0) -> int:
    var fake_level : int = level
    var fake_xp : int = xp + xp_offset
    while fake_xp >= fake_level * XP_PER_LEVEL:
        fake_xp -= fake_level * XP_PER_LEVEL
        fake_level += 1
    return fake_level * XP_PER_LEVEL - (fake_xp)

func level_after_xp(xp_offset : int) -> int:
    var fake_level : int = level
    var fake_xp : int = xp + xp_offset
    while fake_xp >= fake_level * XP_PER_LEVEL:
        fake_xp -= fake_level * XP_PER_LEVEL
        fake_level += 1
    return fake_level

# battle stuff

func _process(_delta):
    # Kept getting key presses pass over from the menus
    if active and not accept_key_released:
        accept_key_released = not Input.is_action_pressed("ui_accept")

func _unhandled_key_input(_event):
    if visible and active and accept_key_released:
        _target_select_input()

func _target_select_input():
    if single_target:
        var index = targets.find(current_target)
        if Input.is_action_just_pressed("ui_up"):
            _highlight_target(index - 1)
        elif Input.is_action_just_pressed("ui_down"):
            _highlight_target(index + 1)
    if Input.is_action_just_pressed("ui_accept"):
        if target_selected_callback:
            target_selected_callback.call_func()
    elif Input.is_action_just_pressed("ui_cancel"):
        target_selected_callback = null
        _clear_targets()
        emit_signal("attack_canceled")

func _highlight_target(index):
    index = index % targets.size() if index >= 0 else index + targets.size()
    # fade all but currently selected target
    for i in range(targets.size()):
        targets[i].targeted = i == index
    current_target = targets[index]

func _select_target(_targets : Array) -> void:
    single_target = true
    targets = _targets
    current_target = targets[0]
    _highlight_target(0)

func get_action_names():
    return ["Bite", "Bark", "Sniff", "Tail"]

func start_physical_attack(_targets : Array) -> void:
#    self.active = true
    accept_key_released = false
    target_selected_callback = funcref(self, "_send_physical_attack")
    _select_target(_targets)

func _send_physical_attack() -> void:
    _clear_targets()
    target_selected_callback = null
    var physical_attack = PhysicalAttack.new()
    physical_attack.target = current_target
    physical_attack.attacker = self
    emit_signal("attack_selected", physical_attack)

func start_magic_attack(_magic_skill, party, monsters) -> void:
    accept_key_released = false
    magic_skill = _magic_skill
    var func_string = "_send_magic_attack"
    if magic_skill.is_healing:
        targets = party
    else:
        targets = monsters
    if magic_skill.hit_all:
        func_string += "_all"
        target_selected_callback = funcref(self, func_string)
        for target in targets:
            target.targeted = true
        single_target = false
    else:
        func_string += "_one"
        target_selected_callback = funcref(self, func_string)
        _select_target(targets)
    print(magic_skill._name)
    

func _send_magic_attack_one() -> void:
    _send_magic_attack([current_target])

func _send_magic_attack_all() -> void:
    _send_magic_attack(targets)

func _send_magic_attack(_targets) -> void:
    _clear_targets()
    target_selected_callback = null
    var magic_attack = MagicAttack.new()
    magic_attack.targets = _targets
    magic_attack.attacker = self
    magic_attack.magic_skill = magic_skill
    emit_signal("attack_selected", magic_attack)    

func _clear_targets() -> void:
    for target in targets:
        target.reset_modulate()

func _set_active(value) -> void:
    if active != value:
        emit_signal("active_changed", value)
    active = value
