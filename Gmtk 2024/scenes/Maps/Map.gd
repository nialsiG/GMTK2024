extends Node2D
class_name GameMap

@export var GameWidth : float = 2000
@export var GameHeigth : float = 2000
@export var StartingPosition: Vector2 = Vector2(400, 350)

func GetMapDimensions() -> Vector2:
	return Vector2(GameWidth, GameHeigth) 

func GetMapStartingPoint() -> Vector2:
	return StartingPosition

func GetPositionsForbidden() -> Array[Vector2]:
	var forbiddenPosition : Array[Vector2] = []
	var fixedElements = get_node("Bounds").get_children()
	for i in fixedElements.size():
		forbiddenPosition.append(fixedElements[i].position)
	return forbiddenPosition
