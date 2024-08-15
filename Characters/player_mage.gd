extends CharacterBody2D

signal health_depleted

@export var move_speed : float = 100
@export var health = 100.0
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	pick_new_state()
	move_and_slide()
	
	const DAMAGE_RATE = 10.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		$Sprite2D.modulate = Color.RED
		if health <= 0.0:
			health_depleted.emit()
	else:
		$Sprite2D.modulate = Color.WHITE

func update_animation_parameters(move_input : Vector2):
	# Don't change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
# Choose state based on what is happening with the player
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
