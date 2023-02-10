extends KinematicBody2D

export(int) var speed = 10000
export(bool) var is_ded = false
export(int) var life
var key: bool = false;
var velocity = Vector2()
var lastlook = Vector2()
onready var animation = get_node("AnimationPlayer")
onready var attackcollision = get_node("Area2D/CollisionShape2D")
onready var sprite = get_node("Sprite")
var didtheded = 0
var is_attacking = false
var attacks = ["down sword", "up sword", "right sword"]

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
	if Input.is_action_just_pressed("suicide"):
		is_ded = true
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

func animate_attack():
	if lastlook.x == 0:
		if lastlook.y > 0:
			animation.play("down sword")
		if lastlook.y < 0:
			animation.play("up sword")
	elif lastlook.y == 0:
		if lastlook.x > 0:
			sprite.flip_h = false
			animation.play("right sword")
		else:
			lastlook.x = -1
			sprite.flip_h = true
			animation.play("right sword")

func colchanger():
	if lastlook.x == 0:
		if lastlook.y > 0:
			attackcollision.position = Vector2(0, 24)
			
		if lastlook.y < 0:
			attackcollision.position = Vector2(0, -7)
			
	elif lastlook.y == 0:
		if lastlook.x > 0:
			attackcollision.position = Vector2(16, 10)
			
		else:
			lastlook.x = -1
			attackcollision.position = Vector2(-16, 10)
			

func attackhandler():
	"""
	Lida com sistemas relacionados a atacar
	"""
	animate_attack()
	colchanger()
	
	
func _on_animation_finished(anim_name): #Looping animations make animations never end!
	if anim_name == "ded":
		pass
	if anim_name in attacks:
		is_attacking = false
		
func takedamage(damage):
	life = life - damage

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
		if is_attacking == false:
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
		else:
			attackhandler()
	elif is_ded == true: #Se estiver morto, he gets a fucking lights out :>
		death_handler()
	
			
