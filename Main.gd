extends Node2D

var current_score = 0
var current_level = 1
var last_level = 2

# The Main script/node handles all the game logic, so we listen to signals here
func _on_Collectable_coin_collected():
	print("player collected a coin")
	current_score = current_score + 1
	$HUD.update_score(current_score)

func _on_GoalArea_player_entered():
	print('Player entered goal, changing level!')
	# Remove the current level
	get_node('Level%s' % current_level).queue_free()
	current_level = current_level + 1
	# Load the next level if such exists
	if current_level <= last_level:
		var next_level = load('Level%s.tscn' % current_level)
		self.add_child(next_level.instance())
	else:
		print('There are no more levels!')
	

func connect_signals():
	print('Connecting signals to Main...')
	var collectables = get_tree().get_nodes_in_group("coin")
	for collectable in collectables:
		print('Collectables: ' + collectable.name)
		collectable.connect("collected_coin", self, "_on_Collectable_coin_collected")
	
	# There should only be one "LevelX" at any time, this needs to be dynamically selected here
	print('Current level when connecting goal signal: %s' % current_level)
	get_node('Level%s/GoalArea' % current_level).connect("player_entered", self, "_on_GoalArea_player_entered")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect all signals on start
	connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
