extends Node

#enum SnifferLevelRecord { Fight, Memory, Investigation }

signal update_sniffer_level

const sniff_radius_growth_per_level = 64.0
var current_sniff_radius = 128.0
var current_sniffer_level = 0
var current_sniffables = [] setget set_current_sniffables

var sniffer_history = []

onready var sniff_timer = $Timer

func raise_sniffer_level():
#func raise_sniffer_level(record):
    #sniffer_history.push_back(record)
    current_sniffer_level += 1
    current_sniff_radius += sniff_radius_growth_per_level
    raise_sniffer_signal()
    
func raise_sniffer_signal():
    emit_signal("update_sniffer_level")
    
func set_current_sniffables(value):
    current_sniffables = value
    raise_sniffer_signal()
