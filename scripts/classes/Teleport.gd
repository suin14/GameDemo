class_name Teleport
extends Interact

@export_file("*.tscn") var path: String
@export var entry_point: String

func interact() -> void:
	super()
	SoundManager.play_sfx("UIPress")
	Game.change_scene(path, {entry_point=entry_point})
	print("[传送] %s" %entry_point)
