extends Control

@onready var status_panel: StatusPanel = $CanvasLayer/StatusPanel


func _on_avatar_pressed() -> void:
	status_panel.show()
