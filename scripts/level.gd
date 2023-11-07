extends Node2D

@onready var start_position = $Start_Position
@onready var player = $player


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):  # esc
		get_tree().quit()

	if Input.is_action_just_pressed("reset"):  # f1
		get_tree().reload_current_scene()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	reset_player()


func _on_trap_touched_player() -> void:
	reset_player()

func reset_player() -> void:
	player.velocity = Vector2.ZERO
	player.global_position = start_position.global_position
