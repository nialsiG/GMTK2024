class_name Player extends Animal

func _ready():
	sprite = get_node("Sprite2D")# Replace with function body.

signal Fed(amount)

func _process(delta):
	get_input_axis()
	UpdateState(axis)

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

func eat(amount: int, foodType : enums.FoodType):
	Fed.emit(amount * GetFoodCoef(foodType))

func GetFoodCoef(foodType : enums.FoodType) -> float :
	if (diet == enums.Diet.omni):
		return 0.75;
	if (diet == enums.Diet.carnivore):
		if (foodType == enums.FoodType.Plant):
			return 0.2
		return 1.5
	if (diet == enums.Diet.vegetarian):
		if (foodType == enums.FoodType.Plant):
			return 1.5
		return 0.2
	return 1
