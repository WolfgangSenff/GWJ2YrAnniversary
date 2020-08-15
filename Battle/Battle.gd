extends Node2D

const BattleMember = preload("res://Battle/BattleMember.tscn")
const PLAYER_X = 10
const PLAYER_Y = 10
const MONSTER_X = 80
const MONSTER_Y = 10
const Y_SPACING = 20

var party : Array
var monsters : Array


func _ready() -> void:
    _load_party()
    _load_monsters()


func _unhandled_key_input(event):
    if Input.is_action_just_pressed("ui_accept"):
        Events.end_battle()


# Load the party members into the battle scene from the
# Party.members array.
func _load_party() -> void:
    var position = Vector2(PLAYER_X, PLAYER_Y)
    for member in Party.members:
        var battle_member = BattleMember.instance()
        add_child(battle_member)
        battle_member.position = position
        battle_member.load_attacker(member)
        party.append(battle_member)
        position.y += Y_SPACING


# Load monsters from the Event parameters into the scene.
# Before loading the battle scene, a MonsterGroup resource
# must first be stored into the `parameters` variable.
func _load_monsters() -> void:
    var position = Vector2(MONSTER_X, MONSTER_Y)
    var monster_group : MonsterGroup = Events.parameters
    for monster in monster_group.monsters:
        monster.hp = monster.max_hp
        monster.mp = monster.max_mp
        var battle_member = BattleMember.instance()
        add_child(battle_member)
        battle_member.position = position
        battle_member.load_attacker(monster)
        monsters.append(battle_member)
        position.y += Y_SPACING
        
    
