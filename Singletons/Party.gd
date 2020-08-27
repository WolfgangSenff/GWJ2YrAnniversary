extends Node

const Dogtective = preload("res://Characters/Players/Dogtective.tscn")
const Slippers = preload("res://Characters/Players/Slippers.tscn")
const Meester = preload("res://Characters/Players/Meester.tscn")

var members : Array
var position : Vector2
var direction : Vector2
var cheeze := 250
var walking_sound_name : String = "walk on grass"
var has_meester = false
var has_slippers = false

func _ready():
    direction = Vector2.DOWN
    members.append(Dogtective.instance())
    add_slippers()

func give_xp(xp : int) -> void:
    for member in members:
        if member.alive:
            member.add_xp(xp)
            
func add_meester():
    if !has_meester:
        members.append(Meester.instance())
        has_meester = true
    
func add_slippers():
    if !has_slippers:
        has_slippers = true
        members.append(Slippers.instance())

