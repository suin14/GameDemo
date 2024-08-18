class_name Locations
extends Node2D

@export var bgm : AudioStream

@onready var player: Player = $player
@onready var tile_map: TileMap = $TileMap
@onready var camera_2d: Camera2D = $player/Camera2D

const offset = 12

func _ready() -> void:
	#相机极限
	var used := tile_map.get_used_rect()
	var tile_size := tile_map.tile_set.tile_size
	
	camera_2d.limit_top = used.position.y * tile_size.y + offset
	camera_2d.limit_right = used.end.x * tile_size.x - offset
	camera_2d.limit_bottom = used.end.y * tile_size.y - offset
	camera_2d.limit_left = used.position.x * tile_size.x + offset
	camera_2d.reset_smoothing()
	
	
	if bgm:
		SoundManager.play_bgm(bgm)

func update_player(pos: Vector2) -> void:
	player.global_position = pos
	camera_2d.reset_smoothing()
	camera_2d.force_update_scroll()
