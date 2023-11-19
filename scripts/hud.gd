extends Control


func set_time_lable(value) -> void:
	$Time.text = "Time: " + str(value)


func _process(_delta: float) -> void:
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())

