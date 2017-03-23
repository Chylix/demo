#include "CSoundStream.h"
#include <iostream>
#include "CSoundEngine.h"
#include <functional>

triebWerk::CSoundStream::CSoundStream()
{
}

triebWerk::CSoundStream::~CSoundStream()
{
}

void triebWerk::CSoundStream::StopStream()
{
	m_Looping = false;
	waveOutReset(m_DeviceHandle);
}

void triebWerk::CSoundStream::WaveOutProc(
	HWAVEOUT  hwo,
	UINT      uMsg,
	DWORD_PTR dwInstance,
	DWORD_PTR dwParam1,
	DWORD_PTR dwParam2)
{
	if (uMsg == WOM_DONE)
	{
		triebWerk::CSoundStream* soundstream = reinterpret_cast<triebWerk::CSoundStream*>(dwInstance);

		if (soundstream->m_Looping == true)
		{
			WAVEHDR* t = (WAVEHDR*)dwParam1;
			waveOutUnprepareHeader(hwo, t, sizeof(WAVEHDR));
			t->lpData = soundstream->m_pSoundSource->GetRawSoundData();
			t->dwBufferLength = soundstream->m_pSoundSource->GetDataSize();
			t->dwBytesRecorded = 0;
			t->dwUser = 0;
			t->dwFlags = 0;
			t->dwLoops = 0;

			waveOutPrepareHeader(hwo, t, sizeof(WAVEHDR));
			waveOutWrite(hwo, t, sizeof(WAVEHDR));
		}
		else
		{
			soundstream->m_Finished = true;
		}

	}
}

void triebWerk::CSoundStream::SetPauseState(bool a_State)
{
	if (m_Paused == false && a_State == true)
	{
		waveOutPause(m_DeviceHandle);
		m_Paused = a_State;
	}
	else if (m_Paused == true && a_State == false)
	{
		waveOutRestart(m_DeviceHandle);
		m_Paused = a_State;
	}
}

void triebWerk::CSoundStream::SetLoopingState(bool a_State)
{
	m_Looping = a_State;
}

bool triebWerk::CSoundStream::IsStreamFinished()
{
	return m_Finished;
}

void triebWerk::CSoundStream::ChangeVolume(const float a_Volume)
{
	//DWORD waveOutVolume = static_cast<DWORD>(MAKELPARAM(0xFFFF * (m_MasterVolume * a_pSound->GetVolume()), 0xFFFF * (m_MasterVolume * a_pSound->GetVolume())));
	waveOutSetVolume(m_DeviceHandle, 0xFFFF * a_Volume);
}