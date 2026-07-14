class_name GameElementParser
extends Resource

const MAX_OPTIONS:=10

static func parse_event(record : Dictionary) -> GameElement:
	var e = EventData.new()
	e.id = record["Name"]
	e.intro_text = record["IntroText"]
	e.background = record["Background"]
	for i in range(1, MAX_OPTIONS):
		var key = "Option%d" % i
		if not record.has(key):
			break
		var opt := EventOption.new()
		opt.label = record[key]
		e.options.append(opt)
	if record.has("Tags"):
		for t in record["Tags"].split("|"):
			e.tags.append(t)
	
	return e


static func parse_enemy(record : Dictionary) -> GameElement:
	var e = EnemyData.new()
	e.id = record["Name"]
	e.strength = record["Strength"]
	e.sprite_path = record["Sprite"]
	if record.has("Tags"):
		for t in record["Tags"].split("|"):
			e.tags.append(t)
	return e
