class_name GameState extends Object

enum GSTurnPhase {
    START,
    PLAY_CARD,
    SELECT_TARGETS,
    APPLY,
    END,
}

enum ZoneType {
    DECK,
    DISCARD,
    HAND,
}

enum CharacterType {
    WARRIOR,
    ROGUE,
    WIZARD,
    CLERIC
}

class GSZone:
    var ref: GSRef.Zone
    var type: ZoneType
    var cards: Array[GSRef.Card]

    func _init(type: ZoneType):
        self.type = type

class GSCard:
    var ref: GSRef.Card
    var name: String
    var zone: GSRef.Zone

class GSCharacter:
    var ref: GSRef.Character

    var faction: int
    var hp: int
    var mana: int

class GSVars:
    var loaded: bool
    var turn: int
    var phase: GSTurnPhase
    var awaitingChoice: bool

var vars: GSVars
var zones: Array[GSZone]
var cards: Array[GSCard]
var characters: Array[GSCharacter]

func _init(existing: GameState):
    if (existing == null):
        vars = GSVars.new()
        _create_zone(ZoneType.DECK)
        _create_zone(ZoneType.DISCARD)
        _create_zone(ZoneType.HAND)
    else:
        vars = existing.vars.duplicate(true)
        zones = existing.zones.duplicate(true)
        cards = existing.cards.duplicate(true)
        characters = existing.characters.duplicate()

func get_zone(ref: GSRef.Zone) -> GSZone:
    return zones[ref.index]

func _create_zone(zonetype: ZoneType) -> GSRef.Zone:
    var zone = GSZone.new(zonetype)
    zone.ref = GSRef.Zone.new(zones.size())

    zones.append(zone)

    return zone.ref

func query_zones_by_type(type: ZoneType) -> GSZone:
    for z in zones:
        if z.type == type:
            return z

    return null

func get_card(ref: GSRef.Card) -> GSCard:
    return cards[ref.index]

func _create_card(name: String, zoneRef: GSRef.Zone) -> GSRef.Card:
    var card = GSCard.new()
    card.ref = GSRef.Card.new(cards.size())
    card.name = name
    card.zone = zoneRef

    cards.append(card)

    var zone = get_zone(zoneRef)
    zone.cards.append(card.ref)

    return card.ref

func get_character(ref: GSRef.Character) -> GSCharacter:
    return characters[ref.index]

func _create_character() -> GSRef.Character:
    var character = GSCharacter.new()
    character.ref = GSRef.Character.new(characters.size())

    characters.append(character)

    return character.ref

func process_requests(user_requests: Array[GSRequest]) -> GameState:
    var result: GameState = GameState.new(self)
    var requests: Array[GSRequest] = user_requests

    while true:
        var wasLoaded: bool = result.vars.loaded
        var done: bool = true

        for req in requests:
            match req.type:
                GSRequest.Type.CREATE_CARD:
                    result._create_card(req.name, req.zoneRef)

                GSRequest.Type.CREATE_CHARACTER:
                    print("create character")

                GSRequest.Type.DONE_WITH_LOAD:
                    result.vars.loaded = true

                GSRequest.Type.MAKE_CHOICE:
                    print("make choice")
                    #var card = result.get_card(req.cardRef)
                    #var def = CardLibrary.get_card(card.name)
                    #for s in def.steps:
                    #    s.call()

        requests = []

        if not wasLoaded and result.vars.loaded:
            print("gamestate: done loading")
            done = false

        if not result.vars.awaitingChoice:
            print("gamestate: advance phase")
            done = false
			result.vars.phase += 1
			result.vars.awaitingChoice = false

		match result.vars.phase:
			GSTurnPhase.START:
				print("gamestate begin: START")

			GSTurnPhase.PLAY_CARD:
				print("gamestate begin: PLAY_CARD")

			GSTurnPhase.SELECT_TARGETS:
				print("gamestate begin: SELECT_TARGETS")

			GSTurnPhase.APPLY:
				print("gamestate begin: APPLY")

			GSTurnPhase.END:
				print("gamestate begin: END")
				result.vars.turn += 1
				result.vars.phase = GSTurnPhase.START

        if done:
            break

    return result

