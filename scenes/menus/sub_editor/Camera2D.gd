extends Camera2D

func _input(event):
	if event is InputEventMouseButton && mouse_inside():
		if event.button_index == BUTTON_WHEEL_UP && zoom.x > 0.3:
			zoom -= Vector2(0.01, 0.01)
		if event.button_index == BUTTON_WHEEL_DOWN && zoom.x < 1:
			zoom += Vector2(0.01, 0.01)
		print(zoom)


func mouse_inside():
	var pos = get_viewport().get_mouse_position()
	var sz = get_viewport().get_visible_rect().size
	return pos.x >= 0 && pos.y >= 0 && pos.x <= sz.x && pos.y <= sz.y