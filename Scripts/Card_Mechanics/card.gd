class_name card

extends Sprite2D

#references to our text boxes
var my_name
var my_cost
var my_text
var my_class 
var my_control

#Store our button 
var my_Button

#public card default image
@export var card_image = load("res://cardimages/black.png")

#goal position and size so we can lerp
var goal_position : Vector2
var goal_scale : Vector2
var travel_time : float = 0.32
var time_passed : float

#personal modifications to make in addition to anything asked of the deck
var position_offset : Vector2
var scale_offset : Vector2

#card information
var face_up = false
var selected = false
var cardname : String = "card"
var cardtext : String = "default card text"
var class_restriction : String
var costAP : int
var costMP : int

#signals sent based on mouse input. Decks pick up these signals. 
signal s_card_hovered(card)
signal s_card_clicked(card)

func _ready():
	set_process(false)

func set_up(_name = "Error Name", _text = "Error Text", _class = "Error Class", _costAP = -1, _costMP = -1, _face_up = true):
	cardname = _name
	cardtext = _text
	costAP = _costAP
	costMP = _costMP
	class_restriction = _class

	my_control = get_node("Control")
	my_name = my_control.get_node("Name")
	my_text = my_control.get_node("Text")
	my_cost = my_control.get_node("Cost")
	my_class = my_control.get_node("Class")
	my_Button = my_control.get_node("Button")

	my_name.text = cardname
	my_text.text = cardtext
	my_cost.text = str(costAP, "\n", costMP)
	my_class.text = class_restriction

	my_Button.mouse_entered.connect(_card_selected)
	my_Button.pressed.connect(_card_pressed)

	set_faceup(_face_up)


func _process(delta):
	time_passed += delta
	position = position.lerp(goal_position + position_offset, time_passed / travel_time)
	scale = scale.lerp(goal_scale + scale_offset, time_passed / travel_time)
	if(time_passed > travel_time):
		position = goal_position + position_offset
		scale = goal_scale + scale_offset
		set_process(false)

func as_string():
	return str(cardname, " \ntext: ", cardtext, " \nselected: ", selected)

func set_card_position(_desired_position : Vector2 = Vector2(0,0), _desired_scale : Vector2 = Vector2(1,1)):
	set_process(true)
	time_passed = 0
	goal_position = _desired_position
	goal_scale = _desired_scale

#sets whether or not we are the selected card and does associated modifications
func change_selection(new_state = true):
	#don't mess with it if we are already set correctly
	if(selected == new_state):
		return
		
	selected = new_state
	if(new_state):
		scale_offset = Vector2(0.1, 0.1)
		position_offset = Vector2(0, -100)
		z_index += 100
	else:
		scale_offset = Vector2(0, 0)
		position_offset = Vector2(0, 0)
		z_index -= 100
	
	set_card_position(goal_position, goal_scale)
	
#sets whether we can see rules text on the card. TODO: Toggle between top art and bottom art
func set_faceup(_face_up : bool):
	face_up = _face_up
	if(face_up):
		my_control.visible = true
		my_Button.disabled = false
	else:
		my_control.visible = false
		my_Button.disabled = true

#function called when a card is hovered
func _card_selected():
	s_card_hovered.emit(self)
	#print("Card Selected!")

#function called when a card is clicked
func _card_pressed():
	s_card_clicked.emit(self)