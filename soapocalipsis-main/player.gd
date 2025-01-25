extends CharacterBody2D
signal hit

@export var speed: float = 200
@export var jump_force: float = -3000
@export var gravedad: float = 1500
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Resetear la velocidad horizontal
	velocity.x = 0

	# Movimiento horizontal
	if Input.is_action_pressed("Move_right"):
		velocity.x += speed
	if Input.is_action_pressed("Move_left"):
		velocity.x -= speed

	# Salto (activar animación justo al presionar la tecla)
	if Input.is_action_just_pressed("Jump"):
		print("Intentando saltar...")
		if is_on_floor():
			print("Está en el suelo, puede saltar.")
			velocity.y = jump_force
			print("velocity.y después de asignar jump_force:", velocity.y)
			$AnimatedSprite2D.play("jump")
		else:
			print("No está en el suelo, no puede saltar.")

	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0  # Reiniciar velocidad vertical al estar en el suelo

	# Mover al personaje (sin argumentos adicionales)
	move_and_slide()

	# Mantener al personaje dentro de los límites de la pantalla
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Reproducir otras animaciones
	update_animation()

# Manejar animaciones según el estado del personaje
func update_animation() -> void:
	if not is_on_floor():
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.play("static")

# Manejar colisiones con otros cuerpos
func _on_body_entered(body: Node2D) -> void:
	emit_signal("hit", body)

func start(pos: Vector2) -> void:
	position = pos
	$CollisionShape2D.disabled = false
