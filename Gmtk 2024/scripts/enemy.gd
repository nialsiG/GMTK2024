class_name Enemy extends Animal

enum state { IDLE, MOVING, CHASING, ATTACKING, FLEEING, WOUNDED, DEAD }

@onready var current_state = state.IDLE
@onready var timer = 0

@export var MAX_IDLE_TIME: float = 3
@export var MAX_MOVE_TIME: float = 3
@export var MAX_FLEEING_TIME: float = 8
@export var MAX_CHASING_TIME: float = 6

var meatValue : int = 30
var _name : String = "enemy"
var _chasingSoundPlayer : AudioStreamPlayer2D
var _fleeingSoundPlayer : AudioStreamPlayer2D
@onready var _debugSizeLabel : Label= $SizeLabel
@onready var _debugRegimLabel : Label = $DietLabel

signal Died(animal : Animal)

var _lastCollidedItems : Array[Node2D] = []

var _idleFactor : float = 1

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
			if (sizeValue < animalSizeValue && animal.diet != enums.Diet.vegetarian):
				hit(clamp(1, (animalSizeValue - sizeValue) /2, sizeValue))
			elif(sizeValue > animalSizeValue && diet != enums.Diet.vegetarian):
				animal.hit(sizeValue - animalSizeValue)
	
	var array = GetCollidingNonAnimals(numberOfCollisions)
	var collidedNewItem = array.size() > _lastCollidedItems.size()
	_lastCollidedItems = array
	
	if (target != null && current_state != state.CHASING && current_state != state.FLEEING):
		if (relationToTarget == enums.Relationship.PREDATOR):
			current_state = state.CHASING
			if(_chasingSoundPlayer != null):
				_chasingSoundPlayer.play()
			print(_name+" started chasing")
		else:
			current_state = state.FLEEING
			if (_fleeingSoundPlayer != null):
				_fleeingSoundPlayer.play()
			print(_name+" started fleeing")
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
				axis = (position - target.position).normalized()
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

func UpdateIdleFactor():
	_idleFactor = randf_range(0.5, 2)

func hit(amount):
	if (_isDead):
		return
	
	_isDead = true
	Died.emit(self)
	queue_free()

func _physics_process(delta):
	move_and_slide()

func start_moving():
	var my_array = [Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	axis = my_array.pick_random()

func OnDetectionAreaEntered(body):
	if (!body is Animal):
		return
		
	var detectedTarget = body as Animal
	var sizeValue = GetSizeValue()
	var targetSizeValue = detectedTarget.GetSizeValue()

	if (targetSizeValue > sizeValue && detectedTarget.diet != enums.Diet.vegetarian):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREY
		
	if (diet != enums.Diet.vegetarian && sizeValue > targetSizeValue):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREDATOR
		
	
func OnAreaEntered(area):
	if (!(area is Consumable)):
		return
		
	var consumable = area as Consumable
	if(diet != consumable.incompatibleDiet):
		current_state = state.CHASING
		relationToTarget = enums.Relationship.PREDATOR
		target = consumable

func DisplaySize():
	if (_debugSizeLabel != null):
		_debugSizeLabel.text = "Size "+str(current_size)

func UpdateDiet(newDiet : enums.Diet):
	diet = newDiet
	if (_debugRegimLabel != null):
		_debugRegimLabel.text = "Diet: "+str(newDiet)
