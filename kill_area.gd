class_name KillArea
extends Area2D


func _init() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player.die()
