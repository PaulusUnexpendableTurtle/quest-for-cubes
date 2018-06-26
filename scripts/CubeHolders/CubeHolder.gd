extends Area2D

export (Vector2) var SIZE
export (Vector2) var CENTER

var cubes = []
func get_cube(point):
	if check_bounds(point):
		return cubes[point.x][point.y]
	else:
		return null
func set_cube(point, value):
	cubes[point.x][point.y] = value


var cell_size = 40

func _ready():
	_on_ready()


func set_layer(number):
	collision_layer = 1 << number
	print("Layer of " + str(self) + ": " + str(collision_layer))
func set_masks(masks):
	collision_mask = 0
	for mask in masks:
		collision_mask |= 1 << mask
	print("Mask of " + str(self) + ": " + str(collision_mask))


func _on_ready():
	prepare_arrays()
	var cubes = $CubeContainer.get_children()
	for cube in cubes:
		$CubeContainer.remove_child(cube)
		add_cube(cube.position / cell_size, cube)

func prepare_arrays():
	for i in range(SIZE.x):
		cubes.append([])
		used.append([])
		for j in range(SIZE.y):
			cubes[i].append(null)
			used[i].append(false)

class Error:
	var type = "Impossible"

func add_cube(point, cube):
	if !check_bounds(point + CENTER):
		return Error.new()
	
	var found = point == Vector2(0, 0) && get_cube(CENTER) == null
	for d in directions:
		if get_cube(point + CENTER + d) != null:
			found = true
		if found:
			break
	if !found:
		return Error.new()
	
	cube.life = cube.LIFE
	cube.position = point * cell_size
	
	point = point + CENTER
	
	var ret = get_cube(point)
	set_cube(point, cube)
	$CubeContainer.add_child(cube)
	
	if ret != null:
		$CubeContainer.remove_child(ret)
	else:
		rebuild_collision_shape()
	
	return ret

var directions = [
	Vector2(+0, -1),
	Vector2(+1, -1),
	Vector2(+1, -0),
	Vector2(+1, +1),
	Vector2(-0, +1),
	Vector2(-1, +1),
	Vector2(-1, +0),
	Vector2(-1, -1)
]

enum direction_names {
	TOP,
	TOPRIGHT,
	RIGHT,
	BOTTOMRIGHT,
	BOTTOM,
	BOTTOMLEFT,
	LEFT,
	TOPLEFT
}

func remove_cube(point):
	point = point + CENTER
	
	if !check_bounds(point) || get_cube(point) == null:
		return []
	
	var ans = [get_cube(point)]
	
	$CubeContainer.remove_child(get_cube(point))
	set_cube(point, null)
	
	for d in directions:
		if has_free_cube(point + d) && !dfs(point + d):
			var t = remove_all(point + d)
			for e in t:
				ans.append(e)
	
	rebuild_collision_shape()
	
	return ans


var used = [[]]
func empty_used():
	for i in range(SIZE.x):
		for j in range(SIZE.y):
			used[i][j] = false

func dfs(point):
	empty_used()
	return inn_dfs(point)

func inn_dfs(v):
	if v == CENTER:
		return true
	used[v.x][v.y] = true
	for d in directions:
		if has_free_cube(v + d) && inn_dfs(v + d):
			return true
	return false


func remove_all(v):
	if !check_bounds(v):
		return []
	if get_cube(v) == null:
		return []
	
	var ans = [get_cube(v)]
	
	$CubeContainer.remove_child(get_cube(v))
	set_cube(v, null)
	
	for d in directions:
		var t = remove_all(v + d)
		for e in t:
			ans.append(e)
	
	return ans


func rebuild_collision_shape():
	var ans = []
	var found = false
	for i in range(SIZE.x):
		for j in range(SIZE.y):
			if cubes[i][j] != null:
				empty_used()
				insert_to_shape(Vector2(i, j), TOP, ans)
				found = true
				break
		if found:
			break
	skip_extra(ans)
	print(ans)
	$CollisionPolygon2D.polygon = PoolVector2Array(ans)


func insert_to_shape(v, orient, ans):
	used[v.x][v.y] = true
	
	var diag = rot(orient, 0).x * rot(orient, 0).y != 0
	
	if diag:
		ans.append(vertex(v, rot(orient, 4)) + rot(orient, 7) * margin)
	
	for i in range(8):
		var dir = rot(orient, i + 5)
		if !has_free_cube(v + dir):
			if i != 7:
				ans.append(vertex(v, dir))
			continue
		if dir.x * dir.y != 0:
			ans.append(vertex(v, dir) + rot(orient, i + 2) * margin)
		insert_to_shape(v + dir, (orient + i + 5) % 8, ans)
		if dir.x * dir.y != 0:
			ans.append(vertex(v, dir) + rot(orient, i) * margin)
	
	if diag:
		ans.append(vertex(v, rot(orient, 4)) + rot(orient, 1) * margin)


var eps = 0.0001
func skip_extra(arr):
	var include = []
	var size = arr.size()
	for i in range(size):
		var p = i - 1
		if p < 0:
			p += size
		var n = i + 1
		if n >= size:
			n -= size
		if abs(abs((arr[p] - arr[i]).angle_to(arr[n] - arr[i])) - PI) < eps:
			include.append(false)
		else:
			include.append(true)
	var pointer = 0
	for i in range(arr.size()):
		if include[i]:
			pointer += 1
		else:
			arr.remove(pointer)


func has_free_cube(v):
	return check_bounds(v) && get_cube(v) != null && !used[v.x][v.y]

func rot(orient, i):
	return directions[(orient + i) % 8]

var margin = 0.25

func vertex(coords, shift):
	return (coords - CENTER + shift * 0.5) * cell_size - shift * margin

func check_bounds(point):
	return 0 <= point.x && point.x < SIZE.x && 0 <= point.y && point.y < SIZE.y

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
