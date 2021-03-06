extends KinematicBody2D

signal player_hit_by_enemy

export (int) var speed = 200

var walk_speed = 35
var jump_speed = -1000
var gravity = 2500
var slowdown = 1000
var freeze = true

var stop_on_next_animation_loop = false

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	# We hide the Player character until the user starts the game from the UI
	hide()

func start(pos):
	if pos:
		position = pos

	freeze = false
	show()

func reset():
	print('Setting Player position to 0,0')
	position = Vector2(0, 0)
	freeze = true
	velocity.y = 0
	velocity.x = 0
	hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_input():
	if(Input.is_action_pressed("MoveRight")):
		$Sprite.play()
		velocity.x += walk_speed
	if(Input.is_action_pressed("MoveLeft")):
		$Sprite.play()
		velocity.x -= walk_speed
	#if(Input.is_action_pressed("MoveDown")):
		#velocity.y += 1
	if(Input.is_action_pressed("MoveUp")):
		#velocity.y -= 1
		if is_on_floor():
			velocity.y = jump_speed
	#velocity = velocity.normalized() * speed
	
func _on_Sprite_animation_finished():
	if stop_on_next_animation_loop:
		$Sprite.stop()
		stop_on_next_animation_loop = false

func _physics_process(delta):
	if freeze:
		return
	velocity.y += gravity * delta
	if velocity.x < 0:
		velocity.x += slowdown * delta
		if velocity.x > 0:
			velocity.x = 0
			stop_on_next_animation_loop = true
	elif velocity.x > 0:
		velocity.x -= slowdown * delta
		if velocity.x < 0:
			velocity.x = 0
			stop_on_next_animation_loop = true
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))


func _on_Area2D_body_entered(body):
	if body.name == "Enemy":
		print('Collided with an enemy!')
		emit_signal("player_hit_by_enemy")
	else:
		print('Collided with something else than an Enemy')
