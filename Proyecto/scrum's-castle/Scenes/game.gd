extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Datos.cofre_acepto,"game")
	if Datos.cofre_acepto and Datos.estado_tarea != "Fallido":
		TareaLimpiar.show() 
	else:
		TareaLimpiar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
