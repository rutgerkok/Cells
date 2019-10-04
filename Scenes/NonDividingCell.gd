extends RigidBody2D

signal out_of_bounds
signal cell_ablation

var min_area = 300
var area = min_area
var max_area

var live_time = 0
var planned_death = false

func _ready():
    max_area = 1000 + randf() * 400
    
    # Make sure each cell has their own shape instance
    var existing_shape: Shape2D = $CollisionShape2D.get_shape()
    $CollisionShape2D.set_shape(existing_shape.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    live_time += delta * Parameters.game_speed
    if live_time > Parameters.max_live_time_nondividing_cells_seconds:
        # Die
        self.planned_death = true
        self.queue_free()
        return

    area += delta * Parameters.game_speed * 100
    if area > max_area:
        # Stop growing
        area = max_area
        return

    var radius = sqrt(area)

    $CollisionShape2D.get_shape().set_radius(radius)
    var desired_width = radius * 2
    var sprite : Sprite = $Sprite
    var texture_size = sprite.texture.get_size()
    sprite.scale = Vector2(desired_width / texture_size.x, desired_width / texture_size.y)


func _input(event):
   # Deletes cells on click
   if event is InputEventMouseButton and event.is_pressed():
       var mouse_relative = self.make_input_local(event).position
       if mouse_relative.length_squared() < self.area:
           self.planned_death = true
           emit_signal("cell_ablation")
           self.queue_free()


func _on_VisibilityNotifier2D_screen_exited():
    if not self.planned_death:
        # For some reason, this event also fires if queue_free is called
        emit_signal("out_of_bounds")
        self.planned_death = true
    self.queue_free()
