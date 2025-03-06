extends Area2D

@export var speed= 200


func _physics_process(delta):
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.

func _on_area_entered(area):
	if area is Blancos:
		area.die()
		queue_free()
		
