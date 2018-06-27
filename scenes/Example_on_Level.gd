extends "res://scripts/Levels/Level.gd"

func _ready():
	start_game([])

var press_count = 0

func on_Button_pressed(area, button):
	press_count += 1
	if press_count == 2:
		$Drops/Steel.visible = true

func on_Button_unpressed(area, button):
	press_count -= 1
