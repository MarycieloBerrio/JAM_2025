extends Node2D

@export var lifetime: float = 2.0  # Tiempo que el proyectil se muestra (en segundos)

func _ready():
	# Inicia un temporizador para eliminar el proyectil después de 'lifetime' segundos
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(lifetime).timeout
	queue_free()  # Elimina el proyectil después del tiempo defini
