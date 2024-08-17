class_name Animal extends CharacterBody2D

const enums = preload("res://scripts/enums.gd")

var defaultScale : Vector2 = Vector2.ONE
var defaultSpeed : float = 500
var scaleCoeff : float = 1.0
var speedCoeff : float = 1.0
var hungerCoeff : float = 1.0
var _isDead : bool

@export var current_size = enums.Size.MEDIUM
@export var current_speed = defaultSpeed
@export var acceleration = 1500
@export var friction = 1200

@onready var axis = Vector2.ZERO

var target : Node2D
var relationToTarget : enums.Relationship
var sprite : AnimatedSprite2D

var currentState = enums.State.Still
var diet : enums.Diet = enums.Diet.omni

func _ready():
	defaultScale = scale
	sprite = get_node("Sprite2D")
	UpdateSize()

func UpdateSize():
	match current_size:
		enums.Size.MICRO:
			scaleCoeff = 0.64
			speedCoeff = 0.8
			hungerCoeff = 0.6
		enums.Size.SMALL:
			scaleCoeff = 0.8
			speedCoeff = 0.9
			hungerCoeff = 0.8
		enums.Size.MEDIUM:
			scaleCoeff = 1
			speedCoeff = 1
			hungerCoeff = 1
		enums.Size.LARGE:
			scaleCoeff = 1.2
			speedCoeff = 1.1
			hungerCoeff = 1.3
		enums.Size.MEGA:
			scaleCoeff = 1.44
			speedCoeff = 1.2
			hungerCoeff = 1.6
		_:
			scaleCoeff = 1
			speedCoeff = 1
			hungerCoeff = 1
	scale = defaultScale * scaleCoeff
	current_speed = current_speed * speedCoeff

func RaiseHungerChange():
	pass

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

func apply_acceleration(amount):
	velocity += amount
	velocity = velocity.limit_length(current_speed)


func increase_size():
	if current_size != enums.Size.MEGA:
		current_size += 1
		scale *= 1.2

func decrease_size():
	if current_size != enums.Size.MICRO:
		current_size -= 1
		scale *= 0.8

func ApplyEvolution(evol : enums.evolution):
	if (evol == enums.evolution.DIET_CARNI):
		UpdateDiet(enums.Diet.carnivore)
	elif (evol == enums.evolution.DIET_HERBI):
		UpdateDiet(enums.Diet.vegetarian)
	elif (evol == enums.evolution.DIET_OMNI):
		UpdateDiet(enums.Diet.omni)
	elif (evol == enums.evolution.NANISM && current_size != enums.Size.MICRO):
		current_size += -1
		UpdateSize()
	elif (evol == enums.evolution.GIGANTISM && current_size != enums.Size.MEGA):
		current_size +=1
		UpdateSize()

func UpdateDiet(newDiet : enums.Diet):
	diet = newDiet

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

func GetCollidingAnimals() -> Array[Animal]:
	var array : Array[Animal] = []
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if (collider is Animal):
			var animal = collider as Animal
			array.append(animal)
		
	return array

func GetSizeValue(value : enums.Size) -> int:
	match(value):
		enums.Size.MICRO:
			return 1
		enums.Size.SMALL:
			return 2
		enums.Size.MEDIUM:
			return 3
		enums.Size.LARGE:
			return 4
		enums.Size.MEGA:
			return 5
		_:
			return 0
