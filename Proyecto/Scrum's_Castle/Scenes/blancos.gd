class_name Blancos extends Area2D

signal muerto

@export var speed = 70

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	emit_signal("muerto")
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
