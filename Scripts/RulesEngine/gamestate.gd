class_name GameState extends Object

enum ZoneType {
    DECK,
    DISCARD,
    HAND,
}

class GS_Zone:
    var ref: GS_Ref.Zone
    var type: ZoneType
    var cards: Array[GS_Ref.Card]

    func _init(type: ZoneType):
        self.type = type

class GS_Card:
    var ref: GS_Ref.Card
    var name: String
    var zone: GS_Ref.Zone

enum CharacterType {
    WARRIOR,
    ROGUE,
    WIZARD,
    CLERIC
}

class GS_Character:
    var ref: GS_Ref.Character

    var faction: int
    var hp: int
    var mana: int

var zones: Array[GS_Zone]
var cards: Array[GS_Card]
var characters: Array[GS_Character]

func _init(existing: GameState):
    if (existing == null):
        _create_zone(ZoneType.DECK)
        _create_zone(ZoneType.DISCARD)
        _create_zone(ZoneType.HAND)
    else:
        zones = existing.zones.duplicate(true)
        cards = existing.cards.duplicate(true)
        characters = existing.characters.duplicate()

func get_zone(ref: GS_Ref.Zone) -> GS_Zone:
    return zones[ref.index]

func _create_zone(zonetype: ZoneType) -> GS_Ref.Zone:
    var zone = GS_Zone.new(zonetype)
    zone.ref = GS_Ref.Zone.new(zones.size())

    zones.append(zone)

    return zone.ref

func query_zones_by_type(type: ZoneType) -> GS_Zone:
    for z in zones:
        if z.type == type:
            return z

    return null

func get_card(ref: GS_Ref.Card) -> GS_Card:
    return cards[ref.index]

func _create_card(name: String, zone: GS_Ref.Zone) -> GS_Ref.Card:
    var card = GS_Card.new()
    card.ref = GS_Ref.Card.new(cards.size())
    card.name = name
    card.zone = zone

    cards.append(card)

    var _zone = get_zone(zone)
    _zone.cards.append(card.ref)

    return card.ref

func get_character(ref: GS_Ref.Character) -> GS_Character:
    return characters[ref.index]

func _create_character() -> GS_Ref.Character:
    var character = GS_Character.new()
    character.ref = GS_Ref.Character.new(characters.size())

    characters.append(character)

    return character.ref

func process_requests(requests: Array[GS_Request]) -> GameState:
    var result: GameState = GameState.new(self)

    for req in requests:
        match req.type:
            GS_Request.Type.CREATE_CARD:
                result._create_card(req.name, req.zoneRef)

            GS_Request.Type.CREATE_CHARACTER:
                print("create character")

            GS_Request.Type.PLAY_CARD:
                var card = result.get_card(req.cardRef)
                var def = CardLibrary.get_card(card.name)
                for s in def.steps:
                    s.call()

    return result

