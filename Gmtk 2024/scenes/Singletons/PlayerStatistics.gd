extends Node
class_name PlayerStatisticsTracker

const enums = preload("res://scripts/enums.gd")

var _hasSeenTutorial : bool = false

var _numberOfGames : int = 0
var _maximumPoints : int = 0
var _totalScore : int = 0

# success
var _maximumSize : enums.Size = enums.Size.VERYSMALL
var _minimumSize : enums.Size = enums.Size.VERYSMALL
var _eatenPlants : Array[String] = []
var _eatenAnimals : Array[String] = []

func CheckTutorial():
	_hasSeenTutorial = true
	
func HasSeenTutorial() -> bool:
	return _hasSeenTutorial
	
func RegisterScoreAndCheckIsHighest(score : int) -> bool:
	_totalScore += score
	if _maximumPoints < score:
		_maximumPoints = score
		return true
	else:
		return false

func AtePlant(plant : String):
	if (!_eatenPlants.any(func(a) : a == plant)):
		_eatenPlants.append(plant)

func AteAnimal(animal : String):
	if (!_eatenAnimals.any(func(a) : a == animal)):
		_eatenAnimals.append(animal)
