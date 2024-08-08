extends Node2D

class_name Bubble

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Color) var color;
export(int) var radius;

func _init(p_color = Color(1, 1, 1), p_radius = 512):
	color = p_color
	radius = p_radius

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("RigidBody2D/Sprite").self_modulate = color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var mouse_entered = false

func non_zero(v):
	if v.x == 0 and v.y == 0:
		return Vector2(1, 0)
	else:
		return v

func left_click():
	var i = 0
	while $Contents.get_child_count() > i:
		var n = $Contents.get_child(i)
		if !color_can_pass(n.color, color):
			i += 1
			continue
		var old_pos = n.get_global_position()
		$Contents.remove_child(n)
		get_node("..").add_child(n)
		var dist = (radius + n.radius)*non_zero(get_global_position().direction_to(old_pos))
		n.set_global_position(get_global_position()+dist)
	#color = Color(1-color.r, color.g, color.b)
	get_node("RigidBody2D/Sprite").self_modulate = color
		
func color_can_pass(a, gate):
	return a.r <= gate.r and a.g <= gate.g and a.b <= gate.b
		
func right_click():
	var par = get_node("../../Contents")
	var i = 0
	while par.get_child_count() > i:
		var n = par.get_child(i)
		if n == self or n.radius >= radius or !color_can_pass(n.color, color):
			i += 1
			continue
		var old_pos = n.get_global_position()
		par.remove_child(n)
		get_node("Contents").add_child(n)
		var dist = (radius - n.radius)*non_zero(get_global_position().direction_to(old_pos))
		n.set_global_position(get_global_position()+dist)
	#color = Color(color.r, 1-color.g, color.b)
	get_node("RigidBody2D/Sprite").self_modulate = color

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed&& \
		mouse_entered:
			left_click()
			self.get_tree().set_input_as_handled()
		if event.button_index == BUTTON_RIGHT and event.pressed&& \
		mouse_entered:
			right_click()
			self.get_tree().set_input_as_handled()

func _on_Area2D_mouse_entered():
	mouse_entered = true

func _on_Area2D_mouse_exited():
	mouse_entered = false

