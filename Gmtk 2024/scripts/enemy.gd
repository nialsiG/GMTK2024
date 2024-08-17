class_name Enemy extends Animal

enum state { IDLE, MOVING, CHASING, ATTACKING, FLEEING, WOUNDED, DEAD }

@onready var current_state = state.IDLE
@onready var timer = 0

@export var MAX_IDLE_TIME: float = 3
@export var MAX_MOVE_TIME: float = 5
@export var MAX_FLEEING_TIME: float = 6

var meatValue : int = 30

signal Died(meatValue : int, position : Vector2)

func _process(delta):
	var hitAnimals = GetCollidingAnimals()
	if (hitAnimals.size() > 0):
		for i in hitAnimals.size():
			var animal = hitAnimals[i]
			if (current_size < animal.current_size):
				Died.emit(meatValue, position)
				queue_free()
	
	match current_state:
		state.IDLE:
			timer += delta
			if timer > MAX_IDLE_TIME:
				timer = 0
				current_state = state.MOVING
				start_moving()
		state.MOVING:
			timer += delta
			if timer > MAX_MOVE_TIME:
				timer = 0
				current_state = state.IDLE
				axis = Vector2.ZERO
		state.CHASING:
			pass
		state.ATTACKING:
			pass
		state.FLEEING:
			pass
		state.WOUNDED:
			pass
		state.DEAD:
			pass
		_:
			pass
			
	UpdateState(axis)
	UpdateSprite()	
	move(delta)

func _physics_process(delta):
	move_and_slide()

func start_moving():
	var my_array = [Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(-1,1), Vector2(-1,0), Vector2(-1,-1), Vector2(0,-1), Vector2(1,-1)]
	axis = my_array.pick_random()

