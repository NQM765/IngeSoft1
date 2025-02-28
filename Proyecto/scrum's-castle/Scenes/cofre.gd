extends Area2D  # O Area3D para 3D

@onready var menu = $CanvasLayer/Panel           # Menú original
@onready var btn_ir_a_tarea: Button = $CanvasLayer2/button_ir_a_tarea

func _ready():
	# Conectar la señal de colisión
	connect("body_entered", _on_body_entered)
	#menu.hide()                # Ocultar el menú al inicio
	btn_ir_a_tarea.hide()  
	if Datos.cofre_menu_mostrado:
		# En interacciones posteriores, ocultar el menú (por si estuviera visible) y mostrar el botón extra
		menu.hide()
		btn_ir_a_tarea.show()
		get_tree().paused = false      # Ocultar el botón extra al inicio

func _on_body_entered(body: Node):
	if body.name == "Player":
		# Si es la primera vez, mostrar el menú y marcar que ya se mostró
		if not Datos.cofre_menu_mostrado:
			mostrar_menu()
			Datos.cofre_menu_mostrado = true
# Pausar el juego para que se vea la UI

		
func mostrar_menu():
	menu.show()
	get_tree().paused = true
  # Pausar el juego

func ocultar_menu():
	menu.hide()
	get_tree().paused = false  # Reanudar el juego

func _on_button_si_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	


func _on_button_no_pressed():
	# Acción del botón "No": reanudar y ocultar el menú
	Datos.cofre_menu_mostrado = false
	get_tree().paused = false
	menu.hide()
	# Mostrar el botón extra para próximas interacciones

# Función para el botón extra, conectada a su señal "pressed"
func _on_button_ir_a_tarea_pressed():
	get_tree().paused = false
	TareaLimpiar.hide() 
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
