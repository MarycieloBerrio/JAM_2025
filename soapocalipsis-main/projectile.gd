extends Node2D

@export var lifetime: float = 2.0  # Tiempo que el proyectil se muestra (en segundos)

func _ready():
	# Inicia un temporizador para eliminar el proyectil después de 'lifetime' segundos
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(lifetime).timeout
	queue_free()  # Elimina el proyectil después del tiempo defini


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Asegúrate de que el nodo del personaje se llame "Player"
		print("El personaje tocó el proyectil. Reiniciando el nivel...")
		restart_level()
		
func restart_level():
	get_tree().reload_current_scene()
