class_name HitBox
extends Area2D

@export var base_damage := 1


func _init() -> void:
	collision_layer = 2
	collision_mask = 0
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
