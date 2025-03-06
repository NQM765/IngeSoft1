extends Control

@onready var button3 = $VBoxContainer/Button3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Control.tscn")
	
func _on_button_3_pressed():
	if button3:
		button3.disabled = true  # Deshabilita el botón para evitar reapertura accidental
	else:
		print("Error: button3 es null")
		return  # Evita continuar si hay error
		
	var tutorial_scene = load("res://instrucciones.tscn")
	if not tutorial_scene:
		print("Error: No se encontró la escena instrucciones.tscn")
		return
	var instance = tutorial_scene.instantiate()
	get_tree().root.add_child(instance)  # Agrega la escena correctamente
	instance.connect("tree_exited", _on_tutorial_closed)  # Detecta cuando se cierra la escena

func _on_tutorial_closed():
	if button3:
		button3.disabled = false  # Reactiva el botón cuando la escena se cierre
	else:
		print("Error: button3 es null al intentar activarlo nuevamente.")
