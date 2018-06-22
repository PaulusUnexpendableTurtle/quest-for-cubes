extends "res://scripts/CubeHolders/CubeHolder.gd"

export (int) var WEIGHT
var weight

export (int) var LIFE
var life

func _ready():
	pass

func _on_ready():
	prepare_arrays()
	
	weight = WEIGHT
	life = LIFE
	
	var cubes = $CubeContainer.get_children()
	for cube in cubes:
		$CubeContainer.remove_child(cube)
		add_cube(cube.position / cell_size, cube)


func add_cube(point, cube):
	var ret = .add_cube(point, cube)
	
	if ret != null && ret.type == "Impossible":
		return ret
	
	if ret != null:
		weight -= ret.WEIGHT
		life -= ret.LIFE
	
	weight += cube.WEIGHT
	life += cube.LIFE
	
	return ret


func remove_cube(point):
	var ret = .remove_cube(point)
	
	for cube in ret:
		weight -= cube.WEIGHT
		life -= cube.LIFE
	
	return ret


signal destroyed
signal damage(amount)

func change_life(amount):
	life = clamp(life + amount, 0, LIFE)
	if life == 0:
		emit_signal("destroyed")
