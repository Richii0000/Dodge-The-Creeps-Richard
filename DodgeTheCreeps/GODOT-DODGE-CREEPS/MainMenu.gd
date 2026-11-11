extends Control

func _ready():
	$Buttons/SinglePlayerButton.grab_focus()

func _on_SinglePlayerButton_pressed():
	Global.num_players = 1
	get_tree().change_scene("res://Main.tscn")

func _on_LocalMultiButton_pressed():
	Global.num_players = 2
	get_tree().change_scene("res://Main.tscn")
