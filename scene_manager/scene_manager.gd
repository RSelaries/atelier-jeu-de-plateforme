# SceneManager
extends Node


@export var in_transition: bool = false


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play(&"fade_in")


func reload_current_scene() -> void:
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play(&"fade_in")


func change_scene_to_file(path: String) -> void:
	animation_player.play(&"fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play(&"fade_in")
