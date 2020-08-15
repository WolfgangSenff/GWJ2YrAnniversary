extends Area2D

export (int) var max_steps
export (int) var min_steps
export (Array, Resource) var monster_groups

var steps_until_battle : int
var active := false

func _ready() -> void:
    var _e = connect("body_entered", self, "_on_body_entered")
    _e = connect("body_exited", self, "_on_body_exited")
    steps_until_battle = randi() % (max_steps - min_steps) + min_steps


# If the player is in this area, count down steps until 0,
# then start the battle.
func _process(_delta) -> void:
    if active:
        var left = Input.is_action_pressed("ui_left")
        var right = Input.is_action_pressed("ui_right")
        var up = Input.is_action_pressed("ui_up")
        var down = Input.is_action_pressed("ui_down")
        if left or right or up or down:
            _take_step()


# Counts down the number of steps. If it reaches 0, grab a
# random MonsterGroup and start the battle.
func _take_step() -> void:
    steps_until_battle -= 1
    if not steps_until_battle:
        var index = randi() % monster_groups.size()
        Events.start_battle(monster_groups[index])
    

func _on_body_entered(body : Dogtective) -> void:
    if body and body.is_in_group('Dogtective'):
        active = true


func _on_body_exited(body : Dogtective) -> void:
    if body and body.is_in_group('Dogtective'):
        active = false
