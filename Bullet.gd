extends Area2D

signal destroyed

var speed = 2000
var target = Vector2(0, 0)
var direction = Vector2(0, 0)

func set_target(new_target):
	print('Setting new target...')
	target = new_target
	direction = position.direction_to(target)

func destroy():
	queue_free()
	emit_signal("destroyed")

# Called when the node enters the scene tree for the first time.
func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "destroy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + direction * delta * speed

func _on_Bullet_body_entered(body):
	# The bullet hit something, so let's destroy it
	destroy()
