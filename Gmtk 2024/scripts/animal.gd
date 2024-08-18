class_name Animal extends CharacterBody2D

const enums = preload("res://scripts/enums.gd")

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
@onready var current_direction = enums.Direction.Down

var target : Node2D
var relationToTarget : enums.Relationship
var sprite : AnimatedSprite2D

var currentState = enums.State.Still
var diet : enums.Diet = enums.Diet.omni

func _ready():
	sprite = get_node("Sprite2D")
	UpdateSize()
	UpdateSprite()

func UpdateSize():	
	match current_size:
		enums.Size.MICRO:
			scaleCoeff = 0.2
			hungerCoeff = 0.5
		enums.Size.VERYSMALL:
			scaleCoeff = 0.4
			hungerCoeff = 0.6
		enums.Size.SMALL:
			scaleCoeff = 0.6
			hungerCoeff = 0.7
		enums.Size.MEDIUMSMALL:
			scaleCoeff = 0.8
			hungerCoeff = 0.8
		enums.Size.MEDIUM:
			scaleCoeff = 1
			hungerCoeff = 1
		enums.Size.MEDIUMLARGE:
			scaleCoeff = 1.2
			hungerCoeff = 1.2
		enums.Size.LARGE:
			scaleCoeff = 1.5
			hungerCoeff = 1.4
		enums.Size.VERYLARGE:
			scaleCoeff = 1.9
			hungerCoeff = 1.6			
		enums.Size.MEGA:
			scaleCoeff = 2.4
			hungerCoeff = 1.8
		enums.Size.COLOSSAL:
			scaleCoeff = 2.5
			hungerCoeff = 2.2
		_:
			scaleCoeff = 1
			hungerCoeff = 1
	scale = Vector2.ONE * scaleCoeff
	current_speed = current_speed * speedCoeff
	DisplaySize()

func DisplaySize():
	pass
	
func GetFoodValue() -> int:
	return GetSizeValue() * 5

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

func ApplyEvolution(evol : enums.evolution):
	match(evol):
		enums.evolution.DIET_CARNI:
			UpdateDiet(enums.Diet.carnivore)
		enums.evolution.DIET_HERBI:
			UpdateDiet(enums.Diet.vegetarian)
		enums.evolution.DIET_OMNI:
			UpdateDiet(enums.Diet.omni)
		enums.evolution.NANISM:
			if(current_size != enums.Size.MICRO):
				current_size += -1
				UpdateSize()
		enums.evolution.GIGANTISM:
			if (current_size != enums.Size.COLOSSAL):
				current_size +=1
				UpdateSize()
		enums.evolution.COLOR:
			UpdateColorRandomly()

func UpdateDiet(newDiet : enums.Diet):
	diet = newDiet

func UpdateState(currentAxis : Vector2):
	if currentAxis == Vector2.ZERO:
		currentState = enums.State.Still
	if (currentAxis.x < 0):
		currentState = enums.State.Left
		current_direction = enums.Direction.Left
	if (currentAxis.x > 0):
		currentState = enums.State.Right
		current_direction = enums.Direction.Right
	if (currentAxis.y > 0):
		currentState = enums.State.Down
		current_direction = enums.Direction.Down
	if (currentAxis.y < 0):
		currentState = enums.State.Up
		current_direction = enums.Direction.Up

func UpdateSprite():
	if (currentState == enums.State.Still):
		match current_direction:
			enums.Direction.Down:
				sprite.animation = "Idle_Down"
				sprite.flip_h = false
			enums.Direction.Left:
				sprite.animation = "Idle_Right"
				sprite.flip_h = true
			enums.Direction.Right:
				sprite.animation = "Idle_Right"
				sprite.flip_h = false
			enums.Direction.Up:
				sprite.animation = "Idle_Down"
				sprite.flip_h = false
			_:
				sprite.animation = "Still"
	elif (currentState == enums.State.Down):
		sprite.play("Down")
		sprite.flip_h = false
	elif (currentState == enums.State.Up):
		sprite.play("Up")
		sprite.flip_h = false
	elif (currentState == enums.State.Left):
		sprite.play("Right")
		sprite.flip_h = true
	elif (currentState == enums.State.Right):
		sprite.play("Right")
		sprite.flip_h = false

func GetCollidingAnimals(collisionCount : int) -> Array[Animal]:
	var array : Array[Animal] = []
		
	for i in collisionCount:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if (collider is Animal):
			var animal = collider as Animal
			array.append(animal)
		
	return array

func GetCollidingNonAnimals(collisionCount : int) -> Array[Node2D]:
	var array : Array[Node2D] = []
	for i in collisionCount:
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if (!(collider is Animal)):
			array.append(collider)
		
	return array

func GetSizeValue() -> int:
	match(current_size):
		enums.Size.MICRO:
			return 1
		enums.Size.VERYSMALL:
			return 2
		enums.Size.SMALL:
			return 3
		enums.Size.MEDIUMSMALL:
			return 4
		enums.Size.MEDIUM:
			return 5
		enums.Size.MEDIUMLARGE:
			return 6
		enums.Size.LARGE:
			return 7
		enums.Size.VERYLARGE:
			return 8
		enums.Size.MEGA:
			return 9
		enums.Size.COLOSSAL:
			return 10
		_:
			return 0

func UpdateColorRandomly():
	var r = randi_range(50, 200)
	var g = randi_range(50, 200)
	var b = randi_range(50, 200)
	modulate = Color8(r, g, b, 255)
