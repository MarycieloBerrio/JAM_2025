extends Node2D

@export var projectile_scene: PackedScene  # Escena del proyectil
@export var fire_rate: float = 1.5  # Tiempo en segundos entre disparos (cadencia)

var can_shoot: bool = true  # Controla si se puede disparar
var active_projectiles: Array = []  # Lista para rastrear los proyectiles activos

func _process(delta):
	# Actualiza la posición de la mirilla para que siga al mouse
	position = get_global_mouse_position()

func _input(event):
	# Detecta si el clic izquierdo del mouse fue presionado
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		shoot()

func shoot():
	if can_shoot and projectile_scene:
		spawn_projectile()
		can_shoot = false
		start_fire_rate_timer()

func spawn_projectile():
	# Instancia la escena del proyectil
	var projectile = projectile_scene.instantiate()
	# Posiciona el proyectil en la posición del mouse
	projectile.position = get_global_mouse_position()
	# Añade el proyectil como hijo del nodo principal
	get_tree().root.add_child(projectile)
	# Añade el proyectil a la lista de proyectiles activos
	print("Proyectil creado en la posición: ", projectile.position)

func start_fire_rate_timer():
	# Crea un temporizador para controlar la cadencia
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true  # Habilita nuevamente el disparo
