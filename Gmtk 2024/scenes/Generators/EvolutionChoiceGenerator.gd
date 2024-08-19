extends Node
class_name EvolutionChoiceGenerator

const evolutionChoiceScript = preload("res://scripts/Evolutions/EvolutionChoice.gd")
const enums= preload("res://scripts/enums.gd")

var _allEvolutions : Array[EvolutionChoice]
var _enemyEvolutions : Array[EvolutionChoice]

func _ready():
	var nanism = CreateChoice("Nanism", 
	"You become smaller. Your food needs are reduced but more animals are predators to you.",
	 enums.evolution.NANISM, "res://assets/sprites/Icons/IconNanism.png")
	
	var gigantism = CreateChoice("Gigantism",
	"You become bigger. Your food needs are increased and you can predate more animals.",
	enums.evolution.GIGANTISM, "res://assets/sprites/Icons/IconGigantism.png")
	
	var dietCarni = CreateChoice("Carnivore",
	"You become carnivore. You get better benefits from eating meat but cannot eat plants.",
	enums.evolution.DIET_CARNI, "res://assets/sprites/Icons/IconCarnivore.png")
	
	var dietHerbi = CreateChoice("Herbivore",
	"You become herbivore. You get better benefits from eating plants but cannot eat meat.",
	enums.evolution.DIET_HERBI, "res://assets/sprites/Icons/IconVegetarism.png")
	
	var dietOmni =CreateChoice("Omnivore",
	"You become omnivore. You can eat everything but get lesser benefits from all food.",
	enums.evolution.DIET_OMNI, "res://assets/sprites/Icons/IconOmni.png")
	
	var healthBonus = CreateChoice("Sturdy",
	"You become sturdier. You gain one more maximum hitpoint.",
	enums.evolution.HEALTH, "res://assets/sprites/Icons/IconSturdy.png")
	
	var agility = CreateChoice("Agility",
	"Your movements are sharper, your dash cooldown is reduced",
	enums.evolution.AGILITY, "res://assets/sprites/Icons/IconAgility.png")
	
	var fangs = CreateChoice("Fang",
	"Your tooth become bigger, during your dash, you gain a temporary size",
	enums.evolution.FANG, "res://assets/sprites/Icons/IconFang.png")

	var efficiency = CreateChoice("Efficiency",
	"Your movements are more efficient, your dash cost less food",
	enums.evolution.EFFICIENCY, "res://assets/sprites/Icons/IconEfficiency.png")

	var lightness = CreateChoice("Lightness",
	"Your frame is lighter, you become faster",
	enums.evolution.LIGHTNESS, "res://assets/sprites/Icons/IconLightness.png")

	var heavyness = CreateChoice("heavyness",
	"Your frame becomes heavier, you become slower",
	enums.evolution.HEAVYNESS, "res://assets/sprites/Icons/IconHeavy.png")

	var color = CreateChoice("Coat",
	"Your coat evolved, maybe it was not the best color, but it is who you are now",
	enums.evolution.COLOR, "res://assets/sprites/Icons/IconColor.png")

	_allEvolutions.append(nanism)
	_allEvolutions.append(gigantism)
	_allEvolutions.append(nanism)
	_allEvolutions.append(gigantism)
	_allEvolutions.append(healthBonus)
	_allEvolutions.append(dietHerbi)
	_allEvolutions.append(dietOmni)
	_allEvolutions.append(dietCarni)
	_allEvolutions.append(fangs)
	_allEvolutions.append(efficiency)
	_allEvolutions.append(agility)
	_allEvolutions.append(color)
	_allEvolutions.append(heavyness)
	_allEvolutions.append(lightness)
	
	_enemyEvolutions.append(nanism)
	_enemyEvolutions.append(gigantism)
	_enemyEvolutions.append(nanism)
	_enemyEvolutions.append(gigantism)
	_enemyEvolutions.append(dietHerbi)
	_enemyEvolutions.append(dietOmni)
	_enemyEvolutions.append(dietCarni)
	_enemyEvolutions.append(color)
	_enemyEvolutions.append(color)
	_enemyEvolutions.append(heavyness)
	_enemyEvolutions.append(lightness)

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
	
	while (indexChoice2 == indexChoice1 && allowedEvols[indexChoice2] == allowedEvols[indexChoice1]):
		indexChoice2 = randi_range(0, allowedEvols.size()-1)
	
	var pickedEvol : Array[EvolutionChoice] = []
	pickedEvol.append(allowedEvols[indexChoice1])
	pickedEvol.append(allowedEvols[indexChoice2])
	return pickedEvol

func GetEnemyEvol() -> enums.evolution:
	var index = randi_range(0, _enemyEvolutions.size()-1)
	return _enemyEvolutions[index].evolution
