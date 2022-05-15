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
	print('Changing level!')
	
	# First we check if the Player has collected all the coins in the level
	if current_score < score_target:
		return
	
	# Remove the current level
	var current_level_node = get_node('Level%s' % current_level)
	if current_level_node != null:
		current_level_node.queue_free()

	current_level = current_level + 1
	load_level(current_level)
	
	$PlayerCharacter.reset()
	$PlayerCharacter.start(false)
	$HUD.hide_buttons()

func load_level(level_number):
	$HUD.update_level(level_number)
	# Load the next level if such exists
	if level_number <= final_level:
		print('Loading level number: %s' % level_number)
		var next_level = load('Level%s.tscn' % level_number)
		self.add_child(next_level.instance())
		current_score = 0
		connect_signals()
	else:
		print('There are no more levels!')
		
func spawn_bullet(target):
	if can_shoot:
		var bullet = load('Bullet.tscn').instance()
		print('Adding bullet to level %s' % current_level)
		get_node('Level%s' % current_level).add_child(bullet)
		can_shoot = false
		bullet.connect('destroyed', self, 'on_bullet_destroyed')
		bullet.set_position($PlayerCharacter.get_position())
		bullet.set_target(target)
		
func on_bullet_destroyed():
	can_shoot = true
		
func restart_current_level():
	print("Restarting current level...")

	$HUD.hide_buttons()
	load_level(current_level)
	$PlayerCharacter.start(false)
	can_shoot = true
	$HUD/Message1.hide()

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
	can_shoot = false
	$PlayerCharacter.reset()
	$HUD/Message1.set_text("You died!")
	$HUD/Message1.show()
	$HUD/StartButton.show()
	$HUD/RestartButton.show()

func start_game():
	reset_game()
	game_started = true
	current_score = 0
	# We kind of hackily use the signal handler to instantiate the first level too.
	_on_GoalArea_player_entered()

	$PlayerCharacter.start(false) #(Vector2(0, 0))
	$HUD/Message1.hide()
	can_shoot = true
	
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
	
	# I have no idea how I managed to connect the HUD start_game in the editor, so this has to be done in script
	$HUD.connect("restart_level", self, "restart_current_level")
	
func determine_last_level():
	print('Checking how many levels have been created...')
	# We just iterate until we don't find a level file of the current number
	var file = File.new()
	var level_number = 1
	while (file.file_exists('Level%s.tscn' % level_number)):
		level_number = level_number + 1
	
	final_level = level_number - 1
	print('%s levels found' % final_level)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	determine_last_level()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if game_started:
		if Input.is_mouse_button_pressed(1):
			print('Trying to spawn a new bullet')
			spawn_bullet(get_local_mouse_position())
