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

var _pickedEvolutions : Array[enums.evolution] = []

var _dynamicElements : Node
var _gameElements : Node
var _player : Player

var _hud : hud
var _hungerbar : hungerbar

var _pauseMenu : PauseMenu
var _evolutionMenu : EvolutionMenu
enum gameState {Menu, Evolution, OnGoing }
var currentState : gameState
var _is_player_dead : bool

var _cycle : int = 1
var _cycleTimer : Timer
var _totalFoodValue : int = 0
var _totalMeatValue : int = 0
var _totalPlantValue : int = 0
var _safetySpawnRadius : float = 300
var _currentAnimals : Array[Animal] = []

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
	_player.connect("UpdatedDashCooldown", OnPlayerUpdatedDashCoolDown)
	
	_hud.UpdateSize(_player.current_size, _player.hungerCoeff)
	_hud.UpdateDiet(_player.diet)
	_hud.UpdateHealth(_player.currentHealth, _player.maxHealth)
	_cycleTimer = get_node("Timer")
	
	_is_player_dead = false
	
	StartGame()

func _process(delta):
	if (Input.is_action_just_pressed("pause_unpause")):
		if (currentState == gameState.OnGoing):
			Pause()
		elif (currentState == gameState.Menu):
			Unpause()

func StartGame():
	GeneratePlants(10)
	GenerateAnimals(5)
	currentState = gameState.OnGoing
	_hud.Pause(false);
	_evolutionMenu.hide()
	_pauseMenu.UnPause()
	_cycleTimer.start()	
	get_tree().paused = false

func GeneratePlants(numberOfPlants):
	var plants = _plantGenerator.GeneratePlants(numberOfPlants, _width, _height, _margin)
	for newPlant in plants:
		newPlant.connect("Eaten", OnEatenConsumable)
		_dynamicElements.call_deferred("add_child", newPlant)

func GenerateAnimals(numberOfAnimals):
	var animals = _animalGenerator.GenerateAnimals(numberOfAnimals, _width, _height, _margin)
	for animal in animals:
		if ((animal.position - _player.position).length() < _safetySpawnRadius):
			animal.position = Vector2(_width - _player.position.x, _height - _player.position.y)
		_applyEnemyEvolForCycle(animal)
		animal.connect("Died", OnAnimalDied)
		_currentAnimals.append(animal)
		_dynamicElements.call_deferred("add_child", animal)

func OnPlayerAte(amount : int):
	_hud.eat(amount)

func OnPlayerUpdatedDiet(diet : enums.Diet):
	_hud.UpdateDiet(diet)
	
func OnPlayerUpdatedSize(size : enums.Size, hungerCoeff : float):
	_hud.UpdateSize(size, hungerCoeff)
	
func OnPlayerUpdatedHealth(currentHealth : int, maxHealth : int):
	_hud.UpdateHealth(currentHealth, maxHealth)

func OnPlayerUpdatedDashCoolDown(isAvailable : bool):
	_hud.UpdateDashCooldown(isAvailable)

func OnEatenConsumable(amount : int, foodType : enums.FoodType):
	_totalFoodValue += amount
	_hud.UpdateScore(amount * 3)
	if (foodType == enums.FoodType.Meat):
		_totalMeatValue += amount
		if _player.diet == enums.Diet.carnivore:
			_hud.UpdateScore(amount * 2)
	else:
		_totalPlantValue += amount
		if _player.diet == enums.Diet.vegetarian:
			_hud.UpdateScore(amount * 2)
		GeneratePlants(1)

func OnAnimalDied(animal : Animal):
	var meat = meatPackedScene.instantiate()
	meat.foodValue = animal.GetFoodValue()
	meat.position = animal.position
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
	if !_is_player_dead:
		_is_player_dead = true
		var tree = get_tree()
		_hud.DisplayDeath(true)
		await get_tree().create_timer(2.5).timeout
		_hud.DisplayDeath(false)
		_hud.DisplayFinalScore(true)
		_hud.UpdateFinalPanel(_pickedEvolutions)

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
	for i in _currentAnimals.size():
		_applyEnemyEvolForCycle(_currentAnimals[i])
		
	get_tree().paused = true

func _applyEnemyEvolForCycle(animal : Animal):
	for i in _cycle - 1:
		var evol = _evolutionChoiceGenerator.GetEnemyEvol()
		animal.ApplyEvolution(evol)

func OnCycleTimeOut():
	Evolve()
	
func OnEvolutionChosen(evol : enums.evolution):
	_pickedEvolutions.append(evol)
	_player.ApplyEvolution(evol)
	_hud.UpdateScore(100 * _cycle)
	Unpause()
	_cycle+=1
	_cycleTimer.start()
