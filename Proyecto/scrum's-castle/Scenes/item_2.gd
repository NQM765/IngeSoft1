extends Area2D

signal item_collected  # Avisará a la escena (TareaLimpiar) que el objeto fue recogido

@export var object_id: String = ""  # ID único para cada objeto (aparece en el Inspector)

func _ready():
	# 1) Verifica si ya fue recogido antes
	if ObjetosRecogidos.is_collected(object_id):
		queue_free()  # Si ya estaba en la lista, se destruye de inmediato
	else:
		# 2) Conectar la señal de colisión para detectar al jugador
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		# 3) Marca el objeto como recogido en el Autoload
		ObjetosRecogidos.mark_as_collected(object_id)

		# 4) Emite señal local para avisar a la escena que se recogió
		emit_signal("item_collected")

		# 5) Se elimina de la escena para simular que se recogió
		queue_free()
