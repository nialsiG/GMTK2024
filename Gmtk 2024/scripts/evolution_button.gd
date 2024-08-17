class_name EvolutionButton extends Button

enum evolution { NANISM, GIGANTISM, CHANGE_DIET, HEALTH }

@onready var current_choice: evolution
@onready var world_scene = "res://scenes/world.tscn"

func _on_pressed():
	evolve()
	go_to_world()

func evolve():
	match current_choice:
		evolution.NANISM:
			pass
		evolution.GIGANTISM:
			pass
		evolution.CHANGE_DIET:
			pass
		evolution.HEALTH:
			pass
		_:
			pass

func go_to_world():
	get_tree().change_scene_to_file(world_scene)
