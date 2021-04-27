extends KinematicBody


enum {LIVE, DEAD, ATTACK}
############    CONSTANTES    ############
const GRAVITY = -24
const MAX_SLOPE_ANGLE = 60
const MAX_SPEED = 4
const JUMP_SPEED = 12
const ACCEL = 3
const DEACCEL= 15

############    VARIÁVEIS    ############
var status
var velocity = Vector3()
var dir = Vector2()
var camera
export(NodePath) var cameraPath
export(NodePath) var control
var target
var stop = false

############    ONREADY    ############
onready var orb = $Contact


func _ready():
	status = LIVE
	target = get_node(control)
	target.connect("touchStatus", self, "_touchStatus")
	
func _physics_process(delta):
	if status == LIVE:
		process_input()
		process_movement(delta)

func process_movement(delta):
	dir.y = 0
	dir.normalized()
	
	velocity.y += delta * GRAVITY
		
	var hvel = velocity
	hvel.y = 0
	
	var new_pos = dir * MAX_SPEED
	
	var accel = DEACCEL
	
	if dir.dot(hvel) > 0:
		accel = ACCEL
	
	hvel = hvel.linear_interpolate(new_pos, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	velocity = move_and_slide(velocity, Vector3.UP, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	
func process_input():
	#walking
	dir = Vector3()
	if target.get_touch():
		var targetPos = target.global_transform.origin
		
		dir = targetPos - self.global_transform.origin 
		look_at(targetPos, Vector3.UP)
	
#	if $RayCast.is_colliding():
#		if Input.is_action_just_pressed("ui_select"):
#			velocity.y = JUMP_SPEED
#		#jump
#		pass
	if stop:
		var targetEnemy = $Weapon.getEnemy()
		if targetEnemy != null:
			look_at(targetEnemy.global_transform.origin, Vector3.UP)
			self.rotation_degrees.x += rotation_degrees.x*-1
	pass
	
func _animation(anim):
	if $AnimationPlayer.current_animation != anim:
		$AnimationPlayer.current_animation = anim
	
func orbColor(color):
	orb.modulate = color

func _touchStatus(value):
	stop = value
	$Weapon.attackAtive(value)
