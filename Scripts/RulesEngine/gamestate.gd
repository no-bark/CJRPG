class_name GameState extends Object

class GS_CharacterRef:
    var index: int

    func _init(index: int):
        self.index = index

class GS_ZoneRef:
    var index: int

    func _init(index: int):
        self.index = index

class GS_CardRef:
    var index: int

    func _init(index: int):
        self.index = index

enum ZoneType {
    DECK,
    DISCARD,
    HAND,
}

class GS_Zone:
    var ref: GS_ZoneRef
    var type: ZoneType
    var cards: Array[GS_CardRef]

    func _init(type: ZoneType):
        self.type = type

class GS_Card:
    var ref: GS_CardRef
    var name: String
    var zone: GS_ZoneRef

enum CharacterType {
    WARRIOR,
    ROGUE,
    WIZARD,
    CLERIC
}

class GS_Character:
    var ref: GS_CharacterRef

    var faction: int
    var hp: int
    var mana: int

var zones: Array[GS_Zone]
var cards: Array[GS_Card]
var characters: Array[GS_Character]

func _init(existing: GameState):
    if (existing == null):
        create_zone(ZoneType.DECK)
        create_zone(ZoneType.DISCARD)
        create_zone(ZoneType.HAND)
    else:
         zones = existing.zones.duplicate(true)
         cards = existing.zones.duplicate(true)
         characters = existing.characters.duplicate()

func get_zone(ref: GS_ZoneRef) -> GS_Zone:
    return zones[ref.index]

func create_zone(zonetype: ZoneType) -> GS_ZoneRef:
    var zone = GS_Zone.new(zonetype)
    zone.ref = GS_ZoneRef.new(zones.size())

    zones.append(zone)

    return zone.ref

func query_zones_by_type(type: ZoneType) -> GS_Zone:
    for z in zones:
        if z.type == type:
            return z

    return null

func get_card(ref: GS_CardRef) -> GS_Card:
    return cards[ref.index]

func create_card(name: String, zone: GS_ZoneRef) -> GS_CardRef:
    var card = GS_Card.new()
    card.ref = GS_CardRef.new(cards.size())
    card.name = name
    card.zone = zone

    cards.append(card)

    var _zone = get_zone(zone)
    _zone.cards.append(card.ref)

    return card.ref

func get_character(ref: GS_CharacterRef) -> GS_Character:
    return characters[ref.index]

func create_character() -> GS_CharacterRef:
    var character = GS_Character.new()
    character.ref = GS_CharacterRef.new(characters.size())

    characters.append(character)

    return character.ref

