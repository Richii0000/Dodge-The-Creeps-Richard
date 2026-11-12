extends Control

onready var volume_slider = $Options/VolumeRow/VolumeSlider
onready var volume_value = $Options/VolumeRow/VolumeValue
onready var mute_check = $Options/MuteCheck
onready var fullscreen_check = $Options/FullscreenCheck
onready var difficulty_option = $Options/DifficultyRow/DifficultyOption
onready var zen_check = $Options/ZenCheck

func _ready():
	# Opciones de dificultad
	difficulty_option.add_item("Fàcil")
	difficulty_option.add_item("Normal")
	difficulty_option.add_item("Difícil")

	# Mostrar los valores guardados
	volume_slider.value = Global.volume
	volume_value.text = str(Global.volume) + "%"
	mute_check.pressed = Global.muted
	fullscreen_check.pressed = Global.fullscreen
	difficulty_option.select(Global.difficulty)
	zen_check.pressed = Global.zen_mode

	volume_slider.grab_focus()

func _on_VolumeSlider_value_changed(value):
	Global.volume = int(value)
	volume_value.text = str(Global.volume) + "%"
	Global.apply_settings()
	Global.save_settings()

func _on_MuteCheck_toggled(button_pressed):
	Global.muted = button_pressed
	Global.apply_settings()
	Global.save_settings()

func _on_FullscreenCheck_toggled(button_pressed):
	Global.fullscreen = button_pressed
	Global.apply_settings()
	Global.save_settings()

func _on_DifficultyOption_item_selected(index):
	Global.difficulty = index
	Global.save_settings()

func _on_ZenCheck_toggled(button_pressed):
	Global.zen_mode = button_pressed
	Global.save_settings()

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
