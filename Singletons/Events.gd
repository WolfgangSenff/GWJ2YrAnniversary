extends Node

const TILE_SIZE = 32
const DOG_SIZE = 16

var current_map = "Outside"
var player_position = Vector2(148, 148)
var player_direction : Vector2
# Used to pass a variable from one scene to the next
var parameters

# Loads a new map.
#   map_name: The name of the scene to load sans .tscn. If
#           you are loading "res://Maps/World.tscn",
#           just use "World".
#   tileemap_coordinates: Where the player should be placed
#           on the new map.
#   direction: The direction the player should be facing. E.g.
#           if go up through a door, it should equal Vector2.UP.
func change_map(map_name : String, tilemap_coordinates : Vector2, _direction : Vector2) -> void:
    # TODO: Direction isn't used yet because the tilemaps we have are two
    # different sizes. Later we can use this to make sure the dog sprite is
    # facing the proper direction and that the bottom (or top/left/right) of the
    # sprite is flush against the tile in map 2 (map_name).
    current_map = map_name
    player_position = tilemap_coordinates * TILE_SIZE
    player_position.x += TILE_SIZE / 2.0
    player_position.y += TILE_SIZE / 2.0
    var _e = get_tree().change_scene('res://Maps/' + map_name + '.tscn')


# Loads the battle scene
#   monster_group: The MonsterGroup to you are going to battle
func start_battle(monster_group : MonsterGroup) -> void:
    parameters = monster_group
    player_position = Party.position
    player_direction = Party.direction
    var _e := get_tree().change_scene('res://Battle/Battle.tscn')    


func end_battle():
    var _e := get_tree().change_scene('res://Maps/' + current_map + '.tscn')
