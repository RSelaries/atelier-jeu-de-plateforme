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


func change_scene_to_file(path: String, transition_parameters: Dictionary[String, Variant] = {}) -> void:
	var anim_speed: float = 1.0
	if transition_parameters.has("transition_mult"):
		anim_speed = transition_parameters["transition_mult"]
	animation_player.play(&"fade_out", -1, anim_speed)
	await animation_player.animation_finished
	var packed_scene: PackedScene = load(path)
	var scene_node: Node = packed_scene.instantiate()
	get_tree().current_scene.free()
	get_tree().root.add_child(scene_node)
	if scene_node.has_method(&"transition"):
		scene_node.transition(transition_parameters)
	get_tree().current_scene = scene_node
	animation_player.play(&"fade_in", -1, anim_speed)
