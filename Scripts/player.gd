extends CharacterBody2D

var speed = 370
var run_speed = 1.0
var target_run_speed = 1.0
var is_running = false
var player_state
var last_foot_direction = Vector2.DOWN
var rotation_speed = 15.0
var current_weapon = "knife"
var is_attacking = false
var acceleration = 0.1

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.length() == 0:
		is_running = false
		player_state = "idle"
	else:
		player_state = "walking"
		last_foot_direction = direction.normalized()
	
	if Input.is_action_pressed("run") and direction.length() > 0:
		is_running = true
		target_run_speed = 2.0
	else:
		is_running = false
		target_run_speed = 1.0
	
	run_speed = lerp(run_speed, target_run_speed, acceleration)
	
	velocity = direction * speed * run_speed
	move_and_slide()
	
	sprite_rotation(delta, direction)
	
	if not is_attacking:
		play_anim()
	
	if Input.is_action_just_pressed("flashlight_switch"):
		switch_flashlight()
	
	if Input.is_action_just_pressed("attack") and current_weapon == "knife" and not is_attacking:
		play_knife_attack()

func sprite_rotation(delta, direction):
	var target_foot_angle
	if direction.length() > 0:
		target_foot_angle = direction.angle()
	else:
		target_foot_angle = last_foot_direction.angle()
	
	$feet.rotation = lerp_angle($feet.rotation, target_foot_angle, rotation_speed * delta)
	
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	var target_body_angle = to_mouse.angle()
	$body.rotation = lerp_angle($body.rotation, target_body_angle, rotation_speed * delta)

func play_anim():
	if $body.animation == "Knife_attack" and $body.is_playing():
		return
	
	if current_weapon == "flashlight":
		$body.offset = Vector2(-93, -107)
		$body.play("Flashlight")
	elif current_weapon == "knife":
		$body.offset = Vector2(-105, -113)
		$body.play("Knife_idle")
	
	if player_state == "idle":
		$feet.play("idle")
	elif player_state == "walking":
		if is_running:
			$feet.play("run")
		else:
			$feet.play("walk")

func switch_flashlight():
	if current_weapon == "flashlight":
		current_weapon = "knife"
	else:
		current_weapon = "flashlight"
	play_anim()

func play_knife_attack():
	is_attacking = true
	$body.offset = Vector2(-103, -113)
	$body.play("Knife_attack")
	await $body.animation_finished
	is_attacking = false
	play_anim()
