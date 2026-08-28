extends Node


@onready var canvas_layer: CanvasLayer = $CanvasLayer


func _ready() -> void:
	close_menu()


func _unhandled_input(event: InputEvent) -> void:
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if event.is_action_pressed(&"pause_menu"):
			open_menu()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func open_menu() -> void:
	canvas_layer.show()
	get_tree().paused = true


func close_menu() -> void:
	canvas_layer.hide()
	get_tree().paused = false


func _on_resume_btn_pressed() -> void:
	close_menu()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_options_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
