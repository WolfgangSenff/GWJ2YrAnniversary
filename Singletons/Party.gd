extends Node

const Dogtective = preload("res://Characters/Players/Dogtective.tscn")
const Slippers = preload("res://Characters/Players/Slippers.tscn")
const Meester = preload("res://Characters/Players/Meester.tscn")

var members : Array
var position : Vector2
var direction : Vector2
var cheeze := 250
var walking_sound_name : String = "walk on grass"

func _ready():
    direction = Vector2.DOWN
    members.append(Dogtective.instance())
    members.append(Slippers.instance())
    members.append(Meester.instance())

func give_xp(xp : int) -> void:
    for member in members:
        if member.alive:
            member.add_xp(xp)

