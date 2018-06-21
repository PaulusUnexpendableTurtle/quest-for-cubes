extends Node

func _ready():
	for i in range($CubeFactory.types_count):
		materials_count.append(0)

var weapons = []
var materials_count = []

func add_item(item):
	if item.type == "Weapon":
		weapons.append(item)
	else:
		if item.type == "Wood":
			materials_count[$CubeFactory.WOOD] += 1
		elif item.type == "Stone":
			materials_count[$CubeFactory.STONE] += 1
		elif item.type == "Steel":
			materials_count[$CubeFactory.STEEL] += 1
		item.queue_free()


func make_cube(type):
	if materials_count[type] == 0:
		return null
	materials_count[type] -= 1
	return $CubeFactory.make_cube(type)
