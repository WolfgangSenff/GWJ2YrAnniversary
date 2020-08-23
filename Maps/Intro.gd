extends Control

onready var anim_player = $ViewportContainer/DogIntroScene/AnimationPlayer

func _ready():
    if !Party.position:
        Party.position = $ViewportContainer/DogIntroScene/YSortTileMap/Dogtective.position
    else:
        $ViewportContainer/DogIntroScene/YSortTileMap/Dogtective.position = Party.position
    anim_player.play("Intro")
    SoundManager.play_music("nostalgia theme (upbeat)", true, true, 1)

func press_down():
    Input.action_press("ai_down")

func stop_press_down():
    Input.action_release("ai_down")
    
func press_up():
    Input.action_press("ai_up")

func stop_press_up():
    Input.action_release("ai_up")
    
func press_left():
    Input.action_press("ai_left")

func stop_press_left():
    Input.action_release("ai_left")
    
func press_right():
    Input.action_press("ai_right")

func stop_press_right():
    Input.action_release("ai_right")

func _on_SkipIntroButton_pressed():
    $CanvasLayer/Control/VBoxContainer/SkipIntroButton.hide()
    $CanvasLayer/Control/VBoxContainer/NewGameButton.show()
    $CanvasLayer/Control/VBoxContainer/QuitButton.show()
    $CanvasLayer/Control/VBoxContainer/TextureRect.show()

func _on_NewGameButton_pressed():
    get_tree().change_scene("res://Maps/OutsideLevel.tscn")

func _on_QuitButton_pressed():
    get_tree().quit()
