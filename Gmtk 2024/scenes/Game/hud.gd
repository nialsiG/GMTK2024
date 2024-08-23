extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")
const start_menu : String = "res://scenes/start_menu.tscn"

var _deathContainer : PanelContainer
var _finalScoreContainer : Panel
var _death_label : Label
var _score_label : Label
var _score : int = 0

@export var icon_agility: Texture2D
@export var icon_carnivore: Texture2D
@export var icon_color: Texture2D
@export var icon_efficiency: Texture2D
@export var icon_fang: Texture2D
@export var icon_gigantism: Texture2D
@export var icon_heavy: Texture2D
@export var icon_light: Texture2D
@export var icon_nanism: Texture2D
@export var icon_omni: Texture2D
@export var icon_sturdy: Texture2D
@export var icon_vegetarian: Texture2D

func _ready():
	_deathContainer = get_node("DeathContainer")
	_death_label = get_node("DeathContainer/DeathLabel")
	_score_label = get_node("Score/ScoreLabel")
	_finalScoreContainer = get_node("FinalScoreContainer")

func _process(_delta):
	pass

func DisplayDeath(display : bool):
	if (display):
		_deathContainer.show()
	else:
		_deathContainer.hide()

func UpdateDeathModulate(value : float):
	_deathContainer.modulate.a = value
	_deathContainer.self_modulate.a = value

func DisplayFinalScore(display : bool):
	if (display):
		_finalScoreContainer.show()
	else:
		_finalScoreContainer.hide()

func UpdateScore(amount):
	_score += amount
	var message = ""
	if _score < 100:
		message += "0"
	if _score < 10:
		message += "0"
	_score_label.text = message + str(_score)

func UpdateFinalPanel(pickedEvolutions):
	var _score_label_2 = $FinalScoreContainer/ScoreLabel2
	var trophy_label = $FinalScoreContainer/TrophyLabel
	var description_label = $FinalScoreContainer/DescriptionLabel
	var grid = $FinalScoreContainer/ScrollContainer/GridContainer
	_score_label_2.text = str(_score)
	if _score < 700: 
		trophy_label.text = "Meg-what?"
		description_label.text = "You won't go down the fossil record... Try again!"
	elif _score >= 700 and _score < 7000: 
		trophy_label.text = "Meg-aneura"
		description_label.text = "Only the most specialized paleontologists know the name of your lineage."
	elif _score >= 7000 and _score < 70000: 
		trophy_label.text = "Meg-atherium"
		description_label.text = "Your lineage is known enough to have its Wikipedia page!"
	elif _score >= 70000 and _score < 700000: 
		trophy_label.text = "Meg-alodon"
		description_label.text = "Kids all over the planet want to dig out your fossils. Good job!"
	elif _score >= 700000 and _score < 7000000: 
		trophy_label.text = "Meg-alosaurus"
		description_label.text = "At this point, everybody knows what a Megacricetodon is. You're amazing!"
	elif _score > 7000000: 
		trophy_label.text = "O-MEG-A"
		description_label.text = "Welcome to the realm of extant species! Will you survive the Anthropocene?"
	for evol in pickedEvolutions:
		var tuile = TextureRect.new()
		match evol:
			enums.evolution.NANISM: 
				tuile.texture = icon_nanism
			enums.evolution.GIGANTISM:
				tuile.texture = icon_gigantism
			enums.evolution.DIET_OMNI:
				tuile.texture = icon_omni
			enums.evolution.DIET_CARNI:
				tuile.texture = icon_carnivore
			enums.evolution.DIET_HERBI:
				tuile.texture = icon_vegetarian
			enums.evolution.HEALTH:
				tuile.texture = icon_sturdy
			enums.evolution.AGILITY:
				tuile.texture = icon_agility
			enums.evolution.FANG:
				tuile.texture = icon_fang
			enums.evolution.EFFICIENCY:
				tuile.texture = icon_efficiency
			enums.evolution.COLOR:
				tuile.texture = icon_color
			enums.evolution.LIGHTNESS:
				tuile.texture = icon_light
			enums.evolution.HEAVYNESS:
				tuile.texture = icon_heavy
			_:
				tuile.texture = icon_heavy
		grid.add_child(tuile)


func _on_back_to_menu_button_pressed():
	var tree = get_tree()
	tree.paused = false
	tree.change_scene_to_file(start_menu)
