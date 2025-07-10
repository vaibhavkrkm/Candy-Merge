extends Control

@onready var VBoxContainer_ = $AchievementsUI/ScrollContainer/VBoxContainer


func _ready():
	for ach in VBoxContainer_.get_children():
		ach.get_node(ach.get_meta("progress_bar")).value = Global.achievements[ach.name][0]


func _process(delta):
	$Background.rotation_degrees += 20*delta


func _on_back_button_pressed():
	Global.play_sound("ClickSound")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
