extends CanvasLayer

signal start_game

var num_players = 2

func setup(players):
	num_players = players
	$ScoreLabel1.visible = not Global.zen_mode
	$ScoreLabel2.visible = (players == 2) and not Global.zen_mode

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(result_text):
	show_message("Game Over")
	yield($MessageTimer, "timeout")

	$Message.text = result_text
	$Message.show()
	yield(get_tree().create_timer(2), "timeout")

	$Message.text = "Dodge the\nCreeps!"
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$BackButton.show()

func update_score(score1, score2):
	if num_players == 1:
		$ScoreLabel1.text = "Score: " + str(score1)
	else:
		$ScoreLabel1.text = "P1: " + str(score1)
		$ScoreLabel2.text = "P2: " + str(score2)

func _on_StartButton_pressed():
	$ClickSound.play()
	$StartButton.hide()
	$BackButton.hide()
	emit_signal("start_game")

func _on_BackButton_pressed():
	$ClickSound.play()
	get_tree().change_scene("res://MainMenu.tscn")

func _on_MessageTimer_timeout():
	$Message.hide()
