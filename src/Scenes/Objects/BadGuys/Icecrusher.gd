extends "BadGuy.gd"

var triggered = false
var recovering = false

onready var trigger_ray = get_node('trigger_ray')

func _physics_process(delta):
	pass

func _squish(delta):
	pass
	
func _process(delta):
	if triggered or recovering:
		return

	if trigger_ray.is_colliding():
		if trigger_ray.get_collider().is_in_group('player'):
			triggered = true
		
	
func _move(delta):
	if not triggered and not recovering:
		return
	
	if is_on_floor() and not recovering:
		triggered = false
		$SFX/thud.play()
		$recover_timer.start()
		return
	
	if triggered:
		velocity.y += 20
		velocity.y = move_and_slide(velocity, FLOOR).y

	elif recovering:
		position.y -= 4

	if recovering and position.y < startpos.y:
		recovering = false
		velocity.y = 0
		velocity.y = move_and_slide(velocity, FLOOR).y

func _on_Area2D_body_entered(body):

	if body.is_in_group('player'):
		body.hurt()
		triggered = false
		recovering = true

	if body.is_in_group('badguys'):
		body.kill()
		triggered = false
		recovering = true

func _on_recover_timer_timeout():
	$recover_timer.stop()
	recovering = true
