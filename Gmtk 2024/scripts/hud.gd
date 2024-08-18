extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")

var _hungerbar : hungerbar
var _lifebar : lifebar
var _iconCarni : PanelContainer
var _iconHerbi : PanelContainer
var _sizeLabel : Label
var _deathContainer : PanelContainer
var _dashOverlay : TextureRect

func _ready():
	_hungerbar = get_node("hungerbar")
	
	_lifebar = get_node("lifebar")
	_iconCarni = get_node("CarniIcon")
	_iconHerbi = get_node("HerbiIcon")
	_sizeLabel = get_node("SizeLabel")
	_deathContainer = get_node("DeathContainer")
	_dashOverlay = get_node("PanelContainer/DashOverlay")

func _process(delta):
	pass

func eat(amount):
	_hungerbar.eat(amount)

func UpdateDashCooldown(isAvailable : bool):
	if (isAvailable):
		_dashOverlay.hide()
	else:
		_dashOverlay.show()


func UpdateHealth(currentHealth : int, maxHealth : int):
	_lifebar.UpdateHealth(currentHealth, maxHealth)

func UpdateDiet(diet : enums.Diet):
	if(diet != enums.Diet.carnivore):
		_iconHerbi.show()
	else:
		_iconHerbi.hide()
	
	if(diet != enums.Diet.vegetarian):
		_iconCarni.show()
	else:
		_iconCarni.hide()

func UpdateSize(size : enums.Size, hungerCoeff : float):
	_sizeLabel.text = GetSizeLabel(size)
	_hungerbar.HUNGER_FACTOR = hungerCoeff

func GetSizeLabel(size : enums.Size):
	match(size):
		enums.Size.MICRO:
			return "Micro" 
		enums.Size.SMALL:
			return "Small"
		enums.Size.MEDIUM:
			return "Medium"
		enums.Size.LARGE:
			return "Large"
		enums.Size.MEGA:
			return "Mega"
		_:
			return "klmdsqklmdfds"
			
func Pause(pause : bool):
	_hungerbar.Pause(pause)
	if (pause):
		hide()
	else:
		show()

func DisplayDeath(display : bool):
	if (display):
		_deathContainer.show()
	else:
		_deathContainer.hide()

func UpdateDeathModulate(value : float):
	_deathContainer.modulate.a = value
	_deathContainer.self_modulate.a = value
