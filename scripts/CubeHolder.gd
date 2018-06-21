extends KinematicBody2D

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


func _ready():
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

var cell_size = 40

func add_cube(point, cube):
	if !check_bounds(point + CENTER):
		return false
	
	var found = point == Vector2(0, 0) && get_cube(CENTER) == null
	for d in directions:
		if get_cube(point + CENTER + d) != null:
			found = true
		if found:
			break
	if !found:
		return false
	
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
		if !dfs(point + d):
			ans = ans + remove_all(point + d)
	
	rebuild_collision_shape()
	
	return ans


var dfs_count = 0
var used = [[]]

func dfs(point):
	dfs_count += 1
	return inn_dfs(point)

func inn_dfs(v):
	if v == CENTER:
		return true
	used[v.x][v.y] = dfs_count
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
		ans = ans + remove_all(v + d)
	
	return ans


func rebuild_collision_shape():
	var ans = []
	for i in range(SIZE.x):
		for j in range(SIZE.y):
			if cubes[i][j] != null:
				dfs_count += 1
				insert_to_shape(Vector2(i, j), TOP, ans)
				break
	skip_extra(ans)
	$CollisionPolygon2D.polygon = PoolVector2Array(ans)


func insert_to_shape(v, orient, ans):
	used[v.x][v.y] = dfs_count
	
	var diag = rot(orient, 0).x * rot(orient, 0).y != 0
	
	if diag:
		ans.append(vertex(v, rot(orient, 4)) + rot(orient, 7) * margin)
	
	for i in range(7):
		var dir = rot(orient, i + 5)
		if !has_free_cube(v + dir):
			ans.append(vertex(v, dir))
			continue
		if dir.x * dir.y != 0:
			ans.append(vertex(v, dir) + rot(orient, i + 2) * margin)
		insert_to_shape(v + dir, i + 5, ans)
		if dir.x * dir.y != 0:
			ans.append(vertex(v, dir) + rot(orient, i) * margin)
	
	if diag:
		ans.append(vertex(v, rot(orient, 4)) + rot(orient, 1) * margin)


func skip_extra(arr):
	#skips dots which are literally between its neighbors
	pass


func has_free_cube(v):
	return check_bounds(v) && get_cube(v) != null && used[v.x][v.y] != dfs_count

func rot(orient, i):
	return directions[(orient + i) % 8]

var margin = 0.25

func vertex(coords, shift):
	return (coords + shift * 0.5) * cell_size - shift * margin

func check_bounds(point):
	return 0 <= point.x < SIZE.x && 0 <= point.y < SIZE.y

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
