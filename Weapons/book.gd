extends Area2D

func _ready():
	look_at(Vector2(0, 10000))

func _physics_process(_delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)


func shoot():
	const PROJECTILE = preload("res://Projectiles/energy_ball.tscn")
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_transform = (%ShootPoint.global_transform)
	%ShootPoint.add_child(new_projectile)


func _on_timer_timeout():
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		shoot()
