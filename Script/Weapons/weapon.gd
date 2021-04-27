extends Area


var listBody = []
var enemy = null
var attack = false

var time = 0
var cadence = 1.2

var damage = 27

var bullet_scene = preload("res://Scenes/Bullet.tscn")

func _physics_process(delta):
	if attack and enemy != null:
		if time < 0:
			time = cadence
			var clone = bullet_scene.instance()
			var root_scene = get_tree().root.get_children()[0]
			root_scene.add_child(clone)
			
			clone.global_transform = self.global_transform
			clone.BULLET_DAMAGE = damage
		
	time -=delta

func attackEnemy(value):
	if enemy != null:
		enemy.target(false)
		
	enemy = near()
	if enemy != null:
		enemy.target(value)
	
func enemyDead(value):
	if enemy != null:
		enemy.target(value)
		enemy = near()
		
	
func attackAtive(value):
	attack = value
	
	if attack:
		attackEnemy(attack)
	else:
		enemyDead(attack)
		
func _on_Arma_body_entered(body):
	listBody.append(body)
	body.connect("die", self, "_die")
	attackEnemy(attack)

	
func _on_Arma_body_exited(body):
	_die(body)


func near():
	if listBody.size() > 0:
		var enemyNear = null
		var distanceEnemy = INF
		for i in listBody:
			var distNew =  i.global_transform.origin.distance_to(global_transform.origin)
			if distNew < distanceEnemy:
				distanceEnemy = distNew
				enemyNear = i
		return enemyNear

func existEnemy():
	return true if listBody.size() > 0 else false
	
func getEnemy():
	return enemy
	
func _die(body):
	body.disconnect("die", self, "_die")
	var id = listBody.find(body)
	if id > -1:
		listBody[id].target(false)
		listBody.remove(id)
		attackEnemy(attack)
