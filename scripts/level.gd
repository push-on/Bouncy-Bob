extends Node2D
@onready var start: StaticBody2D = $start_position
@onready var player: CharacterBody2D = $player
@onready var touch_controles = $Thouch_Controles
@onready var exit_position: Area2D = $Exit
@onready var death_zone: Area2D = $DeathZone
@onready var hud: Control = $UI/HUD
@onready var ui: CanvasLayer = $UI
@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var level_time: int = 35
var timer_node: Node = null
var time_left: int
var win: bool = false


func _ready() -> void:
	# show touch controles on Android
	if DisplayServer.get_name() == "Android":
		touch_controles.show()
		hud.control_hint.hide()
	else:
		touch_controles.hide()

	# connect trap signal
	var traps: Array[Node] = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
	# connect exit signal
	exit_position.body_entered.connect(_on_exit_body_entered)
	# connect death signal
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	# Place Character
	reset_player()
	# Time Node
	time_left = level_time
	hud.set_time_lable(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level_Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()


func _on_level_timer_timeout():
	if not win:
		time_left -= 1
		hud.set_time_lable(time_left)
		if time_left < 0:
			audio_player.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_lable(time_left)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://sceans/start_menu.tscn")


func _on_trap_touched_player() -> void:
	audio_player.play_sfx("hurt")
	reset_player()


func reset_player() -> void:
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()


func _on_death_zone_body_entered(_body: Node2D) -> void:
	audio_player.play_sfx("hurt")
	reset_player()


func _on_exit_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_final_level or (next_level != null):
			exit_position.animate()
			player.active = false
			win = true
			audio_player.play_sfx("win")
			await get_tree().create_timer(1).timeout
			if is_final_level:
				ui.show_win_screen(true)
			else:
				
				get_tree().change_scene_to_packed(next_level)
