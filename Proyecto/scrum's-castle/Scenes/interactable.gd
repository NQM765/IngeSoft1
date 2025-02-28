extends StaticBody2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	interactable.interact = _on_interact
	
func _on_interact():
	if animated_sprite_2d.animation == "close":
		animated_sprite_2d.play("open")
		collision_shape.disabled = true
		print("Door opened")
	elif animated_sprite_2d.animation == "open":
		animated_sprite_2d.play("close")
		collision_shape.disabled = false
		print("Door closed")
