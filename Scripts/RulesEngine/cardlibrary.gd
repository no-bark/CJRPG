class_name CardLibrary extends Object

class CardDef:
    var name: String
    var characterType: GameState.CharacterType
    var text: String
    var steps: Array[Callable]

    func _init(name: String,
               characterType: GameState.CharacterType,
               text: String,
               steps: Array[Callable]):
        self.name = name
        self.characterType = characterType
        self.text = text
        self.steps = steps

static var card_defs: Dictionary

static func init_library():
    card_defs["testcard0"] = CardDef.new(
		"testcard0",
		GameState.CharacterType.WARRIOR,
		"this is testcard0",
        [
            Callable(CardLibrary, "testcard0_step0"),
            Callable(CardLibrary, "testcard0_step1")
        ]
    )

static func get_card(cardid: String) -> CardDef:
    return card_defs[cardid]

static func testcard0_step0():
    print("testcard0_step0")

static func testcard0_step1():
    print("testcard0_step1")
