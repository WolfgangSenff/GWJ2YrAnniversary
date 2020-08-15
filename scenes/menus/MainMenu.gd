extends BaseMenu


func _ready():
	for child in $VBoxContainer.get_children():
		if child is Button:
			child.connect("pressed",self,child.get_name()+"Pressed")



func btnQuitPressed():
	get_tree().quit()
