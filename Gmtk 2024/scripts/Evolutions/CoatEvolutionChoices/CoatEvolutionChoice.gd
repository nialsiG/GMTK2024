extends EvolutionChoice
class_name CoatEvolutionChoice

func _init():
	Name = "EVOLUTION_COAT"
	Description = "EVOLUTION_COAT_DESC"
	_texture = load("res://assets/sprites/Icons/IconColor.png")

func Apply(player : Player):
	player.SetRandomColor()
	
func Activate():
	_isActivated = false
