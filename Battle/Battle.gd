extends Node2D

enum {
    NORMAL,
    ATTACK_SELECT
   }

const PlayerStats = preload("res://Battle/UI/PlayerStats.tscn")
const PLAYER_X = 150
const PLAYER_Y = 60
const MONSTER_X = 480
const MONSTER_Y = 70
const Y_SPACING = 100

onready var player_stats_container = $CanvasLayer/PlayerStatsContainer
onready var fight_menu = $CanvasLayer/FightMenu
onready var fight_menu_buttons = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons
onready var attack_button = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons/AttackButton
onready var magic_button = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons/MagicButton
onready var run_button = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons/RunButton
onready var magic_menu = $CanvasLayer/MagicMenu
onready var magic_menu_container = $CanvasLayer/MagicMenu/NinePatchRect/MagicMenuButtons

var input_mode := NORMAL
var party : Array
var monsters : Array
var current_member : BasePlayer
var current_target : BaseCharacter
var monster_group : MonsterGroup
var targets : Array
var attacks : Array
var in_battle := true

func _ready() -> void:
    SoundManager.play_music('battle')
    _load_party()
    _load_monsters()
    _select_player_action()
    var _e = attack_button.connect('pressed', self, '_start_physical_attack')
    _e = magic_button.connect('pressed', self, '_select_magic_attack')
    _e = run_button.connect('pressed', self, '_run_or_back')
    _e = magic_menu.connect("menu_canceled", self, "_select_player_action")
    _e = magic_menu.connect("magic_attack_selected", self, "_start_magic_attack")

func _unhandled_key_input(_event):
    if fight_menu.visible and Input.is_action_just_pressed("ui_cancel") and current_member != _first_living_member():
        _prev_member()

func _first_living_member() -> BasePlayer:
    for member in party:
        if member.alive:
            return member
    return null

# Load the party members into the battle scene from the
# Party.members array.
func _load_party() -> void:
    var position = Vector2(PLAYER_X, PLAYER_Y)
    for member in Party.members:
        add_child(member)
        member.position = position
        member.call_deferred("in_battle")
        var _e = member.connect("attack_selected", self, "_attack_selected")
        _e = member.connect("attack_canceled", self, "_attack_canceled")
        party.append(member)
        position.y += Y_SPACING
        # load player stats
        var player_stats = PlayerStats.instance()
        player_stats_container.add_child(player_stats)
        player_stats.load_player(member)
    current_member = party[0]

# Load monsters from the Event parameters into the scene.
# Before loading the battle scene, a MonsterGroup resource
# must first be stored into the `parameters` variable.
func _load_monsters() -> void:
    var position = Vector2(MONSTER_X, MONSTER_Y)
    monster_group = Events.parameters
    
    # NOTE: just for testing, delete later
    if not monster_group:
        monster_group = load('res://Characters/Monsters/Groups/NewspaperSlipper.tres')
        Events.parameters = monster_group
    ######################################
    
    if monster_group:
        for monster in monster_group.monsters:
            monster = monster.instance()
            monster.hp = monster.max_hp
            monster.mp = monster.max_mp
            monster.call_deferred("in_battle")
            var _e = monster.connect('character_died', self, "_on_monster_died")
            add_child(monster)
            monster.position = position
            monsters.append(monster)
            position.y += Y_SPACING

func _next_member():
    var index = party.find(current_member)
    index += 1
    if index < party.size():
        current_member = party[index]
        _select_player_action()
    else:
        _select_monster_actions()
        _execute_attacks()
        
func _prev_member():
    var index = party.find(current_member)
    index -= 1
    if index >= 0:
        var _e = attacks.pop_back()
        current_member = party[index]
        _select_player_action()
    else:
        _battle_quit()

func _execute_attacks() -> void:
    _reset_highlighting()
    for attack in attacks:
        if attack.attacker.alive and in_battle:
            if attack is PhysicalAttack:
                attack.target = _get_living_target(attack.target)
                if attack.target and attack.target.alive:
                    yield(attack.attacker.physical_attack(attack.target), 'completed')
            elif attack is MagicAttack:
                if len(attack.targets) == 1:
                    attack.targets[0] = _get_living_target(attack.targets[0])
                yield(attack.attacker.magic_attack(attack), 'completed')
    attacks.clear()
    current_member = _first_living_member()
    _select_player_action()

func _get_living_target(target : BaseCharacter) -> BaseCharacter:
    if target.alive:
        return target
    var attack_targets = monsters
    if target is BasePlayer:
        attack_targets = party
    for target in attack_targets:
        if target.alive:
            return target
    return null

func _select_monster_actions() -> void:
    for monster in monsters:
        var attack = monster.select_attack(party)
        attacks.append(attack)

func _select_player_action(highlight_index := 0) -> void:
    if not current_member:
        _battle_lost()
    if in_battle:
        fight_menu.set_deferred("visible", true)
#        _reset_highlighting()
        _highlight_current_member()
        fight_menu_buttons.get_child(highlight_index).grab_focus()

func _highlight_current_member() -> void:
    for member in party:
        var alpha = 0.5
        if member == current_member:
            alpha = 1
        member.modulate.a = alpha
        member.active = alpha == 1

func _reset_highlighting() -> void:
    for member in party:
        member.modulate.a = 1
        member.active = false

func _get_living_monsters() -> Array:
    var living_monsters := []
    for monster in monsters:
        if monster.alive:
            living_monsters.append(monster)
    return living_monsters

func _start_physical_attack() -> void:
    fight_menu.visible = false
    current_member.start_physical_attack(_get_living_monsters())

func _select_magic_attack() -> void:
    fight_menu.visible = false
    magic_menu.load_magic_skills(current_member.magic_skills)

func _start_magic_attack(magic_skill : BaseMagicAttack) -> void:
    fight_menu.visible = false
    magic_menu.visible = false
    current_member.start_magic_attack(magic_skill, party, _get_living_monsters())

func _run_or_back() -> void:
    _prev_member()

func _attack_selected(attack) -> void:
    attacks.append(attack)
    _next_member()

func _attack_canceled() -> void:
    if current_member.active:
        _select_player_action()
    else:
        _prev_member()

func _on_monster_died() -> void:
    print('dead')
    for monster in monsters:
        if monster.alive:
            return
    if in_battle:
        _battle_won()

func _battle_won() -> void:
    SoundManager.play_music("victory music")
    in_battle = false
    yield(get_tree().create_timer(3), "timeout")
    print('you win + ' + str(monster_group.xp) + ' xp and ' + str(monster_group.cheeze) + 'g of cheeze!')
    _detach_party()
    var _e = get_tree().change_scene("res://Battle/BattleWon.tscn")

func _battle_lost() -> void:
    if in_battle:
        in_battle = false
        yield(get_tree().create_timer(1), "timeout")
        print('you lose ' + str(Party.cheeze / 2) + 'g of cheese!')
        Party.cheeze /= 2
        _detach_party()
        Events.end_battle()

func _battle_quit() -> void:
    _detach_party()
    Events.end_battle()

func _detach_party() -> void:
    for member in Party.members:
        remove_child(member)
