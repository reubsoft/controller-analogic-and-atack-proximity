extends ImmediateGeometry


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	draw_empty_circle( Vector3(0,0,0), 20)
	pass # Replace with function body.



func draw_empty_circle(circle_center, circle_radius):
	var UP = Vector3(0,1,0)
	clear()
	begin(Mesh.PRIMITIVE_LINE_LOOP)
	for i in range(int(128)):
		var rotation = float(i) / 128 * TAU
		add_vertex(rotate(UP, circle_radius-circle_center) + circle_center)
	end()
