extends Area2D

signal eaten(amount)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func OnBodyEntered(body):
	if body is Player:
		eaten.emit(20)
		queue_free()
