extends Node

func _ready():
	pass

const Wood = preload("res://scenes/cubes/Wood.tscn")
const Stone = preload("res://scenes/cubes/Stone.tscn")
const Steel = preload("res://scenes/cubes/Steel.tscn")

enum materials {
	WOOD,
	STONE,
	STEEL
}

var types_count = 3

func make_cube(material):
	if material == WOOD:
		return Wood.instance()
	if material == STONE:
		return Stone.instance()
	if material == STEEL:
		return Steel.instance()
