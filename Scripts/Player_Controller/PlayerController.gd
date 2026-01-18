extends Node

#references to decks we control as a player
var my_deck
var my_hand
var my_discard
var my_active_zone

#card factory so we don't have to control the library of cards or file i/o
var my_factory

#the cards to ask our card factory to make at the start
@export var StartingDeck : Array[int]

const cardScene = preload("res://Scripts/Card_Mechanics/card.tscn")

func _ready():
	my_deck = get_node("Deck")
	my_hand = get_node("Hand")
	my_factory = get_node("CardFactory")
	my_discard = get_node("Discard")
	my_active_zone = get_node("ActiveZone")

	#listening for when a hand card is clicked so we can send it to the active zone
	my_hand.s_contained_card_clicked.connect(hand_card_clicked)

	#starting deck set up
	for n in StartingDeck:
		my_deck.add_card(my_factory.CreateCard(n))

func _input(_input_event):
	#input: D
	#effect: Draw a card from the deck into hand
	if(_input_event.is_action_pressed("draw_card", false, true)):
		for n in (my_deck.draw(1)):
			print(n.as_string())
			my_hand.add_card(n)
		print("~~~~")
	
	#input: A
	#effect: Return the active card from hand to the deck
	if(_input_event.is_action_pressed("add_card", false, true)):
		var drawn_card = my_hand.draw_selected()
		print(drawn_card.as_string())
		my_deck.add_card(drawn_card)
		print("~~~~")
	
	#input: L
	#effect: Look at the entire deck
	if(_input_event.is_action_pressed("look_deck", false, true)):
		my_deck.print_cards()
		print("~~~~")
	
	#input: T
	#effect: Print the top card of the deck
	if(_input_event.is_action_pressed("look_top", false, true)):
		my_deck.print_cards(1)
		print("~~~~")

	#input: S
	#effect: Return the discard pile to the deck, then shuffle 
	if(_input_event.is_action_pressed("shuffle", false, true)):
		my_deck.add_multiple_cards(my_discard.draw(my_discard.cards.size()))
		my_deck.shuffle()
		print("Shuffle Successful")
		print("~~~~")

	#input: left
	#effect: Scroll left in hand
	if(_input_event.is_action_pressed("scroll_left", true, true)):
		my_hand.scroll(true)

	#input: right
	#effect: Scroll right in hand
	if(_input_event.is_action_pressed("scroll_right", true, true)):
		my_hand.scroll(false)
	
	#input: space
	#effect: "Play" a card into discard
	if(_input_event.is_action_pressed("discard_selected", false, true)):
		if(my_active_zone.cards.size() > 0):
			my_discard.add_card(my_active_zone.draw_selected())
			my_hand.active = true

		elif(!my_hand.cards.is_empty()):
			my_discard.add_card(my_hand.draw_selected())

	#input: right click
	if(_input_event.is_action_pressed("deselect_card", false, true)):
		if(my_active_zone.cards.size() > 0):
			var active_drawn_card = my_active_zone.draw_selected()
			if(active_drawn_card != null):
				my_hand.add_card(active_drawn_card)
			
			my_hand.active = true

func hand_card_clicked(clicked_card : card):
	var active_drawn_card = null
	if(my_active_zone.cards.size()> 0):
		active_drawn_card = my_active_zone.draw_selected()

	my_hand.active = false

	print("Card clicked! Card: ", clicked_card.as_string())
	my_hand.selectCard(clicked_card)
	var drawn_card = my_hand.draw_selected()
	print(drawn_card.as_string())
	my_active_zone.add_card(drawn_card)

	if(active_drawn_card != null):
		my_hand.add_card(active_drawn_card)
