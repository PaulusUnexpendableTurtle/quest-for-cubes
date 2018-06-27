extends "res://scripts/Characters/Character.gd"

func _ready():
	pass


func _on_ready():
	time = 0
	._on_ready()
	set_team_number(5)


export (float) var TIME_PER_DECISION
var time

signal request_players_positions(delta)
var players_positions = []

func catch_players_positions(positions, delta):
	var passes = floor(time / TIME_PER_DECISION)
	time = time - passes * TIME_PER_DECISION
	players_positions = positions
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
