class_name Door
extends Area2D


@export var locked_door: bool = false
@export var to_door: StringName
@export_group("To Level")
@export_file_path("*.tscn") var to_level: String
@export var transition_parameters: Dictionary[String, Variant]
@export_custom(PROPERTY_HINT_NONE, "suffix:x") var transition_mult: float = 2.0


var locked: bool = true
var player_inside: bool = false
var player: Player


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hint_label: Label = $HintLabel


func _init() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _ready() -> void:
	animated_sprite_2d.play(&"locked" if locked_door and locked else &"closed")
	hint_label.hide()
	if get_tree().current_scene is Level:
		get_tree().current_scene.doors.append(self)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"player_mov_up") and player_inside:
		if locked_door and locked and Player.key_amount <= 0:
			return
		elif locked_door and locked and Player.key_amount > 0:
			locked = false
			hint_label.text = "ouvrir"
			animated_sprite_2d.play(&"closed")
			Player.key_amount -= 1
		else:
			hint_label.hide()
			player.in_animation = true
			player.sprite.play(&"idle")
			animated_sprite_2d.play(&"opening")
			await animated_sprite_2d.animation_finished
			player.hide()
			if to_door:
				transition_parameters["to_door"] = to_door
			transition_parameters["transition_mult"] = transition_mult
			if to_level:
				SceneManager.change_scene_to_file(to_level, transition_parameters)
			else:
				var target_door: Door = get_tree().current_scene.find_child(to_door)
				SceneManager.animation_player.play(&"fade_out", -1, transition_mult)
				await SceneManager.animation_player.animation_finished
				player.global_position = target_door.global_position
				SceneManager.animation_player.play(&"fade_in", -1, transition_mult)
			player.in_animation = false
			player.show()
			animated_sprite_2d.play(&"closed")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_inside = true
		hint_label.show()
		if locked_door and locked and Player.key_amount > 0:
			hint_label.text = "déverrouiller"
		elif locked_door and locked:
			hint_label.text = "verrouillé"
		else:
			hint_label.text = "ouvrir"


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_inside = false
		hint_label.hide()
