extends Area2D

signal collected_coin

func _on_Collectable_body_entered(body):
	# TODO: this should trigger some function in the scoreboard element
	print("Coin collided on.")
	emit_signal("collected_coin")
	queue_free()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
