class_name Animal extends CharacterBody2D

const enums = preload("res://scripts/enums.gd")

@export var current_size = enums.Size.MEDIUM
@export var current_speed = 500
@export var acceleration = 1500
@export var friction = 1200

@onready var axis = Vector2.ZERO

var sprite : AnimatedSprite2D

var currentState = enums.State.Still
var diet : enums.Diet = enums.Diet.omni

func _ready():
	sprite = get_node("Sprite2D")
	match current_size:
		enums.Size.MICRO:
			scale = Vector2(0.64, 0.64)
		enums.Size.SMALL:
			scale = Vector2(0.8, 0.8)
		enums.Size.MEDIUM:
			scale = Vector2(1, 1)
		enums.Size.LARGE:
			scale = Vector2(1.2, 1.2)
		enums.Size.MEGA:
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

func eat(amount: int, foodType: enums.FoodType):
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
	if current_size != enums.Size.MEGA:
		current_size += 1
		scale *= 1.2

func decrease_size():
	print("size down")
	if current_size != enums.Size.MICRO:
		current_size -= 1
		scale *= 0.8

func UpdateState(currentAxis : Vector2):
	if currentAxis == Vector2.ZERO:
		currentState = enums.State.Still
	if (currentAxis.x < 0):
		currentState = enums.State.Left
	if (currentAxis.x > 0):
		currentState = enums.State.Right
	if (currentAxis.y > 0):
		currentState = enums.State.Down
	if (currentAxis.y < 0):
		currentState = enums.State.Up

func UpdateSprite():
	if (currentState == enums.State.Still):
		sprite.animation = "Still"
	elif (currentState == enums.State.Down):
		sprite.animation = "Down"
	elif (currentState == enums.State.Up):
		sprite.animation = "Up"
	elif (currentState == enums.State.Left):
		sprite.animation = "Left"
	elif (currentState == enums.State.Right):
		sprite.animation = "Right"
