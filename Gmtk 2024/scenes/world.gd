extends Node2D

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/Menus/start_menu.tscn"
var meatPackedScene = preload("res://scenes/Consumables/Meat.tscn")
var mapPackedScene = preload("res://scenes/Maps/Map1.tscn")

var _width : float = 2000
var _height : float = 2000
var _margin : float = 30

var _pickedEvolutions : Array[enums.evolution] = []
var _score : int = 0

@onready var _hud : hud = $CanvasLayer/hud
@onready var _dynamicElements : Node2D = $GameElements/DynamicElements
@onready var _staticElements : Node2D = $GameElements/StaticElements
@onready var _player : Player = $GameElements/DynamicElements/Player

@onready var _plantGenerator : PlantGenerator = $PlantGenerator
@onready var _animalGenerator : AnimalGenerator = $AnimalGenerator
@onready var _evolutionChoiceGenerator : EvolutionChoiceGenerator = $EvolutionChoiceGenerator

@onready var _pauseMenu : PauseMenu = $CanvasLayer/pause_menu
@onready var _evolutionMenu : EvolutionMenu  = $evolution_menu

@onready var _cycleTimer : Timer

enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState

const _meatValueToScale : float = 0.1
const _deathScreenDuration : float = 2.5

var _cycle : int = 1
var _totalFoodValue : int = 0
var _totalMeatValue : int = 0
var _totalPlantValue : int = 0
var _safetySpawnRadius : float = 300
var _currentAnimals : Array[Animal] = []


func _ready():
	_pauseMenu.connect("Resume", Unpause)
	_evolutionMenu.connect("Chose", OnEvolutionChosen)	
	_player.connect("Fed", OnPlayerAte)
	_player.connect("Died", OnPlayerDeath)	
	_cycleTimer = get_node("Timer")
	
	var map : GameMap = mapPackedScene.instantiate()
	var mapDimensions : Vector2 = map.GetMapDimensions()
	var startingPoint = map.GetMapStartingPoint()
	_player.position = startingPoint
	_width = mapDimensions.x
	_height = mapDimensions.y
	_staticElements.add_child(map)
	var blockPoints = map.GetPositionsForbidden()
	_animalGenerator.SetupBounds(_margin, mapDimensions, blockPoints)
	_plantGenerator.SetupBounds(_margin, mapDimensions, blockPoints)
	StartGame()

func _process(_delta):
	if (Input.is_action_just_pressed("pause_unpause")):
		if (currentState == gameState.OnGoing):
			Pause()
		elif (currentState == gameState.Menu):
			Unpause()

func StartGame():
	GeneratePlants(10)
	GenerateAnimals(5)
	currentState = gameState.OnGoing
	_evolutionMenu.hide()
	_pauseMenu.UnPause()
	_cycleTimer.start()	
	_hud.UpdateCycle(_cycle)
	get_tree().paused = false

func GeneratePlants(numberOfPlants):
	var plants = _plantGenerator.Generate(_cycle, numberOfPlants, _player.position)
	for newPlant in plants:
		newPlant.connect("Eaten", OnEatenConsumable)
		_dynamicElements.call_deferred("add_child", newPlant)

func GenerateAnimals(numberOfAnimals):
	var animals = _animalGenerator.Generate(_cycle, numberOfAnimals, _player.position)
	for animal in animals:
		if ((animal.position - _player.position).length() < _safetySpawnRadius):
			animal.position = Vector2(_width - _player.position.x, _height - _player.position.y)
		_applyEnemyEvolForCycle(animal)
		animal.SetupBounds(_width, _height)
		animal.connect("Died", OnAnimalDied)
		_currentAnimals.append(animal)
		_dynamicElements.call_deferred("add_child", animal)

func OnPlayerAte(amount : int):
	_hud.eat(amount)
	
func OnEatenConsumable(amount : int, foodType : enums.FoodType):
	_totalFoodValue += amount
	AddScore(amount * 3)
	if (foodType == enums.FoodType.Meat):
		_totalMeatValue += amount
		if _player._diet == enums.Diet.carnivore:
			AddScore(amount * 2)
	else:
		_totalPlantValue += amount
		if _player._diet == enums.Diet.vegetarian:
			AddScore(amount * 2)
		GeneratePlants(1)

func OnAnimalDied(animal : Animal):
	var meat = meatPackedScene.instantiate()
	meat.foodValue = animal.GetFoodValue()
	meat.position = animal.position
	meat.scale = Vector2.ONE * animal.GetFoodValue() * _meatValueToScale
	meat.connect("Eaten", OnEatenConsumable)
	var deadAnimalIndex = _getAnimalIndex(animal)
	_currentAnimals.remove_at(deadAnimalIndex)
	_dynamicElements.call_deferred("add_child",  meat)
	GenerateAnimals(1)

func _getAnimalIndex(animal : Animal):
	for i in _currentAnimals.size():
		if (_currentAnimals[i] == animal):
			return i 
	return -1
	
func OnPlayerDeath():
	var tree = get_tree()
	tree.paused = true
	_hud.DisplayDeath(true)
	await get_tree().create_timer(_deathScreenDuration).timeout
	_hud.DisplayDeath(false)
	_hud.DisplayFinalScore(true)
	var choicesRecap : Array[EvolutionChoice] = []
	for i in _pickedEvolutions.size():
		choicesRecap.append(_evolutionChoiceGenerator.GetEvolutionForChoice(_pickedEvolutions[i]))
	_hud.UpdateFinalPanel(choicesRecap, _score)

func Pause():
	currentState = gameState.Menu
	_hud.hide()
	get_tree().paused = true
	_pauseMenu.Pause()
	_evolutionMenu.hide()

func Unpause():
	currentState = gameState.OnGoing
	get_tree().paused = false
	_hud.show()
	_pauseMenu.hide()
	_evolutionMenu.hide()
	
func Evolve():
	currentState = gameState.Evolution
	_cycleTimer.stop()
	_pauseMenu.UnPause()
	var choices = _evolutionChoiceGenerator.GetTwoRandomEvolsExcludingSome(_player.GetForbiddenEvols())	
	_evolutionMenu.DisplayChoice(choices)
	for i in _currentAnimals.size():
		_applyEnemyEvolForCycle(_currentAnimals[i])
		
	get_tree().paused = true

func _applyEnemyEvolForCycle(animal : Animal):
	for i in clamp(int(_cycle/3), 1, 5):
		var evol = _evolutionChoiceGenerator.GetEnemyEvol()
		animal.ApplyEvolution(evol)

func OnCycleTimeOut():
	Evolve()
	
func OnEvolutionChosen(evol : enums.evolution):
	_pickedEvolutions.append(evol)
	_player.ApplyEvolution(evol)
	AddScore(100 * _cycle)
	Unpause()
	_cycle+=1
	_hud.UpdateCycle(_cycle)
	_cycleTimer.start()

func AddScore(amount : int):
	_score += amount
	_hud.UpdateScore(_score)
