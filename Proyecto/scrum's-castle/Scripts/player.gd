extends CharacterBody2D

@export var move_speed : float = 100
@export var sprint_speed_multiplier : float = 2.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):

	# Get the input direction and handle the movement.
	var direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	# Flip the sprite
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true 

	# Play animations
	if PersonajeSeleccionado.personaje == "Cazadora":
		if  Datos.estado_tarea == "Fallido":
			animated_sprite.play("DeathC")
		elif direction.x == 0 and direction.y == 0:
			animated_sprite.play("IdleC")
		elif Input.is_action_pressed("sprint"):
			animated_sprite.play("SprintC")
		else:
			animated_sprite.play("WalkC")
	elif PersonajeSeleccionado.personaje == "Mago":
		if  Datos.estado_tarea == "Fallido":
			animated_sprite.play("DeathM")
		elif direction.x == 0 and direction.y == 0:
			animated_sprite.play("IdleM")
		elif Input.is_action_pressed("sprint"):
			animated_sprite.play("SprintM")
		else:
			animated_sprite.play("WalkM")
	
	# Check for sprint input
	if Input.is_action_pressed("sprint"):
		velocity = direction * move_speed * sprint_speed_multiplier
	else:
		velocity = direction * move_speed
	
	# move and slide function
	move_and_slide()
