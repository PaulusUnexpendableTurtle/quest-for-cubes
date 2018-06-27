extends Area2D

export (Texture) var UNPRESSED
export (Texture) var PRESSED

func _ready():
	$Sprite.texture = UNPRESSED

var press_count = 0

signal pressed(area)
func _on_Button_area_entered(area):
	if press_count == 0:
		$Sprite.texture = PRESSED
		emit_signal("pressed", area)
	press_count += 1

signal unpressed(area)
func _on_Button_area_exited(area):
	press_count -= 1
	if press_count == 0:
		$Sprite.texture = UNPRESSED
		emit_signal("unpressed", area)
