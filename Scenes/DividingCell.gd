extends RigidBody2D

signal divide
signal out_of_bounds

var min_area = 300
var area = min_area
var max_area


var _divided  # Set to false during division, so that 


func _ready():
    _divided = false
    max_area = 1400 + randf() * 400
    
    # Make sure each cell has their own shape instance
    var existing_shape: Shape2D = $CollisionShape2D.get_shape()
    $CollisionShape2D.set_shape(existing_shape.duplicate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    area += delta * 300
    if area > max_area:
        # Divide
        emit_signal("divide", self.position)
        self._divided = true
        self.queue_free()

    var radius = sqrt(area)

    $CollisionShape2D.get_shape().set_radius(radius)
    var desired_width = radius * 2
    var sprite : Sprite = $Sprite
    var texture_size = sprite.texture.get_size()
    sprite.scale = Vector2(desired_width / texture_size.x, desired_width / texture_size.y)
    


func _on_VisibilityNotifier2D_screen_exited():
    # For some reason, _screen_exited is fired on queue_free. So ignore if that queue_free came from a division
    if not self._divided:
        emit_signal("out_of_bounds")

    self.queue_free()
