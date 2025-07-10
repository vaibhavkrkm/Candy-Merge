extends Control

@export var TWEENING_TIME = 0.75


func _ready():
	# setting pivot offset to center
	set_pivot_offset(size/2)
	$Label.set_pivot_offset($Label.size/2)
	
	# tweening
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Label, "scale", scale*2, TWEENING_TIME).from_current().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Label, "modulate", Color8(255, 255, 255, 0), TWEENING_TIME).from_current().set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free).set_delay(TWEENING_TIME)


func set_score(tier):
	var score
	if (tier != 8):
		score = 10*tier
	else:
		score = 1000
		$Label.scale = 2
	$Label.text = str(score)
