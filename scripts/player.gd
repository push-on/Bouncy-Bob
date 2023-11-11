extends CharacterBody2D
class_name Player

@export var gravity: int = 400
@export var jump_force: int = 300
@export var speed: int = 125
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const jump_max: int = 1
var jump_count: int = 0
var active: bool = true


func _physics_process(delta: float) -> void:
	var direction: float
# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		clampf(velocity.y, -500, 500)
	if active:
		# Jump
		if Input.is_action_just_pressed("jump") and jump_count < jump_max:
			jump_count += 1
			jump(jump_force)

		if is_on_floor():
			jump_count = 0
		# Left right movement
		direction = Input.get_axis("left", "right")
# Facing Player left right
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)


func jump(force: float):
	velocity.y = -force


func update_animations(x: float) -> void:
	# Animations
	if is_on_floor():
		if x == 0:
			animated_sprite.play("IDLE")
		else:
			animated_sprite.play("RUN")
	else:
		if velocity.y < 0 and jump_count < 1:
			animated_sprite.play("JUMP")

		elif velocity.y < 0 and jump_count < 2:
			animated_sprite.play("DOUBLE_JUMP")

		elif velocity.y > 0:
			animated_sprite.play("FALL")
