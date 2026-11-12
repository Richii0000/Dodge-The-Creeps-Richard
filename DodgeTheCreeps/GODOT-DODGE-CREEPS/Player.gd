extends Area2D

signal hit(player_id)

export var speed = 400
export var player_id = 1
export var input_prefix = "p1_"
export(SpriteFrames) var custom_frames
export var sprite_scale = Vector2(0.5, 0.5)

var screen_size
var alive = false

func _ready():
	screen_size = get_viewport_rect().size
	if custom_frames:
		$AnimatedSprite.frames = custom_frames
	$AnimatedSprite.scale = sprite_scale
	hide()

func _process(delta):
	if not alive:
		return

	var velocity = Vector2.ZERO
	if Input.is_action_pressed(input_prefix + "move_right"):
		velocity.x += 1
	if Input.is_action_pressed(input_prefix + "move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(input_prefix + "move_down"):
		velocity.y += 1
	if Input.is_action_pressed(input_prefix + "move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		if not $StepSound.playing:
			$StepSound.play()
	else:
		$AnimatedSprite.stop()
		$StepSound.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	if Global.zen_mode:
		return  # En modo Zen el jugador no puede morir

	alive = false
	hide()
	$StepSound.stop()
	$HitSound.play()
	emit_signal("hit", player_id)
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	alive = true
	show()
	$CollisionShape2D.disabled = false
