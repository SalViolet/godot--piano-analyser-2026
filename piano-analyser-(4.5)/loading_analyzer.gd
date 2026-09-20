extends Node
signal LoadingComplete(MagSearch)
var Maxheights: Array[float] = []
var equalsTresh: float = 0.01
var firstRun= true
var NoteCount = 21
var spectrum: AudioEffectSpectrumAnalyzerInstance 
const BAR_COUNT: int = 88
var timer = 0;
func _ready() -> void:
	Maxheights.resize(BAR_COUNT+50)
	spectrum = AudioServer.get_bus_effect_instance(3, 1)

func _process(delta: float) -> void:
	timer = max(timer-delta,0)
	_update_spectrum_data()
	firstRun= false
	pass
	
func _update_spectrum_data() -> void:
	if spectrum.get_magnitude_for_frequency_range((2**((21-69.0)/12)*(440.0)), (2**((88-69.0)/12)*(440.0))).length()>0.0030 && timer==0:
		timer=0.15
		NoteCount+=1
		if (NoteCount<88+50):
			var l_magnitude = spectrum.get_magnitude_for_frequency_range((2**((NoteCount-69.0)/12)*(440.0)-.1), (2**((NoteCount-69.0)/12)*(440.0))+.1).length()
			Maxheights[NoteCount-22]=l_magnitude
		print("notes played")

func _on_loading_player_finished() -> void:
	print(Maxheights)
	pass # Replace with function body.
