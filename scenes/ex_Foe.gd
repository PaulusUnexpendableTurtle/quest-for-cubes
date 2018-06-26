extends "res://scripts/Characters/Foes/Foe.gd"

func _ready():
	pass


func hit(area):
	print("Hit: " + str(area))
	.hit(area)


func get_rot_angle(angle):
	if abs(angle) > abs(2 * PI + angle):
		return 2 * PI + angle
	else:
		return angle

func decide(delta, passes):
	var angle = Vector2(0, -1).angle_to(player_position - position)
	rotate(get_rot_angle(angle - rotation), delta)
	
	show_weapon()
