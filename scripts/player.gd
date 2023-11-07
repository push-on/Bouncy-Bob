extends CharacterBody2D
class_name Player

@export var gravity: int = 400
@export var jump_force: int = 300
@export var speed: int = 125
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		clampf(velocity.y, -500, 500)
# Jump
	if Input.is_action_just_pressed("jump"):
		jump(jump_force)
# Left right movement
	var direction: float = Input.get_axis("left", "right")
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
		if velocity.y < 0:
			animated_sprite.play("JUMP")
		else:
			animated_sprite.play("FALL")



