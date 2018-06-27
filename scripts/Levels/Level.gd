extends Node2D

#If level is complete, players may enter one of next levels
#If PvP, no other levels are in

export (Vector2) var TEAM_1_START
export (Vector2) var TEAM_2_START
export (Vector2) var TEAM_3_START
export (Vector2) var TEAM_4_START

var teams = [[], [], [], []]

func _ready():
	for button in $Buttons.get_children():
		button.connect("pressed", self, "on_Button_pressed", [button])
		button.connect("unpressed", self, "on_Button_unpressed", [button])
	
	for player in $Players.get_children():
		player.connect("damage_dealt_to", self, "show_damage")
		player.connect("dead", self, "player_dies", [player])
		teams[player.TEAM - 1].append(player)
	
	for foe in $Foes.get_children():
		foe.connect("damage_dealt_to", self, "show_damage")
		foe.connect("dead", self, "foe_dies", [foe])


func start_game(players):
	for player in players:
		$Players.add_child(player)
		
		player.connect("damage_dealt_to", self, "show_damage")
		player.connect("dead", self, "player_dies", [player])
		
		if player.TEAM == 1:
			player.position = TEAM_1_START
		elif player.TEAM == 2:
			player.position = TEAM_2_START
		elif player.TEAM == 3:
			player.position = TEAM_3_START
		elif player.TEAM == 4:
			player.position = TEAM_4_START
	
	for foe in $Foes.get_children():
		foe.connect("request_players_positions", self, "response_players_positions", [foe])


func spawn(foe, position):
	var new = foe.instance()
	new.position = position
	$Foes.add_child(new)
	new.connect("damage_dealt_to", self, "show_damage")
	new.connect("dead", self, "foe_dies", [new])
	new.connect("request_players_positions", self, "response_players_positions", [new])


func on_Button_pressed(area, button):
	#override if necessary
	pass

func on_Button_unpressed(area, button):
	#override if necessary
	pass


func show_damage(amount, damaged_object):
	#show message dependent of style
	pass


signal loss(team)

func player_dies(player):
	$Players.remove_child(player)
	teams[player.TEAM - 1].erase(player)
	
	drop(player.cash, player.position)
	
	if teams[player.TEAM - 1].size() == 0:
		emit_signal("loss", player.TEAM)

func foe_dies(foe):
	$Foes.remove_child(foe)
	
	drop(foe.cash, foe.position)
	
	if $Foes.get_child_count() == 0:
		emit_signal("loss", 5)


func drop(cash, position):
	for c in cash:
		c.position = position
		c.scale = Vector2(0.5, 0.5)
		c.rotation = randf()
		c.set_masks([9])
		c.connect("area_entered", self, "collect_drop", [c])
		$Drops.add_child(c)

func collect_drop(area, drop):
	if $Drops.find_node(drop.name) == -1:
		return
	
	if drop.type == "Weapon":
		area.get_parent().add_weapon(drop)
	else:
		area.get_parent().collect_cube(drop)


func response_players_positions(delta, foe):
	var ans = []
	for player in $Players.get_children():
		ans.append(player.position)
	foe.catch_players_positions(ans, delta)
