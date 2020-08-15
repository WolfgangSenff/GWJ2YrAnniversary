extends Node

const TILE_SIZE = 32
const DOG_SIZE = 16

var player_position = Vector2(148, 148)

func change_map(map_name : String, tilemap_coordinates : Vector2, _direction : Vector2) -> void:
    # TODO: Direction isn't used yet because the tilemaps we have are two
    # different sizes. Later we can use this to make sure the dog sprite is
    # facing the proper direction and that the bottom (or top/left/right) of the
    # sprite is flush against the tile in map 2 (map_name).
    player_position = tilemap_coordinates * TILE_SIZE
    player_position.x += TILE_SIZE / 2.0
    player_position.y += TILE_SIZE / 2.0
    var _e = get_tree().change_scene('res://Maps/' + map_name + '.tscn')
