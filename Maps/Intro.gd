extends Control

func _ready():
    SoundManager.play_music("nostalgia theme (upbeat)", true, true, false, 1)

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
   
func press_skip_text():
    for i in 10:
        yield(get_tree().create_timer(.5), "timeout")
        Input.action_press("skip_text") ## ???
