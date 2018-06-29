extends "res://scripts/Levels/Level.gd"

func _ready():
	start_game([])
	$Players/Player.print_inventory()
	$Foes/Foe.print_inventory()

var press_count = 0

func on_Button_pressed(area, button):
	press_count += 1
	if press_count == 2 && $Walls/Steel != null:
		$Walls/Steel.visible = true
		$Walls/Steel.set_layer(1)

func on_Button_unpressed(area, button):
	press_count -= 1


func _on_Steel_damage(amount):
	$Walls/Steel.change_life(-amount)

func _on_Steel_destroyed():
	$Walls.remove_child($Walls/Steel)
