extends CharacterBody2D

@export var gravity: int = 400
@export var jump_force: int = 200
@export var speed: int = 100
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		clampf(velocity.y, -300, 500)
# Left right movement
	var direction = Input.get_axis("left", "right")
	velocity.x = direction * speed
# Facing Player left right
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force * delta * 50

	move_and_slide()
	update_animations(direction)

func update_animations(direction):
	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("IDLE")
		else:
			animated_sprite.play("RUN")
	else:
		if velocity.y < 0:
			animated_sprite.play("JUMP")
		else:
			animated_sprite.play("FALL")
