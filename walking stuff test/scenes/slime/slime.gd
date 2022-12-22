extends RigidBody2D


func _ready():
	$AnimatedSprite.playing = true
	var mobtype = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mobtype[randi() % mobtype.size()]
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

