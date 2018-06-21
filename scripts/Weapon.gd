extends "res://scripts/CubeHolder.gd"

export (int) var START_WEIGHT
var weight

export (int) var START_LIFE
var base_life

func _ready():
	prepare_array()
	
	weight = START_WEIGHT
	base_life = START_LIFE
	
	var cubes = $CubeContainer.get_children()
	for cube in cubes:
		$CubeContainer.remove_child(cube)
		add_cube(cube.position / cell_size, cube)


func add_cube(point, cube):
	var ret = .add_cube(point, cube)
	
	if ret == false:
		return ret
	
	if ret != null:
		weight -= ret.WEIGHT
		base_life -= ret.LIFE
	
	weight += cube.WEIGHT
	base_life += cube.LIFE
	
	return ret


func remove_cube(point):
	var ret = .remove_cube(point)
	
	for cube in ret:
		weight -= cube.WEIGHT
		base_life -= cube.LIFE
	
	return ret


signal destroyed

var life
var max_life
func reset_life(amount):
	max_life = amount
	life = max_life

func change_life(amount):
	life = clamp(life + amount, 0, max_life)
	if life == 0:
		emit_signal("destroyed")
