extends "res://scripts/Characters/Character.gd"

func _ready():
	time = 0
	for cube in $Body/CubeContainer.get_children():
		cube.collsion_layer = 2

func add_weapon(weapon):
	.add_weapon(weapon)
	weapon.collision_mask = 7

export (int) var TIME_PER_DECISION
var time

#link this signal to game scene to send player's position
signal request_player_position(delta)
var player_position

func catch_player_position(position, delta):
	var passes = floor(time / TIME_PER_DECISION)
	time %= TIME_PER_DECISION
	player_position = position
	decide(delta, passes)

func decide(delta, passes):
	#decides what to do
	#delta - time since last frame in sec
	#passes - limit of actions
	pass

func _process(delta):
	time += delta
	if time >= TIME_PER_DECISION:
		emit_signal("request_player_position", delta)
