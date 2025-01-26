extends Node2D

var can_shoot = true  # Controla si puede disparar

# Se ejecuta cada frame
func _process(delta):
	# Mueve la mirilla a la posición del mouse
	position = get_viewport().get_mouse_position()

# Detecta el clic del mouse
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if can_shoot:
			shoot()  # Llama al método de disparo
			can_shoot = false  # Bloquea el disparo
			# Espera 0.5 segundos antes de permitir el siguiente disparo
			await get_tree().create_timer(0.5).timeout  # Cambié yield por await
			can_shoot = true  # Permite disparar de nuevo

# Método que simula un disparo
func shoot():
	print("¡Disparo realizado en la posición: ", position)
	# Aquí puedes agregar código para crear un proyectil, o cualquier otra acción
