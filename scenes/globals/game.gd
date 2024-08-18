extends Node

@onready var color_rect: ColorRect = $Black/ColorRect


func _ready() -> void:
	color_rect.color.a = 0
	color_rect.visible = false

func change_scene(path: String, entry_point: String) -> void:
	var tree := get_tree()
	
	tree.paused = true    #转场暂停场景
	# 转场变黑动画
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	color_rect.visible = true
	tween.tween_property(color_rect, "color:a", 1, 0.2)
	await tween.finished
	
	tree.change_scene_to_file(path)
	await tree.tree_changed
	
	for node in tree.get_nodes_in_group("entry_points"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position)
			break

	tree.paused = false
	# 转场结束动画
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0, 0.2)
	color_rect.visible = false
