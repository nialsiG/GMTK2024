class_name Player extends Animal

enum state {Still, Up, Down, Left, Right}
var currentState = state.Still

var sprite;

func _ready():
	sprite = get_node("Sprite2D")# Replace with function body.



func _process(delta):
	get_input_axis()
	#debug change size
	if Input.is_action_just_pressed("size_up"):
		increase_size()
	if Input.is_action_just_pressed("size_down"):
		decrease_size()
	UpdateSprite()
	move(delta)

func _physics_process(delta):
	move_and_slide()

func get_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	if axis == Vector2.ZERO:
		currentState = state.Still
	if (axis.x < 0):
		currentState = state.Left
	if (axis.x > 0):
		currentState = state.Right
	if (axis.y > 0):
		currentState = state.Down
	if (axis.y < 0):
		currentState = state.Up
		
func UpdateSprite():
	if (currentState == state.Still):
		sprite.animation = "Still"
	elif (currentState == state.Down):
		sprite.animation = "Down"
	elif (currentState == state.Up):
		sprite.animation = "Up"
	elif (currentState == state.Left):
		sprite.animation = "Left"
	elif (currentState == state.Right):
		sprite.animation = "Right"
