extends Node2D
@export var next_level: PackedScene = null

@onready var start: StaticBody2D = $start_position
@onready var player: CharacterBody2D = $player
@onready var fps_lable: Label = $UI/FPS
@onready var touch_controles = $Thouch_Controles
@onready var exit_position: Area2D = $Exit


func _ready() -> void:
	reset_player()
	# connect exit signal
	exit_position.body_entered.connect(_on_exit_body_entered)
	# show touch controles on Android
	if DisplayServer.get_name() == "Android":
		touch_controles.show()
	# connect trap signal
	var traps: Array[Node] = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)


func _on_exit_body_entered(body: Node2D) -> void:
	if body is Player:
		if next_level != null:
			exit_position.animate()
			player.active = false
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_packed(next_level)


func _process(_delta: float) -> void:
	fps_lable.text = "FPS: " + str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_trap_touched_player() -> void:
	reset_player()


func reset_player() -> void:
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()


func _on_death_zone_body_entered(_body: Node2D) -> void:
	reset_player()
