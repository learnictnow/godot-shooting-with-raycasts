extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_score(score_colour, value):
	print(value)
	if score_colour == "YELLOW":
		$HBoxContainer/PanelYellow/ScoreLabelYellow.text = "  Score: " + str(value)
	if score_colour == "GREEN":
		$HBoxContainer/PanelGreen/ScoreLabelGreen.text = "  Score: " + str(value)
	if score_colour == "BLUE":
		$HBoxContainer/PanelBlue/ScoreLabelBlue.text = "  Score: " + str(value)
