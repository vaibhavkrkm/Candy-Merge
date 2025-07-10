extends Node


var sfx = true
var music = true

const highscore_path = "user://highscore.dat"
const ach_path = "user://ach.dat"
const plr_path = "user://plr.dat"

# nodes
@onready var MainMenuMusic = $Music/MainMenuMusic
@onready var LevelMusic = $Music/LevelMusic
@onready var Combine1 = $Sounds/Combine1Sound
@onready var Combine2 = $Sounds/Combine2Sound

var game_time = 0  # in seconds
var score = 0

var player_name = null
var highscore = 0
var achievements = {
	"SugarRush": [0, false, 1],
	"GummyMaster": [0, false, 100],
	"LollipopLover": [0, false, 75],
	"CandyCaneCraze": [0, false, 50],
	"PeppermintPower": [0, false, 50],
	"SweetHeart": [0, false, 50],
	"SpiralSensation": [0, false, 20],
	"GumballStarter": [0, false, 1],
	"GumballCombiner": [0, false, 1],
	"GumballGenius": [0, false, 50],
}

@onready var achievement_icons = {
	"SugarRush": get_node("AchievementIcons/Icon1"),
	"GummyMaster": get_node("AchievementIcons/Icon1"),
	"LollipopLover": get_node("AchievementIcons/Icon2"),
	"CandyCaneCraze": get_node("AchievementIcons/Icon2"),
	"PeppermintPower": get_node("AchievementIcons/Icon2"),
	"SweetHeart": get_node("AchievementIcons/Icon3"),
	"SpiralSensation": get_node("AchievementIcons/Icon3"),
	"GumballStarter": get_node("AchievementIcons/Icon4"),
	"GumballCombiner": get_node("AchievementIcons/Icon4"),
	"GumballGenius": get_node("AchievementIcons/Icon4"),
}


func reset_game():
	score = 0
	game_time = 0


func play_sound(sound):
	if (sfx):
		$Sounds.get_node(sound).play()


func format_time(seconds):
	var minutes = int(seconds / 60)
	var remaining_seconds = int(seconds % 60)
	return "%02d:%02d" % [minutes, remaining_seconds]


func append_score(tier):
	if (tier != 8):
		score += 10*tier
	else:
		score += 1000


func save_highscore():
	var highscore_file = FileAccess.open(highscore_path, FileAccess.WRITE)
	highscore_file.store_32(highscore)
	highscore_file.close()


func load_highscore():
	var highscore_file = FileAccess.open(highscore_path, FileAccess.READ)
	if (FileAccess.file_exists(highscore_path)):
		highscore = highscore_file.get_32()
		highscore_file.close()


func save_player_name():
	var plr_file = FileAccess.open(plr_path, FileAccess.WRITE)
	plr_file.store_var(player_name)
	plr_file.close()


func load_player_name():
	var plr_file = FileAccess.open(plr_path, FileAccess.READ)
	if (FileAccess.file_exists(plr_path)):
		player_name = plr_file.get_var()
		plr_file.close()


func save_ach():
	var ach_file = FileAccess.open(ach_path, FileAccess.WRITE)
	ach_file.store_var(achievements)
	ach_file.close()


func load_ach():
	var ach_file = FileAccess.open(ach_path, FileAccess.READ)
	if (FileAccess.file_exists(ach_path)):
		achievements = ach_file.get_var()
		ach_file.close()


func _on_request_completed(result, response_code, headers, body):
	print("request_completed")
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)


func ldrboard_update(playerID, playerName, score):
	if (OS.get_name() != "Web" and OS.get_name() != "Android"):
		print("ldrboard_update")
		var url = "https://api.ldrboard.com/api/v1/ldrboard/candy-merge/log?test=false"
		var json = JSON.stringify(
				{
				"player_unique_id": playerID, # a unique id for each player
				"player_name": playerName, # the name of the player
				"session_id": "string", # doesn't really matter in your case but if players are playing together, we use this to provide match history in the future
				"error_on_null_player_name": false, # relevant if you don't want us to auto generate a player name if player_name is empty,
				"score": score
			}
		)
		var headers = ["Content-Type: application/json", "api-key: lamb16", "game-id: 16"]
		$HTTPRequest.request_completed.connect(_on_request_completed)
		$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)
