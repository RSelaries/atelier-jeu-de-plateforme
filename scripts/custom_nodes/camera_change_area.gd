class_name CameraChangeArea
extends Area2D


@export var target_cam: PhantomCamera2D
@export var cam_priority: int = 20
@export var reset_priority_on_leave: bool = true


var default_cam_priority: int = 0


func _init() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and target_cam:
		default_cam_priority = target_cam.priority
		target_cam.priority = 20


func _on_body_exited(body: Node2D) -> void:
	if body is Player and target_cam and reset_priority_on_leave:
		target_cam.priority = default_cam_priority
