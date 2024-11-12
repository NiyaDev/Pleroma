
module pleroma;
import raylib;


/** Wave, audio wave data
 **/
struct Wave {
	uint frame_count;
	uint sample_rate;
	uint sample_size;
	uint channels;
	void* data;
}
/** Wave faults
 **/
fault WaveFault {
	LOAD_FAILED,
	FAILED_EXPORT,
}
/** Checks whether the Wave is ready to be used
 @return "Whether the wave is ready to use"
 **/
fn bool Wave.ready(&self) {
	return raylib::wave_ready(*self);
}
/** Convert Wave to Sound
 @return "Pointer to new Sound"
 **/
fn Sound*! Wave.sound(&self) {
	Sound* output = malloc(Sound.sizeof);
	*output = raylib::load_sound_wave(*self);
	if (output.stream.buffer == null) { return SoundFault.LOAD_FAILED?; }
	return output;
}
/** Unload Wave
 **/
fn void Wave.unload(&self) {
	raylib::unload_wave(*self);
}
/** Save wave as file
 @param filename "Name to save as"
 @return "Self"
 **/
fn Wave*! Wave.save(&self, String filename) {
	bool result = raylib::export_wave(*self, filename);
	if (result) { return WaveFault.FAILED_EXPORT?; }
	return self;
}
/** Save wave as .h file
 @param filename "Name to save as"
 @return "Self"
 **/
fn Wave*! Wave.save_as_code(&self, String filename) {
	bool result = raylib::export_wave_as_code(*self, filename);
	if (result) { return WaveFault.FAILED_EXPORT?; }
	return self;
}
/** Copies Wave
 @return "Copy of wave"
 **/
fn Wave* Wave.copy(&self) {
	Wave* output = malloc(Wave.sizeof);
	*output = raylib::wave_copy(*self);
	return output;
}
/** Crop a wave to a defined range
 @param init_sample "Initial sample"
 @param final_sample "Last sample"
 @return "Self"
 **/
fn Wave* Wave.crop(&self, int init_sample, int final_sample) {
	raylib::wave_crop(self, init_sample, final_sample);

	return self;
}
/** Convert wave to desired format
 @param sample_rate "Sample rate"
 @param sample_size "Size of samples"
 @param channels "Number of channels"
 @return "Self"
 **/
fn Wave* Wave.format(&self, int sample_rate, int sample_size, int channels) {
	raylib::wave_format(self, sample_rate, sample_size, channels);

	return self;
}
/** Load samples from Wave
 @return "Array of samples as floats"
 **/
fn float* Wave.samples(&self) {
	return raylib::load_wave_samples(*self);
}


def AudioBufferRef = void*;
def AudioProcessorRef = void*;


/** AudioStream, custom audio stream
 **/
struct AudioStream {
	AudioBufferRef buffer;
	AudioProcessorRef processor;

    uint sample_rate;
    uint sample_size;
    uint channels;
}
/** Checks whether the AudioStream is ready to be used
 @return "Result"
 **/
fn bool AudioStream.ready(&self) {
	return raylib::audiostream_ready(*self);
}
/** Unload AudioStream
 **/
fn void AudioStream.unload(&self) {
	raylib::unload_audiostream(*self);
}
/** Updates the buffer with new data
 @param data "New data"
 @param frame_count "The length of the new data"
 **/
fn void AudioStream.update(&self, void* data, int frame_count) {
	raylib::update_audiostream(*self, data, frame_count);
}
/** Checks if any buffers requires refill
 @return "result"
 **/
fn bool AudioStream.processed(&self) {
	return raylib::audiostream_processed(*self);
}

/** Plays audiostream
 @return "Self"
 **/
fn AudioStream* AudioStream.play(&self) {
	raylib::play_audiostream(*self);

	return self;
}
/** Pauses audiostream
 @return "Self"
 **/
fn AudioStream* AudioStream.pause(&self) {
	raylib::pause_audiostream(*self);

	return self;
}
/** Resumes audiostream
 @return "Self"
 **/
fn AudioStream* AudioStream.resume(&self) {
	raylib::resume_audiostream(*self);

	return self;
}
/** Stops audiostream
 @return "Self"
 **/
fn AudioStream* AudioStream.stop(&self) {
	raylib::stop_audiostream(*self);

	return self;
}
/** Checks if audiostream is playing
 @return "Result"
 **/
fn bool AudioStream.playing(&self) {
	return raylib::audiostream_is_playing(*self);
}

/** Sets the AudioStream's volume
 @param volume
 @return "Self"
 **/
fn AudioStream* AudioStream.volume(&self, float volume) {
	raylib::set_audiostream_volume(*self, volume);

	return self;
}
/** Sets the AudioStream's pitch
 @param pitch
 @return "Self"
 **/
fn AudioStream* AudioStream.pitch(&self, float pitch) {
	raylib::set_audiostream_pitch(*self, pitch);

	return self;
}
/** Sets the AudioStream's pan
 @param pan
 @return "Self"
 **/
fn AudioStream* AudioStream.pan(&self, float pan) {
	raylib::set_audiostream_pan(*self, pan);

	return self;
}


/** Sound
 **/
struct Sound {
	AudioStream stream;
    uint frameCount;
}
/** Sound faults
 **/
fault SoundFault {
	LOAD_FAILED,
}
/** Create a duplicate sound referencing the data of the original
 @return "Pointer to new Sound"
 **/
fn Sound* Sound.alias(&self) {
	Sound* output = malloc(Sound.sizeof);
	*output = raylib::load_sound_alias(*self);
	return output;
}
/** Checks whether the Sound is ready to be used
 @return "Result"
 **/
fn bool Sound.ready(&self) {
	return raylib::sound_ready(*self);
}
/** Update data in sound
 @param data "New data"
 @param sample_count "Sample count of new data"
 **/
fn Sound* Sound.update(&self, void* data, int sample_count) {
	raylib::update_sound(*self, data, sample_count);

	return self;
}
/** Unload Sound
 **/
fn void Sound.unload(&self) {
	raylib::unload_sound(*self);
}
/** Unload Sound Alias
 **/
fn void Sound.unload_alias(&self) {
	raylib::unload_sound_alias(*self);
}

/** Plays Sound
 @return "Self"
 **/
fn Sound* Sound.play(&self) {
	raylib::play_sound(*self);

	return self;
}
/** Stops Sound
 @return "Self"
 **/
fn Sound* Sound.stop(&self) {
	raylib::stop_sound(*self);

	return self;
}
/** Pauses Sound
 @return "Self"
 **/
fn Sound* Sound.pause(&self) {
	raylib::pause_sound(*self);

	return self;
}
/** Resumes Sound
 @return "Self"
 **/
fn Sound* Sound.resume(&self) {
	raylib::resume_sound(*self);

	return self;
}
/** Returns whether Sound is playing
 @return "Result"
 **/
fn bool Sound.is_playing(&self) {
	return raylib::sound_is_playing(*self);
}

/** Sets Sound volume
 @param volume "Volume to set"
 @return "Self"
 **/
fn Sound* Sound.volume(&self, float volume) {
	raylib::set_sound_volume(*self, volume);

	return self;
}
/** Sets Sound pitch
 @param pitch "Pitch to set"
 @return "Self"
 **/
fn Sound* Sound.pitch(&self, float pitch) {
	raylib::set_sound_pitch(*self, pitch);

	return self;
}
/** Sets Sound pan
 @param pan "Pan to set"
 @return "Self"
 **/
fn Sound* Sound.pan(&self, float pan) {
	raylib::set_sound_pan(*self, pan);

	return self;
}


/** Music, audio stream, anything longer than ~10 seconds should be streamed
 **/
struct Music {
	AudioStream stream;
	uint frame_count;
	bool looping;

	int ctx_type;
	void* ctx_data;
}
/** Music faults
 **/
fault MusicFault {
	LOAD_FAILED,
}

/** Checks whether the Music is ready to be used
 @return "Result"
 **/
fn bool Music.ready(&self) {
	return raylib::music_ready(*self);
}
/** Unload music
 **/
fn void Music.unload(&self) {
	raylib::unload_music(*self);
}
/** Updates buffers for streaming
 @return "Self"
 **/
fn Music* Music.update(&self) {
	raylib::update_music(*self);

	return self;
}

/** Plays music
 @return "Self"
 **/
fn Music* Music.play(&self) {
	raylib::play_music(*self);

	return self;
}
/** Stops music
 @return "Self"
 **/
fn Music* Music.stop(&self) {
	raylib::stop_music(*self);

	return self;
}
/** Pauses music
 @return "Self"
 **/
fn Music* Music.pause(&self) {
	raylib::pause_music(*self);

	return self;
}
/** Resumes music
 @return "Self"
 **/
fn Music* Music.resume(&self) {
	raylib::resume_music(*self);

	return self;
}
/** Checks whether the music is playing
 @return "Result"
 **/
fn bool Music.is_playing(&self) {
	return raylib::music_is_playing(*self);
}
/** Seek music to a specific position in seconds
 @param position "Point to seek too"
 @return "Self"
 **/
fn Music* Music.seek(&self, float position) {
	raylib::seek_music(*self, position);

	return self;
}

/** Sets volume
 @param volume
 @return "Self"
 **/
fn Music* Music.volume(&self, float volume) {
	raylib::set_music_volume(*self, volume);

	return self;
}
/** Sets pitch
 @param pitch
 @return "Self"
 **/
fn Music* Music.pitch(&self, float pitch) {
	raylib::set_music_pitch(*self, pitch);

	return self;
}
/** Sets pan
 @param pan
 @return "Self"
 **/
fn Music* Music.pan(&self, float pan) {
	raylib::set_music_pan(*self, pan);

	return self;
}

/** Get total length in seconds
 @return "Results"
 **/
fn float Music.length(&self) {
	return raylib::get_music_length(*self);
}
/** Get current runtime in seconds
 @return "Results"
 **/
fn float Music.time_played(&self) {
	return raylib::get_music_played(*self);
}



module pleroma::wave;
import raylib;

/** Load wave from file
 @param filename "Name of file to load"
 @return "Wave file"
 **/
fn Wave*! load(String filename) {
	Wave* output = malloc(Wave.sizeof);
	*output = raylib::load_wave(filename);
	if (output.data == null) { return WaveFault.LOAD_FAILED?; }
	return output;
}
/** Load wave from file
 @param filetype "File extension of data"
 @param data "Pointer to data"
 @param data_len "Length of data"
 @return "Wave file"
 **/
fn Wave*! load_mem(String filetype, char* data, int data_len) {
	Wave* output = malloc(Wave.sizeof);
	*output = raylib::load_wave_memory(filetype, data, data_len);
	if (output.data == null) { return WaveFault.LOAD_FAILED?; }
	return output;
}
/** Unload samples previously created by Wave.samples()
 @param samples "Previously created samples"
 **/
fn void unload_samples(float* samples) {
	raylib::unload_wave_samples(samples);
}


module pleroma::sound;
import raylib;

/** Load Sound from file
 @param filename "Name of file to load"
 @return "Sound file"
 **/
fn Sound*! load(String filename) {
	Sound* output = malloc(Sound.sizeof);
	*output = raylib::load_sound(filename);
	if (output.stream.buffer == null) { return SoundFault.LOAD_FAILED?; }
	return output;
}



module pleroma::audiostream;
import raylib;

/** Loads audio stream
 @param sample_rate
 @param sample_size
 @param channels
 @return "Pointer to new audio stream"
 **/
fn AudioStream* load(uint sample_rate, uint sample_size, uint channels) {
	AudioStream* output = malloc(AudioStream.sizeof);
	*output = raylib::load_audiostream(sample_rate, sample_size, channels);
	return output;
}



module pleroma::music;
import raylib;

/** Load music into audiostream
 @param filename
 @return "Pointer to music"
 **/
fn Music*! load(String filename) {
	Music* output = malloc(Music.sizeof);
	*output = raylib::load_music(filename);
	if (output.stream.buffer == null) { return MusicFault.LOAD_FAILED?; }
	return output;
}
/** Load music into audiostream from memory
 @param filetype
 @param data
 @param data_size
 @return "Pointer to music"
 **/
fn Music*! load_mem(String filetype, char* data, int data_size) {
	Music* output = malloc(Music.sizeof);
	*output = raylib::load_music_from_memory(filetype, data, data_size);
	if (output.stream.buffer == null) { return MusicFault.LOAD_FAILED?; }
	return output;
}
 