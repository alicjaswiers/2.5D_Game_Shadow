extends KinematicBody


const move_speed = 7
const jump_force = 9
const gravity = 20
const max_fall_speed = 30
var y_velo = 0
var facing_right = true
var isJumping = false

onready var anim = $graphics/AnimationPlayer

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_left"):
		if !isJumping:
			anim.play("FastRun")
		move_dir -= 1
	if Input.is_action_pressed("move_right"):
		if !isJumping:
			anim.play("FastRun")
		move_dir += 1
	if Input.is_action_just_released("move_left") or move_dir == 0:
		if !isJumping:
			anim.play("Idle")
	if Input.is_action_just_released("move_right") or move_dir == 0:
		if !isJumping:
			anim.play("Idle")
	if Input.is_action_pressed("punch"):
		if !isJumping:
			anim.play("Punching")

	move_and_slide(Vector3(move_dir * move_speed, y_velo, 0), Vector3(0, 1, 0))

	var just_jump = false
	var grounded = is_on_floor()
	y_velo -= gravity * delta
	
	if y_velo < -max_fall_speed:
		y_velo = -max_fall_speed

	if grounded:
		y_velo = 0.1
		if Input.is_action_pressed("jump"):
			anim.play("Jump")
			y_velo = jump_force
			just_jump = true
			isJumping = true
			yield(anim, "animation_finished")
			isJumping = false


	if move_dir < 0 and facing_right:
		flip()
	if move_dir > 0 and !facing_right:
		flip()
	
func flip():
	$graphics.rotation_degrees.y *= -1
	facing_right = !facing_right


func _on_HitArea_area_entered(area):
	if area.name == "LaserArea":
		get_tree().reload_current_scene()
