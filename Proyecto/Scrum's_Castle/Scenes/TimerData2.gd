extends Node

var tiempo_restante: int = 0
var timer_iniciado: bool = false
var acumulador: float = 0.0  # Acumula delta para descontar segundos

signal timer_finalizado

func iniciar_timer(segundos: int):
	if not timer_iniciado:
		tiempo_restante = segundos
		timer_iniciado = true
		acumulador = 0.0
		set_process(true)  # Activamos el _process

func _process(delta):
	if timer_iniciado and tiempo_restante > 0:
		acumulador += delta
		if acumulador >= 1.0:
			var decrement = int(acumulador)
			tiempo_restante = max(tiempo_restante - decrement, 0)
			acumulador -= decrement
			print("Tick del Timer (process). Tiempo restante:", tiempo_restante)
	elif timer_iniciado and tiempo_restante <= 0:
		timer_iniciado = false
		set_process(false)
		emit_signal("timer_finalizado")
		print("Timer detenido")

func detener_timer():
	if timer_iniciado:
		timer_iniciado = false
		set_process(false)
		print("Timer detenido manualmente")
