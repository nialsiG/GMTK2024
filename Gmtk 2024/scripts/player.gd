class_name Player extends Animal

func _ready():
	pass # Replace with function body.


func _process(delta):
	get_input_axis()
	#debug change size
	if Input.is_action_just_pressed("size_up"):
		increase_size()
	if Input.is_action_just_pressed("size_down"):
		decrease_size()
	move(delta)

func _physics_process(delta):
	move_and_slide()

func get_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	if axis != Vector2.ZERO:
		print("You are moving!")
