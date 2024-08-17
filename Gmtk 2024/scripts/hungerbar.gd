extends HSlider
class_name hungerbar

@export var default_factor = 1

static var HUNGER_FACTOR
static var current_hunger
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
	# debug eat
	if Input.is_action_just_pressed("miam"):
		eat(20)

func eat(amount):
	current_hunger += amount
	if current_hunger > max_value:
		current_hunger = max_value
	value = current_hunger

func Pause(pause : bool):
	_isPaused = pause
