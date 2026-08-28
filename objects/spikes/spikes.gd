extends Area2D


@export_custom(PROPERTY_HINT_NONE, "suffix:s") var activation_time: float = 0.5
@export var active: bool:
	set(value):
		active = value
		animated_sprite_2d.play(&"active" if active else &"inactive")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play(&"active" if active else &"inactive")


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	if player:
		if active:
			hit(body)
		else:
			activate()


func activate() -> void:
	set_deferred(&"monitoring", false)
	await get_tree().create_timer(activation_time).timeout
	set_deferred(&"monitoring", true)
	active = true


func hit(player: Player) -> void:
	player.die()
