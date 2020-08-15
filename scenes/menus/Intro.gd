extends BaseMenu


export(NodePath) var MainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Timer.connect("timeout", self, "main_menu")
	$Timer.start()

func main_menu():
	if get_node(MainMenu)==null:
		printerr("Attempt to switch to null menu!")
		assert(false)
	emit_signal("change_to",get_node(MainMenu))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
