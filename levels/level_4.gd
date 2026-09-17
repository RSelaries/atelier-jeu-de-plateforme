extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$VBoxContainer/GoldCount.text = "Vous avez trouvé %d pièces !" % Player.coin_amount


func _on_button_pressed() -> void:
	Player.coin_amount = 0
	Player.key_amount = 0
	PersistanceManager.collectibles = {}
	SceneManager.change_scene_to_file("res://levels/level_0.tscn")
