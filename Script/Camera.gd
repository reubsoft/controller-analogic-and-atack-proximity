extends Camera


export var distance = 28.0
export var height = 19.0
export(NodePath) var targetNode = null
var target
var velocity = 10

func _ready():
	if targetNode != null:
		target = get_node(targetNode)


func _process(delta):
	var targetPos = target.get_global_transform().origin
	var pos = self.get_global_transform().origin
	
	var offset = pos - targetPos
	
	offset = offset.normalized() * distance
	offset.y = height

	pos = pos.linear_interpolate(targetPos + offset, velocity * delta)
#	pos = targetPos + offset
	
	look_at_from_position(pos, targetPos, Vector3.UP)
