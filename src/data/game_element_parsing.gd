class_name GameElementParser
extends Resource

const MAX_OPTIONS:=10

static func parse(record : Dictionary) -> GameElement:
	if (record["Type"] == "event"):
		var e = EventData.new()
		e.id = record["Name"]
		e.intro_text = record["IntroText"]
		e.background = record["Background"]
		for i in range(1, MAX_OPTIONS):
			var key = "Option%d" % i
			if not record.has(key):
				break
			e.options.append(record[key])
		if record.has("Tags"):
			for t in record["Tags"].split("|"):
				e.tags.append(t)
		
		return e
	
	push_error("Not yet implemented")
	
	return null
