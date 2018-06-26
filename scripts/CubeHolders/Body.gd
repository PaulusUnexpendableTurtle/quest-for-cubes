extends "res://scripts/CubeHolders/CubeHolder.gd"

func _ready():
	pass


func _on_ready():
	._on_ready()
	
	set_layer(9)
	set_masks([])


var team_number = 0
func set_team_number(number):
	team_number = number
	for column in cubes:
		for cube in column:
			if cube == null:
				continue
			cube.set_layer(number)
			cube.set_masks([])


func add_cube(point, cube):
	var ret = .add_cube(point, cube)
	
	if ret != null && ret.type == "Impossible":
		return ret
	
	if ret != null:
		ret.disconnect("destroyed", self, "on_Cube_destroyed")
	cube.connect("destroyed", self, "on_Cube_destroyed", [point])
	
	cube.set_layer(team_number)
	cube.set_masks([])
	
	return ret


func remove_cube(point):
	var ret = .remove_cube(point)
	for cube in ret:
		cube.disconnect("destroyed", self, "on_Cube_destroyed")
	return ret

var cash = []

signal body_changed
func rebuild_collision_shape():
	.rebuild_collision_shape()
	emit_signal("body_changed")

signal dead
func on_Cube_destroyed(point):
	cash = cash + remove_cube(point)
	if point == CENTER:
		emit_signal("dead")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
