extends Node2D
class_name Tarea2

signal tarea_completada2

var items_recogidos: int = 0
var total_items: int = 5

@onready var timer_cambio: Timer = $Timer_cambio

func _ready() -> void:
	print("[DEBUG] TareaLimpiar2 inicializada")
	set_z_index(100)
	
	# Verificar si la tarea ya está eliminada al inicio
	if Datos.tarea2_eliminada:
		_ocultar_objetos()
	
	# Mostrar u ocultar según cofre2_acepto
	if Datos.cofre2_acepto:
		set_process(true)
		_mostrar_objetos()
	else:
		set_process(false)
		_ocultar_objetos()
	
	# Conectar señales de los objetos
	for item in $ContainerT2.get_children():
		if item is Area2D:
			item.add_to_group("tarea2_items")
			if not item.is_connected("item_collected", Callable(self, "_on_item_collected")):
				item.connect("item_collected", Callable(self, "_on_item_collected"))

func _process(delta: float) -> void:
	# Verificar en cada frame si la tarea está Fallida
	if Datos.estados_tareas[1] == "Fallido" and not Datos.tarea2_eliminada:
		print("Tarea 2 Fallida. Ocultando objetos.")
		Datos.tarea2_eliminada = true
		TimerData2.detener_timer()
		_ocultar_objetos()
		return
	
	# Lógica del timer (solo si no está Fallida)
	if (
		TimerData2.timer_iniciado 
		and TimerData2.tiempo_restante <= 0 
		and items_recogidos < total_items 
		and Datos.estados_tareas[1] != "Completado"
	):
		print("Tiempo agotado en Tarea 2. Marcando como Fallido.")
		Datos.actualizar_estado_tarea(1, "Fallido")

# Oculta los objetos y desactiva sus colisiones
func _ocultar_objetos():
	for item in $ContainerT2.get_children():
		if item is Area2D:
			item.hide()
			item.set_deferred("monitoring", false)  # Desactiva detección de colisiones

# Muestra los objetos y activa colisiones
func _mostrar_objetos():
	for item in $ContainerT2.get_children():
		if item is Area2D:
			item.show()
			item.set_deferred("monitoring", true)  # Reactiva colisiones

func _on_item_collected(child_node: Node) -> void:
	if child_node.is_in_group("tarea2_items") and Datos.estados_tareas[1] != "Fallido":
		items_recogidos += 1
		print("Recogiste un objeto de Tarea 2. Total =", items_recogidos)
		if items_recogidos >= total_items:
			Datos.actualizar_estado_tarea(1, "Completado")
			print("¡Tarea 2 completada!")
			Datos.emit_signal("tarea_completada2_global")
