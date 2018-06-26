extends Node2D

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Steel_destroyed():
	remove_child($Steel)


func _on_Steel_damage(amount):
	$Steel.change_life(-amount)


func _on_Player_dead():
	remove_child($Player)


func _on_Foe_request_player_position(delta):
	$Foe.catch_player_position($Player.position, delta)


func _on_Foe_dead():
	remove_child($Foe)
