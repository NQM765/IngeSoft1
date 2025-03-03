extends Control

@onready var label = $RichTextLabel  # Asegúrate de que el nombre del nodo es correcto
@onready var imagen = $TextureRect 

var full_text = "¡Bienvenido! En este juego tendrás que gestionar un equipo de personas con diferentes habilidades.
Se te asignarán un conjunto de tareas que debes completar en ## minutos. Debes estratégico al definir el integrante que realizará cada tarea.

Controles:"  # Texto completo a mostrar
var text_speed = 0.02  # Velocidad de escritura (en segundos por letra)

func _ready():
	imagen.visible = false  # Imagen oculta al inicio
	await escribir_texto(full_text)  # Esperar a que termine el texto
	imagen.visible = true  # Muestra la imagen al final
	
	var tween = get_tree().create_tween()
	tween.tween_property(imagen, "modulate", Color(1,1,1,1), 2.0)

func escribir_texto(texto):
	label.text = ""  # Limpia el texto antes de empezar
	for letra in texto:
		label.text += letra
		await get_tree().create_timer(text_speed).timeout  # Espera antes de la siguiente letra

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("key_e"):
		queue_free()

func _on_button_volver_pressed():
	queue_free()
