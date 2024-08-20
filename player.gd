class_name Player
extends CharacterBody2D

@export var MOVE_SPEED: float = 100.0

var move_direction
var direction : String
var interacting_with: Array[Interact]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var interaction_icon: Sprite2D = $InteractionIcon
@onready var pause_menu: Control = $CanvasLayer/PauseMenu


func _ready() -> void:
	Game.time_gui.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interacting_with:
		interacting_with.back().interact()
		
	if event.is_action_pressed("pause"):
		pause_menu.show_menu()


func _physics_process(_delta: float) -> void:
	interaction_icon.visible = not interacting_with.is_empty()
	
	move_direction = Input.get_vector("move_left","move_right","move_up","move_down")
	move_and_slide()


func register_interactable(v: Interact) -> void:
	if v in interacting_with:
		return
	interacting_with.append(v)

func unregister_interactable(v: Interact) -> void:
	interacting_with.erase(v)
