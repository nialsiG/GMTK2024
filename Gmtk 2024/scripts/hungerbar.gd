extends HSlider
class_name hungerbar

@export var default_factor = 10

signal DiedOfHunger()
signal FoodOverflowed()

var HUNGER_FACTOR
var current_hunger
var _isPaused : bool

func _ready():
	if HUNGER_FACTOR == null:
		HUNGER_FACTOR = default_factor
	if current_hunger == null:
		current_hunger = value

func _process(delta):
	if (_isPaused):
		pass;
	current_hunger -= delta * HUNGER_FACTOR
	value = current_hunger
	if (current_hunger <= 0):
		DiedOfHunger.emit()

func eat(amount):
	current_hunger += amount
	if current_hunger > max_value:
		FoodOverflowed.emit()
		current_hunger = max_value
	value = current_hunger

func Update(factor):
	HUNGER_FACTOR = default_factor * factor

func Pause(pause : bool):
	_isPaused = pause
