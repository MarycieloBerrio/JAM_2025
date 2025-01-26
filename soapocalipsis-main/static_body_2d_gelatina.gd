extends StaticBody2D
@export var repulsion_force: float = 300

func repel_player(player: CharacterBody2D) -> void:
	var direction = (player.global_position - global_position).normalized()
	player.velocity += direction * repulsion_force
