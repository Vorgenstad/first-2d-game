extends Node

@export var mob_scene: PackedScene

var score

func _on_player_hit():
	game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	initialize_mob(mob)

	add_child(mob)

func initialize_mob(mob):
	var spawn_location = get_node("MobPath/MobSpawnLocation")
	spawn_location.progress_ratio = randf()
	
	mob.position = spawn_location.position
	
	var direction = spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_hud_start_game():
	new_game()
