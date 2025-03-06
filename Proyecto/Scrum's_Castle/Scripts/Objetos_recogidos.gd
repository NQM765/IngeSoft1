extends Node

signal task_completed  # Señal que se emitirá cuando se recojan todos los objetos

# Lista de IDs que el jugador ya recogió.
var collected_ids: Array = []

# Número total de objetos que deben recogerse para completar la tarea.
var total_required: int = 6

func is_collected(object_id: String) -> bool:
	return object_id in collected_ids

func mark_as_collected(object_id: String) -> void:
	if object_id not in collected_ids:
		collected_ids.append(object_id)
		# Si ya se han recogido la cantidad requerida, emitir la señal
		if collected_ids.size() >= total_required:
			emit_signal("task_completed")

func reset_collected():
	collected_ids.clear()
