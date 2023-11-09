extends Node2D

@onready var start_position: Marker2D = $Start_Position
@onready var player: CharacterBody2D = $player
@onready var fps_lable: Label = $UI/FPS


func _ready() -> void:
	var traps: Array[Node] = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)


func _process(_delta: float) -> void:
	fps_lable.text = "FPS: " + str(Engine.get_frames_per_second())
	# Quit & Reset Level
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_trap_touched_player() -> void:
	reset_player()


func reset_player() -> void:
	player.velocity = Vector2.ZERO
	player.global_position = start_position.global_position


func _on_death_zone_body_entered(_body: Node2D) -> void:
	reset_player()
