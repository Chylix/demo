#pragma once
#include "CSoundSource.h"
#include "CSoundStream.h"
#include <list>

namespace triebWerk
{
	class CResourceManager;

	class CSoundEngine
	{
	private:
		float m_MasterVolume;
		float m_SFXVolume;
		float m_BGMVolume;
		std::list<CSoundStream*>m_SoundStreams;
		CResourceManager* m_pResourceManagerHandle;


	public:
		CSoundEngine();
		~CSoundEngine();

	public:
		bool Initialize(CResourceManager* a_pResourceManager, const float a_MasterVolume, const float a_SFXVolume, const float a_BGMVolume);
		void Update();
		void Shutdown();

		//Sets the overall volume of all sounds from 0.0f (silence) to 1.0f (full strength)
		void SetMasterVolume(const float a_MasterVolume);
		//Get the master volume from 0.0f (silence) to 1.0f (full strength)
		float GetMasterVolume() const;
		//Set the volume of all SFX sounds
		void SetSFXVolume(const float a_Volume);
		//Set the volume of all BGM sounds
		void SetBGMVolume(const float a_Volume);
		//Set the volume of all SFX sounds
		float GetSFXVolume() const;
		//Set the volume of all BGM sounds
		float GetBGMVolume() const;

		CSoundStream* PlaySoundSource(CSoundSource* a_pSound, bool a_Looping = false, bool a_CreateSoundStream = false);
		void RemoveSoundStream(CSoundStream* a_pStream);
	private:
		void UpdateSoundResources();
		DWORD CalculateSoundVolume(const CSoundSource* a_pSoundSource);

	};
}