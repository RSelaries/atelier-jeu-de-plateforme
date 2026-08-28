extends Control


@onready var play_button: Button = $CenterContainer/VBoxContainer/MarginContainer/PlayButton
@onready var options_button: Button = $CenterContainer/VBoxContainer/MarginContainer3/OptionsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/MarginContainer2/QuitButton


func _on_play_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://levels/level_0.tscn")


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
