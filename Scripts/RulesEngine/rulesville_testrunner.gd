class_name RulesVilleTestRunner extends Node

func _init():
    CardLibrary.init_library()

    var gs = load_deck0()

    var requests: Array[GS_Request]
    requests.append(GS_Request.new(
        GS_Request.Type.PLAY_CARD,
        "",
        null,
        GS_Ref.Card.new(0),
        ))

    gs = gs.process_requests(requests)

	for e in gs.events:
		pass

func load_deck0() -> GameState:
    var gs = GameState.new(null)

    var requests: Array[GS_Request]
    requests.append(GS_Request.new(
        GS_Request.Type.CREATE_CARD,
        "testcard0",
        gs.query_zones_by_type(GameState.ZoneType.HAND).ref,
        null,
        ))

    gs = gs.process_requests(requests)

    return gs
