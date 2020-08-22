extends HBoxContainer

onready var sniff_hint1 = $SniffHint
onready var sniff_hint2 = $SniffHint2
onready var sniff_hint3 = $SniffHint3
onready var sniff_hint4 = $SniffHint4
onready var sniff_hint5 = $SniffHint5
onready var sniff_hint6 = $SniffHint6
onready var sniff_hint7 = $SniffHint7

func _ready():
    SnifferPower.connect("update_sniffer_level", self, "_on_update_sniffer_level")
    _on_update_sniffer_level()

func _on_update_sniffer_level():
    var sniff_hint_children = get_children()
    for child in SnifferPower.current_sniffer_level + 2:
        if child < sniff_hint_children.size():
            if not sniff_hint_children[child].visible:
                sniff_hint_children[child].show()
    
    if sniff_hint_children and sniff_hint_children.size() > 0:
        var idx = 0
        for sniff_hint in sniff_hint_children:
            if SnifferPower.current_sniffables and idx < SnifferPower.current_sniffables.size() and SnifferPower.current_sniffables[idx]:
                sniff_hint.sniff_color = SnifferPower.current_sniffables[idx].SniffColor
            else:
                sniff_hint.sniff_color = Color.antiquewhite
            idx += 1
