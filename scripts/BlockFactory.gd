extends Node

func _ready():
	pass

export (PackedScene) var Wood
export (PackedScene) var Stone
export (PackedScene) var Steel

enum materials {
	WOOD,
	STONE,
	STEEL
}

func make_cube(material):
	if material == WOOD:
		return Wood.instance()
	if material == STONE:
		return Stone.instance()
	if material == STEEL:
		return Steel.instance()
