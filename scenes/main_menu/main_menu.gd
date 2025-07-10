extends Control

# buttons
@onready var play_button = $Buttons/Play
@onready var more_games_button = $Buttons/MoreGames
@onready var quit_button = $Buttons/Quit


func _ready():
	print(OS.get_name())
	OS.request_permissions()
	
	if (OS.get_name() == "Android" or OS.get_name() == "Web"):
		$Buttons/LeaderboardButton.disabled = true
	
	for button in $Buttons.get_children():
		if (button.get_class() != "AnimationPlayer"):
			button.pivot_offset = button.size / 2
	
	$HighscoreLabel.text = "My Best Score:\n" + str(Global.highscore)
	$AnimationPlayer.play("logo")
	$Buttons/AnimationPlayer.play("play_button")
	
	if (not Global.sfx):
		$Buttons/Sound.set_pressed(true)
	if (not Global.music):
		$Buttons/Music.set_pressed(true)
	
	# playing main menu music
	if (Global.music == true):
		if (Global.LevelMusic.playing):
			Global.LevelMusic.stop()
		if (not Global.MainMenuMusic.playing):
			Global.MainMenuMusic.play()
	
	if (Global.player_name == null):
		$WelcomeLabel.visible = false
		# ask for player name entry
		$Overlay.visible = true
		$PlayerUI.visible = true
		$PlayerUI/CloseButton.disabled = true
	else:
		$WelcomeLabel.text = "Welcome\n" + Global.player_name + "!"
		$WelcomeLabel.visible = true


func _process(delta):
	$Background.rotation_degrees += 20*delta


func _on_play_pressed():
	Global.play_sound("ClickSound")
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")

func _on_more_games_mouse_entered():
	more_games_button.scale = Vector2(1.2, 1.2)

func _on_more_games_mouse_exited():
	more_games_button.scale = Vector2.ONE

func _on_more_games_button_down():
	more_games_button.scale = Vector2(0.9, 0.9)

func _on_more_games_pressed():
	Global.play_sound("ClickSound")
	more_games_button.scale = Vector2(1.2, 1.2)
	OS.shell_open("https://lets-connect-team.itch.io/")




func _on_quit_mouse_entered():
	quit_button.scale = Vector2(1.2, 1.2)

func _on_quit_mouse_exited():
	quit_button.scale = Vector2.ONE

func _on_quit_button_down():
	quit_button.scale = Vector2(0.9, 0.9)

func _on_quit_pressed():
	Global.play_sound("ClickSound")
	quit_button.scale = Vector2(1.2, 1.2)
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "logo"):
		$AnimationPlayer.play("logo")
	
	if (anim_name == "play_button"):
		$Buttons/AnimationPlayer.play("play_button")


func _on_achievements_pressed():
	Global.play_sound("ClickSound")
	get_tree().change_scene_to_file("res://scenes/main_menu/achievements.tscn")


func _on_sound_toggled(button_pressed):
	if (button_pressed):
		Global.sfx = false
	else:
		Global.sfx = true


func _on_music_toggled(button_pressed):
	if (button_pressed):
		if (Global.MainMenuMusic.playing):
			Global.MainMenuMusic.stop()
		Global.music = false
	else:
		Global.MainMenuMusic.play()
		Global.music = true


func _on_how_to_play_pressed():
	Global.play_sound("ClickSound")
	get_tree().change_scene_to_file("res://scenes/main_menu/how_to_play.tscn")


func _on_close_button_pressed():
	Global.play_sound("ClickSound")
	$Overlay.visible = false
	$PlayerUI.visible = false


func _on_submit_button_pressed():
	if ($PlayerUI/TextEdit.text != ""):
		Global.player_name = $PlayerUI/TextEdit.text
		Global.save_player_name()
		if (Global.highscore != 0):
			Global.ldrboard_update(OS.get_unique_id(), Global.player_name, Global.highscore)
		_on_close_button_pressed()
		$WelcomeLabel.visible = true
		$WelcomeLabel.text = "Welcome\n" + Global.player_name + "!"


func _on_player_button_pressed():
	# ask for player name entry
	Global.play_sound("ClickSound")
	$Overlay.visible = true
	$PlayerUI.visible = true
	$PlayerUI/CloseButton.disabled = false
	if (Global.player_name != null):
		$PlayerUI/TextEdit.text = Global.player_name


func _on_clear_button_pressed():
	$PlayerUI/TextEdit.text = ""


func _on_leaderboard_button_pressed():
	Global.play_sound("ClickSound")
	OS.shell_open("https://candy-merge.ldrboard.com/")


func _on_twitter_pressed():
	Global.play_sound("ClickSound")
	OS.shell_open("https://twitter.com/letsconnectteam/")


func _on_rate_button_pressed():
	Global.play_sound("ClickSound")
	OS.shell_open("https://lets-connect-team.itch.io/candy-merge/rate?source=game")


func _on_donate_button_pressed():
	Global.play_sound("ClickSound")
	OS.shell_open("https://www.buymeacoffee.com/vaibhavkr")
