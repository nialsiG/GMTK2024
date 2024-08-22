class_name Player extends Animal

var _invincibilityTimer : Timer
var _isInvincible : bool

var _isDashing : bool = false
var _isDashInRecovery : bool = false
var _dashDuration : float = 0
var _dashMaxDuration : float = 0.2
var _dashRecoveryTime : float = 3
var _dashSizeBonus : int = 1
var _dashSpeedBonus : float = 4
var _dashFoodCost : float = 5
var _dashAxis : Vector2
var blink_timer : float = 0
var blink_limit : float = 0.1
var _eatingSoundPlayer : AudioStreamPlayer2D
var _dashSoundPlayer : AudioStreamPlayer
var _deathSoundPlayer : AudioStreamPlayer

func _ready():
	sprite = get_node("Sprite2D")
	_eatingSoundPlayer = get_node("EatingSound")
	_dashSoundPlayer = get_node("DashSound")
	_deathSoundPlayer = get_node("DeathSound")
	current_size = enums.Size.VERYSMALL
	_invincibilityTimer = get_node("InvincibilityTimer")
	_invincibilityTimer.connect("timeout", OnIFrameTimeOut)
	UpdateSize()
	
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
				hit(int((animalSizeValue - sizeValue) /2.0))
			elif (sizeValue > animalSizeValue && _diet != enums.Diet.vegetarian):
				animal.hit(sizeValue - animalSizeValue)
	ManageDashCoolDown(delta)
	get_input_axis()
	
	if (axis != Vector2.ZERO && Input.is_action_just_pressed("attack") 
	&& !(_isDashing || _isDashInRecovery)):
		_isDashing = true
		_dashSoundPlayer.play()
		_dashAxis = axis
		UpdatedDashCooldown.emit(false)
		#eat(-_dashFoodCost * GetSizeValue(), enums.FoodType.Consumed)
			
	UpdateState(axis)
	UpdateSprite()
	blink(delta)
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
		enums.Size.VERYSMALL:
			sizeValue = 2
		enums.Size.SMALL:
			sizeValue = 3
		enums.Size.MEDIUMSMALL:
			sizeValue = 4
		enums.Size.MEDIUM:
			sizeValue = 5
		enums.Size.MEDIUMLARGE:
			sizeValue = 6
		enums.Size.LARGE:
			sizeValue = 7
		enums.Size.VERYLARGE:
			sizeValue = 8
		enums.Size.MEGA:
			sizeValue = 9
		enums.Size.COLOSSAL:
			sizeValue = 10
		_:
			return 0

	if (_isDashing):
		sizeValue += _dashSizeBonus

	return sizeValue

func _physics_process(_delta):
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
	_eatingSoundPlayer.play()
	Fed.emit(amount * GetFoodCoef(foodType))

func hit(amount : int):
	if (amount >= maxHealth && maxHealth > 1 && currentHealth == maxHealth):
		amount = maxHealth - 1
	if (!_isInvincible):
		AddHealth(-amount)
		if (currentHealth <= 0):
			_deathSoundPlayer.play()
			Died.emit()
		else:
			_isInvincible = true
			_invincibilityTimer.start()

# A function to blink while invincible
func blink(delta):
	if !_isInvincible and !sprite.is_visible_in_tree():
		sprite.show()
	if _isInvincible:
		blink_timer += delta
	if blink_timer >= blink_limit:
		blink_timer = 0
		match sprite.is_visible_in_tree():
			true: sprite.hide()
			false: sprite.show()

func GetFoodCoef(foodType : enums.FoodType) -> float :
	if (_diet == enums.Diet.omni):
		return 0.75;
	if (_diet == enums.Diet.carnivore):
		if (foodType == enums.FoodType.Plant):
			return 0.2
		return 1.5
	if (_diet == enums.Diet.vegetarian):
		if (foodType == enums.FoodType.Plant):
			return 1.5
		return 0.2
	return 1

func GetForbiddenEvols() -> Array[enums.evolution]:
	var evols : Array[enums.evolution] = []
	if (_diet == enums.Diet.carnivore):
		evols.append([enums.evolution.DIET_CARNI, enums.evolution.DIET_HERBI])
	elif (_diet == enums.Diet.omni):
		evols.append(enums.evolution.DIET_OMNI)
	elif (_diet == enums.Diet.vegetarian):
		evols.append([enums.evolution.DIET_HERBI, enums.evolution.DIET_CARNI])	
	if (current_size == enums.Size.MICRO):
		evols.append(enums.evolution.NANISM)
	elif (current_size == enums.Size.COLOSSAL):
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
				current_size = current_size - 1 as enums.Size
				UpdateSize()
				RaiseUpdateSize()
		enums.evolution.GIGANTISM:
			if(current_size != enums.Size.COLOSSAL):
				current_size = current_size + 1 as enums.Size
				UpdateSize()
				RaiseUpdateSize()
		enums.evolution.HEALTH:
			maxHealth +=1
			AddHealth(1)
		enums.evolution.AGILITY:
			_dashRecoveryTime *= 0.8
		enums.evolution.FANG:
			_dashSizeBonus += 1
		enums.evolution.EFFICIENCY:
			_dashFoodCost *= 0.8
		enums.evolution.COLOR:
			var r = randi_range(00, 250)
			var g = randi_range(0, 250)
			var b = randi_range(0, 250)
			modulate = Color8(r, g, b, 255)
		enums.evolution.LIGHTNESS:
			_max_speed *= _speedEvolCoeff
		enums.evolution.HEAVYNESS:
			_max_speed /= _speedEvolCoeff
		
func UpdateDiet(newDiet : enums.Diet):
	_diet = newDiet
	UpdatedDiet.emit(_diet)

func RaiseUpdateSize():
	UpdatedSize.emit(current_size, _hungerCoeff)

func OnIFrameTimeOut():
	_isInvincible = false

func AddHealth(health : int):
	currentHealth = clamp(currentHealth + health, 0, maxHealth)
	UpdatedHealth.emit(currentHealth, maxHealth)
