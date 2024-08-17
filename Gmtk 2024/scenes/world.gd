extends Node2D

var plantPS = preload("res://scenes/plant.tscn")
var deinogalerixPS = preload("res://scenes/deinogalerix.tscn")
var width = 2000
var height = 2000
var margin =30
var dynamicElements
var hud

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_node("CanvasLayer/hud")
	dynamicElements = (get_node("DynamicElements")) as Node
	GeneratePlants(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GeneratePlants(numberOfPlants):
	for i in numberOfPlants:
		var x = randf() * (width - 2*margin) + margin
		var y = randf() * (height - 2*margin) + margin
		var plant = plantPS.instantiate()
		plant.position = Vector2(x, y)
		plant.connect("eaten", OnEaten)
		dynamicElements.call_deferred("add_child", plant)

func OnEaten(amount):
	hud.eat(amount)
	GeneratePlants(1)
