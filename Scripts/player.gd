extends CharacterBody2D

var speed = 250
var player_state
var last_foot_direction = Vector2.DOWN
var rotation_speed = 15.0

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 or direction.y != 0:
		player_state = "walking"
		last_foot_direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()
	
	sprite_rotation(delta, direction)
	
	play_anim()
	
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
	if player_state == "idle":
		$feet.play("idle")
		$body.play("Flashlight")
	if player_state == "walking":
		$feet.play("walk")
		$body.play("Flashlight")
