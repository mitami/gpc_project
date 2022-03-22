extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed = 200

var walk_speed = 35
var jump_speed = -1000
var gravity = 2500
var slowdown = 1000

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_input():
	if(Input.is_action_pressed("MoveRight")):
		velocity.x += walk_speed
	if(Input.is_action_pressed("MoveLeft")):
		velocity.x -= walk_speed
	#if(Input.is_action_pressed("MoveDown")):
		#velocity.y += 1
	if(Input.is_action_pressed("MoveUp")):
		#velocity.y -= 1
		if is_on_floor():
			print("Was on floor")
			velocity.y = jump_speed
	#velocity = velocity.normalized() * speed
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if velocity.x < 0:
		velocity.x += slowdown * delta
		if velocity.x > 0:
			velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= slowdown * delta
		if velocity.x < 0:
			velocity.x = 0
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))
