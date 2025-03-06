extends Area2D

signal item_collected(node)  # Avisará a la escena (TareaLimpiar) que el objeto fue recogido

@export var object_id: String = ""  # ID único para cada objeto (aparece en el Inspector)

func _ready():
	# 1) Verifica si ya fue recogido antes
	if ObjetosRecogidos.is_collected(object_id):
		queue_free()  # Si ya estaba en la lista, se destruye de inmediato
	else:
		# 2) Conectar la señal de colisión para detectar al jugador
		connect("body_entered", Callable(self, "_on_body_entered"))

# Al interactuar con el objeto:
func _on_body_entered(body):
	if body.name == "Player":
		ObjetosRecogidos.mark_as_collected(object_id)
		emit_signal("item_collected", self)  # <--- Emite el nodo
		queue_free()




		
