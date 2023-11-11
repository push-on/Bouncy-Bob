extends StaticBody2D

@onready var spawn_pos = $spawn_position


func get_spawn_pos() -> Vector2:
	return spawn_pos.global_position
