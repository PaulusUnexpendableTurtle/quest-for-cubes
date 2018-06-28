extends "res://scripts/Characters/Foes/Foe.gd"

func _ready():
	pass


func decide(delta, passes):
	if players_positions.size() > 0:
		var angle = Vector2(0, -1).angle_to(players_positions[0] - position)
		rotate(get_rot_angle(angle - rotation), delta)
		move(players_positions[0] - position, delta)
		show_weapon()
	else:
		rotate(1, delta)
