extends CanvasLayer

@onready var panel = $Panel  # Asegúrate de que la ruta sea correcta

func _ready():
	panel.hide()  # Ocultar el menú al inicio

func mostrar_menu():
	panel.show()  # Mostrar el menú
	get_tree().paused = true  # Pausar el juego

func ocultar_menu():
	panel.hide()  # Ocultar el menú
	get_tree().paused = false  # Reanudar el juego


	
