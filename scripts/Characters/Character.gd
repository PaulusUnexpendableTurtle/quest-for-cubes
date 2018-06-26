extends KinematicBody2D


func _ready():
	_on_ready()


func _on_ready():
	_on_Body_body_changed()
	
	for cube in $Body/CubeContainer.get_children():
		cube.connect("damage", self, "damage_cube", [cube])
	
	var weapons = $WeaponHolder.get_children()
	for weapon in weapons:
		$WeaponHolder.remove_child(weapon)
		add_weapon(weapon)
	
	set_layer(6)
	set_masks([6])


var team_number = 0
func set_team_number(number):
	team_number = number
	$Body.set_team_number(number)
	for weapon in $Inventory.weapons:
		weapon.set_team_number(number)


func set_layer(number):
	collision_layer = 1 << number
func set_masks(masks):
	collision_mask = 0
	for mask in masks:
		collision_mask |= 1 << mask


func _on_Body_body_changed():
	count_stats()
	$BodyCollision_copy.polygon = $Body/CollisionPolygon2D.polygon


export (float) var MOMENTUM
export (float) var MASS
export (float) var HP
export (float) var ARMOR
export (float) var STRENGTH
export (float) var DMG
export (float) var WEAPON_HP
export (float) var SPEED
export (float) var LUCK


var armor
var hp
var mass
var momentum
var strength
var dmg
var weapon_hp
var speed
var luck


func count_stats():
	var arr = $Body.cubes
	
	momentum = MOMENTUM
	mass = MASS
	hp = HP
	armor = ARMOR
	strength = STRENGTH
	dmg = DMG
	weapon_hp = WEAPON_HP
	speed = SPEED
	luck = LUCK
	
	for i in range(arr.size()):
		for j in range(arr[i].size()):
			if arr[i][j] == null:
				continue
			
			var vector = Vector2(i, j) - $Body.CENTER
			var dist = vector.length()
			
			momentum += arr[i][j].WEIGHT * pow(dist, 2)
			mass += arr[i][j].WEIGHT
			
			if hp_upgrade(vector):
				hp += dist
			if armor_upgrade(vector):
				armor += dist
			if strength_upgrade(vector):
				strength += sqrt(dist)
			if dmg_upgrade(vector):
				dmg += dist
			if weapon_hp_upgrade(vector):
				weapon_hp += dist
			if speed_upgrade(vector):
				speed += dist
			if luck_upgrade(vector):
				luck += dist
	
	luck /= 42


func hp_upgrade(v):
	#returns true if cube on v upgrades hp
	return false

func armor_upgrade(v):
	#returns true if cube on v upgrades armor
	return false

func strength_upgrade(v):
	#returns true if cube on v upgrades strength
	return false

func dmg_upgrade(v):
	#returns true if cube on v upgrades dmg
	return false

func weapon_hp_upgrade(v):
	#returns true if cube on v upgrades weapon_hp
	return false

func speed_upgrade(v):
	#returns true if cube on v upgrades speed
	return false

func luck_upgrade(v):
	#returns true if cube on v upgrades luck
	return false


signal damage_dealt_to(amount, damaged_object)

func add_cube(point, cube):
	var ret = $Body.add_cube(point, cube)
	
	if ret == false:
		return ret
	
	if ret != null:
		ret.disconnect("damage", self, "damage_cube")
	cube.connect("damage", self, "damage_cube", [cube])
	
	return ret


func damage_cube(amount, cube):
	print(str(amount) + " " + str(cube))
	amount = clamp(amount - (armor + 5 * get_bonus()), 0, amount)
	cube.change_life(-amount)
	emit_signal("damage_dealt_to", amount, cube)


func remove_cube(point):
	var ret = $Body.remove_cube(point)
	for cube in ret:
		cube.disconnect("damage", self, "damage_cube")
	return ret


func move(direction, delta):
	direction = direction.normalized()
	position += direction * body_speed() * delta

func body_speed():
	return (2000 + speed * 30 + strength * 10) / (1 + mass) + 40 * get_bonus()


func rotate(angle, delta):
	var rot = rot_speed()
	if angle < 0:
		rotation += clamp(angle, -rot * delta, 0)
	else:
		rotation += clamp(angle, 0, rot * delta)

func rot_speed():
	return (2500 + speed * 50 + strength * 40) / (1000 + momentum) + 0.25 * get_bonus()


var active_weapon = 0

func add_weapon(weapon):
	$Inventory.weapons.append(weapon)
	
	weapon.connect("destroyed", self, "drop_weapon", [$Inventory.weapons.size() - 1])
	weapon.connect("area_entered", self, "hit")
	weapon.connect("damage", self, "damage_weapon", [weapon])
	
	weapon.set_team_number(team_number)


func damage_weapon(amount, weapon):
	amount = clamp(amount - (weapon_hp + 5 * get_bonus()), 0, amount) / 100
	weapon.change_life(-amount)
	emit_signal("damage_dealt_to", amount, weapon)


func hit(area):
	if correct_hit_target(area):
		var total_damage = count_damage()
		print("hit correct, dmg = " + str(total_damage))
		area.emit_signal("damage", total_damage)

func correct_hit_target(area):
	return has_signal(area, "damage")

func has_signal(area, signal_name):
	var t = area.get_signal_list()
	var ans = []
	for e in t:
		if e.name == signal_name:
			return true
	return false


func count_damage():
	return 10
	if $Inventory.weapons.size() > active_weapon:
		var mass_effect = mass / max(100 - 2 * strength, 1) + $Inventory.weapons[active_weapon].weight / 10
		return 10 * (1 + dmg + get_bonus()) + pow(speed, 2) * mass_effect
	return 0


var weapon_in_hand = false
var can_show_weapon = true
func _on_WeaponTimer_timeout():
	if weapon_in_hand:
		if $Inventory.weapons.size() > active_weapon:
			$WeaponHolder.remove_child($Inventory.weapons[active_weapon])
		weapon_in_hand = false
		$WeaponTimer.wait_time = weapon_cooldown()
		$WeaponTimer.start()
	else:
		can_show_weapon = true

func weapon_cooldown():
	if $Inventory.weapons.size() > active_weapon:
		return 0.1
		return 0.01 * $Inventory.weapons[active_weapon].weight / max(strength + 0.5 * speed, 1) - 0.05 * get_bonus()
	return 0.1


func show_weapon():
	if !can_show_weapon:
		return
	weapon_in_hand = true
	can_show_weapon = false
	#CENTER of Weapon is at the CENTER of Body - (0, 0)
	if $Inventory.weapons.size() > active_weapon:
		$WeaponHolder.add_child($Inventory.weapons[active_weapon])
	$WeaponTimer.wait_time = weapon_hold_time()
	$WeaponTimer.start()

func weapon_hold_time():
	if $Inventory.weapons.size() > active_weapon:
		return 0.5 + (strength + 0.5 * speed) / $Inventory.weapons[active_weapon].weight + 0.3 * get_bonus()
	return 0.5

var cash = []

func drop_weapon(weapon):
	#TODO: fix dis
	var t = $WeaponHolder.get_children()
	if t[0] == weapon:
		$WeaponHolder.remove_child(weapon)
	
	cash = cash + weapon.remove_cube(weapon.CENTER)
	
	weapon.disconnect("destroyed", self, "drop_weapon")
	weapon.disconnect("body_entered", self, "hit")
	weapon.disconnect("damage", self, "damage_weapon")
	
	weapon.queue_free()
	
	$Inventory.weapons.erase(weapon)
	
	if $Inventory.weapons.size() == active_weapon:
		active_weapon = max(active_weapon - 1, 0)


func end_fight():
	check_body_cash()
	for cube in cash:
		if redrops(cube):
			$Inventory.add_cube(cube)


func redrops(cube):
	return cube.REDROP_CHANCE * (1 + luck) >= randf()


func get_bonus():
	var roll = randf()
	if luck >= roll:
		return 1 + (luck - roll) * 2
	return 0


func check_body_cash():
	cash = cash + $Body.cash
	$Body.cash = []


signal dead
func die():
	check_body_cash()
	remove_cube($Body.CENTER)
	emit_signal("dead")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
