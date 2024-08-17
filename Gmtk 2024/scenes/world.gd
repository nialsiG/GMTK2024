extends Node2D

const enums = preload("res://scripts/enums.gd")

var _width = 2000
var _height = 2000
var _margin =30

var _plantGenerator : PlantGenerator
var _animalGenerator : AnimalGenerator
var _evolutionChoiceGenerator : EvolutionChoiceGenerator

var _dynamicElements : Node
var _gameElements : Node
var _player : Player

var _hud : hud
var _pauseMenu : PauseMenu
var _evolutionMenu : EvolutionMenu
enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState

var _cycle : int = 1
var _cycleTimer : Timer

func _ready():
	_hud = get_node("CanvasLayer/hud")
	_gameElements = get_node("GameElements")
	_dynamicElements = (get_node("GameElements/DynamicElements")) as Node
	_plantGenerator = get_node("PlantGenerator")
	_animalGenerator = get_node("AnimalGenerator")
	_evolutionChoiceGenerator = get_node("EvolutionChoiceGenerator")
	_player = get_node("GameElements/Player")
	_pauseMenu = get_node("CanvasLayer/pause_menu")
	_pauseMenu.connect("Resume", Unpause)
	_evolutionMenu = get_node("evolution_menu")
	_evolutionMenu.connect("Chose", OnEvolutionChosen)
	
	_player.connect("Fed", OnPlayerAte)
	_player.connect("UpdatedDiet", OnPlayerUpdatedDiet)
	_player.connect("UpdatedSize", OnPlayerUpdatedSize)
	_hud.UpdateSize(_player.current_size)
	_hud.UpdateDiet(_player.diet)
	_cycleTimer = get_node("Timer")
	
	StartGame()

func _process(delta):
	if (Input.is_action_just_pressed("pause_unpause")):
		if (currentState == gameState.OnGoing):
			Pause()
		elif (currentState == gameState.Menu):
			Unpause()

func StartGame():
	GeneratePlants(5)
	GenerateAnimals(5)
	currentState = gameState.OnGoing
	_hud.Pause(false);
	_evolutionMenu.hide()
	_pauseMenu.UnPause()
	_cycleTimer.start()	
	
func GeneratePlants(numberOfPlants):
	var plants = _plantGenerator.GeneratePlants(numberOfPlants, _width, _height, _margin)
	for newPlant in plants:
		newPlant.connect("Eaten", OnEatenPlant)
		_dynamicElements.call_deferred("add_child", newPlant)

func GenerateAnimals(numberOfAnimals):
	var animals = _animalGenerator.GenerateAnimals(numberOfAnimals, _width, _height, _margin)
	for animal in animals:
		_dynamicElements.call_deferred("add_child", animal)

func OnPlayerAte(amount : int):
	_hud.eat(amount)

func OnPlayerUpdatedDiet(diet : enums.Diet):
	_hud.UpdateDiet(diet)
	
func OnPlayerUpdatedSize(size : enums.Size):
	_hud.UpdateSize(size)
	
func OnEatenPlant(amount : int):
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
	_cycleTimer.stop()
	_hud.Pause(true)
	_pauseMenu.UnPause()
	var choices = _evolutionChoiceGenerator.GetTwoRandomEvolsExcludingSome(_player.GetForbiddenEvols())	
	_evolutionMenu.DisplayChoice(choices)
	get_tree().paused = true

func OnCycleTimeOut():
	Evolve()
	
func OnEvolutionChosen(evol : enums.evolution):
	_player.ApplyEvolution(evol)
	Unpause()
	_cycle+=1
	_cycleTimer.start()
