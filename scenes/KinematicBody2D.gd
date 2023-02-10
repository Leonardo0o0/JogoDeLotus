extends KinematicBody2D

export(int) var speed = 10000
var velocity = Vector2()
var lastlook = Vector2()
onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

func _ready():
	lastlook.x = 1
	lastlook.y = 0
	animation.play("right idle")

func inputgetter():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	velocity = velocity.normalized() * speed
	
func moveanimate():
	if velocity.x == 0:
		lastlook.x = 0
		if velocity.y < 0:
			animation.play("up run")
			lastlook.y = -1
		else:
			animation.play("down run")
			lastlook.y = 1
	if velocity.y == 0:
		lastlook.y = 0
		if velocity.x > 0:
			lastlook.x = 1
			sprite.flip_h = false
			animation.play("right run")
		else:
			lastlook.x = -1
			sprite.flip_h = true
			animation.play("right run")
	if velocity.y != 0 and velocity.x != 0:
		lastlook.y = 0
		if velocity.x > 0:
			lastlook.x = 1
			sprite.flip_h = false
			animation.play("right run")
		else:
			lastlook.x = -1
			sprite.flip_h = true
			animation.play("right run")
			
func idleanimate():
	if lastlook.x == 0:
		if lastlook.y > 0:
			animation.play("down idle")
		if lastlook.y < 0:
			animation.play("up idle")
	elif lastlook.y == 0:
		if lastlook.x > 0:
			sprite.flip_h = false
			animation.play("right idle")
		else:
			lastlook.x = -1
			sprite.flip_h = true
			animation.play("right idle")
			
func _physics_process(delta):
	inputgetter()
	move_and_slide(velocity*delta)
	if velocity.y != 0 or velocity.x != 0:
		moveanimate()
	else:
		idleanimate()
		
	

