class_name Animal extends CharacterBody2D

enum size { MICRO, SMALL, MEDIUM, LARGE, MEGA }

@export var current_size = size.MEDIUM
@export var current_speed = 500
@export var acceleration = 1500
@export var friction = 1200

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


func move(delta):
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
	else:
		apply_acceleration(acceleration * axis * delta)


func attack():
	pass

func hit(amount):
	pass

func die():
	pass



func apply_friction(amount):
	if velocity.length() >= amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
	print("decelerate")

func apply_acceleration(amount):
	velocity += amount
	velocity = velocity.limit_length(current_speed)
	print("accelerate")


func increase_size():
	print("size up")
	if current_size != size.MEGA:
		current_size += 1
		scale *= 1.2

func decrease_size():
	print("size down")
	if current_size != size.MICRO:
		current_size -= 1
		scale *= 0.8
