extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(winner_text):
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = winner_text
	$Message.show()
	yield(get_tree().create_timer(2), "timeout")

	$Message.text = "Dodge the\nCreeps!"
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()

func update_score(score1, score2):
	$ScoreLabel1.text = "P1: " + str(score1)
	$ScoreLabel2.text = "P2: " + str(score2)

func _on_StartButton_pressed():
	$ClickSound.play()
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
