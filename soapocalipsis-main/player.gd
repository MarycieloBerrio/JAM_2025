extends CharacterBody2D
signal hit

@export var speed: float = 200
@export var jump_force: float = -300
@export var gravedad: float = 500
@export var repulsion_force: float = 300  # Fuerza de repulsión

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
	handle_collisions()

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


func handle_collisions() -> void:
	# Detectar si colisiona con un StaticBody2D
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()  # Obtiene el objeto colisionado
		if collider and collider.has_method("repel_player"):
			collider.repel_player(self)
