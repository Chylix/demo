#pragma once
#include <Windows.h>
#include "CSoundSource.h"
#include <functional>

class CSoundEngine;

namespace triebWerk
{
	class CSoundStream
	{
	public:
		CSoundStream();
		~CSoundStream();

	public:
		CSoundSource* m_pSoundSource;
		HWAVEOUT m_DeviceHandle;
		WAVEHDR m_Header;

	private:
		bool m_Looping;
		bool m_Paused;
		bool m_Finished;

	public:
		static void CALLBACK CSoundStream::WaveOutProc(HWAVEOUT  hwo,
			UINT      uMsg,
			DWORD_PTR dwInstance,
			DWORD_PTR dwParam1,
			DWORD_PTR dwParam2);
		//Stops the sound and frees the stream
		void StopStream();
		void SetPauseState(bool a_State);
		void SetLoopingState(bool a_State);
		bool IsStreamFinished();
		//Changes the volume of the stream from 0.0f(silence) to 1.0f(full strength)
		void ChangeVolume(const float a_Volume);
	};
}