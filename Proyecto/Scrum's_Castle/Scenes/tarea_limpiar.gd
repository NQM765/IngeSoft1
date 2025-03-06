extends Node2D
class_name Tarea1

# Señal que se emitirá al completar la tarea.
signal tarea_completada

var items_recogidos: int = 0
var total_items: int = 6  # Ajusta al número de objetos que tengas

@onready var timer_cambio: Timer = $Timer_cambio

func _ready() -> void:
	
	set_z_index(100)
	# Configuración inicial de visibilidad según el estado de cofre2_acepto.
	if Datos.cofre_acepto:
		set_process(true)
		show()
	else:
		hide()
		set_process(false)
		
	if Datos.tarea1_eliminada:  # O Datos.tarea2_eliminada según corresponda.
		queue_free()
	
	# Conectar cada objeto del contenedor al grupo "tarea2_items" y su señal "item_collected"
	for item in $Container.get_children():
		if item is Area2D:
			item.add_to_group("tarea1_items")
			if not item.is_connected("item_collected", Callable(self, "_on_item_collected")):
				item.connect("item_collected", Callable(self, "_on_item_collected"))

func _process(delta: float) -> void:
	if TimerData.timer_iniciado and TimerData.tiempo_restante <= 0 and items_recogidos < total_items and Datos.estados_tareas[0] != "Completado" and Datos.estados_tareas[0] != "Fallido":
		print("Tiempo agotado en Tarea 1. Marcando como Fallido.")
		Datos.actualizar_estado_tarea(0, "Fallido")
		TimerData.detener_timer()
		
		# Marca la tarea como eliminada para que no se vuelva a mostrar.
		Datos.tarea1_eliminada = true

		get_tree().root.remove_child(self)
		queue_free()

func _on_item_collected(child_node: Node) -> void:
	print("Grupos del objeto:", child_node.get_groups())
	# Si el objeto pertenece al grupo y la tarea aún no está fallida:
	if child_node.is_in_group("tarea1_items") and Datos.estados_tareas[0] != "Fallido":
		items_recogidos += 1
		print("Recogiste un objeto de Tarea 1. Total =", items_recogidos)
		# Si se han recogido todos los ítems, se marca la tarea como completada y se emite la señal.
		if items_recogidos >= total_items:
			Datos.actualizar_estado_tarea(0, "Completado")
			print("¡Tarea 1 completada!")
			emit_signal("tarea_completada")
