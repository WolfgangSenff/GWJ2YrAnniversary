extends Node2D

func _ready():
    $TileMap/AStar2DExt.build_astar2d_map()
