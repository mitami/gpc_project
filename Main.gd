extends Node2D

var game_started = false

var current_score = 0
var score_target = 0
var current_level = 0
var final_level = 2

var can_shoot = true

# The Main script/node handles all the game logic, so we listen to signals here
func _on_Collectable_coin_collected():
	print("player collected a coin")
	current_score = current_score + 1
	$HUD.update_score(current_score, score_target)

func _on_GoalArea_player_entered():
	print('Player entered goal, changing level!')
	
	# First we check if the Player has collected all the coins in the level
	if current_score < score_target:
		return
	
	# Remove the current level
	var current_level_node = get_node('Level%s' % current_level)
	if current_level_node != null:
		current_level_node.queue_free()

	current_level = current_level + 1
	$HUD.update_level(current_level)
	# Load the next level if such exists
	if current_level <= final_level:
		var next_level = load('Level%s.tscn' % current_level)
		self.add_child(next_level.instance())
		current_score = 0
		connect_signals()
	else:
		print('There are no more levels!')
		
func spawn_bullet(target):
	if can_shoot:
		var bullet = load('Bullet.tscn').instance()
		get_node('Level%s' % current_level).add_child(bullet)
		can_shoot = false
		bullet.connect('destroyed', self, 'on_bullet_destroyed')
		bullet.set_position($PlayerCharacter.get_position())
		bullet.set_target(target)
		
func on_bullet_destroyed():
	can_shoot = true
		
func reset_game():
	print('Resetting game...')
	game_started = false
	
	var currently_loaded_level = get_node('Level%s' % current_level)
	if currently_loaded_level != null:
		currently_loaded_level.queue_free()
	
	current_score = 0
	current_level = 0
	score_target = 0
	$PlayerCharacter.reset()
	$HUD/StartButton.set_visible(true)

func game_over():
	print('Player died!')
	reset_game()

func start_game():
	game_started = true
	current_score = 0
	current_level = 0
	# We kind of hackily use the signal handler to instantiate the first level too.
	if current_level == 0:
		_on_GoalArea_player_entered()

	# Connect all signals on start
	# connect_signals()
	$PlayerCharacter.start(false) #(Vector2(0, 0))
	
func connect_signals():
	print('Connecting signals to Main...')
	# Coins
	var collectables = get_tree().get_nodes_in_group("coin")
	for collectable in collectables:
		collectable.connect("collected_coin", self, "_on_Collectable_coin_collected")
	
	# Goal
	get_node('Level%s/GoalArea' % current_level).connect("player_entered", self, "_on_GoalArea_player_entered")
	
	
	# Player leaving screen
	$PlayerCharacter/VisibilityNotifier2D.connect("screen_exited", self, "game_over")
	# Player colliding with an enemy
	$PlayerCharacter.connect("player_hit_by_enemy", self, "game_over")
	# Now when we already have the list of all collectables, we can use it to determine the maximum score
	score_target = collectables.size()
	$HUD.update_score(current_score, score_target)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if game_started:
		if Input.is_mouse_button_pressed(1):
			print('Trying to spawn a new bullet')
			spawn_bullet(get_local_mouse_position())
