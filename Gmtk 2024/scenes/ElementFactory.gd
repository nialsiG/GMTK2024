extends Node
class_name ElementFactory

const enums = preload("res://scripts/enums.gd")

var meatPackedScene = preload("res://scenes/Consumables/Meat.tscn")
var mapPackedScene = preload("res://scenes/Maps/Map1.tscn")
var projectilePackedScene = preload("res://scenes/Player/Projectiles/Projectile.tscn")
var meatProjectilePackedScene = preload("res://scenes/Player/Projectiles/MeatProjectile.tscn")

const _meatValueToScale : float = 0.1

func GetProjectile(foodType : enums.FoodType, axis : Vector2, position : Vector2) -> Projectile:
	var projectile : Projectile
	if (foodType == enums.FoodType.Meat):
		projectile = meatProjectilePackedScene.instantiate()
	else:
		projectile = projectilePackedScene.instantiate()
	projectile.SetAxis(axis)
	projectile.position = position
	return projectile


func GetMeat(foodValue : int, position : Vector2) -> Meat:
	var meat = meatPackedScene.instantiate()
	meat.foodValue = foodValue
	meat.position = position
	meat.scale = Vector2.ONE * foodValue * _meatValueToScale
	return meat

func GetMap(mapNumber : int) -> GameMap:
	if (mapNumber == 1):
		return mapPackedScene.instantiate()
	else:
		print("Map not found: "+str(mapNumber))
		return mapPackedScene.instantiate()
