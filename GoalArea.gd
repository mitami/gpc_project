extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_GoalArea_body_entered(body):
	print('Entered goal!')
	# Should emit event to increase level, or should that be on level load?
	# Should change the level. Pick level based on level label?
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
