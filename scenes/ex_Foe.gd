extends "res://scripts/Characters/Foes/Foe.gd"

func _ready():
	pass

func decide(delta, passes):
	var angle = Vector2(0, -1).angle_to(players_positions[0] - position)
	rotate(get_rot_angle(angle - rotation), delta)
	move(players_positions[0] - position, delta)
	show_weapon()


var d = 1
var start_rot = -10 * PI

func victory_dance(delta, passes):
	if start_rot == -10 * PI:
		start_rot = rotation
	if abs(rotation - start_rot) > PI / 2:
		show_weapon()
		d = -d
	rotate(d, delta)