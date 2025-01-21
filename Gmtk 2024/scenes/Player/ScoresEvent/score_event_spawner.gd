extends Node
class_name ScoreEventSpawner

const _scoreEventPs = preload("res://scenes/Player/ScoresEvent/ScoreEvent.tscn")

signal DisplayScore(scoreEvent : ScoreEvent)

func _ready():
	pass

func Initialize(player : Player):
	player.Fed.connect(OnFed)
	
func OnFed(amount : int):
	var scoreEvent = _scoreEventPs.instantiate() as ScoreEvent
	scoreEvent.Amount = amount
	DisplayScore.emit(scoreEvent)
