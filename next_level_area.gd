class_name NextLevelArea
extends Area2D


@export_file_path("*.tscn") var next_level: String


func _init() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneManager.change_scene_to_file(next_level)
