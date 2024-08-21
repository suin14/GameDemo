extends Control

@onready var status_panel: status_panel = $CanvasLayer/StatusPanel


func _on_avatar_pressed() -> void:
	status_panel.show()
