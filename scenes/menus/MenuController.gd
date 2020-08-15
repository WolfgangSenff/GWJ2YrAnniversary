extends Node2D

onready var camera = $Camera2D
export(Array, NodePath) var menu_array

var current_menu

func _ready():
	camera.current=true
	#Hide other menu's to prevent them from showing when we dont want them to
	#var node
	for node in get_children():
		if node is Control:
			node.visible = false
			node.connect("change_to",self,"change_to")
	
	change_to($Intro)


func change_to(node):
	if $TweenIn.is_active():
		printerr("Attempt to change menu while tween active")
		return
	
	if is_instance_valid(current_menu):
		$TweenOut.interpolate_property( current_menu,"rect_position",\
			current_menu.rect_position,\
			camera.position-Vector2(2000,0),\
			1,Tween.TRANS_CUBIC\
		)
		$TweenOut.start()
	
	current_menu = node
	node.visible = true
	node.rect_position = camera.position+Vector2(2000,0)
	$TweenIn.interpolate_property(node, "rect_position",node.rect_position,camera.position,1,Tween.TRANS_CUBIC)
	$TweenIn.start()

