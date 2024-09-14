extends Node
class_name EvolutionChoiceGenerator

const evolutionChoiceScript = preload("res://scripts/Evolutions/EvolutionChoice.gd")
const enums= preload("res://scripts/enums.gd")

var _allEvolutions : Array[EvolutionChoice]
var _enemyEvolutions : Array[EvolutionChoice]

var _addedUzi : bool = false

var _nanism : EvolutionChoice
var _gigantism : EvolutionChoice
var _dietCarni : EvolutionChoice
var _dietHerbi : EvolutionChoice
var _dietOmni : EvolutionChoice
var _healthBonus : EvolutionChoice
var _agility : EvolutionChoice
var _fangs : EvolutionChoice
var _lightness : EvolutionChoice
var _heavyness : EvolutionChoice
var _color : EvolutionChoice
var _thrower : EvolutionChoice
var _speedster : EvolutionChoice
var _bigCheeks : EvolutionChoice

func _ready():
	SecretOptions.connect("UnlockedOptions", OnCheatCodeUnlocked)
	_nanism = CreateChoice("EVOLUTION_NANISM", 	"EVOLUTION_NANISM_DESC", enums.evolution.NANISM, "res://assets/sprites/Icons/IconNanism.png")	
	_gigantism = CreateChoice("EVOLUTION_GIGANTISM","EVOLUTION_GIGANTISM_DESC", enums.evolution.GIGANTISM, "res://assets/sprites/Icons/IconGigantism.png")	
	_dietCarni = CreateChoice("EVOLUTION_CARNIVORE", "EVOLUTION_CARNIVORE_DESC", enums.evolution.DIET_CARNI, "res://assets/sprites/Icons/IconCarnivore.png")	
	_dietHerbi = CreateChoice("EVOLUTION_HERVIBORE", "EVOLUTION_HERBIVORE_DESC", enums.evolution.DIET_HERBI, "res://assets/sprites/Icons/IconVegetarism.png")
	_dietOmni =CreateChoice("EVOLUTION_OMNIVORE", "EVOLUTION_OMNIVORE_DESC", enums.evolution.DIET_OMNI, "res://assets/sprites/Icons/IconOmni.png")
	_healthBonus = CreateChoice("EVOLUTION_STURDY", "EVOLUTION_STURDY_DESC", enums.evolution.HEALTH, "res://assets/sprites/Icons/IconSturdy.png")
	_agility = CreateChoice("EVOLUTION_AGILITY", "EVOLUTION_AGILITY_DESC", enums.evolution.AGILITY, "res://assets/sprites/Icons/IconAgility.png")	
	_fangs = CreateChoice("EVOLUTION_FANG","EVOLUTION_FANG_DESC", enums.evolution.FANG, "res://assets/sprites/Icons/IconFang.png")

	#var efficiency = CreateChoice("Efficiency",
	#"Your movements are more efficient, your dash cost less food",
	#enums.evolution.EFFICIENCY, "res://assets/sprites/Icons/IconEfficiency.png")

	_lightness = CreateChoice("EVOLUTION_LIGHTNESS", "EVOLUTION_LIGHTNESS_DESC", enums.evolution.LIGHTNESS, "res://assets/sprites/Icons/IconLightness.png")
	_heavyness = CreateChoice("EVOLUTION_HEAVYNESS", "EVOLUTION_HEAVYNESS_DESC", enums.evolution.HEAVYNESS, "res://assets/sprites/Icons/IconHeavy.png")
	_color = CreateChoice("EVOLUTION_COAT", "EVOLUTION_COAT_DESC", enums.evolution.COLOR, "res://assets/sprites/Icons/IconColor.png")
	_thrower = CreateChoice("EVOLUTION_THROW", "EVOLUTION_THROW_DESC", enums.evolution.THROW, "res://assets/sprites/Icons/IconLearnThrow.png")
	_bigCheeks = CreateChoice("EVOLUTION_BIG_CHEEKS","EVOLUTION_BIG_CHEEKS_DESC", enums.evolution.CHEEKY, "res://assets/sprites/Icons/IconCheeky.png")
	_speedster = CreateChoice("EVOLUTION_DASH", "EVOLUTION_DASH_DESC", enums.evolution.THROW, "res://assets/sprites/Icons/IconAgility.png")

	_allEvolutions.append(_nanism)
	_allEvolutions.append(_gigantism)
	_allEvolutions.append(_nanism)
	_allEvolutions.append(_gigantism)
	_allEvolutions.append(_healthBonus)
	_allEvolutions.append(_dietHerbi)
	_allEvolutions.append(_dietOmni)
	_allEvolutions.append(_dietCarni)
	_allEvolutions.append(_fangs)
	#_allEvolutions.append(efficiency)
	_allEvolutions.append(_agility)
	_allEvolutions.append(_color)
	_allEvolutions.append(_heavyness)
	_allEvolutions.append(_lightness)

	if(SecretOptions.IsUziActived()):
		_addedUzi = true
		_allEvolutions.append(_thrower)
	
	_enemyEvolutions.append(_nanism)
	_enemyEvolutions.append(_gigantism)
	_enemyEvolutions.append(_nanism)
	_enemyEvolutions.append(_gigantism)
	_enemyEvolutions.append(_dietHerbi)
	_enemyEvolutions.append(_dietOmni)
	_enemyEvolutions.append(_dietCarni)
	_enemyEvolutions.append(_color)
	_enemyEvolutions.append(_color)
	_enemyEvolutions.append(_heavyness)
	_enemyEvolutions.append(_lightness)

func CreateChoice(evolName : String, description : String, evol : enums.evolution, path : String) -> EvolutionChoice:
	var evolChoice = evolutionChoiceScript.new()
	evolChoice.Name = evolName
	evolChoice.Description = description	
	evolChoice.evolution = evol
	evolChoice.InitializeTexture(path)
	return evolChoice

func GetTwoRandomEvolsExcludingSome(excludedEvols : Array[enums.evolution]) -> Array[EvolutionChoice]:
	var allowedEvols : Array[EvolutionChoice] = []
	for i in _allEvolutions.size():
		var found = false
		for j in excludedEvols.size():
			if(excludedEvols[j] == _allEvolutions[i].evolution):
				found = true
				break
		if (!found):
			allowedEvols.append(_allEvolutions[i])
	
	var indexChoice1 = randi_range(0, allowedEvols.size()-1)
	var indexChoice2 = randi_range(0, allowedEvols.size()-1)
	
	while (allowedEvols[indexChoice2] == allowedEvols[indexChoice1]):
		indexChoice2 = randi_range(0, allowedEvols.size()-1)
	
	var pickedEvol : Array[EvolutionChoice] = []
	pickedEvol.append(allowedEvols[indexChoice1])
	pickedEvol.append(allowedEvols[indexChoice2])
	return pickedEvol

func GetEnemyEvol() -> enums.evolution:
	var index = randi_range(0, _enemyEvolutions.size()-1)
	return _enemyEvolutions[index].evolution

func GetEvolutionForChoice(evol : enums.evolution) -> EvolutionChoice:
	for i in _allEvolutions.size():
		if _allEvolutions[i].evolution == evol:
			return _allEvolutions[i]
	return null

func OnCheatCodeUnlocked(_description : String):
	if (SecretOptions.IsUziActived() && !_addedUzi):
		_addedUzi = true
		_allEvolutions.append(_thrower)
		_allEvolutions.append(_bigCheeks)
