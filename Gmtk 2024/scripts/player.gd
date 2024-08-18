class_name Player extends Animal

var _invincibilityTimer : Timer
var _isInvincible : bool

var _isDashing : bool = false
var _isDashInRecovery : bool = false
var _dashDuration : float = 0
var _dashMaxDuration : float = 0.2
var _dashRecoveryTime : float = 10 
var _dashSizeBonus : int = 1
var _dashSpeedBonus : float = 4
var _dashFoodCost : int = 5
var _dashAxis : Vector2

func _ready():
	sprite = get_node("Sprite2D")
	current_size = enums.Size.SMALL
	_invincibilityTimer = get_node("InvincibilityTimer")
	_invincibilityTimer.connect("timeout", OnIFrameTimeOut)
	
signal Fed(amount : int)
signal UpdatedDiet(diet : enums.Diet)
signal UpdatedSize(size : enums.Size, newhungerCoeff : float)
signal Died()
signal UpdatedHealth(health : int, maxHealth : int)
signal UpdatedDashCooldown(isAvailable: bool)

var maxHealth = 2;
var currentHealth = 2;

func _process(delta):
	var collisionCount = get_slide_collision_count()
	var hitAnimals = GetCollidingAnimals(collisionCount)
	if (hitAnimals.size() > 0):
		for i in hitAnimals.size():
			var animal = hitAnimals[i]
			var sizeValue = GetSizeValue()
			var animalSizeValue= animal.GetSizeValue() 
			if (sizeValue < animalSizeValue && !_isInvincible):
				hit(animalSizeValue - sizeValue)
			elif (sizeValue > animalSizeValue && diet != enums.Diet.vegetarian):
				animal.hit(sizeValue - animalSizeValue)

	ManageDashCoolDown(delta)

	get_input_axis()
		
	if (axis != Vector2.ZERO && Input.is_action_just_pressed("attack") && !(_isDashing || _isDashInRecovery)):
		_isDashing = true
		_dashAxis = axis
		UpdatedDashCooldown.emit(false)
		eat(-_dashFoodCost * GetSizeValue(), enums.FoodType.Consumed)
			
	UpdateState(axis)
	
	UpdateSprite()
	move(delta)

func ManageDashCoolDown(delta : float):
	if(_isDashInRecovery):
		_dashDuration += delta
		if (_dashDuration > _dashRecoveryTime):
			_isDashInRecovery = false
			_dashDuration = 0
			UpdatedDashCooldown.emit(true)
	
	if (_isDashing):
		_dashDuration += delta
		if (_dashDuration > _dashMaxDuration):
			_isDashing = false
			_isDashInRecovery = true

func GetDashSpeed() -> float:
	if (!_isDashing):
		return 1
	else:
		return _dashSpeedBonus

func GetSizeValue() -> int:
	var sizeValue = 0;
	match(current_size):
		enums.Size.MICRO:
			sizeValue = 1
		enums.Size.SMALL:
			sizeValue = 2
		enums.Size.MEDIUM:
			sizeValue = 3
		enums.Size.LARGE:
			sizeValue = 4
		enums.Size.MEGA:
			sizeValue = 5
		_:
			return 0

	if (_isDashing):
		sizeValue += _dashSizeBonus

	return sizeValue

func _physics_process(delta):
	move_and_slide()

func get_input_axis():
	if (_isDashing):
		axis = _dashAxis
	else :
		axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

func apply_acceleration(amount):
	velocity += amount * GetDashSpeed()
	velocity = velocity.limit_length(current_speed * GetDashSpeed())
	if (_isDashing):
		print(velocity)

func eat(amount: int, foodType : enums.FoodType):
	Fed.emit(amount * GetFoodCoef(foodType))

func hit(amount : int):
	if (!_isInvincible):	
		AddHealth(-amount)	
	if (currentHealth <= 0):
		Died.emit()
	else:
		_isInvincible = true
		_invincibilityTimer.start()

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
	match (evol):
		enums.evolution.DIET_CARNI:
			UpdateDiet(enums.Diet.carnivore)
		enums.evolution.DIET_HERBI:
			UpdateDiet(enums.Diet.vegetarian)
		enums.evolution.DIET_OMNI:
			UpdateDiet(enums.Diet.omni)
		enums.evolution.NANISM:
			if(current_size != enums.Size.MICRO):
				current_size += -1
				UpdateSize()
				RaiseUpdateSize()
		enums.evolution.GIGANTISM:
			if(current_size != enums.Size.MEGA):
				current_size +=1
				UpdateSize()
				RaiseUpdateSize()
		enums.evolution.HEALTH:
			maxHealth +=1
			AddHealth(1)
		enums.evolution.AGILITY:
			_dashRecoveryTime *= 0.8
			print("RecoveryTime: "+str(_dashRecoveryTime))
		enums.evolution.FANG:
			_dashSizeBonus += 1
		enums.evolution.EFFICIENCY:
			_dashFoodCost *= 0.8	
			print("Foodcost: "+str(_dashFoodCost))
		
func UpdateDiet(newDiet : enums.Diet):
	diet = newDiet
	UpdatedDiet.emit(diet)

func RaiseUpdateSize():
	UpdatedSize.emit(current_size, hungerCoeff)

func OnIFrameTimeOut():
	_isInvincible = false

func AddHealth(health : int):
	currentHealth = clamp(currentHealth + health, 0, maxHealth)
	UpdatedHealth.emit(currentHealth, maxHealth)
