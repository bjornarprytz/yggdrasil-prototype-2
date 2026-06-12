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

func resources(mutations: Dictionary[String, int]) -> Array[GameElement]:
    var elements: Array[GameElement] = []
    for key in mutations.keys():
        elements.append(ResourceChange.new(key, mutations[key]))
    return elements

func from_pool(filters: Database.Filters, n: int) -> Array[GameElement]:
    return Pool.draw_n(filters, n)
