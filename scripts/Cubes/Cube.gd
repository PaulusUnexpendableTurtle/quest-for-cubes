extends Area2D

export (int) var WEIGHT
export (int) var REDROP_CHANCE

export (int) var LIFE
var life

func _ready():
	life = LIFE
	$AnimatedSprite.play()


func set_layer(number):
	collision_layer = 1 << number
func set_masks(masks):
	collision_mask = 0
	for mask in masks:
		collision_mask |= 1 << mask


export (String) var type = "Cube"

func set_sprite(frames):
	$AnimatedSprite.stop()
	$AnimatedSprite.frames = frames
	$AnimatedSprite.play()

func set_sprite_by_paths(paths, fps):
	var new = SpriteFrames()
	new.add_animation("default")
	new.set_animation_loop("default", true)
	new.set_animation_speed("default", fps)
	
	for path in paths:
		var img = ImageTexture()
		img.load(path)
		new.add_frame("default", img)
	
	$AnimatedSprite.stop()
	$AnimatedSprite.frames = new
	$AnimatedSprite.play("default")


signal destroyed
signal damage(amount)

func change_life(amount):
	print("change life of " + str(self) + ": " + str(amount))
	life = clamp(life + amount, 0, LIFE)
	if life == 0:
		emit_signal("destroyed")
