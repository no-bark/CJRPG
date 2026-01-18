class_name GS_Request extends Object

enum Type {
	CREATE_CARD,
	CREATE_CHARACTER,
	PLAY_CARD,
}

func _init(
	type: Type,
	name: String,
	zoneRef: GS_Ref.Zone,
	cardRef: GS_Ref.Card
):
	self.type = type
	self.name = name
	self.zoneRef = zoneRef
	self.cardRef = cardRef

var type: Type
var name: String
var zoneRef: GS_Ref.Zone
var cardRef: GS_Ref.Card

