extends EvolutionChoice
class_name SpeedEvolutionChoice

var _maxSpeed : float = 500
var _acceleration : float = 1500
var _friction : float = 1500

func _init(maxSpeed : float, acceleration : float, friction : float):
	_maxSpeed = maxSpeed
	_acceleration = acceleration
	_friction = friction

func Apply(player : Player):
	player._max_speed = _maxSpeed
	player.acceleration = _acceleration
	player.friction = _friction
	print("SPEED CHANGE: "+str(_maxSpeed)+" "+str(_acceleration)+" "+str(_friction))

func Display():
	print(str(Name)+": "+str(Description)+" SPEED CHANGE: "+str(_maxSpeed)+" "+str(_acceleration)+" "+str(_friction)+" "+str(_isActivated))
