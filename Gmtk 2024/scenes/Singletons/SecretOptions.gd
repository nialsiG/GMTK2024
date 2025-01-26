extends Node

const enums = preload("res://scripts/enums.gd")

const _uziCode : String = "LRLRDUUD"
const _debuceModeCode : String = "UUUUDDLR"
const _cheatCodeLength : int = 8

var _isCodeAllowed : bool = false
var _activatedUzi : bool = false
var _isDebugModeActive : bool = false

var _lastCommands : Array[String] = []

var AllowDig : bool = false
var AllowSpeedEvolution : bool = true
var AllowSizeEvolution : bool = true
var AllowDietBranch : bool = true
var AllowColorEvolution : bool = true

var StartingAbility : enums.Ability = enums.Ability.Dash

var MaxCycleDurationInSeconds : float = 10
var GodMode : bool = false 

signal UnlockedOptions(description : String)

func _process(_delta):
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
			_lastCommands.clear()
			_activatedUzi = true
			UnlockedOptions.emit("UNLOCK_THROW")
		if (code == _debuceModeCode):
			_lastCommands.clear()
			_isDebugModeActive = true
			UnlockedOptions.emit("DEBUG_MODE")
		
func IsUziActived() -> bool:
	return _activatedUzi
	
func AllowCode(allows : bool):
	_isCodeAllowed = allows

func ActivateGodMOde(activate : bool):
	GodMode = activate
	
func IsGodModeActivated() -> bool:
	return GodMode

func UpdateStartAbility(ability : enums.Ability):
	StartingAbility = ability
