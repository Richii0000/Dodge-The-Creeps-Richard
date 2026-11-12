extends Node

const SETTINGS_PATH = "user://settings.cfg"

var num_players = 1

# Ajustes
var volume = 100        # 0 a 100
var muted = false
var fullscreen = false
var difficulty = 1      # 0 = Fàcil, 1 = Normal, 2 = Difícil
var zen_mode = false

func _ready():
	load_settings()
	apply_settings()

func apply_settings():
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear2db(volume / 100.0))
	AudioServer.set_bus_mute(bus, muted or volume == 0)
	OS.window_fullscreen = fullscreen

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.set_value("audio", "muted", muted)
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("game", "difficulty", difficulty)
	config.set_value("game", "zen_mode", zen_mode)
	config.save(SETTINGS_PATH)

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err != OK:
		return  # La primera vez no existe el archivo: se usan los valores por defecto
	volume = config.get_value("audio", "volume", 100)
	muted = config.get_value("audio", "muted", false)
	fullscreen = config.get_value("video", "fullscreen", false)
	difficulty = config.get_value("game", "difficulty", 1)
	zen_mode = config.get_value("game", "zen_mode", false)
