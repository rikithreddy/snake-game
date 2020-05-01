extends Area2D

func _ready():
	rand_seed(100)
	pass # Replace with function body.
func spawner():
	position.x = ((randi() % 10) + 1) *16 + 8 
	position.y = ((randi() % 10) + 1) *16 + 8 
		
func _on_Food_body_entered(body):
	if body.name == "Player":
		body.score += 1
		body.get_parent().get_node("Label").set_text("Score="+str(body.score ))
		body.add_tail()
		spawner()
