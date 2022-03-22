extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed = 200

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_input():
	velocity = Vector2()
	if(Input.is_action_pressed("MoveRight")):
		velocity.x += 1
	if(Input.is_action_pressed("MoveLeft")):
		velocity.x -= 1
	if(Input.is_action_pressed("MoveDown")):
		velocity.y += 1
	if(Input.is_action_pressed("MoveUp")):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
