class_name Animal extends CharacterBody2D

const enums = preload("res://scripts/enums.gd")

var defaultSpeed : float = 500
var _max_speed : float = 500
var _scaleCoeff : float = 1.0
var current_size = enums.Size.MEDIUM

var _width : float = 2000
var _height : float = 2000

const _speedEvolCoeff : float = 1.2

@export var initial_size : enums.Size = enums.Size.MEDIUM
@export var current_speed : float = defaultSpeed
@export var acceleration : float = 1500
@export var friction : float = 1500
@export var meatValue : int = 30
@export var animalName : String = "Undefined"
@export var startingDiet : enums.Diet = enums.Diet.omni

@onready var axis = Vector2.ZERO
@onready var current_direction : enums.Direction = enums.Direction.Down
@onready var sprite : AnimatedSprite2D = get_node("Sprite2D")

var target : Node2D
var relationToTarget : enums.Relationship

var currentState = enums.State.Still
var _diet : enums.Diet = enums.Diet.omni

func _ready():
	_diet = startingDiet
	current_size = initial_size
	UpdateSize()
	UpdateSprite()

func _initialize():
	pass

func UpdateSize():
	match current_size:
		enums.Size.MICRO:
			_scaleCoeff = 0.2
		enums.Size.VERYSMALL:
			_scaleCoeff = 0.3
		enums.Size.SMALL:
			_scaleCoeff = 0.5
		enums.Size.MEDIUMSMALL:
			_scaleCoeff = 0.8
		enums.Size.MEDIUM:
			_scaleCoeff = 1
		enums.Size.MEDIUMLARGE:
			_scaleCoeff = 1.2
		enums.Size.LARGE:
			_scaleCoeff = 1.5
		enums.Size.VERYLARGE:
			_scaleCoeff = 1.7
		enums.Size.MEGA:
			_scaleCoeff = 2.2
		enums.Size.COLOSSAL:
			_scaleCoeff = 2.8
		_:
			_scaleCoeff = 1
	scale = Vector2.ONE * _scaleCoeff
	DisplaySize()

func SetupBounds(levelWidth : float, levelHeight : float):
	_width = levelWidth
	_height = levelHeight	

func DisplaySize():
	pass
	
func GetFoodValue() -> int:
	return int(current_size) * 5

func CanEatMeat() -> bool:
	return _diet == enums.Diet.carnivore || _diet == enums.Diet.omni

func RaiseHungerChange():
	pass

func move(delta):
	if axis == Vector2.ZERO:
		apply_friction(friction * delta)
	else:
		apply_acceleration(acceleration * axis * delta)

func eat(_amount: int, _foodType: enums.FoodType):
	pass

func apply_friction(amount):
	if velocity.length() >= amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_acceleration(amount):
	velocity += amount
	velocity = velocity.limit_length(getMaxSpeed())

func getMaxSpeed() -> float:
	return _max_speed

func getPower() -> int:
	return int(current_size)

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
				current_size = current_size - 1 as enums.Size 
				UpdateSize()
		enums.evolution.GIGANTISM:
			if (current_size != enums.Size.COLOSSAL):
				current_size = current_size + 1 as enums.Size
				UpdateSize()
		enums.evolution.COLOR:
			UpdateColorRandomly()
		enums.evolution.LIGHTNESS:
			_max_speed *= _speedEvolCoeff
		enums.evolution.HEAVYNESS:
			_max_speed /= _speedEvolCoeff


func UpdateDiet(newDiet : enums.Diet):
	_diet = newDiet

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

func UpdateColorRandomly():
	var r = randi_range(50, 200)
	var g = randi_range(50, 200)
	var b = randi_range(50, 200)
	modulate = Color8(r, g, b, 255)
