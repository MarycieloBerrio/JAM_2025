extends CharacterBody2D
signal hit

@export var speed: float = 200
@export var jump_force: float = -300
@export var gravedad: float = 500
@export var repulsion_force: float = 1000  # Fuerza de repulsión

var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	velocity.x = 0
	# Movimiento horizontal
	if Input.is_action_pressed("Move_right"):
		velocity.x += speed
	if Input.is_action_pressed("Move_left"):
		velocity.x -= speed

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0

	# Salto
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_force
		$AnimatedSprite2D.play("jump")  # Reproduce la animación de salto

	# Mover al personaje
	move_and_slide()

	# Mantener al personaje dentro de los límites de la pantalla
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	# Lógica de animaciones
	update_animation()

func update_animation() -> void:
	if not is_on_floor():
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")  # Cambia a animación de salto
	elif velocity.x != 0:
		if $AnimatedSprite2D.animation != "walk":
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		if $AnimatedSprite2D.animation != "static":
			$AnimatedSprite2D.play("static")  # Cambia a animación estática

func _on_body_entered(body: Node2D) -> void:
	# Detecta si es la plataforma y aplica repulsión
	if body.is_in_group("platform"):  # Asegúrate de añadir la plataforma al grupo "platform"
		apply_repulsion(body)

	emit_signal("hit", body)

# Aplica la fuerza de repulsión al jugador
func apply_repulsion(platform: Node2D) -> void:
	# Obtener la dirección de la repulsión
	var direction = (position - platform.position).normalized()  # Dirección hacia atrás desde la plataforma
	velocity += direction * repulsion_force * get_physics_process_delta_time()
