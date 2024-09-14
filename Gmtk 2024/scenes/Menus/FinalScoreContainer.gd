extends Control
class_name FinalScoreContainer

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/Menus/start_menu.tscn"

@onready var _score_label_2 = %FinalScoreLabel
@onready var trophy_label = %TrophyLabel
@onready var description_label = %TrophyDescriptionLabel
@onready var grid = %SelectedEvolGridContainer

func UpdateFinalPanel(pickedEvolutions : Array[EvolutionChoice], score : int):
	_score_label_2.text = str(score)
	if score < 700: 
		trophy_label.text = tr("TROPHY_0_NAME")
		description_label.text = tr("TROPHY_0_DESC")
	elif score >= 700 and score < 7000: 
		trophy_label.text = tr("TROPHY_1_NAME")
		description_label.text = tr("TROPHY_1_DESC")
	elif score >= 7000 and score < 70000: 
		trophy_label.text = tr("TROPHY_2_NAME")
		description_label.text = tr("TROPHY_2_DESC")
	elif score >= 70000 and score < 700000: 
		trophy_label.text = tr("TROPHY_3_NAME")
		description_label.text = tr("TROPHY_3_DESC")
	elif score >= 700000 and score < 7000000: 
		trophy_label.text = tr("TROPHY_4_NAME")
		description_label.text = tr("TROPHY_4_DESC")
	elif score > 7000000: 
		trophy_label.text = tr("TROPHY_5_NAME")
		description_label.text = tr("TROPHY_5_DESC")
		
	for evol in pickedEvolutions:
		var tuile = TextureRect.new()
		tuile.texture = evol.Texture()
		grid.add_child(tuile)

func _on_back_to_menu_button_pressed():
	var tree = get_tree()
	tree.paused = false
	tree.change_scene_to_file(start_menu)
