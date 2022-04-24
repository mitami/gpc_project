extends Area2D

signal player_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_GoalArea_body_entered(body):
	print('Entered goal!')
	# Emit a signal and let Main script handle level changing
	emit_signal("player_entered")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
