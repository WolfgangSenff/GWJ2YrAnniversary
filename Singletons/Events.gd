extends Node

const TILE_SIZE = 64
const DOG_SIZE = 32
const DOG_COLLISION_Y = 26
const father_time = preload("res://Characters/Monsters/Groups/FatherTime.tres")

var current_map = "OutsideLevel"
var player_position = Vector2(258, 256)
# Used to pass a variable from one scene to the next
var parameters
var final_battle = false

# Loads a new map.
#   map_name: The name of the scene to load sans .tscn. If
#           you are loading "res://Maps/World.tscn",
#           just use "World".
#   tileemap_coordinates: Where the player should be placed
#           on the new map.
#   direction: The direction the player should be facing. E.g.
#           if go up through a door, it should equal Vector2.UP.
func change_map(map_name : String, tilemap_coordinates : Vector2, direction : Vector2) -> void:
    # TODO: Direction isn't used yet because the tilemaps we have are two
    # different sizes. Later we can use this to make sure the dog sprite is
    # facing the proper direction and that the bottom (or top/left/right) of the
    # sprite is flush against the tile in map 2 (map_name).
    current_map = map_name
    Party.direction = direction
    player_position = tilemap_coordinates * TILE_SIZE
    var y_offset := 0
    var x_offset := TILE_SIZE / 2.0
    
    player_position.x += x_offset
    if direction.y:
        x_offset = TILE_SIZE / 2.0
        y_offset += TILE_SIZE - 1 if direction.y < 0 else DOG_COLLISION_Y + 1
    player_position.y += y_offset
    var _e = get_tree().change_scene('res://Maps/' + map_name + '.tscn')


# Loads the battle scene
#   monster_group: The MonsterGroup to you are going to battle
func start_battle(monster_group : MonsterGroup) -> void:
    parameters = monster_group
    player_position = Party.position
    var _e := get_tree().change_scene('res://Battle/Battle.tscn')

func start_final_battle() -> void:
    final_battle = true
    start_battle(father_time)

func end_battle():
    for member in Party.members:
        member.in_battle = false
    var _e := get_tree().change_scene('res://Maps/' + current_map + '.tscn')
