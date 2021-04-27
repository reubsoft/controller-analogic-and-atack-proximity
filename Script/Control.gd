extends Spatial

export var distanceControler = 7.0
export var joystickSize = 55
export var stickSize = 30
export(NodePath) var nodePlayer
export(NodePath) var camera
var touchNumber = [Vector2(), Vector2()]
var touch = false

onready var joystick = $joystick
onready var stick = $joystick/stick
onready var orb = $orb
var basic
var player
var cam
var distViewStick = 0


############    SIGNAL    ############
signal touchStatus

func _ready():
	player = get_node(nodePlayer)
	cam = get_node(camera)
	_showStick(touch)
	pass
	
func _physics_process(delta):
	if touch:
		updateJoystickView()
		self.global_transform.origin = player.global_transform.origin + basic.x * (distanceControler * distViewStick)  * delta
		
func get_touch():
	return touch

func updateJoystickView():
	if touch:
		joystick.position = touchNumber[0]
		distViewStick = touchNumber[0].distance_to(touchNumber[1])
		var angleStick = touchNumber[1].angle_to_point(touchNumber[0])
		var posStick = touchNumber[1]
		
		basic = Basis(Vector3(0,1,0), -angleStick) * cam.get_global_transform().basis
		
		if distViewStick > stickSize:
			distViewStick = stickSize
		stick.position = Vector2(distViewStick,0).rotated(angleStick)

func _input(event):
	if event is InputEventScreenTouch:
		touchNumber[0] = event.position
		touchNumber[1] = event.position
		touch = !touch
		_showStick(touch)
	if event is InputEventScreenDrag:
			touchNumber[1] = event.position

func restarJoystick():
	var view = get_viewport().size
	joystick.position = Vector2(view.x/2, view.y-joystickSize)
	stick.position = Vector2()
	emit_signal("touchStatus", true)
	
func _showStick(action):
	if action:
		emit_signal("touchStatus", false)
		orb.show()
		return
	orb.hide()
	restarJoystick()

func orbColor(color):
	orb.modulate = color
