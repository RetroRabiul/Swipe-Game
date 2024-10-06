extends Control

var score_particles = preload("res://scenes/score_particles.tscn")
@export var background_colors : Array[Color]

var pressed_position : Vector2
var release_position : Vector2
var score : int 

var decrease_health_speed : int = 275
var health_to_increase : int = 250
var health : float = 10000

var is_game_over : bool

func _ready() -> void:
	change_background_color()

func _process(delta: float) -> void:
	decrease_health(delta)
	
func decrease_health(delta : float) -> void:
	if is_game_over:
		return
	
	if health > 0:
		health -= delta * decrease_health_speed 
		$HealthBar.value = health
	else:
		game_over()

func _input(event: InputEvent) -> void:
	if is_game_over:
		return
	
	if Input.is_action_just_pressed("click"):
		pressed_position = event.position
	if Input.is_action_just_released("click"):
		release_position = event.position
		calculate_swipe()

func calculate_swipe() -> void:
	var difference : Vector2 = release_position - pressed_position
	
	if difference != Vector2.ZERO:
		if abs(difference.x) > abs(difference.y):
			if difference.x > 0 and $Arrow.rotation_degrees == 90:
				correct_swipe()
			elif difference.x < 0 and $Arrow.rotation_degrees == 270:
				correct_swipe()
			else:
				game_over()
		else:
			if difference.y > 0 and $Arrow.rotation_degrees == 180:
				correct_swipe()
			elif difference.y < 0 and $Arrow.rotation_degrees == 0:
				correct_swipe()
			else:
				game_over()
		

func correct_swipe() -> void:
	set_arrow_rotation()
	increase_score()
	change_background_color()
	instantiate_score_particles()
	increase_health()
	

func set_arrow_rotation() -> void:
	var random_arrow_rotation : int = $Arrow.rotation_degrees / 90
	var new_rotation : int
	
	while true:
		new_rotation = randi() % 4
		if new_rotation != random_arrow_rotation:
			break
	$Arrow.rotation_degrees = new_rotation * 90

func increase_score() -> void:
	score += 1
	$ScoreLabel.text = "Score: " + str(score)
	Input.vibrate_handheld(125)
	$ScoreLabelAnimationPlayer.play("ScoreIncreased")

func instantiate_score_particles() -> void:
	var score_particles_instance : Control = score_particles.instantiate()
	score_particles_instance.get_node("ScoreParticles").emitting = true
	add_child(score_particles_instance)
	
	var background_color : Color = $Background.color
	var darkening_factor : float = 0.5
	var darken_background_color : Color = Color(
		background_color.r * darkening_factor,
		background_color.g * darkening_factor,
		background_color.b * darkening_factor,
		background_color.a
	)
	score_particles_instance.get_node("ScoreParticles").color = darken_background_color

func increase_health() -> void:
	var random : float = randi()
	
	if random <= 0.25 and health < 10000 - health_to_increase:
		health += health_to_increase


func change_background_color() -> void:
	var new_color_index : int
	
	while true:
		new_color_index = randi_range(0, background_colors.size() - 1)
		if background_colors[new_color_index] != $Background.color:
			break
	$Background.color = background_colors[new_color_index]

func game_over() -> void:
	$GameOver.game_over()
	is_game_over = true
