extends Node2D

var items_recogidos: int = 0
var total_items: int = 6  # Ajusta al número de objetos que tengas

@onready var panel_felicidad: Panel = $CanvasLayer/Panel_felicidades
@onready var timer_cambio: Timer = $Timer_cambio

# Guarda el valor anterior para detectar cambios en cofre_acepto
var prev_cofre_acepto = Datos.cofre_acepto

func _ready():
	set_z_index(100)
	print(Datos.cofre_acepto, "Tarea")
	# Configuración inicial de visibilidad según el valor actual de cofre_acepto
	if Datos.cofre_acepto:
		show()
	else:
		hide()
	
	panel_felicidad.hide()
	
	# Conectar la señal para cuando se complete la tarea (si se emite desde otro nodo)
	ObjetosRecogidos.connect("task_completed", Callable(self, "_on_task_completed"))
	timer_cambio.connect("timeout", Callable(self, "_on_TimerCambio_timeout"))
	
	# Conectar la señal item_collected de cada objeto (Area2D) hijo
	for child in get_children():
		if child is Area2D:
			child.connect("item_collected", Callable(self, "_on_item_collected"))
	
func _process(delta: float) -> void:
	move_to_front()
	# Actualiza la visibilidad en función de cofre_acepto
	if Datos.cofre_acepto != prev_cofre_acepto:
		if Datos.cofre_acepto:
			show()
		else:
			hide()
		prev_cofre_acepto = Datos.cofre_acepto
	
	# Si el timer está activo, se acabó el tiempo y la tarea no está completada,
	# se marca la tarea como "Fallido" y se cambia la escena.
	if TimerData.timer_iniciado and TimerData.tiempo_restante <= 0 and items_recogidos < total_items and Datos.estado_tarea != "Completado" and Datos.estado_tarea != "Fallido":
		print("Tiempo agotado sin completar la tarea. Marcando como Fallido.")
		Datos.estado_tarea = "Fallido"
		TimerData.detener_timer()
		TareaLimpiar.hide() 
		#get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	
func _on_item_collected():
	# Si la tarea ya se marcó como Fallida, no se procesan más objetos.
	if Datos.estado_tarea == "Fallido":
		return
	
	items_recogidos += 1
	print("Recogiste un objeto. Total =", items_recogidos)
	
	if items_recogidos >= total_items:
		print("¡Tarea completada! Recogiste todos los objetos.")
		_on_task_completed()  # Marca la tarea como completada

func _on_task_completed() -> void:
	print("Tarea completada, mostrando panel de felicitaciones")
	
	# Detener el timer global
	TimerData.detener_timer()
	
	# Actualizar el estado global a "Completado"
	Datos.estado_tarea = "Completado"
	
	panel_felicidad.show()
	timer_cambio.start()  # Inicia el temporizador para el cambio de escena

func _on_TimerCambio_timeout() -> void:
	print("Tiempo de felicitación terminado, cambiando de escena a TareaActual")
	panel_felicidad.hide()
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
	timer_cambio.stop()
