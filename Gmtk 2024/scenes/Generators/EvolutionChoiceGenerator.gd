extends Node
class_name EvolutionChoiceGenerator

const evolutionChoiceScript = preload("res://scripts/Evolutions/EvolutionChoice.gd")
const enums= preload("res://scripts/enums.gd")

var _allEvolutions : Array[EvolutionChoice]

func _ready():
	var nanism = CreateChoice("Nanism", 
	"You become smaller. Your food needs are reduced and so is your speed. More animal are predators to you.",
	 enums.evolution.NANISM, "")
	
	var gigantism = CreateChoice("Gigantism",
	"You become bigger. Your food needs are increased and so is your speed. You can predate more animals.",
	enums.evolution.GIGANTISM, "")
	
	var dietCarni = CreateChoice("Carnivore",
	"You become carnivore. You get better benefits from eating meat but cannot eat plants.",
	enums.evolution.DIET_CARNI, "")
	
	var dietHerbi = CreateChoice("Herbivore",
	"You become herbivore. You get better benefits from eating plants but cannot eat meat.",
	enums.evolution.DIET_HERBI, "")
	
	var dietOmni =CreateChoice("Omnivore",
	"You become omnivore. You can eat everything but get lesser benefits from all food.",
	enums.evolution.DIET_OMNI, "")
	
	var healthBonus = CreateChoice("Health",
	"Give you one more hitpoint.",
	enums.evolution.HEALTH, "")
	
	var agility = CreateChoice("Agility",
	"Your movements are sharper, your dash cooldown is reduced",
	enums.evolution.AGILITY, "")
	
	var fangs = CreateChoice("Fang",
	"Your tooth become bigger, during your dash, you gain a temporary size",
	enums.evolution.FANG, "")

	var efficiency = CreateChoice("Efficiency",
	"Your movements are more efficient, your dash cost less food",
	enums.evolution.EFFICIENCY, "")

	_allEvolutions.append(nanism)
	_allEvolutions.append(gigantism)
	_allEvolutions.append(healthBonus)
	_allEvolutions.append(dietHerbi)
	_allEvolutions.append(dietOmni)
	_allEvolutions.append(dietCarni)
	_allEvolutions.append(fangs)
	_allEvolutions.append(efficiency)
	_allEvolutions.append(agility)

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
	while (indexChoice2 == indexChoice1):
		indexChoice2 = randi_range(0, allowedEvols.size()-1)
	
	var pickedEvol : Array[EvolutionChoice] = []
	pickedEvol.append(allowedEvols[indexChoice1])
	pickedEvol.append(allowedEvols[indexChoice2])
	return pickedEvol
