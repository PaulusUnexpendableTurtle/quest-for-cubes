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
