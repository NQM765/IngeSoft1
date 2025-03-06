extends Node2D

@onready var Playerpos = $PlayerSpawn
@onready var Contenedor_flechas = $Contenedor
@onready var btn_ir_a_tarea: Button = $CanvasLayer2/button_ir_a_tarea

var contador_blancos = 0
var blancos_objetivo = 3

signal tarea_completada3

func _ready() -> void:
	# Conectar la señal de disparo del Player (usando Callable para Godot 4)
	var player_node = get_node("Player")
	player_node.connect("Flecha_disparada", Callable(self, "_cuando_se_dispare"))
	player_node.global_position = Playerpos.global_position

	# Conectar la señal "muerto" de cada blanco
	$Blancos.connect("muerto", Callable(self, "_on_blanco_muerto"))
	$Blancos2.connect("muerto", Callable(self, "_on_blanco_muerto"))
	$Blancos3.connect("muerto", Callable(self, "_on_blanco_muerto"))

func _cuando_se_dispare(flecha, location):
	print("Se recibió la señal y se va a instanciar una flecha en: ", location)
	var disparo = flecha.instantiate()
	disparo.global_position = location
	Contenedor_flechas.add_child(disparo)


func _process(delta: float) -> void:
	if TimerData3.timer_iniciado and TimerData3.tiempo_restante <= 0 and contador_blancos < blancos_objetivo and Datos.estados_tareas[2] != "Completado" and Datos.estados_tareas[2] != "Fallido":
		print("Tiempo agotado en Tarea 3. Marcando como Fallido.")
		Datos.actualizar_estado_tarea(2, "Fallido")
		TimerData3.detener_timer()
		get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")

func _on_blanco_muerto():
	contador_blancos += 1
	print("Blancos eliminados: ", contador_blancos)
	

	if contador_blancos >= blancos_objetivo:
		Datos.actualizar_estado_tarea(2, "Completado")
		print("¡Tarea 3 completada!")
		TimerData3.detener_timer()
		Datos.cofre3_acepto = false
		Datos.tiempo_final_tarea3 = TimerData3.tiempo_restante
		emit_signal("tarea_completada3")
		get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")
		
		
		# Aquí tu lógica de tarea completada
func _on_button_ir_a_tarea_pressed() -> void:
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/tarea_actual.tscn")

	


	
