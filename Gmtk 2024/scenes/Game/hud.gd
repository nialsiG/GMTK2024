extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")

var _score : int = 0

@onready var _deathContainer : PanelContainer = $DeathContainer
@onready var _finalScoreContainer : FinalScoreContainer = $FinalScoreContainer
@onready var _scoreLabel : Label  = $Score/ScoreLabel
@onready var _cycleLabel : Label  = $CycleLabel

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

func UpdateScore(score : int):
	_scoreLabel.text = "%0*d" % [4, score]

func UpdateCycle(cycle : int):
	_cycleLabel.text = "Cycle %0*d" % [4, cycle]

func UpdateFinalPanel(pickedEvolutions : Array[EvolutionChoice], score : int):
	_finalScoreContainer.UpdateFinalPanel(pickedEvolutions, score)


