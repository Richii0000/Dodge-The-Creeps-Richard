extends Node

export(PackedScene) var mob_scene
var score1 = 0
var score2 = 0
var alive1 = false
var alive2 = false

var mob_min_speed = 150.0
var mob_max_speed = 250.0

func _ready():
	randomize()
	$HUD.setup(Global.num_players)
	apply_difficulty()

func apply_difficulty():
	match Global.difficulty:
		0:  # Fàcil
			$MobTimer.wait_time = 0.8
			mob_min_speed = 100.0
			mob_max_speed = 180.0
		1:  # Normal
			$MobTimer.wait_time = 0.5
			mob_min_speed = 150.0
			mob_max_speed = 250.0
		2:  # Difícil
			$MobTimer.wait_time = 0.3
			mob_min_speed = 220.0
			mob_max_speed = 350.0

func _unhandled_input(event):
	# Con Escape vuelves al menú (útil sobre todo en modo Zen)
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu.tscn")

func new_game():
	score1 = 0
	score2 = 0
	alive1 = true
	alive2 = (Global.num_players == 2)
	get_tree().call_group("mobs", "queue_free")

	if Global.num_players == 1:
		$Player1.start(Vector2(240, 450))
	else:
		$Player1.start($StartPosition1.position)
		$Player2.start($StartPosition2.position)

	$StartTimer.start()
	$HUD.update_score(score1, score2)
	if Global.zen_mode:
		$HUD.show_message("Mode Zen")
	else:
		$HUD.show_message("Get Ready")
	$Music.play()

func _on_player_hit(player_id):
	if player_id == 1:
		alive1 = false
	else:
		alive2 = false

	if not alive1 and not alive2:
		game_over()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()

	var result_text
	if Global.num_players == 1:
		result_text = "Score:\n" + str(score1)
	elif score1 > score2:
		result_text = "Guanya el\nJugador 1!"
	elif score2 > score1:
		result_text = "Guanya el\nJugador 2!"
	else:
		result_text = "Empat!"
	$HUD.show_game_over(result_text)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	if Global.zen_mode:
		return  # En modo Zen no hay puntuación
	if alive1:
		score1 += 1
	if alive2:
		score2 += 1
	$HUD.update_score(score1, score2)

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()

	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position

	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(rand_range(mob_min_speed, mob_max_speed), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
