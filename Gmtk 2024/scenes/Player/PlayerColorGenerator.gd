extends Node
class_name PlayerColorGenerator

var _defaultColor1 = Vector4(0.855, 0.686, 0.443, 1.0);
var _defaultColor2 = Vector4(0.6,0.6,0.6, 1.0);

var _color1Posibilities : Array[Vector4] = [
	_defaultColor1,
	Vector4(0.95, 0.95, 0.95, 1.0), #White
	Vector4(0.45, 0.3, 0.2, 1.0), #Dark brown
	Vector4(0.2,0.2,0.2,1.0), # dark
	Vector4(0.7,0.7,0.7,1.0), # light grey
	Vector4(0.5, 0.6, 0.2, 1.0), #Mossy green
	Vector4(0.4,0.2,0.9,1.0), # purple
	Vector4(0.9,0.4,0.2,1.0), # orange
	Vector4(0.2,0.6,0.6,1.0), # icy
	Vector4(0.9,0.3,0.8,1.0), # pink
	Vector4(0.1,0.1,0.9,1.0), # blue
	Vector4(0.8,0.2,0.3,1.0)
	] # Red
	
var _color2Posibilities : Array[Vector4] = [_defaultColor2, 
	Vector4(0.8, 0.8, 0.8, 1.0), # really white
	Vector4(0.5, 0.8, 0.5, 1.0), # light green 
	Vector4(0.5, 0.8, 0.5, 1.0), # light green 
	Vector4(0.5, 0.8, 0.5, 1.0), # light green 
	Vector4(0.5, 0.8, 0.5, 1.0), # light green 
	]


func GetDefaultColor1() -> Vector4:
	return _defaultColor1
	
func GetDefaultColor2() -> Vector4:
	return _defaultColor2
	
func GetRandomColor1() -> Vector4:
	return _color1Posibilities.pick_random()
	
func GetRandomColor2() -> Vector4:
	return _defaultColor2; #_color2Posibilities.pick_random()
