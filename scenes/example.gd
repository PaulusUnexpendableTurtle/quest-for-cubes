extends Node2D

func _ready():
	$Button.connect("pressed", self, "on_Button_pressed", [$Button])
	$Button.connect("unpressed", self, "on_Button_unpressed", [$Button])
	$Button2.connect("pressed", self, "on_Button_pressed", [$Button2])
	$Button2.connect("unpressed", self, "on_Button_unpressed", [$Button2])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

var press_count = 0

func on_Button_pressed(area, button):
	press_count += 1
	if press_count == 2 && $Steel != null:
		$Steel.visible = true
		$Steel.set_layer(5)

func on_Button_unpressed(area, button):
	press_count -= 1


func _on_Steel_destroyed():
	remove_child($Steel)


func _on_Steel_damage(amount):
	$Steel.change_life(-amount)


func _on_Player_dead():
	remove_child($Player)


func _on_Foe_request_players_positions(delta):
	$Foe.catch_players_positions([$Player.position], delta)


func _on_Foe_dead():
	remove_child($Foe)
