@tool
extends Level


func _on_teleport_area_up_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position.y -= 42*16
