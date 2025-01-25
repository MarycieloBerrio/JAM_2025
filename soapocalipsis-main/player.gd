extends CharacterBody2D
signal hit

@export var speed: float = 200
@export var jump_force: float = -300
@export var gravedad: float = 500
#var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2

# Se llama cuando el nodo entra al árbol de la escena por primera vez
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Se llama en cada frame de física
func _physics_process(delta: float) -> void:
	# Resetear la velocidad horizontal
	velocity.x = 0

	# Movimiento horizontal
	if Input.is_action_pressed("Move_right"):
		velocity.x += speed
	if Input.is_action_pressed("Move_left"):
		velocity.x -= speed

	# Aplicar gravedad si no estamos en el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0  # Reiniciar velocidad vertical al estar en el suelo

	# Salto
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force

	# Mover al personaje
	move_and_slide()

	# Mantener al personaje dentro de los límites de la pantalla
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Animaciones y flip horizontal
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "static"

# Manejar colisiones con otros cuerpos
func _on_body_entered(body: Node2D) -> void:
	emit_signal("hit", body)

# Reiniciar posición del jugador
func start(pos: Vector2) -> void:
	position = pos
	$CollisionShape2D.disabled = false
