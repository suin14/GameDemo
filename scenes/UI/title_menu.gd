extends Control

@onready var startGame: Button = $V/Start
@onready var loadGame: Button = $V/Load


func _ready() -> void:
	loadGame.disabled = not Game.has_save()
	startGame.grab_focus()
	SoundManager.setup_ui_sounds(self)  #设置ui音效


func _on_start_pressed() -> void:
	Game.new_game()

func _on_load_pressed() -> void:
	Game.load_game()

func _on_exit_pressed() -> void:
	get_tree().quit()
