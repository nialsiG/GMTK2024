class_name Player extends Animal

var _invincibilityTimer : Timer
var _isInvincible : bool

func _ready():
	sprite = get_node("Sprite2D")
	current_size = enums.Size.SMALL
	_invincibilityTimer = get_node("InvincibilityTimer")
	_invincibilityTimer.connect("timeout", OnIFrameTimeOut)
	
signal Fed(amount : int)
signal UpdatedDiet(diet : enums.Diet)
signal UpdatedSize(size : enums.Size)
signal Died()
signal UpdatedHealth(health : int, maxHealth : int)

var maxHealth = 2;
var currentHealth = 2;

func _process(delta):
	if (!_isInvincible):
		var hitAnimals = GetCollidingAnimals()
		if (hitAnimals.size() > 0):
			for i in hitAnimals.size():
				var animal = hitAnimals[i]
				if (current_size < animal.current_size):
					AddHealth(-1)
					if (currentHealth <= 0):
						Died.emit()
					else:
						_isInvincible = true
						_invincibilityTimer.start()

			
	get_input_axis()
	UpdateState(axis)
	
	#debug change size
	if Input.is_action_just_pressed("size_up"):
		increase_size()
		RaiseUpdateSize()
	if Input.is_action_just_pressed("size_down"):
		decrease_size()
		RaiseUpdateSize()
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

func GetForbiddenEvols() -> Array[enums.evolution]:
	var evols : Array[enums.evolution] = []
	if (diet == enums.Diet.carnivore):
		evols.append(enums.evolution.DIET_CARNI)
	elif (diet == enums.Diet.omni):
		evols.append(enums.evolution.DIET_OMNI)
	elif (diet == enums.Diet.vegetarian):
		evols.append(enums.evolution.DIET_HERBI)	
	if (current_size == enums.Size.MICRO):
		evols.append(enums.evolution.NANISM)
	elif (current_size == enums.Size.MEGA):
		evols.append(enums.evolution.GIGANTISM)
		
	return evols
	
func ApplyEvolution(evol : enums.evolution):
	if (evol == enums.evolution.DIET_CARNI):
		UpdateDiet(enums.Diet.carnivore)
	elif (evol == enums.evolution.DIET_HERBI):
		UpdateDiet(enums.Diet.vegetarian)
	elif (evol == enums.evolution.DIET_OMNI):
		UpdateDiet(enums.Diet.omni)
	elif (evol == enums.evolution.NANISM && current_size != enums.Size.MICRO):
		current_size += -1
		UpdateSize()
		RaiseUpdateSize()
	elif (evol == enums.evolution.GIGANTISM && current_size != enums.Size.MEGA):
		current_size +=1
		UpdateSize()
		RaiseUpdateSize()
	elif (evol == enums.evolution.HEALTH):
		maxHealth +=1
		AddHealth(1)

func UpdateDiet(newDiet : enums.Diet):
	diet = newDiet
	UpdatedDiet.emit(diet)

func RaiseUpdateSize():
	UpdatedSize.emit(current_size)

func OnIFrameTimeOut():
	_isInvincible = false

func AddHealth(health : int):
	currentHealth = clamp(currentHealth + health, 0, maxHealth)
	UpdatedHealth.emit(currentHealth, maxHealth)
