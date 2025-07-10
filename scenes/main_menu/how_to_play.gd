extends Control


func _process(delta):
	$Background.rotation_degrees += 20*delta


func _on_back_button_pressed():
	Global.play_sound("ClickSound")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
