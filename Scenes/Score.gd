extends Control

signal restart_game  # Emitted when the game should be restarted

var score = 0



# Called when the node enters the scene tree for the first time.
func _ready():
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    score += delta * Parameters.game_speed
    

    $Label.text = "Score: " + str(int(score))


func _on_game_over():
    # Called by other nodes when the game is over
    Parameters.game_speed = 0
    $Popup/Label.text = "Spel voorbij! Je score is " + str(int(self.score)) + "."
    $Popup.popup_centered($Popup.rect_size)


func _on_game_modified():
    # Called by other nodes when the user changed the game (like changing the parameters)
    self.score = 0


func _on_Popup_popup_hide():
    # Called when popup is closed
    self.score = 0
    emit_signal("restart_game")


