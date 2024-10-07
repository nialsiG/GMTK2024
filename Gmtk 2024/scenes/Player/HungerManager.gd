extends Node
class_name HungerManager

const enums = preload("res://scripts/enums.gd")

@export var default_factor = 5

signal DiedOfHunger()
signal FoodOverflowed()
signal UpdatedValue(value : int)

var _maxValue = 100
var HUNGER_FACTOR
var current_hunger
var _isPaused : bool

func _ready():
	if HUNGER_FACTOR == null:
		HUNGER_FACTOR = default_factor
	if current_hunger == null:
		current_hunger = _maxValue

func _process(delta):
	if (_isPaused):
		pass;
	current_hunger -= delta * HUNGER_FACTOR
	UpdatedValue.emit(current_hunger)
	if (current_hunger <= 0):
		DiedOfHunger.emit()
		_isPaused = true

func eat(amount) -> float:
	current_hunger += amount
	if current_hunger > _maxValue:
		FoodOverflowed.emit()
		current_hunger = _maxValue
	return current_hunger

func UpdateHungerFactor(size : enums.Size):
	var newFactor : float = 1
	match size:
		enums.Size.MICRO:
			newFactor = 0.5
		enums.Size.VERYSMALL:
			newFactor = 0.6
		enums.Size.SMALL:
			newFactor = 0.8
		enums.Size.MEDIUMSMALL:
			newFactor = 0.9
		enums.Size.MEDIUM:
			newFactor = 1
		enums.Size.MEDIUMLARGE:
			newFactor = 2
		enums.Size.LARGE:
			newFactor = 4
		enums.Size.VERYLARGE:
			newFactor = 6
		enums.Size.MEGA:
			newFactor = 9
		enums.Size.COLOSSAL:
			newFactor = 11
		_:
			newFactor = 1
	HUNGER_FACTOR = default_factor * newFactor
	
