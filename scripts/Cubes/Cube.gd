extends Area2D

export (int) var WEIGHT
export (int) var LIFE
var life

func _ready():
	pass

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

func change_life(amount):
	life = clamp(life + amount, 0, LIFE)
	if life == 0:
		emit_signal("destroyed")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
