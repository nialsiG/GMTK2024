extends Control
class_name PlayerHud

const enums = preload("res://scripts/enums.gd")

@onready var _hungerbar : HSlider = $hungerbar
@onready var _lifebar : HSlider = $lifebar
@onready var _iconCarni : PanelContainer = $CarniIcon
@onready var _iconHerbi : PanelContainer = $HerbiIcon
@onready var _sizeLabel : Label = $SizeLabel
@onready var _dashOverlay : TextureRect = $PanelContainer/DashOverlay

var _currentSize : enums.Size = enums.Size.MEDIUM

func _ready():
	GameLanguageSettings.connect("UpdatedLanguage", UpdateLanguage)
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
	_currentSize = newSize
	_sizeLabel.text = GetSizeLabel(newSize)

func GetSizeLabel(sizeToTranslate : enums.Size):
	match(sizeToTranslate):
		enums.Size.MICRO:
			return "SIZE_MICRO"
		enums.Size.VERYSMALL:
			return "SIZE_VERY_SMALL"
		enums.Size.SMALL:
			return "SIZE_SMALL"
		enums.Size.MEDIUMSMALL:
			return "SIZE_MEDIUM_SMALL"
		enums.Size.MEDIUM:
			return "SIZE_MEDIUM"
		enums.Size.MEDIUMLARGE:
			return "SIZE_MEDIUM_LARGE"
		enums.Size.LARGE:
			return "SIZE_LARGE"
		enums.Size.VERYLARGE:
			return tr("SIZE_VERY_LARGE")
		enums.Size.MEGA:
			return tr("SIZE_MEGA")
		enums.Size.COLOSSAL:
			return tr("SIZE_COLOSSAL")
		_:
			return "klmdsqklmdfds"

func UpdateLanguage():
	UpdateSize(_currentSize)
