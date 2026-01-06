class_name CardLibrary extends Object

class CardDef:
    var steps: Array[Callable]

    func _init(steps: Array[Callable]):
        self.steps = steps

static var card_defs: Dictionary

static func init_library():
    card_defs["testcard0"] = CardDef.new(
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
