class_name Enemy extends Animal

enum state { IDLE, MOVING, CHASING, ATTACKING, FLEEING, WOUNDED, DEAD }

@onready var current_state = state.IDLE
@onready var timer = 0

@export var MAX_IDLE_TIME: float = 3
@export var MAX_MOVE_TIME: float = 5
@export var MAX_FLEEING_TIME: float = 8
@export var MAX_CHASING_TIME: float = 6

var meatValue : int = 30
var _name : String = "enemy"

signal Died(meatValue : int, position : Vector2)

func _process(delta):
	if(_isDead):
		return
		
	var hitAnimals = GetCollidingAnimals()
	if (hitAnimals.size() > 0):
		for i in hitAnimals.size():
			var animal = hitAnimals[i]
			var sizeValue = GetSizeValue(current_size)
			var animalSizeValue = GetSizeValue(animal.current_size)
			if (sizeValue < animalSizeValue && animal.diet != enums.Diet.vegetarian):
				hit(animalSizeValue - sizeValue)
			elif(sizeValue > animalSizeValue && diet != enums.Diet.vegetarian):
				animal.hit(sizeValue - animalSizeValue)
	
	if (target != null && current_state != state.CHASING && current_state != state.FLEEING):
		if (relationToTarget == enums.Relationship.PREDATOR):
			current_state = state.CHASING
			print(_name+" started chasing")
		else:
			current_state = state.FLEEING
			print(_name+" started fleeing")
		timer = 0

	if (target == null && (current_state == state.CHASING || current_state == state.FLEEING)):
		current_state = state.IDLE
		print(_name+" started being idle")
		timer = 0

	timer += delta
	
	match current_state:
		state.IDLE:
			if timer > MAX_IDLE_TIME:
				timer = 0
				current_state = state.MOVING
				start_moving()
				print(_name+" started moving")
		state.MOVING:
			if timer > MAX_MOVE_TIME:
				timer = 0
				current_state = state.IDLE
				axis = Vector2.ZERO
		state.CHASING:
			if timer > MAX_CHASING_TIME || target == null:
				timer = 0
				current_state = state.IDLE				
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

func hit(amount):
	if (_isDead):
		return
	
	_isDead = true
	Died.emit(meatValue, position)
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
	var sizeValue = GetSizeValue(current_size)
	var targetSizeValue = GetSizeValue(detectedTarget.current_size)

	if (targetSizeValue > sizeValue && detectedTarget.diet != enums.Diet.vegetarian):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREY
		
	if (diet != enums.Diet.vegetarian && sizeValue > targetSizeValue):
		target = detectedTarget
		relationToTarget = enums.Relationship.PREDATOR
		
	
func OnAreaEntered(area):
	if (!(area.get_parent() is Consumable)):
		return
		
	var consumable = area.get_parent() as Consumable
	if(diet != consumable.incompatibleDiet):
		current_state = state.CHASING
		relationToTarget = enums.Relationship.PREDATOR
		target = consumable
