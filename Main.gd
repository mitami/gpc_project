extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_score = 0


func _on_Collectable_coin_collected():
	print("player collected a coin")
	current_score = current_score + 1
	$HUD.update_score(current_score)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find all Collectables
	var collectables = get_tree().get_nodes_in_group("coin")
	# Connect the signal to this score incrementer above
	for collectable in collectables:
		print('Collectables: ' + collectable.name)
		collectable.connect("collected_coin", self, "_on_Collectable_coin_collected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
