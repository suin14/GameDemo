extends Node

const SAVE_PATH := "user://data.sav"
const CONFIG_PATH := "user://config.ini"

@onready var black: ColorRect = $UI/Black
@onready var time_system: TimeSystem = $TimeSystem
@onready var time_gui: Control = $UI/TimeGUI
@onready var default_player_status: Dictionary = PlayerStatus.init_status()
@onready var inventory: Inventory = preload("res://content/data/player_inventory.tres")

var can_interact: bool = true


func _ready() -> void:
	black.color.a = 0
	Game.load_config()
	time_gui.visible = false

func change_scene(path: String, params := {}) -> void:
	var tree := get_tree()
	
	tree.paused = true    #转场暂停场景
	# 转场变黑动画
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black, "color:a", 1, 0.2)
	await tween.finished
	
	if "init" in params:
		params.init.call()
		
	tree.change_scene_to_file(path)
	await tree.tree_changed

	if tree.current_scene is Locations:
		if "entry_point" in params:
			for node in tree.get_nodes_in_group("entry_points"):
				if node.name == params.entry_point:
					tree.current_scene.update_player(node.global_position)
					break
		
		if "position" in params:
			await tree.current_scene.ready
			tree.current_scene.update_player(params.position)

	tree.paused = false
	# 转场结束动画
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(black, "color:a", 0, 0.2)

func back_to_title() -> void:
	change_scene("res://scenes/UI/title_menu.tscn", {})


func new_game() -> void:
	change_scene("res://scenes/room.tscn", {
		entry_point = "StartPoint", 
		init = func():
			PlayerStatus.from_dict(default_player_status)
			time_system.date_time.days = 1
			time_system.date_time.hours = 0
			time_system.date_time.minutes = 0
			inventory.init()
	})


func save_game() -> void:
	var scene := get_tree().current_scene
	#var inventory : Inventory = get_tree().current_scene.player.inventory
	var data := {
		scene = scene.scene_file_path,
		status = PlayerStatus.to_dict(),
		date_time = time_system.to_dict(),
		player = {
			direction = scene.player.direction,
			position = {
				x = scene.player.global_position.x,
				y = scene.player.global_position.y
			}
		},
		inventory = scene.player.inventory.to_dict()
	}
	var json := JSON.stringify(data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		return
	file.store_string(json)

func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	
	var json := file.get_as_text()
	var data := JSON.parse_string(json) as Dictionary
	
	time_system.date_time.days = data.date_time.days
	time_system.date_time.hours = data.date_time.hours
	time_system.date_time.minutes = data.date_time.minutes
	
	change_scene(data.scene, {
		direction = data.player.direction,
		position = Vector2(
			data.player.position.x,
			data.player.position.y
		),
		init = func():
			PlayerStatus.from_dict(data.status)
			time_system.from_dict(data.date_time)
			inventory.from_dict(data.inventory)
	})

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func save_config() -> void:  #保存配置文件
	var config := ConfigFile.new()
	
	config.set_value("audio", "master", SoundManager.get_volume(SoundManager.Bus.MASTER))
	config.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.Bus.SFX))
	config.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.Bus.BGM))
	
	config.save(CONFIG_PATH)

func load_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)
	
	SoundManager.set_volume(
		SoundManager.Bus.MASTER,
		config.get_value("audio", "master", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.SFX,
		config.get_value("audio", "sfx", 1.0)
	)
	SoundManager.set_volume(
		SoundManager.Bus.BGM,
		config.get_value("audio", "bgm", 1.0)
	)


func skip_time(skip_minutes: int) -> void:
	time_system.date_time.minutes += skip_minutes
	

func doing_action() -> void:
	Game.time_system.time_paused = true
	Game.can_interact = false

func done_action() -> void:
	Game.time_system.time_paused = false
	Game.can_interact = true
