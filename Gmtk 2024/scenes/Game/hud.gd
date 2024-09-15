extends Control
class_name hud

const enums = preload("res://scripts/enums.gd")

@onready var _deathContainer : PanelContainer = $DeathContainer
@onready var _finalScoreContainer : FinalScoreContainer = $FinalScoreContainer
@onready var _evolutionMenu : EvolutionMenu = $evolution_menu
@onready var _pauseMenu : PauseMenu = $pause_menu
@onready var _scoreLabel : Label  = $Score/ScoreLabel
@onready var _cycleLabel : Label  = $CycleLabel

func _ready():
	DisplayPause(false)
	DisplayDeath(false)
	DisplayFinalScore(false)
	DisplayEvolutionMenu(false)


#region Display
func Display(panel: Control, display: bool):
	if (display):
		panel.show()
	else:
		panel.hide()

func DisplayDeath(display : bool):
	Display(_deathContainer, display)

func DisplayFinalScore(display : bool):
	Display(_finalScoreContainer, display)
	_finalScoreContainer._backToMenuButton.grab_focus()

func DisplayEvolutionMenu(display: bool, choices: Array[EvolutionChoice] = []):
	if display:
		_evolutionMenu.DisplayChoice(choices)
		_evolutionMenu.button_1.grab_focus()
	Display(_evolutionMenu, display)

func DisplayPause(display: bool):
	Display(_pauseMenu, display)
	if (display):
		_pauseMenu.Pause()
	Display(_scoreLabel, !display)
#endregion

#region Update
func UpdateScore(score : int):
	_scoreLabel.text = "%0*d" % [4, score]

func UpdateCycle(cycle : int):
	_cycleLabel.text = "Cycle %0*d" % [4, cycle]

func UpdateFinalPanel(pickedEvolutions : Array[EvolutionChoice], score : int):
	_finalScoreContainer.UpdateFinalPanel(pickedEvolutions, score)
#endregion
