extends "res://scripts/CubeHolders/CubeHolder.gd"

func _ready():
	pass

func _on_ready():
	prepare_arrays()
	var cubes = $CubeContainer.get_children()
	for cube in cubes:
		$CubeContainer.remove_child(cube)
		add_cube(cube.position / cell_size, cube)

func add_cube(point, cube):
	print(point, cube)
	var ret = .add_cube(point, cube)
	print(ret)
	
	if ret != null && ret.type == "Impossible":
		return ret
	
	if ret != null:
		ret.disconnect("destroyed", self, "on_Cube_destroyed")
	cube.connect("destroyed", self, "on_Cube_destroyed", [point])
	
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
