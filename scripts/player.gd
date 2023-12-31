extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = calculate_velocity()
	
	play_animation(velocity)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func play_animation(velocity):
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func calculate_velocity():
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	return velocity

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(_body):
	hide()
	hit.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)
