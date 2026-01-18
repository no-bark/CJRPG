extends Control

const cardScene = preload("card.tscn")

@export var cardScale : Vector2 = Vector2(1, 1) #how big the cards are while in this deck
@export var public : bool #whether or not the cards in this deck are face up
@export var active : bool = false #whether or not the deck should have a card selected
@export var backsideImage = load("res://cardimages/page08.jpg") #what back art should cards have while in this deck TODO: something else

const cardWidthAbsolute : int = 850 #how wide the cards are in pixels 

var cards : Array[card]
var selectedCard : int = 0
var selectedCardRef : card

#when a card in our deck gets clicked, this signal is called
signal s_contained_card_clicked(clicked_card : card)

var size_indicator

func _ready():
	size_indicator = get_node("Decksize_Indicator")

	shuffle()
	if(public):
		for n in cards:
			n.texture = n.card_image
			place_card(n)
	else:
		for n in cards:
			n.texture = backsideImage
			place_card(n)
	spread()
	boundSelectedCard()

#draw the top n cards of the deck into a list of output cards
func draw(number):
	var output_cards : Array[card] = []
	if number <= cards.size():
		print("draw good!")
		for n in number:
			var drawn_card = p_draw_card(cards.size() - 1)
			output_cards.append(drawn_card)
		print("cards left:", cards.size())
		spread()
	else:
		print("draw bad!")
		print("cards left:", cards.size())
	boundSelectedCard()
	return output_cards

func draw_selected():
	if(boundSelectedCard()):
		return p_draw_card(selectedCard)
	else:
		return null

#private helper function for removing cards from the list and doing book-keeping
func p_draw_card(index : int):
	var drawn_card = cards[index]

	cards[index].s_card_hovered.disconnect(card_hovered)
	cards[index].s_card_clicked.disconnect(card_clicked)
	cards.remove_at(index)
	spread()
	boundSelectedCard()
	drawn_card.change_selection(false)

	return drawn_card

	
#wrapper to add chunks of cards cleanly
func add_multiple_cards(added_cards : Array[card]):
	for n in added_cards:
		add_card(n)

#add a card to this deck at the top
func add_card(added_card : card):
	if(public):
		added_card.texture = added_card.card_image
		added_card.set_faceup(true)
	else:
		added_card.texture = backsideImage
		added_card.set_faceup(false)
	cards.append(added_card)

	added_card.s_card_hovered.connect(card_hovered)
	added_card.s_card_clicked.connect(card_clicked)

	if(added_card.get_parent() == null):
		add_child(added_card)
	else:
		added_card.reparent(self, true)
	place_card(added_card)
	spread()
	boundSelectedCard()

#when a card in our deck gets hovered, this function gets called
func card_hovered(hovered_card : card):
	selectCard(hovered_card)

#when a card in our deck gets clicked, this function is called
func card_clicked(clicked_card : card):
	s_contained_card_clicked.emit(clicked_card)

func print_cards(count = 0):
	var desired_cards : Array[card] = []
	if (count != 0 && count < cards.size()):
		desired_cards.append_array(cards.slice(cards.size() - (count), cards.size()))
	else:
		desired_cards.append_array(cards)

	for n in desired_cards:
		print(n.as_string())

func shuffle():
	cards.shuffle()
	spread()

#spread cards across the range this deck has access to
func spread():
	#don't divide by 0 if the list is empty
	if(cards.is_empty()):
		return
	
	#Cards should be the minimum distance apart between jamming them together and placing them next to one another
	var card_distance = min(size_indicator.position.x / cards.size(), (cardWidthAbsolute * cardScale.x))
	var index = 0

	#set each card card_distance apart
	for card_iter in cards:
		card_iter.set_card_position(Vector2(card_distance * index, 0), cardScale)

		#zero out then z-order the cards by deck order
		card_iter.z_index -= card_iter.z_index % 100
		card_iter.z_index += index

		index += 1

#put a card in the stack and make it the right size
func place_card(card_to_place):
	card_to_place.set_card_position(card_to_place.goal_position, cardScale)
	
#Move the indicated card left or right. False = right, True = left
func scroll(left_or_right = false):
	boundSelectedCard()
	
	#move left
	if(left_or_right):
		#can't move further left than 0
		if(selectedCard <= 0):
			return
		else:
			selectedCard -= 1

	#move right
	else:
		#can't move further right than size - 1
		if((selectedCard + 1) >= cards.size()):
			return
		else:
			selectedCard += 1
	updateSelectedCard()

#used to select a specific card rather than scroll
func selectCard(chosenCard: card):
	selectedCard = cards.find(chosenCard)
	updateSelectedCard()

#called each time card selection changes
func updateSelectedCard():
	#if we aren't active, don't worry about our selected card
	if(active == false):
		return
		
	#deselelect the previous card
	if(selectedCardRef != null && public):
		selectedCardRef.change_selection(false)

	#if the new card is valid select that. Otherwise, empty out our ref
	if(selectedCard < cards.size() && selectedCard >= 0):
		if(public):
			cards[selectedCard].change_selection(true)
		selectedCardRef = cards[selectedCard]
	else:
		selectedCardRef = null

func boundSelectedCard():
	if(cards.is_empty()):
		selectedCard = -1
		updateSelectedCard()
		return false

	#bound our selected card within the current list
	if(selectedCard < 0):
		selectedCard = 0
	elif(selectedCard >= cards.size()):
		selectedCard = (cards.size() - 1)
	updateSelectedCard()
	return true
