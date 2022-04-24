extends CanvasLayer

func update_score(score, max_score):
	$ScoreLabel.text = 'Score: %s / %s' % [score, max_score]
	
func update_level(level):
	$LevelLabel.text = 'Level: %s' % level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
