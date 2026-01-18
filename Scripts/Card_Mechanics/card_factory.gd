extends Node

const path_CSVData = "res://CardData/PaperClasses.csv"
var CardLibrary
const cardScene = preload("card.tscn")

func _ready():
	load_data()

func load_data():
	var file_data = preload(path_CSVData)
	CardLibrary = file_data.records

func CreateCard(ind : int):
	var cardInstance = cardScene.instantiate()
	cardInstance.set_up(
		CardLibrary[ind]["Name"], 
		CardLibrary[ind]["Text"], 
		CardLibrary[ind]["Class"], 
		CardLibrary[ind]["AP Cost"], 
		CardLibrary[ind]["MC Cost"],  
		false)
	return cardInstance
