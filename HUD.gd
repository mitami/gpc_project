extends CanvasLayer

signal start_game
signal restart_level

func _on_StartButton_pressed():
	hide_buttons()
	emit_signal("start_game")
	
func _on_RestartButton_pressed():
	hide_buttons()
	emit_signal("restart_level")
	
func hide_buttons():
	$StartButton.hide()
	$RestartButton.hide()

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
