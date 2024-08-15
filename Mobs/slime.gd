extends CharacterBody2D

@export var move_speed: float = 60
@export var health: int = 10

@onready var player = get_node("/root/GameLevel/PlayerMage")
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")


func _physics_process(_delta):
	despawn_check()
	var direction = global_position.direction_to(player.global_position)
	
	update_animation_parameters(direction)
	
	velocity = direction * move_speed
	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	# Don't change animation parameters if there is no move input
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)

func take_damage(damage: int):
	health -= damage
	$Sprite2D.modulate = Color.RED
	
	if health <= 0:
		queue_free()
		const SMOKE_SCENE = preload("res://Projectiles/smoke.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
	
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE

func despawn_check():
	if global_position.distance_to(player.global_position) > 336:
		queue_free()
