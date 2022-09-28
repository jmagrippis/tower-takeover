class_name HurtBox
extends Area2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	if hitbox.owner != owner && owner.has_method("take_damage"):
		owner.take_damage(hitbox.base_damage, hitbox.owner.position)
	
