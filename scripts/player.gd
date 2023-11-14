extends CharacterBody2D
class_name Player

@export var move_speed: int = 125
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready
var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = (
	((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1
)

const jump_max: int = 2  # Allow for double jump
var jump_count: int = 0
var double_jump_available: bool = true
var coyote_time: float = 0.3

var active: bool = true


func _physics_process(delta: float) -> void:
	var direction: float

	# Coyote Time
	if is_on_floor():
		coyote_time = 0.3
	else:
		coyote_time -= delta

	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		clampf(velocity.y, -500, 500)

	if active:
		# Jump
		if (
			(Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_time > 0.0))
			or (double_jump_available and Input.is_action_just_pressed("jump"))
		):
			jump_count += 1
			double_jump_available = false
			jump()

		if is_on_floor():
			jump_count = 0
			double_jump_available = true

		# Left right movement
		direction = Input.get_axis("left", "right")

	# Facing Player left right
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)

	velocity.x = direction * move_speed
	move_and_slide()
	update_animations(direction)


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func jump():
	velocity.y = jump_velocity


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
		elif velocity.y < 0 and jump_count == 1:
			animated_sprite.play("DOUBLE_JUMP")
		elif velocity.y > 0:
			animated_sprite.play("FALL")
