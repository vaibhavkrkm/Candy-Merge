extends Node2D


const TREATS = [
	preload("res://scenes/candy/orange_candy.tscn"),
	preload("res://scenes/candy/gummy_bear.tscn"),
	preload("res://scenes/candy/lollipop.tscn"),
	preload("res://scenes/candy/candy_cane.tscn"),
	preload("res://scenes/candy/peppermint_candy.tscn"),
	preload("res://scenes/candy/heart_lollipop.tscn"),
	preload("res://scenes/candy/spiral_lollipop.tscn"),
	preload("res://scenes/candy/gumball_machine.tscn"),
]
const SCORE_EFFECT = preload("res://scenes/level/score_effect.tscn")
const STARTING_TREAT = TREATS[0]

@onready var next_candy = STARTING_TREAT.instantiate()
@onready var next2_candy

var can_drop = true
var move_dir = null
var move_speed = 400


func _ready():
	# playing level music
	if (Global.music == true):
		if (Global.MainMenuMusic.playing):
			Global.MainMenuMusic.stop()
		if (not Global.LevelMusic.playing):
			Global.LevelMusic.play()
	update_treat_to_drop()
	
	var candy_no = randi_range(1, 4)
	var candy_ind
	if (candy_no < 4):
		candy_ind = randi_range(0, 2)
	else:
		candy_ind = 3
	next2_candy = TREATS[candy_ind].instantiate()
	$UI/NextBubble/TextureRect.texture = $TreatToDrop.get_node(str(next2_candy.name)).texture


func _process(delta):
	var right_offset
	var left_offset
	if (next_candy != null):
		right_offset = next_candy.WIDTH + 25
		left_offset = next_candy.WIDTH + 25
	else:
		right_offset = 50
		left_offset = 50
	
	if (OS.get_name() != "Android"):
		if (get_global_mouse_position().x > $GlassJar/Left.global_position.x + left_offset and get_global_mouse_position().x < $GlassJar/Right.global_position.x - right_offset):
			$TreatToDrop.position.x = get_global_mouse_position().x
		elif (get_global_mouse_position().x < $GlassJar/Left.global_position.x + left_offset):
			$TreatToDrop.position.x = $GlassJar/Left.global_position.x + left_offset
		elif (get_global_mouse_position().x > $GlassJar/Right.global_position.x - right_offset):
			$TreatToDrop.position.x = $GlassJar/Right.global_position.x - right_offset
	elif (OS.get_name() == "Android"):
		if (move_dir == "left" and $TreatToDrop.global_position.x > $GlassJar/Left.global_position.x + left_offset):
			$TreatToDrop.position.x -= move_speed * delta
		elif (move_dir == "right" and $TreatToDrop.global_position.x < $GlassJar/Right.global_position.x - right_offset):
			$TreatToDrop.position.x += move_speed * delta
		else:
			if ($TreatToDrop.global_position.x < $GlassJar/Left.global_position.x + left_offset):
				$TreatToDrop.position.x = $GlassJar/Left.global_position.x + left_offset
			elif ($TreatToDrop.global_position.x > $GlassJar/Right.global_position.x - right_offset):
				$TreatToDrop.position.x = $GlassJar/Right.global_position.x - right_offset
	
	$UI/ScoreBubble/Label.text = "Score: " + str(Global.score)
	
	$Background.rotation_degrees += 5*delta


func _input(event):
	if (OS.get_name() != "Android"):
		if (event.is_action_pressed("drop") and $NextCandyTimer.is_stopped() and can_drop):
			# spawn treat
			spawn_candy(next_candy, $TreatToDrop.position)
			update_treat_to_drop("invisible")
			$NextCandyTimer.start()


func spawn_candy(current_treat, pos, score_effect=false, tier=null):
	if (typeof(current_treat) == 24):    # if spawning during drop
		Global.play_sound("DropSound")
		current_treat.position = pos
		$Candies.add_child(current_treat)
	elif (typeof(current_treat) == TYPE_INT):    # if spawning when 2 candies merge
		var ind = current_treat - 1
		var treat = TREATS[ind].instantiate()
		treat.position = pos
		$Candies.add_child(treat)
	
	if (score_effect == true):
		var current_effect = SCORE_EFFECT.instantiate()
		current_effect.position = pos - current_effect.size*2
		current_effect.set_score(tier)
		$Others.add_child(current_effect)


func play_gumball_effect():
	$GumballCombineEffect.set_emitting(true)


func show_ach_unlocked(ach_texture, ach_title):
	$UI/AchievementUnlockedUI/Icon.texture = ach_texture
	$UI/AchievementUnlockedUI/TitleLabel.text = ach_title
	$UI/AchievementUnlockedUI.visible = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($UI/AchievementUnlockedUI, "position", Vector2($UI/AchievementUnlockedUI.position.x, $UI/AchievementUnlockedUI.position.y+140), 0.5).from_current().set_ease(Tween.EASE_IN)
	tween.tween_callback(emit_ach_particles)
	$AchievementTimer.start()


func emit_ach_particles():
	$UI/AchievementUnlockedUI/GPUParticles2D.emitting = true


func hide_ach_unlocked():
	$UI/AchievementUnlockedUI.visible = false


func update_treat_to_drop(flag="visible"):
	if (flag == "visible"):
		for treat in $TreatToDrop.get_children():
			if (treat.name == next_candy.name or treat.name == "DropLine"):
				treat.visible = true
			else:
				treat.visible = false
	else:
		for treat in $TreatToDrop.get_children():
			treat.visible = false


func gameover():
	get_tree().paused = true
	$UI/Overlay.visible = true
	$UI/GameoverUI/ScoreLabel.text = "You Scored: " + str(Global.score) + "!"
	$UI/GameoverUI.visible = true
	
	if (Global.score > Global.highscore):
		# new highscore achieved
		Global.play_sound("NewHighscoreSound")
		$UI/GameoverUI/NewHighscore.visible = true
		Global.highscore = Global.score
		Global.save_highscore()
		Global.ldrboard_update(OS.get_unique_id(), Global.player_name, Global.highscore)
	else:
		Global.play_sound("GameoverSound")
		$UI/GameoverUI/NewHighscore.visible = false


func _on_next_candy_timer_timeout():
	var candy_no = randi_range(1, 4)
	var candy_ind
	if (candy_no < 4):
		candy_ind = randi_range(0, 2)
	else:
		candy_ind = 3
	next_candy = next2_candy
	next2_candy = TREATS[candy_ind].instantiate()
	$UI/NextBubble/TextureRect.texture = $TreatToDrop.get_node(str(next2_candy.name)).texture
	update_treat_to_drop()


func _on_game_timer_timeout():
	Global.game_time += 1
	$UI/TimeBubble/Label.text = "Your Time:\n" + str(Global.format_time(Global.game_time))


func _on_jar_limit_body_entered(body):
	if (body.jar_limit_collision):
		gameover()


func _on_home_pressed():
	Global.play_sound("ClickSound")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	Global.reset_game()


func _on_pause_pressed():
	Global.play_sound("ClickSound")
	get_tree().paused = true
	$UI/Overlay.visible = true
	$UI/PauseUI.visible = true


func _on_continue_pressed():
	Global.play_sound("ClickSound")
	$UI/Overlay.visible = false
	$UI/PauseUI.visible = false
	get_tree().paused = false


func _on_pause_mouse_entered():
	can_drop = false


func _on_pause_mouse_exited():
	can_drop = true


func _on_replay_pressed():
	Global.play_sound("ClickSound")
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
	get_tree().paused = false


func _on_achievement_timer_timeout():
	var tween = create_tween()
	tween.tween_property($UI/AchievementUnlockedUI, "position", Vector2($UI/AchievementUnlockedUI.position.x, $UI/AchievementUnlockedUI.position.y-140), 0.5).from_current().set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide_ach_unlocked)


func _on_left_button_pressed():
	move_dir = "left"


func _on_left_button_released():
	move_dir = null


func _on_right_button_pressed():
	move_dir = "right"


func _on_right_button_released():
	move_dir = null


func _on_drop_button_pressed():
	if ($NextCandyTimer.is_stopped() and can_drop):
		# spawn treat
		spawn_candy(next_candy, $TreatToDrop.position)
		update_treat_to_drop("invisible")
		$NextCandyTimer.start()


func _on_request_completed(result, response_code, headers, body):
	print("request_completed")
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json)

func ldrboard_update(playerID, playerName, score):
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
