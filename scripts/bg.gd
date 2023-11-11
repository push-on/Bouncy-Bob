extends ParallaxBackground

@onready var sprite: Sprite2D = $ParallaxLayer/Sprite2D
@export var speed: int = 20
@export var bg_texture: CompressedTexture2D = preload("res://assets/Background/Brown.png")


func _ready() -> void:
	sprite.texture = bg_texture

func _process(delta: float) -> void:
	sprite.region_rect.position += delta * Vector2(speed, speed)
	if sprite.region_rect.position >= Vector2(64, 64):
		sprite.region_rect.position = Vector2.ZERO

