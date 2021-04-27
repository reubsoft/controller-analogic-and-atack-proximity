extends Spatial


var prefabEnemy = preload("res://Enemy.tscn")

export var time = 1.0

var spawn = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	time = rng.randf_range(4.0, time)
	spawn = time
	pass # Replace with function body.


func _process(delta):
	if spawn < 0:
		spawn = time
		var clone = prefabEnemy.instance()
		var root_scene = get_tree().root.get_children()[0]
		root_scene.add_child(clone)
			
		clone.global_transform = self.global_transform
		
	spawn -= delta
	
	
