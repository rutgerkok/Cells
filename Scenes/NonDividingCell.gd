extends RigidBody2D

signal out_of_bounds

var min_area = 300
var area = min_area
var max_area

var live_time = 0


func _ready():
    max_area = 1000 + randf() * 400
    
    # Make sure each cell has their own shape instance
    var existing_shape: Shape2D = $CollisionShape2D.get_shape()
    $CollisionShape2D.set_shape(existing_shape.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    
    live_time += delta
    if live_time > Parameters.max_live_time_nondividing_cells_seconds:
        # Die
        queue_free()
        return

    area += delta * 100
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
    


func _on_VisibilityNotifier2D_screen_exited():
    emit_signal("out_of_bounds")
    self.queue_free()
