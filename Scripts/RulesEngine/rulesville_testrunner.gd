class_name RulesVilleTestRunner extends Node

func _init():
    CardLibrary.init_library()

    var gs = load_deck0()

	#var requests: Array[GSRequest]
	#requests.append(GSRequest.new(
    #    GSRequest.Type.MAKE_CHOICE,
    #    "",
	#	0,
    #    null,
    #    GSRef.Card.new(0),
    #    ))

    #gs = gs.process_requests(requests)

    #for e in gs.events:
    #    pass

func load_deck0() -> GameState:
    var gs = GameState.new(null)

    var requests: Array[GSRequest]
    requests.append(GSRequest.new(
        GSRequest.Type.CREATE_CARD,
        "testcard0",
		0,
        gs.query_zones_by_type(GameState.ZoneType.HAND).ref,
        null,
        ))

    requests.append(GSRequest.new(
        GSRequest.Type.DONE_WITH_LOAD,
		"",
		0,
		null,
        null,
        ))

    gs = gs.process_requests(requests)

    return gs
