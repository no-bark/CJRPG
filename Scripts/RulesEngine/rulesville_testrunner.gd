class_name RulesVilleTestRunner extends Node

#var GameState = load("Scripts/RulesEngine/gamestate.gd")

func _init():
    CardLibrary.init_library()

    var gs = load_deck0()

    var ref = GameState.GS_CardRef.new(0)
    var card = gs.get_card(ref)
    var def = CardLibrary.get_card(card.name)
    for s in def.steps:
        s.call()

func load_deck0() -> GameState:
    var gs = GameState.new(null)

    gs.create_card("testcard0", GameState.ZoneType.DECK)

    return gs
    
