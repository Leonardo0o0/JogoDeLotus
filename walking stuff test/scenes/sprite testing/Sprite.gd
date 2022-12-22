extends Sprite

var speed = 400
var angspeed = PI

func _process(delta):
	#deals with angle shit. Defines rotations and stuff
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	rotation += angspeed * direction * delta 
	#rotation is aparently some var from sprite, 
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed
	position += velocity * delta






