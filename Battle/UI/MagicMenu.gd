extends CenterContainer

const ItemButton = preload("res://UI/ItemButton.tscn")

onready var magic_menu_buttons = $NinePatchRect/MagicMenuButtons

signal menu_canceled()
signal magic_attack_selected(magic_attack)

func _ready():
    visible = false

func _unhandled_key_input(_event) -> void:
    if visible:
        if Input.is_action_just_pressed("ui_cancel"):
            _cancel()

func load_magic_skills(magic_skills : Array) -> void:
    if magic_skills:
        for child in magic_menu_buttons.get_children():
            magic_menu_buttons.remove_child(child)
            child.queue_free()
        for skill in magic_skills:
            var button = ItemButton.instance()
            button.text = skill._name + ': ' + str(skill.mp_used)
            button.connect("button_down", self, "_on_button_selected", [skill])
            magic_menu_buttons.add_child(button)
        magic_menu_buttons.get_child(0).grab_focus()
        visible = true
    else:
        _cancel()

func _on_button_selected(magic_skill : BaseMagicAttack):
    emit_signal("magic_attack_selected", magic_skill)

func _cancel() -> void:
    visible = false
    emit_signal("menu_canceled", 1)
