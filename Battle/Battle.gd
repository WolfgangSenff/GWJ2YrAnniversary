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
onready var special_button = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons/SpecialButton
onready var run_button = $CanvasLayer/FightMenu/NinePatchRect/FightMenuButtons/RunButton
onready var magic_menu = $CanvasLayer/MagicMenu
onready var magic_menu_container = $CanvasLayer/MagicMenu/NinePatchRect/MagicMenuButtons

var input_mode := NORMAL
var party : Array
var monsters : Array
var current_member : BasePlayer
var current_target : BaseCharacter
var targets : Array
var attacks : Array

func _ready() -> void:
    _load_party()
    _load_monsters()
    _select_player_action()
    var _e = attack_button.connect('pressed', self, '_start_physical_attack')
    _e = magic_button.connect('pressed', self, '_select_magic_attack')
    _e = special_button.connect('pressed', self, '_start_special_attack')
    _e = run_button.connect('pressed', self, '_run_or_back')
    _e = magic_menu.connect("menu_canceled", self, "_select_player_action")
    _e = magic_menu.connect("magic_attack_selected", self, "_start_magic_attack")

func _unhandled_key_input(_event):
    if not current_member.active and Input.is_action_just_pressed("ui_cancel") and current_member != _first_living_member():
        _prev_member()

func _first_living_member() -> BasePlayer:
    for member in party:
        if member.stats.hp:
            return member
    return null

# Load the party members into the battle scene from the
# Party.members array.
func _load_party() -> void:
    var position = Vector2(PLAYER_X, PLAYER_Y)
    for member in Party.members:
        var battle_member : BasePlayer = load('res://Characters/Players/' + member.battle_resource_name + '.tscn').instance()
        add_child(battle_member)
        battle_member.position = position
        battle_member.stats = member
        var _e = battle_member.connect("attack_selected", self, "_attack_selected")
        _e = battle_member.connect("attack_canceled", self, "_attack_canceled")
        party.append(battle_member)
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
    var monster_group : MonsterGroup = Events.parameters
    
    # NOTE: just for testing, delete later
    if not monster_group:
        monster_group = load('res://Characters/Monsters/Groups/NewspaperSlipper.tres')
    ######################################
    
    if monster_group:
        for monster in monster_group.monsters:
            monster.hp = monster.max_hp
            monster.mp = monster.max_mp
            var battle_member : BaseMonster = load('res://Characters/Monsters/' + monster.battle_resource_name + '.tscn').instance()
            add_child(battle_member)
            battle_member.position = position
            battle_member.stats = monster
            monsters.append(battle_member)
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
        current_member = party[index]
        _select_player_action()
    else:
        Events.end_battle()

func _execute_attacks() -> void:
    _reset_highlighting()
    for attack in attacks:
        if attack.attacker.alive:
            if attack is PhysicalAttack:
                yield(attack.attacker.physical_attack(attack.target), 'completed')
            elif attack is MagicAttack:
                yield(attack.attacker.magic_attack(attack), 'completed')
    attacks.clear()
    current_member = _first_living_member()
    _select_player_action()

func _select_monster_actions() -> void:
    for monster in monsters:
        var attack = monster.select_attack(party)
        attacks.append(attack)

func _select_player_action(highlight_index := 0) -> void:
    fight_menu.visible = true
    current_member.active = false
    _reset_highlighting()
    _highlight_current_member()
    fight_menu_buttons.get_child(highlight_index).grab_focus()

func _highlight_current_member() -> void:
    for member in party:
        var alpha = 0.5
        if member == current_member:
            alpha = 1
        member.modulate.a = alpha

func _reset_highlighting() -> void:
    for member in party:
        member.modulate.a = 1

func _start_physical_attack() -> void:
    fight_menu.visible = false
    current_member.start_physical_attack(monsters)

func _select_magic_attack() -> void:
    magic_menu.load_magic_skills(current_member.stats.magic_skills)

func _start_magic_attack(magic_skill : MagicSkill) -> void:
    fight_menu.visible = false
    magic_menu.visible = false
    current_member.start_magic_attack(magic_skill, party, monsters)

func _start_special_attack() -> void:
    fight_menu.visible = false
    current_member.start_special_attack()

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
