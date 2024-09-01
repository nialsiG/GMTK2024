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
var _guerillero : EvolutionChoice

func _ready():
	SecretOptions.connect("UnlockedOptions", OnCheatCodeUnlocked)
	_nanism = CreateChoice("Nanism", 
	"You become smaller. Your food needs are reduced but more animals are predators to you.",
	 enums.evolution.NANISM, "res://assets/sprites/Icons/IconNanism.png")
	
	_gigantism = CreateChoice("Gigantism",
	"You become bigger. Your food needs are increased and you can predate more animals.",
	enums.evolution.GIGANTISM, "res://assets/sprites/Icons/IconGigantism.png")
	
	_dietCarni = CreateChoice("Carnivore",
	"You become carnivore. You get better benefits from eating meat but cannot eat plants.",
	enums.evolution.DIET_CARNI, "res://assets/sprites/Icons/IconCarnivore.png")
	
	_dietHerbi = CreateChoice("Herbivore",
	"You become herbivore. You get better benefits from eating plants but cannot eat meat.",
	enums.evolution.DIET_HERBI, "res://assets/sprites/Icons/IconVegetarism.png")
	
	_dietOmni =CreateChoice("Omnivore",
	"You become omnivore. You can eat everything but get lesser benefits from all food.",
	enums.evolution.DIET_OMNI, "res://assets/sprites/Icons/IconOmni.png")
	
	_healthBonus = CreateChoice("Sturdy",
	"You become sturdier. You gain one more maximum hitpoint.",
	enums.evolution.HEALTH, "res://assets/sprites/Icons/IconSturdy.png")
	
	_agility = CreateChoice("Agility",
	"Your movements are sharper, your dash cooldown is reduced",
	enums.evolution.AGILITY, "res://assets/sprites/Icons/IconAgility.png")
	
	_fangs = CreateChoice("Fang",
	"Your tooth become bigger, during your dash, you gain a temporary size",
	enums.evolution.FANG, "res://assets/sprites/Icons/IconFang.png")

	#var efficiency = CreateChoice("Efficiency",
	#"Your movements are more efficient, your dash cost less food",
	#enums.evolution.EFFICIENCY, "res://assets/sprites/Icons/IconEfficiency.png")

	_lightness = CreateChoice("Lightness",
	"Your frame is lighter, you become faster",
	enums.evolution.LIGHTNESS, "res://assets/sprites/Icons/IconLightness.png")

	_heavyness = CreateChoice("heavyness",
	"Your frame becomes heavier, you become slower",
	enums.evolution.HEAVYNESS, "res://assets/sprites/Icons/IconHeavy.png")

	_color = CreateChoice("Coat",
	"Your coat evolved, maybe it was not the best color, but it is who you are now",
	enums.evolution.COLOR, "res://assets/sprites/Icons/IconColor.png")

	_guerillero = CreateChoice("Guerilla",
	"Your active ability becomes Throw, the last thing you ate is stored in your mouth and can be hurled at other animals, damaging them.",
	enums.evolution.THROW, "res://assets/sprites/icon.svg")

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
		_allEvolutions.append(_guerillero)
	
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

func OnCheatCodeUnlocked(description : String):
	if (SecretOptions.IsUziActived() && !_addedUzi):
		_addedUzi = true
		#_allEvolutions.clear()
		_allEvolutions.append(_guerillero)
		#_allEvolutions.append(_lightness)
