extends CharacterBody2D

@export var final_destination: Vector2 = Vector2(93, 405)  # Punto específico donde debe llegar y quedarse
const SPEED = 200

@onready var nav_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

# Variable para almacenar la dirección actual (se usará para girar el sprite)
var current_direction: Vector2 = Vector2.ZERO

func _ready():
	print("Posición inicial del nodo:", global_position)
	set_process(true)  
	set_physics_process(true)  
	print("Script cargado correctamente en PlayerCh2") 
	print("Estado inicial de NavigationAgent2D:")
	print("  - Target Position:", nav_agent.target_position)
	print("  - ¿Ruta terminada?:", nav_agent.is_navigation_finished())
 

	nav_agent.navigation_finished.connect(_on_nav_finished)
	var result = nav_agent.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	if result == OK:
		print("✅ Señal velocity_computed conectada correctamente")
	else:
		print("❌ Error al conectar la señal velocity_computed, código:", result)

	# Establecer el destino final
	nav_agent.target_position = final_destination

func _physics_process(delta):
	
	if !nav_agent.is_navigation_finished():
		nav_agent.target_position = final_destination
	var tolerance = 5.0  # Ajusta según sea necesario

	# Si ya llegamos al destino, detenemos completamente el movimiento
	if position.distance_to(nav_agent.target_position) < tolerance:
		velocity = Vector2.ZERO  # Evita que el agente siga recalculando
		print("Llegó al destino. Deteniendo movimiento.")
		return  # Salimos para no seguir ejecutando código innecesario

	# Calculamos la siguiente posición y dirección
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()
	velocity = direction * SPEED
	nav_agent.set_velocity(velocity)


	nav_agent.velocity = velocity  # Asignamos la velocidad al agente

	print("Siguiente posición en la ruta:", next_path_pos)
	print("Velocidad calculada:", velocity)

	move_and_slide()
	print("🔹 Posición actual:", global_position, " | Destino:", nav_agent.target_position)
	print("🔹 ¿Ruta terminada?:", nav_agent.is_navigation_finished())
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true 
		
	var anim_name = ""
	# Play animations
	if Datos.estados_tareas[0] == "Fallido":
		print("Estado tarea es Fallido")
		if Datos.personajes_seleccionados[0] == "Cazadora":
			anim_name = "DeathC"
		elif Datos.personajes_seleccionados[0] == "Mago":
			anim_name = "DeathM"
		elif Datos.personajes_seleccionados[0] == "Granjero":
			anim_name = "DeathG"
		elif Datos.personajes_seleccionados[0] == "":
			anim_name = "DeathK"
	else:
		print(Datos.personajes_seleccionados, "hola")
		# Si la velocidad es muy baja, se considera que está en Idle
		if velocity.length() < 1:
			if Datos.personajes_seleccionados[0] == "Cazadora":
				anim_name = "IdleC"
			elif Datos.personajes_seleccionados[0] == "Mago":
				anim_name = "IdleM"
			elif Datos.personajes_seleccionados[0] == "Granjero":
				anim_name = "IdleG"
			elif Datos.personajes_seleccionados[0] == "Caballero":
				anim_name = "IdleK"
		else:
			# En movimiento, se reproduce la animación de caminar (Walk)
			if Datos.personajes_seleccionados[0] == "Cazadora":
				anim_name = "WalkC"
			elif Datos.personajes_seleccionados[0] == "Mago":
				anim_name = "WalkM"
			elif Datos.personajes_seleccionados[0] == "Granjero":
				anim_name = "WalkG"
			elif Datos.personajes_seleccionados[0] == "Caballero":
				anim_name = "WalkK"

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	print("Ejecutando _on_navigation_agent_2d_velocity_computed")
	# Actualizamos la velocidad del cuerpo respetando la interpolación hacia la velocidad "segura"
	velocity = velocity.move_toward(safe_velocity, 100)
	move_and_slide()
	print("Velocity:", velocity)


	# Voltear el sprite según la dirección de movimiento


func _on_nav_finished():
	# Cuando el agente llegue al destino, detenemos el movimiento
	velocity = Vector2.ZERO
	# Aquí puedes agregar lógica adicional si deseas, por ejemplo, reproducir una animación final o dete
