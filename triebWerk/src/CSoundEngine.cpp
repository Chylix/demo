#include "CSoundEngine.h"
#include <iostream>
#include <CResourceManager.h>

triebWerk::CSoundEngine::CSoundEngine()
	: m_MasterVolume(1.0f)
{
}

triebWerk::CSoundEngine::~CSoundEngine()
{
}

bool triebWerk::CSoundEngine::Initialize(CResourceManager* a_pResourceManager, const float a_MasterVolume, const float a_SFXVolume, const float a_BGMVolume)
{
	m_BGMVolume = a_BGMVolume;
	m_MasterVolume = a_MasterVolume;
	m_SFXVolume = a_SFXVolume;

	return true;
}

void triebWerk::CSoundEngine::Update()
{
	std::list<CSoundStream*>::iterator i = m_SoundStreams.begin();
	while (i != m_SoundStreams.end())
	{
		if ((*i)->IsStreamFinished())
		{
			waveOutClose((*i)->m_DeviceHandle);
			delete (*i);
			m_SoundStreams.erase(i++);  // alternatively, i = items.erase(i);
		}
		else
		{
			++i;
		}
	}
}

void triebWerk::CSoundEngine::Shutdown()
{
	std::list<CSoundStream*>::iterator i = m_SoundStreams.begin();
	while (i != m_SoundStreams.end())
	{
		if ((*i)->IsStreamFinished())
		{
			waveOutClose((*i)->m_DeviceHandle);
			delete (*i);
			m_SoundStreams.erase(i++);  // alternatively, i = items.erase(i);
		}
		else
		{
			(*i)->StopStream();
			waveOutClose((*i)->m_DeviceHandle);
			delete (*i);
			m_SoundStreams.erase(i++);  // alternatively, i = items.erase(i);
		}
	}
}

void triebWerk::CSoundEngine::SetMasterVolume(const float a_MasterVolume)
{
	m_MasterVolume = a_MasterVolume;
}

void triebWerk::CSoundEngine::SetSFXVolume(const float a_Volume)
{
	m_SFXVolume = a_Volume;
	UpdateSoundResources();
}

void triebWerk::CSoundEngine::SetBGMVolume(const float a_Volume)
{
	m_BGMVolume = a_Volume;
	UpdateSoundResources();
}

float triebWerk::CSoundEngine::GetSFXVolume() const
{
	return m_SFXVolume;
}

float triebWerk::CSoundEngine::GetBGMVolume() const
{
	return m_BGMVolume;
}

float triebWerk::CSoundEngine::GetMasterVolume() const
{
	return m_MasterVolume;
}

triebWerk::CSoundStream * triebWerk::CSoundEngine::PlaySoundSource(CSoundSource * a_pSound, bool a_Looping, bool a_CreateSoundStream)
{
	CSoundStream* stream = new CSoundStream();

	stream->SetLoopingState(a_Looping);

	stream->m_pSoundSource = a_pSound;

	MMRESULT result = waveOutOpen(&stream->m_DeviceHandle, WAVE_MAPPER, &a_pSound->GetSoundFormat(), (DWORD_PTR)CSoundStream::WaveOutProc, (DWORD_PTR)stream, CALLBACK_FUNCTION);
	if (result != MMSYSERR_NOERROR)
	{
		std::cout << "Error could not open waveOut" << std::endl;
		return false;
	}

	//FirstBuffer
	stream->m_Header.lpData = a_pSound->GetRawSoundData();
	stream->m_Header.dwBufferLength = a_pSound->GetDataSize();
	stream->m_Header.dwBytesRecorded = 0;
	stream->m_Header.dwUser = 0;
	stream->m_Header.dwFlags = 0;
	stream->m_Header.dwLoops = 0;

	result = waveOutPrepareHeader(stream->m_DeviceHandle, &stream->m_Header, sizeof(WAVEHDR));

	if (result != MMSYSERR_NOERROR)
	{
		std::cout << "Error could not prepare header" << std::endl;
		return false;
	}

	waveOutWrite(stream->m_DeviceHandle, &stream->m_Header, sizeof(WAVEHDR));

	result = waveOutSetVolume(stream->m_DeviceHandle, CalculateSoundVolume(a_pSound));
	if (result != MMSYSERR_NOERROR)
	{
		std::cout << "Error set volume" << std::endl;
		return false;
	}

	if (a_CreateSoundStream)
	{
		m_SoundStreams.push_back(stream);
		return stream;
	}
	else
	{
		m_SoundStreams.push_back(stream);
		return nullptr;
	}
}

void triebWerk::CSoundEngine::RemoveSoundStream(CSoundStream * a_pStream)
{
	m_SoundStreams.remove(a_pStream);
	a_pStream->StopStream();
	waveOutClose(a_pStream->m_DeviceHandle);
	delete (a_pStream);
}

void triebWerk::CSoundEngine::UpdateSoundResources()
{
	m_pResourceManagerHandle->UpdateDefaultSoundVolumes(m_SFXVolume, m_BGMVolume);
}

DWORD triebWerk::CSoundEngine::CalculateSoundVolume(const CSoundSource * a_pSoundSource)
{

	float volumeMultiplier = 0.0f;

	switch (a_pSoundSource->m_SoundType)
	{
	case CSoundSource::ESoundType::BGM:
		volumeMultiplier = m_BGMVolume;
		break;
	case CSoundSource::ESoundType::SFX:
		volumeMultiplier = m_SFXVolume;
		break;
	case CSoundSource::ESoundType::None: //if no special type was set for this soundsource play it as normal
		volumeMultiplier = 1.0f;
		break;
	}

	//Calculate the final volume
	float volume = m_MasterVolume * volumeMultiplier * a_pSoundSource->GetVolume();

	std::cout << a_pSoundSource->m_SoundID.GetName() << " " << a_pSoundSource->m_SoundType << ": " << volume << std::endl;

	//Generate a DWORD with the volume for lowOrder and highOrder so waveOutSetVolume set it to stereo
	return static_cast<DWORD>(MAKELPARAM(0xFFFF * volume, 0xFFFF * volume));
}
