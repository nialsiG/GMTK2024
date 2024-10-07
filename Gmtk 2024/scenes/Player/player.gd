class_name Player extends Animal

var _isInvincible : bool

var _actionAxis : Vector2

var blink_timer : float = 0
var blink_limit : float = 0.1

var _isDead : bool = false
var _currentAbility : enums.Ability = enums.Ability.Dash

@onready var _dashSoundPlayer : AudioStreamPlayer2D = $DashSound
@onready var _eatingSoundPlayer : AudioStreamPlayer2D = $EatingSound
@onready var _deathSoundPlayer : AudioStreamPlayer2D = $DeathSound
@onready var _invincibilityTimer : Timer = $InvincibilityTimer
@onready var _hud : PlayerHud = $CanvasLayer/hud
@onready var _hungerManager : HungerManager = $HungerManager
@onready var _dashManager : DashManager = $DashManager
@onready var _throwManager : ThrowManager = $ThrowManager
@onready var _evolutionAnimation : AnimatedSprite2D = $EvolAnimation
@onready var _lastDirection = Vector2.ZERO

func _ready():
	_colorGenerator = get_node("ColorGenerator")
	current_size = initial_size
	_hungerManager.connect("DiedOfHunger", OnDeathFromHunger)
	_hungerManager.connect("FoodOverflowed", OnFoodOverflow)
	_invincibilityTimer.connect("timeout", OnIFrameTimeOut)
	_hud.UpdateHealth(currentHealth, maxHealth)
	_dashManager.Initialize(_hud)
	_dashManager.Enable()
	_throwManager.Initialize(_hud)
	RaiseUpdateSize()	
	_setShaderColor(_colorGenerator.GetDefaultColor1(), _colorGenerator.GetDefaultColor2())
	_evolutionAnimation.animation_finished.connect(OnEvolutionAnimationFinished)

func OnEvolutionAnimationFinished():
	_evolutionAnimation.hide()

func _useShaderColor() -> bool:
	return false 
	
func _setShaderColor(color1 : Vector4, color2 : Vector4):
	var shaderMaterial = (sprite.material as ShaderMaterial)
	shaderMaterial.set_shader_parameter("Color1", color1)
	shaderMaterial.set_shader_parameter("Color2", color2)
	
signal Fed(amount : int)
signal UpdatedDiet(diet : enums.Diet)
signal UpdatedSize(size : enums.Size, newhungerCoeff : float)
signal Died()
signal UpdatedHealth(health : int, maxHealth : int)
signal Throw(type : enums.FoodType, axis : Vector2, position : Vector2)

var maxHealth = 2;
var currentHealth = 2;
var _paused = false

func _process(delta):
	if(_paused):
		return
		
	var collisionCount = get_slide_collision_count()
	var hitAnimals = GetCollidingAnimals(collisionCount)
	if (hitAnimals.size() > 0):
		for i in hitAnimals.size():
			var animal = hitAnimals[i]
			var power = getPower()
			var enemyPower = animal.getPower()
			if (power < enemyPower && !_isInvincible):
				hit(int((enemyPower - power) /2.0))
			elif (power > enemyPower && _diet != enums.Diet.vegetarian):
				animal.hit(power - enemyPower)

	get_input_axis()

	if(axis != Vector2.ZERO):
		_lastDirection = axis
	
	if (axis != Vector2.ZERO && Input.is_action_just_pressed("attack")): 
		if (_dashManager.CanPerform()):
			_dashManager.Dash()
			_dashSoundPlayer.play()
			_actionAxis = axis
			
		elif (_throwManager.CanPerform()):
			_actionAxis = axis
			var foodToThrow = _throwManager.GetFoodToThrow()
			Throw.emit(foodToThrow.type, _actionAxis, position + _lastDirection * 60 * _scaleCoeff)
			
	UpdateState(axis)
	UpdateSprite()
	blink(delta)
	move(delta)
	
	_hud.UpdateHunger(_hungerManager.current_hunger)

func SetPaused():
	sprite.animation = "Idle_Down"
	velocity = Vector2.ZERO
	_paused = true

func SetUnpaused():
	_paused = false

func getPower() -> int:
	return int(current_size) + _dashManager.GetDashAttackBonus()

func GetDashSpeed() -> float:
	if (!_dashManager.IsDashing()):
		return 1
	else:
		return _dashManager.GetDashSpeedBonus()

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

	sizeValue += _dashManager.GetDashSizeBonus()

	return sizeValue

func _physics_process(_delta):
	move_and_slide()

func get_input_axis():
	if (_dashManager.IsDashing()):
		axis = _actionAxis
	else :
		axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

func apply_acceleration(amount):
	velocity += amount * GetDashSpeed()
	velocity = velocity.limit_length(current_speed * GetDashSpeed())

func eat(amount: int, foodType : enums.FoodType):
	_eatingSoundPlayer.play()
	var newHungerValue = _hungerManager.eat(amount * GetFoodCoef(foodType))
	_hud.UpdateHunger(newHungerValue)
	_throwManager.Store(amount, foodType)

func OnFoodOverflow():
	AddHealth(1)	

func hit(amount : int):
	if (amount >= maxHealth && maxHealth > 1 && currentHealth == maxHealth):
		amount = maxHealth - 1
	if (!_isInvincible):
		AddHealth(-amount)
		if (currentHealth <= 0 && !_isDead):
			_isDead = true
			_deathSoundPlayer.play()
			SetPaused()
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

func OnDeathFromHunger():
	if (_isDead):
		pass
	_isDead = true
	Died.emit()

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
		evols.append_array([enums.evolution.DIET_CARNI, enums.evolution.DIET_HERBI])
	elif (_diet == enums.Diet.omni):
		evols.append(enums.evolution.DIET_OMNI)
	elif (_diet == enums.Diet.vegetarian):
		evols.append_array([enums.evolution.DIET_HERBI, enums.evolution.DIET_CARNI])	
	if (current_size == enums.Size.MICRO):
		evols.append(enums.evolution.NANISM)
	elif (current_size == enums.Size.COLOSSAL):
		evols.append(enums.evolution.GIGANTISM)
	
	if (_currentAbility == enums.Ability.Dash):
		evols.append(enums.evolution.DASH)
		evols.append(enums.evolution.CHEEKY)
	elif (_currentAbility == enums.Ability.Throw):
		evols.append(enums.evolution.THROW)
		evols.append(enums.evolution.AGILITY)
		evols.append(enums.evolution.FANG)
		
	return evols
	
func ApplyEvolution(evol : enums.evolution):
	_evolutionAnimation.show()
	_evolutionAnimation.play()
	await get_tree().create_timer(0.5).timeout
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
				RaiseUpdateSize()
		enums.evolution.GIGANTISM:
			if(current_size != enums.Size.COLOSSAL):
				current_size = current_size + 1 as enums.Size
				RaiseUpdateSize()
		enums.evolution.HEALTH:
			maxHealth +=1
			AddHealth(1)
		enums.evolution.AGILITY:
			_dashManager.UpdateDashRecoveryTime(0.8)
		enums.evolution.FANG:
			_dashManager.AddDashAttackBonus(1)
			_hud.UpdateFangSizeLabel(_dashManager.GetStatAttackBonus())
		enums.evolution.EFFICIENCY:
			_dashManager.UpdateDashFoodCost(0.8)
		enums.evolution.COLOR:
			_setShaderColor(_colorGenerator.GetRandomColor1(), _colorGenerator.GetRandomColor2())
		enums.evolution.LIGHTNESS:
			_max_speed *= _speedEvolCoeff
		enums.evolution.HEAVYNESS:
			_max_speed /= _speedEvolCoeff
		enums.evolution.DASH:
			_currentAbility = enums.Ability.Dash
			_dashManager.Enable()
			_throwManager.Disable()
		enums.evolution.THROW:
			_currentAbility = enums.Ability.Throw
			_dashManager.Disable()
			_throwManager.Enable()
			_throwManager.AddStorageSize(1)
		enums.evolution.CHEEKY:
			_throwManager.AddStorageSize(1)

func UpdateDiet(newDiet : enums.Diet):
	_diet = newDiet
	_hud.UpdateDiet(newDiet)

func RaiseUpdateSize():
	UpdateSize()
	_hud.UpdateSize(current_size)
	_hungerManager.UpdateHungerFactor(current_size)

func OnIFrameTimeOut():
	_isInvincible = false

func AddHealth(health : int):
	currentHealth = clamp(currentHealth + health, 0, maxHealth)
	_hud.UpdateHealth(currentHealth, maxHealth)
