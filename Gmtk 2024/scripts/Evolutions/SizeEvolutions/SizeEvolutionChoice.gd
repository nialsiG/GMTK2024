extends EvolutionChoice
class_name SizeEvolutionChoice

var _size : enums.Size

func _init(size : enums.Size):
	_size = size

func Apply(player : Player):
	player.EvolveSize(_size)
