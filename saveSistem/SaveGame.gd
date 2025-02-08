extends Node2D
var config = ConfigFile.new()

func save(score):
	config.set_value("data", "hight_score", round(score))
	config.save("res://savegame.cfg")
	
func load():
	var hight_score = 0
	var err = config.load("res://savegame.cfg")
	if err == OK:
		hight_score = config.get_value("data","hight_score")
		return hight_score
	else:
		hight_score = 0
		return hight_score
	
