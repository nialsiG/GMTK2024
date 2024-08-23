extends Node2D
class_name GameMap

@export var GameWidth : float = 2000
@export var GameHeigth : float = 2000

func GetMapDimensions() -> Vector2:
	return Vector2(GameWidth, GameHeigth) 
