extends Control
class_name PlayerHud

const enums = preload("res://scripts/enums.gd")

@onready var _hungerbar : HSlider = $hungerbar
@onready var _lifebar : HSlider = $lifebar
@onready var _iconCarni : PanelContainer = $CarniIcon
@onready var _iconHerbi : PanelContainer = $HerbiIcon
@onready var _sizeLabel : Label = $SizeLabel
@onready var _dashOverlay : TextureRect = $PanelContainer/DashOverlay

func _ready():
	#_hungerbar = get_node("hungerbar")
	pass

func UpdateHunger(amount):
	_hungerbar.value = amount

func UpdateHealth(currentHealth : int, maxHealth : int):
	_lifebar.max_value = maxHealth
	_lifebar.value = currentHealth
	
func UpdateDashCooldown(isAvailable : bool):
	if (isAvailable):
		_dashOverlay.hide()
	else:
		_dashOverlay.show()

func UpdateDiet(diet : enums.Diet):
	if(diet != enums.Diet.carnivore):
		_iconHerbi.show()
	else:
		_iconHerbi.hide()
	
	if(diet != enums.Diet.vegetarian):
		_iconCarni.show()
	else:
		_iconCarni.hide()

func UpdateSize(newSize : enums.Size):
	_sizeLabel.text = GetSizeLabel(newSize)

func GetSizeLabel(sizeToTranslate : enums.Size):
	match(sizeToTranslate):
		enums.Size.MICRO:
			return "Micro"
		enums.Size.VERYSMALL:
			return "Very small" 
		enums.Size.SMALL:
			return "Small"
		enums.Size.MEDIUMSMALL:
			return "Medium small"
		enums.Size.MEDIUM:
			return "Medium"
		enums.Size.MEDIUMLARGE:
			return "Medium large"
		enums.Size.LARGE:
			return "Large"
		enums.Size.VERYLARGE:
			return "Very large"
		enums.Size.MEGA:
			return "Mega"
		enums.Size.COLOSSAL:
			return "Colossal"
		_:
			return "klmdsqklmdfds"
