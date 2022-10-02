class_name Door
extends StaticBody2D

signal entering

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var leads_to_scene: PackedScene

var is_open: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func interaction_can_interact(player: King) -> bool:
	return player != null


func interaction_interact(_interactionComponent: InteractionComponent) -> void:
	_open_door()


func _open_door() -> void:
	if (!is_open):
		animation_player.play('opening')
		is_open = true
		await get_tree().create_timer(0.45).timeout
		emit_signal("entering", self)
		await get_tree().create_timer(1.1).timeout
		get_tree().change_scene_to_packed(leads_to_scene)
