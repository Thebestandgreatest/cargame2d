extends KinematicBody2D

var velocity = Vector2()

const acceleration = Vector2(0,-10)
const braking = 20
const resistances = 2
const wheelDriftResistance = 5
const maxSpeed = 1000
const rotationSpeed = 0.08
const minWDrResStr = 0.05
const spriteAngle = -PI / 2
const spriteSize = Vector2(32,64)

func _physics_process(delta):
	var res = resistances
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if Input.is_action_pressed("ui_left"):
			rotation -= rotationSpeed
		else:
			rotation += rotationSpeed
		
	if Input.is_action_pressed("ui_up"):
		velocity += acceleration.rotated(rotation)
	else:
		if Input.is_action_pressed("ui_down"):
			res += braking
	
	if velocity.length() > res:
		var angle = velocity.angle() - (rotation - spriteAngle)
		var wDrResStr = sin(angle)
		if abs(wDrResStr) > minWDrResStr:
			velocity += Vector2(wDrResStr * wheelDriftResistance, 0).rotated(rotation)
		else:
			velocity *= abs(cos(angle))
		velocity += -velocity.normalized() * res
		if velocity.length() > maxSpeed:
			velocity = velocity / velocity.length() * maxSpeed
	else:
		velocity = Vector2()
		velocity = move_and_slide(velocity)
