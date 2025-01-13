extends Node
class_name StepSpawner

const enums = preload("res://scripts/enums.gd")
const stepSpritePs = preload("res://scenes/Player/StepSpawner/StepSprite.tscn")
const _groundSprite = preload("res://assets/sprites/Player/ground_step.png")

signal SpawnStep(sprite : StepSprite)

func Initialize(player : Player):
	player.SpawnStep.connect(OnStepSpawn)

func OnStepSpawn(stepType : enums.StepType, globalPosition : Vector2):
	var step : Sprite2D
	var newStep = stepSpritePs.instantiate()
	newStep.texture = _groundSprite
	newStep.global_position = globalPosition
	SpawnStep.emit(newStep)
