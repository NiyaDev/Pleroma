
module pleroma::raylib;
import std::io;


<* Audio wave data *>
struct Wave {
  uint frame_count;
  uint sample_rate;
  uint sample_size;
  uint channels;
  void* data;
}
<* Wave faults *>
fault WaveFault {
  LOAD_FAILED,
  FAILED_EXPORT,
}

<* Checks whether the wave is ready to be used *>
fn bool Wave.ready(self) {
  return wave_ready(self);
}
<* Convert Wave to Sound *>
fn Sound*! Wave.sound(&self) {
	Sound* output = mem::new(Sound);
	*output = raylib::load_sound_wave(*self);
	//if (output.stream.buffer == null) { return SoundFault.LOAD_FAILED?; }
	return output;
}
<* Unload Wave *>
fn void Wave.unload(&self) {
	raylib::unload_wave(*self);
	free(self);
}
<* Save wave as file *>
fn void! Wave.save(&self, String filename) {
	bool result = raylib::export_wave(*self, filename);
	if (!result) { return WaveFault.FAILED_EXPORT?; }
}
<* Save wave as .h file *>
fn void! Wave.save_as_code(&self, String filename) {
	bool result = raylib::export_wave_as_code(*self, filename);
	if (!result) { return WaveFault.FAILED_EXPORT?; }
}
<* Copies Wave *>
fn Wave* Wave.copy(&self) {
	Wave* output = mem::new(Wave);
	*output = raylib::wave_copy(*self);
	return output;
}
<* Crop a wave to a defined range
  @param init_sample "Initial sample"
  @param final_sample "Last sample"
 *>
fn void Wave.crop(&self, int init_sample, int final_sample) {
	raylib::wave_crop(self, init_sample, final_sample);
}
<* Convert wave to desired format
  @param sample_rate "Sample rate"
  @param sample_size "Size of samples"
  @param channels "Number of channels"
 *>
fn void Wave.format(&self, int sample_rate, int sample_size, int channels) {
	raylib::wave_format(self, sample_rate, sample_size, channels);
}
<* Load samples from Wave *>
fn float* Wave.samples(&self) {
	return raylib::load_wave_samples(*self);
}


def AudioBufferRef = void*;
def AudioProcessorRef = void*;


<* AudioStream, custom audio stream *>
struct AudioStream {
	AudioBufferRef buffer;
	AudioProcessorRef processor;

  uint sample_rate;
  uint sample_size;
  uint channels;
}
<* Checks whether the AudioStream is ready to be used *>
fn bool AudioStream.ready(&self) {
	return raylib::audiostream_ready(*self);
}
<* Unload AudioStream *>
fn void AudioStream.unload(&self) {
	raylib::unload_audiostream(*self);
	free(self);
}
<* Updates the buffer with new data
  @param data "New data"
  @param frame_count "The length of the new data"
 *>
fn void AudioStream.update(&self, void* data, int frame_count) {
	raylib::update_audiostream(*self, data, frame_count);
}
<* Checks if any buffers requires refill *>
fn bool AudioStream.processed(&self) {
	return raylib::audiostream_processed(*self);
}

<* Plays audiostream *>
fn void AudioStream.play(&self) {
	raylib::play_audiostream(*self);
}
<* Pauses audiostream *>
fn void AudioStream.pause(&self) {
	raylib::pause_audiostream(*self);
}
<* Resumes audiostream *>
fn void AudioStream.resume(&self) {
	raylib::resume_audiostream(*self);
}
<* Stops audiostream *>
fn void AudioStream.stop(&self) {
	raylib::stop_audiostream(*self);
}
<* Checks if audiostream is playing *>
fn bool AudioStream.playing(&self) {
	return raylib::audiostream_is_playing(*self);
}

<* Sets the AudioStream's volume *>
fn void AudioStream.volume(&self, float volume) {
	raylib::set_audiostream_volume(*self, volume);
}
<* Sets the AudioStream's pitch *>
fn void AudioStream.pitch(&self, float pitch) {
	raylib::set_audiostream_pitch(*self, pitch);
}
<* Sets the AudioStream's pan *>
fn void AudioStream.pan(&self, float pan) {
	raylib::set_audiostream_pan(*self, pan);
}


<* Sound *>
struct Sound {
	AudioStream stream;
  uint frameCount;
}
<* Sound faults *>
fault SoundFault {
	LOAD_FAILED,
}
<* Create a duplicate sound referencing the data of the original *>
fn Sound* Sound.alias(&self) {
	Sound* output = mem::new(Sound);
	*output = raylib::load_sound_alias(*self);
	return output;
}
<* Checks whether the Sound is ready to be used *>
fn bool Sound.ready(&self) {
	return raylib::sound_ready(*self);
}
<* Update data in sound
  @param data "New data"
  @param sample_count "Sample count of new data"
 *>
fn void Sound.update(&self, void* data, int sample_count) {
	raylib::update_sound(*self, data, sample_count);
}
<* Unload Sound *>
fn void Sound.unload(&self) {
	raylib::unload_sound(*self);
	free(self);
}
<* Unload Sound Alias *>
fn void Sound.unload_alias(&self) {
	raylib::unload_sound_alias(*self);
}

<* Plays Sound *>
fn void Sound.play(&self) {
	raylib::play_sound(*self);
}
<* Stops Sound *>
fn void Sound.stop(&self) {
	raylib::stop_sound(*self);
}
<* Pauses Sound *>
fn void Sound.pause(&self) {
	raylib::pause_sound(*self);
}
<* Resumes Sound *>
fn void Sound.resume(&self) {
	raylib::resume_sound(*self);
}
<* Returns whether Sound is playing *>
fn bool Sound.is_playing(&self) {
	return raylib::sound_is_playing(*self);
}

<* Sets Sound volume *>
fn void Sound.volume(&self, float volume) {
	raylib::set_sound_volume(*self, volume);
}
<* Sets Sound pitch *>
fn void Sound.pitch(&self, float pitch) {
	raylib::set_sound_pitch(*self, pitch);
}
<* Sets Sound pan *>
fn void Sound.pan(&self, float pan) {
	raylib::set_sound_pan(*self, pan);
}


<* Music, audio stream, anything longer than ~10 seconds should be streamed *>
struct Music {
	AudioStream stream;
	uint frame_count;
	bool looping;

	int ctx_type;
	void* ctx_data;
}
<* Music faults *>
fault MusicFault {
	LOAD_FAILED,
	SEEK_PAST_END,
}
<* Checks whether the Music is ready to be used *>
fn bool Music.ready(&self) {
	return raylib::music_ready(*self);
}
<* Unload music *>
fn void Music.unload(&self) {
	raylib::unload_music(*self);
	free(self);
}
<* Updates buffers for streaming *>
fn void Music.update(&self) {
	raylib::update_music(*self);
}

<* Plays music *>
fn void Music.play(&self) {
	raylib::play_music(*self);
}
<* Stops music *>
fn void Music.stop(&self) {
	raylib::stop_music(*self);
}
<* Pauses music *>
fn void Music.pause(&self) {
	raylib::pause_music(*self);
}
<* Resumes music *>
fn void Music.resume(&self) {
	raylib::resume_music(*self);
}
<* Checks whether the music is playing *>
fn bool Music.is_playing(&self) {
	return raylib::music_is_playing(*self);
}
<* Seek music to a specific position in seconds
  @param position "Point to seek too"
  @require position > 0
 *>
fn void! Music.seek(&self, float position) {
	if (position > self.length()) {
		io::printfn("ERROR Seeked past the length of music");
		return MusicFault.SEEK_PAST_END?;
	}
	raylib::seek_music(*self, position);
}

<* Sets volume *>
fn void Music.volume(&self, float volume) {
	raylib::set_music_volume(*self, volume);
}
<* Sets pitch *>
fn void Music.pitch(&self, float pitch) {
	raylib::set_music_pitch(*self, pitch);
}
<* Sets pan *>
fn void Music.pan(&self, float pan) {
	raylib::set_music_pan(*self, pan);
}

<* Get total length in seconds *>
fn float Music.length(&self) {
	return raylib::get_music_length(*self);
}
<* Get current runtime in seconds *>
fn float Music.time_played(&self) {
	return raylib::get_music_played(*self);
}



module pleroma::raylib::wave;

<* Load wave from file
  @param filename "Name of file to load"
 *>
fn Wave*! load(String filename) {
	Wave* output = mem::new(Wave);
	*output = raylib::load_wave(filename);
	if (output.data == null) { return WaveFault.LOAD_FAILED?; }
	return output;
}
<* Load wave from file
  @param filetype "File extension of data"
  @param data "Pointer to data"
  @param data_len "Length of data"
 *>
fn Wave*! load_mem(String filetype, char* data, int data_len) {
	Wave* output = mem::new(Wave);
	*output = raylib::load_wave_memory(filetype, data, data_len);
	if (output.data == null) { return WaveFault.LOAD_FAILED?; }
	return output;
}
<* Unload samples previously created by Wave.samples()
  @param samples "Previously created samples"
 *>
fn void unload_samples(float* samples) {
	raylib::unload_wave_samples(samples);
}


module pleroma::raylib::sound;

<* Load Sound from file
  @param filename "Name of file to load"
 *>
fn Sound*! load(String filename) {
	Sound* output = mem::new(Sound);
	*output = raylib::load_sound(filename);
	if (output.stream.buffer == null) { return SoundFault.LOAD_FAILED?; }
	return output;
}



module pleroma::raylib::audiostream;

<* Loads audio stream
  @param sample_rate
  @param sample_size
  @param channels
 *>
fn AudioStream* load(uint sample_rate, uint sample_size, uint channels) {
	AudioStream* output = mem::new(AudioStream);
	*output = raylib::load_audiostream(sample_rate, sample_size, channels);
	return output;
}



module pleroma::raylib::music;

<* Load music into audiostream
  @param filename
  @return "Pointer to music"
 *>
fn Music*! load(String filename) {
	Music* output = mem::new(Music);
	*output = raylib::load_music(filename);
	if (output.stream.buffer == null) { return MusicFault.LOAD_FAILED?; }
	return output;
}
<* Load music into audiostream from memory
  @param filetype
  @param data
  @param data_size
 *>
fn Music*! load_mem(String filetype, char* data, int data_size) {
	Music* output = mem::new(Music);
	*output = raylib::load_music_from_memory(filetype, data, data_size);
	if (output.stream.buffer == null) { return MusicFault.LOAD_FAILED?; }
	return output;
}
 
