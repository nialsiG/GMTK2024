class_name Enemy extends Animal

enum state { IDLE, MOVING, CHASING, ATTACKING, FLEEING, WOUNDED, DEAD }

@onready var current_state = state.IDLE
@onready var timer = 0

@export var MAX_IDLE_TIME: float = 3
@export var MAX_MOVE_TIME: float = 3
@export var MAX_FLEEING_TIME: float = 8
@export var MAX_CHASING_TIME: float = 6

var _name : String = "enemy"
var _chasingSoundPlayer : AudioStreamPlayer2D
var _fleeingSoundPlayer : AudioStreamPlayer2D
var _lastPosition : Vector2
var _isDead : bool

var _isBlockedLeft : bool = false
var _isBlockedRight : bool = false
var _isBlockedTop : bool = false
var _isBlockedBottom : bool = false

@onready var _debugSizeLabel : Label= $SizeLabel
@onready var _debugRegimLabel : Label = $DietLabel

signal Died(animal : Animal)

var _lastCollidedItems : Array[Node2D] = []

var _idleFactor : float = 1

func _initialize():
	UpdateIdleFactor()	
	_lastPosition = position
	_fleeingSoundPlayer = get_node("FleeingSoundPlayer")
	_chasingSoundPlayer = get_node("ChasingSoundPlayer")


func UpdateIdleFactor():
	_idleFactor = randf_range(0.5, 2)

func _process(delta):
	if(_isDead):
		return
		
	var numberOfCollisions = get_slide_collision_count()
	var hitAnimals = GetCollidingAnimals(numberOfCollisions)
	if (hitAnimals.size() > 0):
		for i in hitAnimals.size():
			var animal = hitAnimals[i]
			var sizeValue = GetSizeValue()
			var animalSizeValue = animal.GetSizeValue()
			if (sizeValue < animalSizeValue && animal._diet != enums.Diet.vegetarian):
				hit(clamp(1, int((animalSizeValue - sizeValue) /2.0), sizeValue))
			elif(sizeValue > animalSizeValue && _diet != enums.Diet.vegetarian):
				animal.hit(sizeValue - animalSizeValue)
	
	var array = GetCollidingNonAnimals(numberOfCollisions)
	var collidedNewItem = array.size() > _lastCollidedItems.size()
	_lastCollidedItems = array

	var margin = 50.0
	_isBlockedLeft = position.x - GetRadius() < margin
	_isBlockedRight = position.x  + GetRadius() > (2000 - -margin) && axis.x > 0
	_isBlockedTop = position.y - GetRadius() < margin
	_isBlockedBottom = position.y + GetRadius() > 2000 - margin 
	var isBlocked = _isBlockedLeft || _isBlockedRight || _isBlockedTop || _isBlockedBottom
						
	if (target != null && current_state != state.CHASING && current_state != state.FLEEING):
		if (relationToTarget == enums.Relationship.PREDATOR):
			current_state = state.CHASING
			if(_chasingSoundPlayer != null):
				_chasingSoundPlayer.play()
		else:
			current_state = state.FLEEING
			if (_fleeingSoundPlayer != null):
				_fleeingSoundPlayer.play()
		timer = 0

	if (target == null && (current_state == state.CHASING || current_state == state.FLEEING)):
		stayIdle()

	timer += delta
	
	match current_state:
		state.IDLE:
			if timer > MAX_IDLE_TIME:
				timer = 0
				current_state = state.MOVING
				start_moving()
				print(_name+" started moving")
		state.MOVING:
			if(isBlocked):
				start_moving()
			if timer > MAX_MOVE_TIME * _idleFactor || collidedNewItem:
				stayIdle()
		state.CHASING:
			if timer > MAX_CHASING_TIME || target == null:
				timer = 0
				stayIdle()
				target = null
				relationToTarget = enums.Relationship.NONE
			else:
				axis = (target.position - position).normalized()
		state.ATTACKING:
			pass
		state.FLEEING:
			if timer > MAX_FLEEING_TIME:
				timer = 0
				current_state = state.MOVING
			else:
				var direction = (position - target.position).normalized()
				if (_isBlockedLeft):
					direction += Vector2.RIGHT
				if(_isBlockedRight):
					direction += Vector2.LEFT
				if(_isBlockedBottom):
					direction += Vector2.UP
				if(_isBlockedTop):
					direction += Vector2.DOWN
				axis = direction.normalized()
		state.WOUNDED:
			pass
		state.DEAD:
			pass
		_:
			pass
			
	UpdateState(axis)
	UpdateSprite()	
	move(delta)

func stayIdle():
	timer = 0
	UpdateIdleFactor()
	current_state = state.IDLE
	axis = Vector2.ZERO

func hit(_amount):
	if (_isDead):
		return
	
	_isDead = true
	Died.emit(self)
	queue_free()

func GetRadius() -> float:
	return _scaleCoeff * 60

func _physics_process(_delta):
	move_and_slide()

func start_moving():
	var my_array = []
	if (!_isBlockedLeft):
		my_array.append(Vector2(-1,0))
		if (!_isBlockedBottom):
			my_array.append(Vector2(-1, 1))
		if (!_isBlockedTop):
			my_array.append(Vector2(-1, -1))

	if (!_isBlockedRight):
		my_array.append(Vector2(1,0))
		if (!_isBlockedBottom):
			my_array.append(Vector2(1, 1))
		if (!_isBlockedTop):
			my_array.append(Vector2(1, -1))
			
	if (!_isBlockedBottom):
		my_array.append(Vector2(0, 1))
		
	if (!_isBlockedTop):
		my_array.append(Vector2(0, -1))

	axis = my_array.pick_random()

func OnDetectionAreaEntered(body):
	if (!body is Animal):
		return
		
	var detectedTarget = body as Animal
	var sizeValue = GetSizeValue()
	var targetSizeValue = detectedTarget.GetSizeValue()

	if (targetSizeValue > sizeValue && detectedTarget._diet != enums.Diet.vegetarian):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREY
		
	if (_diet != enums.Diet.vegetarian && sizeValue > targetSizeValue):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREDATOR
		
	
func OnAreaEntered(area):
	if (!(area is Consumable)):
		return
		
	var consumable = area as Consumable
	if(_diet != consumable.incompatibleDiet):
		current_state = state.CHASING
		relationToTarget = enums.Relationship.PREDATOR
		target = consumable

func DisplaySize():
	if (_debugSizeLabel != null):
		_debugSizeLabel.text = "Size "+str(current_size)

func UpdateDiet(newDiet : enums.Diet):
	_diet = newDiet
	if (_debugRegimLabel != null):
		_debugRegimLabel.text = "Diet: "+str(newDiet)
