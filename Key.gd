extends Area2D


func on_body_entered(body):
	if body.is_in_group("Player"):
		body.key = true
		queue_free()
