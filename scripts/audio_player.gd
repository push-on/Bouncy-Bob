extends Node

var hurt = preload("res://assets/audio/sfx_damage_hit10.wav")
var jump = preload("res://assets/audio/sfx_movement_jump13.wav")
var win = preload("res://assets/audio/sfx_sound_neutral11.wav")

func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	elif sfx_name == "win":
		stream = win
	else:
		print("invalid sfx name")
		return
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "sfx"
	asp.volume_db = -20
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
