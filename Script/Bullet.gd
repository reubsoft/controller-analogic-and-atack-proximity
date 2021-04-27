extends Spatial


var BULLET_SPEED = 40
var BULLET_DAMAGE = 26

const KILL_TIMER = 4
var timer = 0

var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")
	pass # Replace with function body.

func _physics_process(delta):
	var forward_dir = global_transform.basis.z.normalized()
	global_translate(forward_dir*-1 * BULLET_SPEED * delta)
	
	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	if hit_something == false:
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)
		
	hit_something = true
	queue_free()
