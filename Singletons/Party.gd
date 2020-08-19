extends Node

const dogtective = preload("res://Characters/Players/Dogtective.tres")
const frank = preload("res://Characters/Players/Frank.tres")
const mice_family = preload("res://Characters/Players/MiceFamily.tres")

var members : Array
var position : Vector2
var direction : Vector2

func _ready():
    direction = Vector2.DOWN
    members.append(dogtective)
    members.append(frank)
    members.append(mice_family)
