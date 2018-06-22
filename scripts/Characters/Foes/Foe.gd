extends "res://scripts/Characters/Character.gd"

func _ready():
	._ready()
	time = 0

export (int) var MS_PER_DECISION
var time

#link this signal to game scene to send player's position
signal request_player_position
var player_position
func catch_player_position(position):
	player_position = position

func decide(delta):
	#decides what to do
	pass

func _process(delta):
	time += delta
	if time >= MS_PER_DECISION:
		emit_signal("request_player_position")
		while time >= MS_PER_DECISION:
			time -= MS_PER_DECISION
			decide(delta)
