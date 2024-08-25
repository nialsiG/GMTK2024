extends Node
class_name BaseGenerator

var _width : float = 2000
var _height : float = 2000
var _margin : float = 200
var _packedScenes : Array[PackedScene]
var _blockedPositions : Array[Vector2]
var _safetySpawnRadius : float = 300

func SetupBounds(margin : float, dimensions : Vector2, blockedPositions : Array[Vector2]):
	_margin = margin
	_width = dimensions.x
	_height = dimensions.y
	_blockedPositions = blockedPositions

func Generate(numberOfItems: int, playerPosition : Vector2):
	var generatedItems := []
	for i in numberOfItems:

		var newPosition = _getRandomPositionWithinBounds()
		while(!_isPositionAcceptable(newPosition, playerPosition)):
			newPosition = _getRandomPositionWithinBounds()

		var ps = randi_range(0, _packedScenes.size()-1)
		var item = _packedScenes[ps].instantiate()
		item.position = newPosition
		generatedItems.append(item)
	return generatedItems

func _getRandomPositionWithinBounds():
	var x = randf() * (_width - 2 * _margin) + _margin
	var y = randf() * (_height - 2 * _margin) + _margin	
	return Vector2(x, y)	
	
func _isPositionAcceptable(newPosition : Vector2, playerPosition : Vector2) -> bool:
	if (newPosition - playerPosition).length() < _safetySpawnRadius:
		return false		

	for blockPosition in _blockedPositions:
		if ((newPosition - blockPosition).length() < 100):
			return false
						
	return true
