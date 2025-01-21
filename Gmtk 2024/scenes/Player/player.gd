class_name Player extends Animal

var _isInvincible : bool

var _actionAxis : Vector2

var blink_timer : float = 0
var blink_limit : float = 0.1
var _digSpeedCoeff : float = 0.5

var _stepTimer : float = 0
var _stepMaxTimer : float = 0.1

var _isDead : bool = false
var _currentAbility : enums.Ability = enums.Ability.Dash
var _waitingForOutOfGround : bool = false

var _overlappingAreas : Array[Node2D] = []

@onready var _dashSoundPlayer : AudioStreamPlayer2D = $DashSound
@onready var _eatingSoundPlayer : AudioStreamPlayer2D = $EatingSound
@onready var _deathSoundPlayer : AudioStreamPlayer2D = $DeathSound
@onready var _invincibilityTimer : Timer = $InvincibilityTimer
@onready var _hud : PlayerHud = $CanvasLayer/hud
@onready var _hungerManager : HungerManager = $HungerManager
@onready var _dashManager : DashManager = $DashManager
@onready var _digManager : DigManager = $DigManager
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
	if (_currentAbility == enums.Ability.Dash):
		_dashManager.Enable()
	_throwManager.Initialize(_hud)
	if (_currentAbility == enums.Ability.Throw):
		_throwManager.Enable()
	_digManager.Initialize(_hud)
	_digManager.DigTimeOut.connect(OnDigTimeOut)
	if (_currentAbility == enums.Ability.Dig):
		_digManager.Enable()
		
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
signal Hid()
signal SpawnStep(stepType : enums.StepType, position : Vector2)

var maxHealth = 2;
var currentHealth = 2;
var _paused = false

func _process(delta):
	if(_paused):
		return
		
	var collisionCount = get_slide_collision_count()
	if (_waitingForOutOfGround && _overlappingAreas.size() == 0):
		LeaveUnderGround()
		_waitingForOutOfGround = false
		_hungerManager.ReleaseOverUse()
		
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
		elif (_digManager.CanPerform()):
			if(_digManager.Dig()):
				GoUnderGround()
			else:
				LeaveUnderGround()
			
	UpdateState(axis)
	UpdateSprite()
	blink(delta)
	move(delta)
	if (axis.length() > 0):
		_stepTimer += delta
		if _stepTimer > _stepMaxTimer:
			RaiseSpawnStep()
			_stepTimer = 0
			
	_hud.UpdateHunger(_hungerManager.current_hunger)

func RegisterOverlappingArea(area : Node2D):
	_overlappingAreas.append(area)
	sprite.visible = false

func UnregisterOverlappingArea(area : Node2D):
	_overlappingAreas.erase(area)
	if (_overlappingAreas.size() == 0):
			sprite.show()
	
func OnDigTimeOut():
	if(_overlappingAreas.size() > 0):
		_waitingForOutOfGround = true
		_hungerManager.SetOverUse()
	else:
		LeaveUnderGround()

func GoUnderGround():
	collision_layer = 4
	collision_mask = 4
	Hid.emit()

func LeaveUnderGround():
	collision_layer = 0x11
	collision_mask = 0x11
	
func CheckSpecialSpriteState():
	if (!sprite.visible):
		return
	
	if (_digManager.IsDigging() || _waitingForOutOfGround):
		if (currentState == enums.State.Still):
			sprite.animation = "Digging_Idle"
		else:
			match current_direction:
				enums.Direction.Down:
					if (sprite.animation != "Digging_Down"):
						sprite.animation = "Digging_Down"
					sprite.flip_h = false
					sprite.flip_v = false
				enums.Direction.Left:
					if (sprite.animation != "Digging_Right"):
						sprite.animation = "Digging_Right"
					sprite.flip_h = true
					sprite.flip_v = true
				enums.Direction.Right:
					if (sprite.animation != "Digging_Right"):
						sprite.animation = "Digging_Right"
					sprite.flip_h = false
					sprite.flip_v = false
				enums.Direction.Up:
					if (sprite.animation != "Digging_Down"):
						sprite.animation = "Digging_Down"
					sprite.flip_h = false
					sprite.flip_v = true
		return true
		
	return false

func SetPaused():
	sprite.animation = "Idle_Down"
	velocity = Vector2.ZERO
	_paused = true

func SetUnpaused():
	_paused = false

func getPower() -> int:
	return int(current_size) + _dashManager.GetAbilityAttackBonus() + _digManager.GetAbilityAttackBonus()

func GetDashSpeed() -> float:
	if (!_dashManager.IsDashing()):
		return 1
	else:
		return _dashManager.GetDashSpeedBonus()

func GetDigSpeed() -> float:
	if (_digManager.IsDigging()):
		return _digSpeedCoeff
	return 1

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
	velocity = velocity.limit_length(current_speed * GetDashSpeed() * GetDigSpeed())

func eat(amount: int, foodType : enums.FoodType):
	_eatingSoundPlayer.play()
	Fed.emit(amount)
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
		evols.append(enums.evolution.DIG_ATTACK_BONUS)
		evols.append(enums.evolution.DIG_COOLDOWN_BONUS)
		evols.append(enums.evolution.DIG_DURATION_BONUS)
		evols.append(enums.evolution.DIG_SPEED_BONUS)
	elif (_currentAbility == enums.Ability.Throw):
		evols.append(enums.evolution.THROW)
		evols.append(enums.evolution.AGILITY)
		evols.append(enums.evolution.FANG)
		evols.append(enums.evolution.DIG_ATTACK_BONUS)
		evols.append(enums.evolution.DIG_COOLDOWN_BONUS)
		evols.append(enums.evolution.DIG_DURATION_BONUS)
		evols.append(enums.evolution.DIG_SPEED_BONUS)
	elif (_currentAbility == enums.Ability.Dig):
		evols.append(enums.evolution.DIGGER)
		evols.append(enums.evolution.AGILITY)
		evols.append(enums.evolution.CHEEKY)
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
			_digManager.Disable()
			_throwManager.Disable()
		enums.evolution.THROW:
			_currentAbility = enums.Ability.Throw
			_dashManager.Disable()
			_digManager.Disable()
			_throwManager.Enable()
			_throwManager.AddStorageSize(1)
		enums.evolution.DIGGER:
			_currentAbility = enums.Ability.Dig
			_dashManager.Disable()
			_digManager.Enable()
			_throwManager.Disable()
		enums.evolution.CHEEKY:
			_throwManager.AddStorageSize(1)
		enums.evolution.CLAWS:
			_digSpeedCoeff += 0.15
		enums.evolution.DIG_ATTACK_BONUS:
			_digManager.AddDigAttackBonus(1)
		enums.evolution.DIG_COOLDOWN_BONUS:
			_digManager.AddDigCooldownBonus(1)
		enums.evolution.DIG_DURATION_BONUS:
			_digManager.AddDigDurationBonus(1)
			
func UpdateDiet(newDiet : enums.Diet):
	_diet = newDiet
	_hud.UpdateDiet(newDiet)

func RaiseUpdateSize():
	UpdateSize()
	_hud.UpdateSize(current_size)
	_hungerManager.UpdateHungerFactor(current_size)

func OnIFrameTimeOut():
	_isInvincible = false
	sprite.show()

func AddHealth(health : int):
	currentHealth = clamp(currentHealth + health, 0, maxHealth)
	_hud.UpdateHealth(currentHealth, maxHealth)

func RaiseSpawnStep():
	SpawnStep.emit(enums.StepType.Ground, global_position)
