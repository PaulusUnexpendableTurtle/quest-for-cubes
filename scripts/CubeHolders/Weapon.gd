extends "res://scripts/CubeHolders/CubeHolder.gd"

export (int) var WEIGHT
var weight

export (int) var LIFE
var life

func _ready():
	for cube in $CubeContainer.get_children():
		cube.collision_layer = 8
		cube.collision_mask = 16

func _on_ready():
	weight = WEIGHT
	life = LIFE
	._on_ready()

func add_cube(point, cube):
	var ret = .add_cube(point, cube)
	
	if ret != null && ret.type == "Impossible":
		return ret
	
	if ret != null:
		weight -= ret.WEIGHT
		life -= ret.LIFE
	
	weight += cube.WEIGHT
	life += cube.LIFE
	
	cube.collision_layer = 8
	cube.collision_mask = 16
	
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
