extends "res://scripts/Characters/Character.gd"

func _ready():
	pass

export (int) var TEAM

func _on_ready():
	._on_ready()
	set_team_number(TEAM)


func press(action):
	return Input.is_action_pressed(action)

func get_rot_angle(angle):
	if abs(angle) > abs(2 * PI + angle):
		return 2 * PI + angle
	else:
		return angle

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			show_weapon()

func _process(delta):
	var angle = Vector2(0, -1).angle_to(get_viewport().get_mouse_position() - position)
	rotate(get_rot_angle(angle - rotation), delta)
	
	var v = Vector2()
	if press("ui_up"):
		v.y -= 1
	if press("ui_down"):
		v.y += 1
	if press("ui_left"):
		v.x -= 1
	if press("ui_right"):
		v.x += 1
	v = v.normalized()
	
	move(v, delta)
