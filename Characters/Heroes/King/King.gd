extends CharacterBody2D


const SPEED: float = 700.0
const JUMP_VELOCITY: float = -800.0
const FALL_GRAVITY_FACTOR: float = 1.40

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
