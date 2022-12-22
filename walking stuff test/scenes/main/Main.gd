extends Node2D

export (PackedScene) var mobscene
var score

func _ready():
	randomize()
	new_game()
	

func gameover():
	$scoretimer.stop()
	$mobtimer.stop()
	
func new_game():
	score = 0
	$Player.start($start.position)
	$starttimer.start()
	

func _on_starttimer_timeout():
	$mobtimer.start()
	$scoretimer.start()

func _on_scoretimer_timeout():
	score += 1

func _on_mobtimer_timeout():
	var mob = mobscene.instance()
	var mobspawnlocation = get_node("mobspawner/spawnlocation")
	mobspawnlocation.offset = randi()
	
	var direction = mobspawnlocation.rotation + PI/2
	mob.position = mobspawnlocation.position
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var vel = Vector2(rand_range(150, 250), 0)
	mob.linear_velocity = vel.rotated(direction)
	
	add_child(mob)
