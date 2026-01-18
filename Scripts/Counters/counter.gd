extends Control

@export var Starting_Value : int = 0
var value : int = 0

var label

func _ready():
	#save our private variable as the starting value
	value = Starting_Value

	#find our children
	var increase_button = find_child("Increase_Button")
	var decrease_button = find_child("Decrease_Button")
	label = find_child("Value")

	#correctly label our buttons and connect to relevant functions
	increase_button.text = "+"
	increase_button.pressed.connect(_increase_pressed)

	decrease_button.text = "-"
	decrease_button.pressed.connect(_decrease_pressed)

	#start off with our starting value
	label.text = str(value)

#Do this when "+" is pressed
func _increase_pressed():
	value += 1
	label.text = str(value)

#Do this when "-" is pressed
func _decrease_pressed():
	value -= 1
	label.text = str(value)
