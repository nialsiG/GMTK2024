extends Node
class_name StepSpawner

const enums = preload("res://scripts/enums.gd")
const stepSpritePs = preload("res://scenes/Player/StepSpawner/StepSprite.tscn")
const _groundSprite1 = preload("res://assets/sprites/Player/ground_step1.png")
const _groundSprite2 = preload("res://assets/sprites/Player/ground_step2.png")
var _textureCounter = 0;
var _textureCount = 2;

signal SpawnStep(sprite : StepSprite)

func Initialize(player : Player):
	player.SpawnStep.connect(OnStepSpawn)

func OnStepSpawn(stepType : enums.StepType, globalPosition : Vector2):
	var step : Sprite2D
	var newStep = stepSpritePs.instantiate()
	newStep.texture = GetTexture()
	newStep.global_position = globalPosition
	SpawnStep.emit(newStep)

func GetTexture() -> Texture2D :
	_textureCounter = (_textureCounter + 1) % _textureCount
	if (_textureCounter == 0):
		return _groundSprite1
	elif (_textureCounter == 1):
		return _groundSprite2
		
	return _groundSprite1
