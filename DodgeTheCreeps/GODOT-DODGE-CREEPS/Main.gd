extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	new_game()  # Solo para probar (paso 72). Luego se quita.

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1

func _on_MobTimer_timeout():
	# Crea un enemigo nuevo
	var mob = mob_scene.instance()

	# Elige un punto aleatorio del camino
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Dirección hacia dentro de la pantalla
	var direction = mob_spawn_location.rotation + PI / 2

	# Coloca al enemigo en ese punto
	mob.position = mob_spawn_location.position

	# Un poco de aleatoriedad en la dirección
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Velocidad aleatoria entre 150 y 250
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Lo añade a la escena
	add_child(mob)
