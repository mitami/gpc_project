extends Node2D

var current_score = 0

# The Main script/node handles all the game logic, so we listen to signals here
func _on_Collectable_coin_collected():
	print("player collected a coin")
	current_score = current_score + 1
	$HUD.update_score(current_score)

func _on_GoalArea_player_entered():
	print('Player entered goal, changing level!')
	

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect all signals on start
	var collectables = get_tree().get_nodes_in_group("coin")
	for collectable in collectables:
		print('Collectables: ' + collectable.name)
		collectable.connect("collected_coin", self, "_on_Collectable_coin_collected")
		
	$GoalArea.connect("player_entered", self, "_on_GoalArea_player_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
