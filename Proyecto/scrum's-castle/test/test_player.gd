extends GutTest

var player  # Cambié "Player" a "player" para mantener la consistencia con el resto del script.

func before_each():
	# Instanciar el nodo jugador con el script a probar.
	player = preload("res://Scripts/player.gd").new()
	add_child(player)
	
	# Crear un nodo AnimatedSprite2D simulado, ya que el script lo requiere.
	var anim_sprite = AnimatedSprite2D.new()
	anim_sprite.name = "AnimatedSprite2D"
	player.add_child(anim_sprite)
	
	# Configurar animaciones dummy para evitar errores al llamar a play().
	var frames = SpriteFrames.new()
	frames.add_animation("Idle")
	frames.add_animation("Walk")
	anim_sprite.frames = frames

func after_each():
	player.queue_free()

func test_movimiento_derecha():
	# Simular input: presionar "ui_right"
	Input.action_press("ui_right")
	# Llamar al _physics_process con delta = 1/60
	player._physics_process(1/60)
	# Se espera que la dirección sea (1,0), por lo que la velocidad debe ser igual a move_speed en x.
	var expected_velocity = Vector2(player.move_speed, 0)
	assert_eq(player.velocity, expected_velocity, "La velocidad debe ser igual a move_speed en dirección derecha")
	# Liberar el input simulado
	Input.action_release("ui_right")

func test_movimiento_idle():
	# No se simula ningún input; se espera estado idle.
	player._physics_process(1/60)
	var expected_velocity = Vector2.ZERO
	assert_eq(player.velocity, expected_velocity, "La velocidad debe ser cero cuando no hay input")
