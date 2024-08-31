extends Node

const _uziCode : String = "LRLRDUDA"
const _cheatCodeLength : int = 8

var _isCodeAllowed : bool = false
var _activatedUzi : bool = false
var _lastCommands : Array[String] = []

signal UnlockedOptions(description : String)

func _process(delta):
	if(!_isCodeAllowed):
		return
	
	if(Input.is_action_just_pressed("move_down")):
		_lastCommands.append("D")
	if(Input.is_action_just_pressed("move_left")):
		_lastCommands.append("L")
	if(Input.is_action_just_pressed("move_right")):
		_lastCommands.append("R")
	if(Input.is_action_just_pressed("move_up")):
		_lastCommands.append("U")
	if(Input.is_action_just_pressed("attack")):
		_lastCommands.append("A")

	while(_lastCommands.size() > _cheatCodeLength):
		_lastCommands.remove_at(0)
		
	if (_lastCommands.size() == _cheatCodeLength):
		var code = ""
		for i in _lastCommands.size():
			code+= _lastCommands[i]
		if (code == _uziCode):
			_activatedUzi = true
			UnlockedOptions.emit("You unlocked \"Throw\" mutation, allowing to replace your dash by capability to throw eaten food to concurrents, damaging them")
		code = ""
		
func IsUziActived() -> bool:
	return _activatedUzi
	
func AllowCode(allows : bool):
	_isCodeAllowed = allows
