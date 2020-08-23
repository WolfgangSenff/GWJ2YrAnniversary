extends Resource
class_name DialogResource

export (Array, String) var AllLines
export (bool) var DogSpeaksFirst

func init_dialog(dog, obj):
    if dog and obj and AllLines and AllLines.size() > 0:
        var first_speaker = dog if DogSpeaksFirst else obj
        var second_speaker = dog if not DogSpeaksFirst else obj
        second_speaker = second_speaker if obj else first_speaker
        var first_speaking = true
        for line in AllLines:
            var current_speaker = first_speaker if first_speaking else second_speaker
            current_speaker.show_thought_bubble(line)
            yield(current_speaker, "thought_done")
            first_speaking = not first_speaking
    
    yield((Engine.get_main_loop() as SceneTree).create_timer(0.2), "timeout")
