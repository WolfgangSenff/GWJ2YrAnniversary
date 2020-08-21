extends Node2D

onready var dog = $YSort/Dogtective

#var random_sniffer_history = [SnifferPower.SnifferLevelRecord.Fight, SnifferPower.SnifferLevelRecord.Investigation, SnifferPower.SnifferLevelRecord.Memory]

func _ready():
    var current_sniffables = get_tree().get_nodes_in_group("Sniffable")
    dog.connect("sniffer_updated", self, "_on_sniffer_updated")
    dog.set_all_sniffables(current_sniffables)
    
func _on_sniffer_updated(sniffables):
    SnifferPower.current_sniffables = sniffables

# Temporary
func _on_Button_pressed():
    #SnifferPower.raise_sniffer_level(random_sniffer_history[randi() % random_sniffer_history.size()])
    SnifferPower.raise_sniffer_level()
