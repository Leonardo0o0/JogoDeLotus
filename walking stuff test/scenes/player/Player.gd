extends Area2D

export (int) var speed = 400
var screensize
var velocity
var animation
var waslookinglast
signal hit

func _ready():
	screensize = get_viewport_rect().size
	animation = get_node("AnimatedSprite")
	animation.animation = "Idle"
	animation.play()
	

func _process(dt):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		waslookinglast = -1
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
		waslookinglast = 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	if velocity.length() > 0:
		animation.animation = "Walk"
		animation.flip_h = velocity.x < 0
		animation.flip_v = false
		if velocity.x == 0:
			animation.flip_h = waslookinglast == -1
	elif velocity.length() == 0:
		animation.animation = "Idle"
		animation.flip_h = waslookinglast == -1
		animation.flip_v = false
	position += velocity * dt
	position.x = clamp(position.x, 0, screensize.x) 
	position.y = clamp(position.y, 0, screensize.y)

func _on_Player_body_entered(body):
	emit_signal("hit")
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
