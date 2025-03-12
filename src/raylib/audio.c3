
module pleroma::raylib;


struct Wave {
  uint frame_count;
  uint sample_rate;
  uint sample_size;
  uint channels;
  void* data;
}
fault WaveFault {
  LOAD_FAILED,
  FAILED_EXPORT,
}
struct Sound {
	AudioStream stream;
  uint frameCount;
}
fault SoundFault {
	LOAD_FAILED,
}
struct Music {
	AudioStream stream;
	uint frame_count;
	bool looping;

	int ctx_type;
	void* ctx_data;
}
fault MusicFault {
	LOAD_FAILED,
	SEEK_PAST_END,
}
struct AudioStream {
	AudioBufferRef buffer;
	AudioProcessorRef processor;

  uint sample_rate;
  uint sample_size;
  uint channels;
}
def AudioBufferRef = void*;
def AudioProcessorRef = void*;
