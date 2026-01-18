class_name GSRequest extends Object

enum Type {
	CREATE_CARD,
	CREATE_CHARACTER,
	DONE_WITH_LOAD,
	MAKE_CHOICE,
}

var type: Type
var name: String
var index: int
var zoneRef: GSRef.Zone
var cardRef: GSRef.Card

func _init(
	type: Type,
	name: String,
	index: int,
	zoneRef: GSRef.Zone,
	cardRef: GSRef.Card
):
	self.type = type
	self.name = name
	self.index = index
	self.zoneRef = zoneRef
	self.cardRef = cardRef

