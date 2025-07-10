extends RigidBody2D


@export var TIER: int
@export var WIDTH: int

var jar_limit_collision = false
var ach = Global.achievements


func get_avg_pos(other_pos):
	return (global_position + other_pos) / 2


func _on_body_entered(body):
	jar_limit_collision = true
	if (not body is StaticBody2D):
		var this_id = get_instance_id()
		var other_id = body.get_instance_id()
		
		if (this_id > other_id):
			if (TIER == body.TIER):
				# work with achievements
				# Ach 1
				if (ach["SugarRush"][1] == false):
					ach["SugarRush"][0] += 1
					if (ach["SugarRush"][0] >= ach["SugarRush"][2]):
						ach["SugarRush"][1] = true
						get_tree().call_group(
							"LevelGroup",
							"show_ach_unlocked",
							Global.achievement_icons["SugarRush"].texture,
							"🍬 Sugar Rush"
						)
						Global.play_sound("AchievementSound")
					Global.save_ach()
				
				# Ach 2
				if (ach["GummyMaster"][1] == false):
					if (body.name == "OrangeCandy"):
						ach["GummyMaster"][0] += 1
						if (ach["GummyMaster"][0] >= ach["GummyMaster"][2]):
							ach["GummyMaster"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["GummyMaster"].texture,
								"🍬 Gummy Master"
							)
						Global.save_ach()
				
				# Ach 3
				if (ach["LollipopLover"][1] == false):
					if (body.name == "GummyBear"):
						ach["LollipopLover"][0] += 1
						if (ach["LollipopLover"][0] >= ach["LollipopLover"][2]):
							ach["LollipopLover"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["LollipopLover"].texture,
								"🍭 Lollipop Lover"
							)
						Global.save_ach()
				
				# Ach 4
				if (ach["CandyCaneCraze"][1] == false):
					if (body.name == "Lollipop"):
						ach["CandyCaneCraze"][0] += 1
						if (ach["CandyCaneCraze"][0] >= ach["CandyCaneCraze"][2]):
							ach["CandyCaneCraze"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["CandyCaneCraze"].texture,
								"🍭 Candy Cane Craze"
							)
						Global.save_ach()
				
				# Ach 5
				if (ach["PeppermintPower"][1] == false):
					if (body.name == "CandyCane"):
						ach["PeppermintPower"][0] += 1
						if (ach["PeppermintPower"][0] >= ach["PeppermintPower"][2]):
							ach["PeppermintPower"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["PeppermintPower"].texture,
								"🍭 Peppermint Power"
							)
						Global.save_ach()
				
				# Ach 6
				if (ach["SweetHeart"][1] == false):
					if (body.name == "PeppermintCandy"):
						ach["SweetHeart"][0] += 1
						if (ach["SweetHeart"][0] >= ach["SweetHeart"][2]):
							ach["SweetHeart"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["SweetHeart"].texture,
								"🥰 Sweet Heart"
							)
						Global.save_ach()
				
				# Ach 7
				if (ach["SpiralSensation"][1] == false):
					if (body.name == "HeartLollipop"):
						ach["SpiralSensation"][0] += 1
						if (ach["SpiralSensation"][0] >= ach["SpiralSensation"][2]):
							ach["SpiralSensation"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["SpiralSensation"].texture,
								"😵‍💫 Spiral Sensation"
							)
						Global.save_ach()
				
				# Ach 8
				if (ach["GumballStarter"][1] == false):
					if (body.name == "SpiralLollipop"):
						ach["GumballStarter"][0] += 1
						if (ach["GumballStarter"][0] >= ach["GumballStarter"][2]):
							ach["GumballStarter"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["GumballStarter"].texture,
								"🍫 Gumball Starter"
							)
						Global.save_ach()
				
				# Ach 9
				if (ach["GumballCombiner"][1] == false):
					if (body.name == "GumballMachine"):
						ach["GumballCombiner"][0] += 1
						if (ach["GumballCombiner"][0] >= ach["GumballCombiner"][2]):
							ach["GumballCombiner"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["GumballCombiner"].texture,
								"🍫 Gumball Combiner"
							)
						Global.save_ach()
				
				# Ach 10
				if (ach["GumballGenius"][1] == false):
					if (body.name == "GumballMachine"):
						ach["GumballGenius"][0] += 1
						if (ach["GumballGenius"][0] >= ach["GumballGenius"][2]):
							ach["GumballGenius"][1] = true
							get_tree().call_group(
								"LevelGroup",
								"show_ach_unlocked",
								Global.achievement_icons["GumballGenius"].texture,
								"🍫 Gumball Genius"
							)
						Global.save_ach()
				
				shape_owner_clear_shapes(this_id)
				shape_owner_clear_shapes(other_id)
				
				# playing appropriate sfx
				if (TIER < 7):
					Global.play_sound("Combine1Sound")
				elif (TIER == 7):
					Global.play_sound("Combine2Sound")
				else:
					Global.play_sound("Combine3Sound")

				if (TIER < 8):
					get_tree().call_group("LevelGroup", "spawn_candy", TIER+1, position, true, TIER)
				else:
					get_tree().call_group("LevelGroup", "play_gumball_effect")
				body.queue_free()
				queue_free()
				Global.append_score(TIER)
