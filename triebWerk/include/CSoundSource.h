#pragma once
#include <Windows.h>
#include <string>
#include <CID.h>
#pragma comment(lib, "Winmm.lib")

namespace triebWerk
{
	class CSoundSource
	{
	public:
		enum ESoundType
		{
			SFX,
			BGM,
			None
		};

	public:
		CID m_SoundID;
		ESoundType m_SoundType;

	private:
		WAVEFORMATEX m_Format;
		char* m_AudioData;
		unsigned long m_AudioBufferByteSize;
		float m_Volume;

	public:
		CSoundSource();
		~CSoundSource();

	public:
		//Loads sound data from a .wav 
		bool LoadSoundDataFromFile(const char* a_pPath);
		//Get the sound format
		WAVEFORMATEX GetSoundFormat() const;
		//Get the raw audio data save in the PCM format
		char* GetRawSoundData() const;
		//Get the data size
		unsigned long GetDataSize() const;
		//Sets the volume of the source from 0.0f(silence) to 1.0f(full strength)
		void SetVolume(const float a_Volume);
		//Get the volume of the soundsource 
		float GetVolume() const;
	};
}