extends CharacterBody2D

var MinSpeed = 100
var MaxSpeed = 400
const Up = Vector2(0, -1)

var airTimeCount = 0
var climbXValue = 0
var climbYValue = 0
var groundDirection = 0
var gravity = 300
var hasReleasedRope = false
var isClimbingLedge = false
var isCrawlingLedge = false
var isFalling = false
var isGrabbingLedge = false
var isRunning = false
var isSwinging = false
var jumpVelocity = 100
var speed = 100
var swingSpeed = 0
var swingRope = null
var wasJumping = false

#func _ready():
#	animatedSprite2D = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(isSwinging, swingRope)
	pass

func _physics_process(delta):
	#Handle death conditions
	#if !isDead || !hasReset:
		if hasReleasedRope:
			airTimeCount += 1
			if airTimeCount > 30:
				airTimeCount = 0
				$CollisionShape2D.disabled = false
				isSwinging = false
				hasReleasedRope = false
		# Handle swinging on a rope
		if isSwinging && swingRope != null:
			global_position = global_position.move_toward(Vector2(swingRope.global_position.x, swingRope.global_position.y), 10)
			$CollisionShape2D.disabled = true
			if Input.is_action_just_pressed("ui_right"):
				swingRope.apply_impulse(Vector2(10, 0))
			elif Input.is_action_just_pressed("ui_left"):
				swingRope.apply_impulse(Vector2(-10, 0))
			elif Input.is_action_just_pressed("ui_accept"):
				velocity = swingRope.linear_velocity
				swingRope = null
				hasReleasedRope = true
		# Handle climbing a ledge
		elif isGrabbingLedge:
			velocity.x = 0
			velocity.y = 0
			if isCrawlingLedge:
				crawl_ledge()
			elif isClimbingLedge:
				ascend_ledge()
			elif Input.is_action_pressed("ui_accept"):
				isClimbingLedge = true
				ascend_ledge()
		# Add the gravity
		elif !is_on_floor():
			velocity.y += gravity * delta
			isRunning = false
			groundDirection = sign(velocity.x)
			wasJumping = true
		else:
			isSwinging = false
			if isFalling:
				isFalling = false
			elif wasJumping:
				if groundDirection != sign(velocity.x):
					speed = MinSpeed
					wasJumping = false
			# Enable running toggle
			if Input.is_action_pressed("ui_cancel"):
				isRunning = true
			elif Input.is_action_just_released("ui_cancel"):
				isRunning = false
			# Handle jumping
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = -jumpVelocity - (speed * .25)
			# Handle moving left and right speeds
			if isRunning && speed < MaxSpeed:
				speed += 2.5
			elif !isRunning && speed > MinSpeed:
				speed -= 5
			if Input.is_action_just_pressed("ui_right"):
				speed = MinSpeed
			elif Input.is_action_just_pressed("ui_left"):
				speed = MinSpeed
			if Input.is_action_pressed("ui_right"):
				velocity.x = speed
			elif Input.is_action_pressed("ui_left"):
				velocity.x = -speed
			else:
				velocity.x = 0
				speed = MinSpeed
		
		move_and_slide()
		
		# Apply initial force to rope
		for n in get_slide_collision_count():
			var i = get_slide_collision(n)
			if i.get_collider() is RigidBody2D && i.get_collider().name.contains("RopeLinkage"):
				i.get_collider().apply_impulse(Vector2(0.2 * swingSpeed, 0))
				if Input.is_action_pressed("ui_select"):
					isSwinging = true
					swingRope = i.get_collider()
		if isSwinging && swingRope != null:
			swingSpeed = swingRope.linear_velocity.x
		else:
			swingSpeed = velocity.x
		pass

func ascend_ledge():
	global_position = global_position.move_toward(Vector2(global_position.x, climbYValue), 1)
	if global_position.y == climbYValue:
		isCrawlingLedge = true
	pass
	
func crawl_ledge():
	global_position = global_position.move_toward(Vector2(climbXValue, global_position.y), 1)
	if global_position.x == climbXValue:
		isGrabbingLedge = false
		isClimbingLedge = false
		isCrawlingLedge = false
		speed = MinSpeed

func use_hands(body):
	if body.name.contains("LedgeGrab"):
		if velocity.x != MaxSpeed:
			climbYValue = body.global_position.y + 1
			climbXValue = body.global_position.x
			isGrabbingLedge = true
			isFalling = false
		elif velocity.x == MaxSpeed:
			isFalling = true
	elif body.name.contains("Floor"):
		isFalling = true
	
func _on_grab_area_2d_1_body_entered(body):
	use_hands(body)
	pass # Replace with function body.


func _on_grab_area_2d_2_body_entered(body):
	use_hands(body)
	pass # Replace with function body.
