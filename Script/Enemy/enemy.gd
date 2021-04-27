extends KinematicBody

export var life = 100

export(NodePath) var player
var p
var speed
signal die(body)

enum {LIVE, DEAD, ATTACK}
############    CONSTANTES    ############
const GRAVITY = -24
const MAX_SLOPE_ANGLE = 70
const MAX_SPEED = 4
const JUMP_SPEED = 12
const ACCEL = 10
const DEACCEL= 15

############    VARIÁVEIS    ############
var status
var velocity = Vector3()
var dir = Vector2()
var target
var stop = false

############    ONREADY    ############
onready var orb = $Contact


func _ready():
	status = LIVE

	p = get_tree().get_nodes_in_group("PLAYER")[0]
	
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

	var targetPos = p.global_transform.origin
		
	dir = targetPos - self.global_transform.origin 
	dir = dir.normalized()
	look_at(targetPos, Vector3.UP)
	self.rotation_degrees.x += rotation_degrees.x*-1



func bullet_hit(value, teste):
	life -= value
	if life < 0:
		emit_signal("die", self)
		queue_free()
	
func target(danger):
	if danger:
		$target.show()
	else:
		$target.hide()
	
