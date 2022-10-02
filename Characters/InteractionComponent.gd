class_name InteractionComponent
extends Area2D

@export var interaction_parent: NodePath

signal on_interactable_changed(newInteractable: Node2D)

var interaction_target: Node2D


func _init() -> void:
	collision_layer = 0
	collision_mask = 4 # = Layer 3: "Interactables"
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

# Called every frame
func _process(_delta: float) -> void:
	# Check whether the player is trying to interact
	if (interaction_target != null and Input.is_action_just_pressed("interact")):
		# If so, we'll call interaction_interact() if our target supports it
		if (interaction_target.has_method("interaction_interact")):
			interaction_target.interaction_interact(self)


# Signal triggered when our collider collides with something on the interaction layer
func _on_body_entered(body: Node2D) -> void:
	var canInteract: bool = false
	
	# GDScript lacks the concept of interfaces, so we can't check whether the body implements an interface
	# Instead, we'll see if it has the methods we need
	if (body.has_method("interaction_can_interact")):
		# Interactables tell us whether we're allowed to interact with them.
		canInteract = body.interaction_can_interact(get_node(interaction_parent))
	
	if not canInteract:
		return
		
	# Store the thing we'll be interacting with, so we can trigger it from _process
	interaction_target = body
	emit_signal("on_interactable_changed", interaction_target)


func _on_body_exited(body: Node2D):
	if (body == interaction_target):
		interaction_target = null
		emit_signal("on_interactable_changed", null)
