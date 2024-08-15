extends Node2D

var slime_count = 0
var hardcap = 300
var mobcap = 4

func _on_scaling_timeout():
	mobcap += 1

func _on_timer_timeout():
	while get_tree().get_nodes_in_group("Enemies").size() < mobcap and get_tree().get_nodes_in_group("Enemies").size() < hardcap:
		spawn_mob()

func spawn_mob():
	var slime = preload("res://Mobs/slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	slime.global_position = %PathFollow2D.global_position
	add_child(slime)
	slime_count += 1
	slime.add_to_group("Enemies")

func get_furthest_distance_from_player():
	var max_distance = 0.0

	for i in range(0, 100):
		%PathFollow2D.progress_ratio = i
		var distance = $PlayerMage.global_position.distance_to(%PathFollow2D.global_position)
		if distance > max_distance:
			max_distance = distance

	return max_distance


func _on_player_mage_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true

