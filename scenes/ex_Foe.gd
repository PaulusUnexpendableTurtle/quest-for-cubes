extends "res://scripts/Characters/Foes/Foe.gd"

func _ready():
	pass


func decide(delta, passes):
	var angle = Vector2(0, -1).angle_to(player_position - position)
	rotate(get_rot_angle(angle - rotation), delta)
	move(player_position - position, delta)
	show_weapon()
