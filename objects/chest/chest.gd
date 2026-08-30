extends Area2D


@export var item: String = "emerald"

var opened: bool = false
var player_inside: bool = false
var player: Player

@onready var hint_label: Label = $HintLabel
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _init() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _ready() -> void:
	hint_label.hide()
	if opened:
		animated_sprite_2d.play(&"opened")


func _on_body_entered(body: Node2D) -> void:
	if opened: return
	if body is Player:
		player_inside = true
		player = body
		hint_label.show()


func _on_body_exited(body: Node2D) -> void:
	if opened: return
	if body is Player:
		player_inside = false
		hint_label.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"player_mov_up") and player_inside and not opened:
		open_chest()


func open_chest() -> void:
	opened = true
	animated_sprite_2d.play(&"opened")
	player.gain_item(item)
	hint_label.hide()
