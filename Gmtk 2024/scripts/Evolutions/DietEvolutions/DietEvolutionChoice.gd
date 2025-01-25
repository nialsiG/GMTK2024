extends EvolutionChoice
class_name DietEvolutionChoice 

var diet : enums.Diet = enums.Diet.omni

func Apply(player : Player):
	player.UpdateDiet(diet)
