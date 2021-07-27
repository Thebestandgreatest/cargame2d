extends KinematicBody2D

const speedLabelOffset = Vector2(-100,-100)

const wheel_base = 80
const steering_angle = 15
const engine_power = 1500
const friction = -0.999
const drag = -0.0002
const braking = -450
const max_speed_reverse = 500
const slip_speed = 400
const traction_fast = 0.1
const traction_slow = 0.7

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	
	get_parent().get_node("UI Holder/Speed").text = var2str(velocity.length())
	get_parent().get_node("UI Holder").rect_position = position + OS.get_screen_size()
	
func get_input():
	var turn = 0
	if Input.is_action_pressed("ui_right"):
		turn += 1
		$CollisionShape2D/Sprite.frame = 1
	elif Input.is_action_pressed("ui_left"):
		turn -= 1
		$CollisionShape2D/Sprite.frame = 2
	else:
		$CollisionShape2D/Sprite.frame = 0
	steer_angle = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("ui_up"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("ui_down"):
		acceleration = transform.x * braking

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
