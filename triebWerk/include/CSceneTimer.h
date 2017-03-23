#pragma once

namespace triebWerk
{
	class CSceneTimer
	{
	private:
		float m_TimerTillActivation;

	public:
		CSceneTimer();
		~CSceneTimer();

	public:
		//Updates timer and returns if the time is over
		bool UpdateTimer(float a_FrameTime);
		void SetTimer(float a_Time);
		float GetTimer() const;
	};
}