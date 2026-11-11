extends Node

export(PackedScene) var mob_scene
var score1 = 0
var score2 = 0
var alive1 = false
var alive2 = false

func _ready():
	randomize()
	$HUD.setup(Global.num_players)

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

	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
