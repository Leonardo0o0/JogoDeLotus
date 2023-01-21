extends KinematicBody2D

export(int) var speed = 10000
export(bool) var is_ded = false
export(int) var life
var velocity = Vector2()
var lastlook = Vector2()
onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
var didtheded = 0
var is_attacking = false


func _ready():
	lastlook.x = 1
	lastlook.y = 0
	animation.play("right idle")
	life = 3

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
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
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

func attackhandler():
	pass
	
func _on_animation_finished(anim_name):
	if anim_name == "ded":
		pass

func death_handler():
	"""
	A função realiza algumas atividades para lidar com a morte do jogador em conjunto com o else lá em baixo.
	
	1. toca a animação de morte
	2. desabilita checagem de input (efetivamente matando o desgramado)
	3. Troca sprite base para animação de dead idle
	"""
	if didtheded == 0:
		animation.play("ded")
		didtheded = 1
	else:
		animation.play("ded idle")
	
func _physics_process(delta):
	if is_ded == false:
		inputgetter()
		move_and_slide(velocity*delta)
		if velocity.y != 0 or velocity.x != 0:
			moveanimate()
		else:
			idleanimate()
		if is_attacking == true:
			attackhandler()
		if life <= 0:
			is_ded = true
			
	if is_ded == true: #Se estiver morto, he gets a fucking lights out :>
		death_handler()
	
			
