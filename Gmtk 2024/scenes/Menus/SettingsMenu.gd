extends Control

@onready var slider : VSlider = $VBoxContainer/SoundSlider

func OnSoundContainerEntered():
	slider.visible = true

func OnSoundContainerExited():
	slider.visible = false
