extends AudioStreamPlayer
#Evrything needs to be on time with the music, music has lag so now time has lag
@export var time = 0

var time_begin
var time_delay


func _ready():
	#program: "so..like its been 5 minutes since you started right" song: "3 seconds" Program: "HEH?!?! song: "L A G"
	# this latency program was shamlessly stolen streight from the godot docs
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()


func _process(_delta):
	time = (Time.get_ticks_usec() - time_begin) / 1000000.0
	# Compensate for latency.
	time -= time_delay
	# May be below 0 (did not begin yet).
	time = max(0, time)
	


func _on_sensitivity_slider_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
