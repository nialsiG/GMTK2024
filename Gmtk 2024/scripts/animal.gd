class_name Animal extends CharacterBody2D

enum size { MICRO, SMALL, MEDIUM, LARGE, MEGA }

@export var current_size = size.MEDIUM
@export var current_speed = 100

@onready var axis = Vector2.ZERO

func _ready():
	match current_size:
		size.MICRO:
			scale = Vector2(0.64, 0.64)
		size.SMALL:
			scale = Vector2(0.8, 0.8)
		size.MEDIUM:
			scale = Vector2(1, 1)
		size.LARGE:
			scale = Vector2(1.2, 1.2)
		size.MEGA:
			scale = Vector2(1.44, 1.44)
		_:
			scale = Vector2(1, 1)

func _process(delta):
	pass

func _physics_process(delta):
	pass

func move():
	pass

func attack():
	pass

func hit(amount):
	pass

func die():
	pass

func increase_size():
	if current_size != size.MEGA:
		current_size += 1
		scale *= 1.2

func decrease_size():
	if current_size != size.MICRO:
		current_size -= 1
		scale *= 0.8
