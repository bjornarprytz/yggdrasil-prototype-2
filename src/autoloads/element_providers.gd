extends Node

func select(ids: Array[String]) -> Array[GameElement]:
    var elements: Array[GameElement] = []
    for id in ids:
        var hit = Database.get_element(id)
        if hit:
            elements.append(hit)
        else:
            push_warning("Element with id %s not found in database" % id)
    return elements

func resource_outcomes(mutations: Dictionary[String, int]) -> Array[Outcome]:
    var outcomes: Array[Outcome] = []
    for key in mutations.keys():
        var o := Outcome.new()
        o.type = Outcome.Type.RESOURCE_CHANGE
        o.resource_type = key
        o.amount_min = mutations[key]
        o.amount_max = mutations[key]
        outcomes.append(o)
    return outcomes

func from_pool(filters: Database.Filters, n: int) -> Array[GameElement]:
    return Pool.draw_n(filters, n)
