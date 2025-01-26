extends Area2D

@export var speed: float = 400.0
@export var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	# Mover el proyectil en la dirección especificada
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	# Verificar si colisionó con el jugador
	if area.name == "Player":
		# Llamar a la función de reinicio del jugador
		area.call("reset_position")
		# Eliminar el proyectil tras la colisión
		queue_free()
