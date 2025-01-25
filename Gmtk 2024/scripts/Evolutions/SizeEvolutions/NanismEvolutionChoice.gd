extends SizeEvolutionChoice
class_name NanismEvolutionChoice

func _init(size : enums.Size):
	super._init(size)
	Name = "EVOLUTION_NANISM"
	Description = "EVOLUTION_NANISM_DESC"
	_texture = load("res://assets/sprites/Icons/IconNanism.png")
