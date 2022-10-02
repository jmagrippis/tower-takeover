extends RigidBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func take_damage(base_damage: int, origin: Vector2 = Vector2.ZERO):
	if (base_damage > 0):
		var impact_point = to_local(origin).clamp(Vector2(-1, -1), Vector2.ONE)
		animation_player.play('hit')
		apply_central_impulse(Vector2(impact_point.x * -500, impact_point.y * -50))
		apply_torque_impulse(500)


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if (anim_name == 'hit'):
		await get_tree().create_timer(0.1).timeout
		queue_free()
