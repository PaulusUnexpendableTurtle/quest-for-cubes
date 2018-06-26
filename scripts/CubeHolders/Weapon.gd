extends "res://scripts/CubeHolders/CubeHolder.gd"

export (float) var WEIGHT
var weight

export (float) var LIFE
var max_life
var life

func _ready():
	pass


func _on_ready():
	weight = WEIGHT
	max_life = LIFE
	life = max_life
	
	._on_ready()
	
	for column in cubes:
		for cube in column:
			if cube == null:
				continue
			cube.set_layer(8)
			cube.set_masks([])
	
	set_layer(7)


func set_team_number(number):
	var t = [1, 2, 3, 4, 5, 7]
	t.erase(number)
	set_masks(t)


func add_cube(point, cube):
	var ret = .add_cube(point, cube)
	
	if ret != null && ret.type == "Impossible":
		return ret
	
	if ret != null:
		weight -= ret.WEIGHT
		life *= (max_life - ret.LIFE) / max_life
		max_life -= ret.LIFE
	
	weight += cube.WEIGHT
	
	if max_life == 0:
		life = cube.LIFE
	else:
		life *= (max_life + cube.LIFE) / max_life
	
	max_life += cube.LIFE
	
	cube.set_layer(8)
	cube.set_masks([])
	
	return ret


func remove_cube(point):
	var ret = .remove_cube(point)
	
	for cube in ret:
		weight -= cube.WEIGHT
		life *= (max_life - cube.LIFE) / max_life
		max_life -= cube.LIFE
	
	return ret


signal destroyed
signal damage(amount)

func change_life(amount):
	print("change life of " + str(self) + ": " + str(amount))
	life = clamp(life + amount, 0, max_life)
	if life == 0:
		emit_signal("destroyed")
