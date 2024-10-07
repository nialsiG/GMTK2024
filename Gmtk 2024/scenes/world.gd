extends Node2D

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/Menus/start_menu.tscn"

var _width : float = 2000
var _height : float = 2000
var _margin : float = 30

var _pickedEvolutions : Array[enums.evolution] = []
var _score : int = 0

@onready var _hud : hud = $CanvasLayer/hud
@onready var _pauseMenu : PauseMenu = $CanvasLayer/hud/pause_menu
@onready var _evolutionMenu : EvolutionMenu  = $CanvasLayer/hud/evolution_menu
@onready var _dynamicElements : Node2D = $GameElements/DynamicElements
@onready var _staticElements : Node2D = $GameElements/StaticElements
@onready var _player : Player = $GameElements/DynamicElements/Player

@onready var _plantGenerator : PlantGenerator = $PlantGenerator
@onready var _animalGenerator : AnimalGenerator = $AnimalGenerator
@onready var _evolutionChoiceGenerator : EvolutionChoiceGenerator = $EvolutionChoiceGenerator
@onready var _elementFactory : ElementFactory = $ElementFactory

@onready var _cycleTimer : Timer

enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState


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
	_player.connect("Throw", OnPlayerThrow)
	_cycleTimer = get_node("Timer")
	_loadMap(1)
	StartGame()

func _loadMap(mapNumber : int):
	var map : GameMap = _elementFactory.GetMap(mapNumber)
	var mapDimensions : Vector2 = map.GetMapDimensions()
	var startingPoint = map.GetMapStartingPoint()
	_player.position = startingPoint
	_width = mapDimensions.x
	_height = mapDimensions.y
	_staticElements.add_child(map)
	var blockPoints = map.GetPositionsForbidden()
	_animalGenerator.SetupBounds(_margin, mapDimensions, blockPoints)
	_plantGenerator.SetupBounds(_margin, mapDimensions, blockPoints)

func _process(_delta):
	if (Input.is_action_just_pressed("pause_unpause")):
		if (currentState == gameState.OnGoing):
			Pause()
		elif (currentState == gameState.Menu):
			Unpause()

func StartGame():
	GeneratePlants(10)
	GenerateAnimals(5)
	AddCycle(0)
	Unpause()

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
		animal.SetupBounds(_width, _height)
		animal.connect("Died", OnAnimalDied)
		_currentAnimals.append(animal)
		_dynamicElements.call_deferred("add_child", animal)
		call_deferred("_applyEnemyEvolForCycle", animal)

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
	var meat = _elementFactory.GetMeat(animal.GetFoodValue(), animal.position)
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
	# Death screen
	_hud.DisplayDeath(true)
	await tree.create_timer(_deathScreenDuration).timeout
	_hud.DisplayDeath(false)
	# Final screen
	var choicesRecap : Array[EvolutionChoice] = []
	for i in _pickedEvolutions.size():
		choicesRecap.append(_evolutionChoiceGenerator.GetEvolutionForChoice(_pickedEvolutions[i]))
	_hud.DisplayFinalScore(true)
	_hud.UpdateFinalPanel(choicesRecap, _score)

func OnPlayerThrow(type : enums.FoodType, axis : Vector2, throwPosition : Vector2):
	var projectile : Projectile = _elementFactory.GetProjectile(type, axis, throwPosition + throwPosition.normalized() * 30)
	add_child(projectile)

func Pause():
	_player.SetPaused()
	currentState = gameState.Menu
	get_tree().paused = true
	_hud.DisplayPause(true)

func Unpause():
	_player.SetUnpaused()
	currentState = gameState.OnGoing
	get_tree().paused = false
	_hud.DisplayPause(false)
	
func Evolve():
	_player.SetPaused()
	currentState = gameState.Evolution
	var choices = _evolutionChoiceGenerator.GetTwoRandomEvolsExcludingSome(_player.GetForbiddenEvols())
	print(choices)
	_hud.DisplayEvolutionMenu(true, choices)
	for i in _currentAnimals.size():
		_applyEnemyEvolForCycle(_currentAnimals[i])

func _applyEnemyEvolForCycle(animal : Animal):
	if (_cycle == 1):
		return
		
	for i in clamp(int(_cycle/3), 1, 5):
		var evol = _evolutionChoiceGenerator.GetEnemyEvol()
		animal.ApplyEvolution(evol)

func OnCycleTimeOut():
	_cycleTimer.stop()
	_player.SetPaused()
	get_tree().paused = true
	Evolve()
	
func OnEvolutionChosen(evol : enums.evolution):
	_hud.DisplayEvolutionMenu(false)
	_pickedEvolutions.append(evol)
	_player.PROCESS_MODE_ALWAYS
	_player.ApplyEvolution(evol)
	await get_tree().create_timer(0.8).timeout
	_player.PROCESS_MODE_INHERIT
	AddScore(100 * _cycle)
	AddCycle(1)
	Unpause()

func AddCycle(amount: int):
	_cycle += amount
	_hud.UpdateCycle(_cycle)
	_cycleTimer.start()

func AddScore(amount : int):
	_score += amount
	_hud.UpdateScore(_score)
