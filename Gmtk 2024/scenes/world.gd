extends Node2D
 
var _width = 2000
var _height = 2000
var _margin =30

var _dynamicElements : Node
var _gameElements : Node
var _hud : hud
var _plantGenerator : PlantGenerator
var _animalGenerator : AnimalGenerator
var _player : Player
var _cycle : int = 1
var _pauseMenu : PauseMenu
var _evolutionMenu : EvolutionMenu

enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState

func _ready():
	_hud = get_node("CanvasLayer/hud")
	_gameElements = get_node("GameElements")
	_dynamicElements = (get_node("GameElements/DynamicElements")) as Node
	_plantGenerator = get_node("PlantGenerator")
	_animalGenerator = get_node("AnimalGenerator")
	_player = get_node("GameElements/Player")
	_pauseMenu = get_node("CanvasLayer/pause_menu")
	_pauseMenu.connect("Resume", Unpause)
	_evolutionMenu = get_node("evolution_menu")
	
	StartGame()

func _process(delta):
	if (Input.is_action_just_pressed("pause_unpause")):
		if (currentState == gameState.OnGoing):
			Pause()
		elif (currentState == gameState.Menu):
			Unpause()

func StartGame():
	GeneratePlants(5)
	GenerateAnimals(2)
	currentState = gameState.OnGoing
	_hud.Pause(false);
	_evolutionMenu.hide()
	_pauseMenu.UnPause()
	
func GeneratePlants(numberOfPlants):
	var plants = _plantGenerator.GeneratePlants(numberOfPlants, _width, _height, _margin)
	for plant in plants:
		plant.connect("Eaten", OnEatenPlant)
		_dynamicElements.call_deferred("add_child", plant)

func GenerateAnimals(numberOfAnimals):
	var animals = _animalGenerator.GenerateAnimals(numberOfAnimals, _width, _height, _margin)
	for animal in animals:
		_dynamicElements.call_deferred("add_child", animal)

func OnEatenPlant(amount):
	_hud.eat(amount)
	GeneratePlants(1)

func Pause():
	currentState = gameState.Menu
	get_tree().paused = true
	_pauseMenu.Pause()
	_hud.Pause(true)
	_evolutionMenu.hide()

func Unpause():
	currentState = gameState.OnGoing
	get_tree().paused = false
	_pauseMenu.hide()
	_hud.Pause(false)
	_evolutionMenu.hide()
	
func Evolve():
	currentState = gameState.Evolution
	_hud.Pause(true)
	_pauseMenu.Pause()
	_evolutionMenu.show()
	get_tree().paused = false
