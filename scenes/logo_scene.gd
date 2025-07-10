extends Control


func _ready():
	Global.load_highscore()
	Global.load_ach()
	Global.load_player_name()


func _on_scene_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
