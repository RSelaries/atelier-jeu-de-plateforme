@tool
class_name Level
extends Node2D


@export var player: Player:
	set(value):
		player = value
		update_configuration_warnings()
@export var default_camera: PhantomCamera2D:
	set(value):
		default_camera = value
		update_configuration_warnings()


var doors: Array[Door]


func transition(transition_parameters: Dictionary[String, Variant]) -> void:
	if transition_parameters.has("to"):
		player.global_position = transition_parameters["to"]
		var previous_tween_duration: float = default_camera.tween_duration
		default_camera.tween_duration = 0.0
		await get_tree().process_frame
		default_camera.tween_duration = previous_tween_duration
	
	if transition_parameters.has("flip_h"):
		player.sprite.flip_h = transition_parameters["flip_h"]
	
	if transition_parameters.has("to_door"):
		var target_door: Door = find_child(transition_parameters["to_door"])
		if target_door:
			player.in_animation = true
			player.global_position = target_door.global_position
			var previous_tween_duration: float = default_camera.tween_duration
			default_camera.tween_duration = 0.0
			target_door.animated_sprite_2d.play(&"opening")
			await target_door.animated_sprite_2d.animation_finished
			default_camera.tween_duration = previous_tween_duration
			player.in_animation = false
			target_door.animated_sprite_2d.play(&"closed")


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not player:
		warnings.append("Player reference chould be provided")
	if not default_camera:
		warnings.append("Default camera reference should be provided")
	
	return warnings
