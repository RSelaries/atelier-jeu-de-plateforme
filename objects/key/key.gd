extends Area2D


var picked_up: bool = false


func _init() -> void:
	body_entered.connect(_on_body_entered)


func _ready() -> void:
	if picked_up:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not picked_up:
		body.pick_up_item("key")
		picked_up = true
		queue_free()
