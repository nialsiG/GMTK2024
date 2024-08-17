extends Node2D

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/start_menu.tscn"
var meatPackedScene = preload("res://scenes/Meat.tscn")

var _width : float = 2000
var _height : float = 2000
var _margin : float = 30

var _plantGenerator : PlantGenerator
var _animalGenerator : AnimalGenerator
var _evolutionChoiceGenerator : EvolutionChoiceGenerator

var _dynamicElements : Node
var _gameElements : Node
var _player : Player

var _hud : hud
var _hungerbar : hungerbar

var _pauseMenu : PauseMenu
var _evolutionMenu : EvolutionMenu
enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState

var _cycle : int = 1
var _cycleTimer : Timer

func _ready():
	_hud = get_node("CanvasLayer/hud")
	_hungerbar = get_node("CanvasLayer/hud/hungerbar")
	_hungerbar.connect("DiedOfHunger", OnPlayerDeath)
	_hungerbar.connect("FoodOverflowed", OnFoodOverFlow)
	
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
	_player.connect("UpdatedHealth", OnPlayerUpdatedHealth)
	_player.connect("Died", OnPlayerDeath)
	
	_hud.UpdateSize(_player.current_size)
	_hud.UpdateDiet(_player.diet)
	_hud.UpdateHealth(_player.currentHealth, _player.maxHealth)
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
		animal.connect("Died", OnAnimalDied)
		_dynamicElements.call_deferred("add_child", animal)

func OnPlayerAte(amount : int):
	_hud.eat(amount)

func OnPlayerUpdatedDiet(diet : enums.Diet):
	_hud.UpdateDiet(diet)
	
func OnPlayerUpdatedSize(size : enums.Size):
	_hud.UpdateSize(size)
	
func OnPlayerUpdatedHealth(currentHealth : int, maxHealth : int):
	_hud.UpdateHealth(currentHealth, maxHealth)
	
func OnEatenPlant(amount : int):
	_hud.eat(amount)
	GeneratePlants(1)

func OnAnimalDied(foodValue : int, bodyPosition : Vector2):
	var meat = meatPackedScene.instantiate()
	meat.foodValue = foodValue
	meat.position = bodyPosition
	_dynamicElements.call_deferred("add_child",  meat)
	GenerateAnimals(1)

func OnPlayerDeath():
	get_tree().paused = true
	_hud.DisplayDeath(true)
	await get_tree().create_timer(5).timeout
	_hud.DisplayDeath(false)
	get_tree().paused = false
	get_tree().change_scene_to_file(start_menu)
	

func OnFoodOverFlow():
	_player.AddHealth(1)

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
