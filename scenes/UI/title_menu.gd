extends Control

@onready var startGame: Button = $V/Start
@onready var loadGame: Button = $V/Load


func _ready() -> void:
	loadGame.disabled = not Game.has_save()
	startGame.grab_focus()
	SoundManager.setup_ui_sounds(self)  #设置ui音效
	Game.time_system.time_paused = true
	Game.time_gui.visible = false

func _on_start_pressed() -> void:
	Game.time_system.time_paused = false
	Game.new_game()

func _on_load_pressed() -> void:
	Game.time_system.time_paused = false
	Game.load_game()

func _on_exit_pressed() -> void:
	get_tree().quit()
