extends Control
class_name FinalScoreContainer

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/Menus/start_menu.tscn"

@onready var _score_label_2 = %FinalScoreLabel
@onready var trophy_label = %FinalTrophyLabel
@onready var description_label = %FinalTrophyDescriptionLabel
@onready var grid = %FinalEvolutionsGridContainer

func UpdateFinalPanel(pickedEvolutions : Array[EvolutionChoice], score : int):
	_score_label_2.text = str(score)
	if score < 700: 
		trophy_label.text = "Meg-what?"
		description_label.text = "You won't go down the fossil record... Try again!"
	elif score >= 700 and score < 7000: 
		trophy_label.text = "Meg-aneura"
		description_label.text = "Only the most specialized paleontologists know the name of your lineage."
	elif score >= 7000 and score < 70000: 
		trophy_label.text = "Meg-atherium"
		description_label.text = "Your lineage is known enough to have its Wikipedia page!"
	elif score >= 70000 and score < 700000: 
		trophy_label.text = "Meg-alodon"
		description_label.text = "Kids all over the planet want to dig out your fossils. Good job!"
	elif score >= 700000 and score < 7000000: 
		trophy_label.text = "Meg-alosaurus"
		description_label.text = "At this point, everybody knows what a Megacricetodon is. You're amazing!"
	elif score > 7000000: 
		trophy_label.text = "O-MEG-A"
		description_label.text = "Welcome to the realm of extant species! Will you survive the Anthropocene?"
	for evol in pickedEvolutions:
		var tuile = TextureRect.new()
		tuile.texture = evol.Texture()
		grid.add_child(tuile)

func _on_back_to_menu_button_pressed():
	var tree = get_tree()
	tree.paused = false
	tree.change_scene_to_file(start_menu)
