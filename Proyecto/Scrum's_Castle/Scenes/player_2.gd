class_name Player extends CharacterBody2D 

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
	
	var anim_name = ""
	# Play animations
	if Datos.estados_tareas[2] == "Fallido":
		print("Estado tarea es Fallido")
		if Datos.personajes_seleccionados[2] == "Cazadora":
			anim_name = "DeathC"
		elif Datos.personajes_seleccionados[2] == "Mago":
			anim_name = "DeathM"
		elif Datos.personajes_seleccionados[2] == "Granjero":
			anim_name = "DeathG"
		elif Datos.personajes_seleccionados[2] == "Caballero":
			anim_name = "DeathK"
	else:
		print(Datos.personajes_seleccionados, "hola")
		# Si la velocidad es muy baja, se considera que está en Idle
		if velocity.length() < 1:
			if Datos.personajes_seleccionados[2] == "Cazadora":
				anim_name = "IdleC"
			elif Datos.personajes_seleccionados[2] == "Mago":
				anim_name = "IdleM"
			elif Datos.personajes_seleccionados[2] == "Granjero":
				anim_name = "IdleG"
			elif Datos.personajes_seleccionados[2] == "Caballero":
				anim_name = "IdleK"
		else:
			# En movimiento, se reproduce la animación de caminar (Walk)
			if Datos.personajes_seleccionados[2] == "Cazadora":
				anim_name = "WalkC"
			elif Datos.personajes_seleccionados[2] == "Mago":
				anim_name = "WalkM"
			elif Datos.personajes_seleccionados[2] == "Granjero":
				anim_name = "WalkG"
			elif Datos.personajes_seleccionados[2] == "Caballero":
				anim_name = "WalkK"
		
	
	animated_sprite.play(anim_name)
	
	# Check for sprint input
	if Input.is_action_pressed("sprint"):
		velocity = direction * move_speed * sprint_speed_multiplier
	else:
		velocity = direction * move_speed
	
	# move and slide function
	move_and_slide()

## a partir de aqui son funcionalidades del juego 
signal Flecha_disparada(flecha, location)

@onready var flecha = preload("res://Scenes/Flecha.tscn")

@onready var Posicion = $"Posición_disparo"

func _process(delta):
	if Input.is_action_just_pressed("Disparo"):
		Disparo()
		
func Disparo():
	print("Disparo ejecutado")
	Flecha_disparada.emit(flecha, Posicion.global_position)
	pass
