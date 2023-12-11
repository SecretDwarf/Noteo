extends Node2D

func _ready():
	# Assuming the child node you want to detect clicks on is named "NewGame" (which is a Button node)
	var button = %NewGame
	
	# Connect the "pressed" signal of the button node to the "_on_button_pressed" method in this script
	button.pressed.connect(self._button_pressed)

# Method called when the button is pressed
func _button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
