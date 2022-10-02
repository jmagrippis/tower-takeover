class_name King
extends CharacterBody2D

const SPEED: float = 255.0
const JUMP_VELOCITY: float = -350.0
const FALL_GRAVITY_FACTOR: float = 1.40

var foot_step: PackedScene = preload("res://Characters/Particles/FootStep.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
# For one off landing effects
var recently_airborne: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = %Sprite2d

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * FALL_GRAVITY_FACTOR

	# Handle attack.
	if Input.is_action_just_pressed("attack"):
		attack()
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		if Input.is_action_pressed("down"):
			drop()
		else:
			velocity.y = JUMP_VELOCITY

	# Flip sprite according to whether we are "looking" left or right
	if velocity.x > 0:
		sprite.scale.x = 1
		sprite.position.x = 0
	elif velocity.x < 0:
		sprite.scale.x = -1
		sprite.position.x = -14
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	animation_tree.set("parameters/movement/current", int(velocity.length() > 0))

	# handle airborne animations
	animation_tree.set("parameters/fall/blend_position", Vector2(0, velocity.y))
	if is_on_floor():
		animation_tree.set("parameters/airborne/current", false)
		if recently_airborne:
			animation_tree.set("parameters/movement/current", 2)
			await get_tree().create_timer(0.1).timeout
			recently_airborne = false
	else:
		animation_tree.set("parameters/airborne/current", true)
		recently_airborne = true
		
	move_and_slide()
	
	
func attack() -> void:
	animation_tree.set("parameters/attacking/current", 1)
	await get_tree().create_timer(0.35).timeout
	animation_tree.set("parameters/attacking/current", 0)


func drop() -> void:
	animation_tree.set("parameters/movement/current", 2)
	await get_tree().create_timer(0.05).timeout
	velocity.y = -JUMP_VELOCITY
	position.y += 1
	

func spawn_foot_step() -> void:
	var instance: CPUParticles2D = foot_step.instantiate()
	instance.emitting = true
	instance.position.y += 4
	add_child(instance)


func spawn_landing() -> void:
	var right_instance: CPUParticles2D = foot_step.instantiate()
	right_instance.emitting = true
	right_instance.position.y += 4
	right_instance.position.x += 4
	add_child(right_instance)
	
	var left_instance: CPUParticles2D = foot_step.instantiate()
	left_instance.emitting = true
	left_instance.position.y += 4
	left_instance.position.x -= 4
	add_child(left_instance)


func _on_door_entering(door: Door) -> void:
	animation_tree.set("parameters/interacting/current", 1)
	position.x = door.position.x
	position.y = door.position.y
	await get_tree().create_timer(1).timeout
	queue_free()
