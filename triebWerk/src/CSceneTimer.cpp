#include <CSceneTimer.h>

triebWerk::CSceneTimer::CSceneTimer()
	: m_TimerTillActivation(0.0f)
{
}

triebWerk::CSceneTimer::~CSceneTimer()
{
}

bool triebWerk::CSceneTimer::UpdateTimer(float a_FrameTime)
{
	m_TimerTillActivation -= a_FrameTime;
	
	return (m_TimerTillActivation <= 0.0f);
}

void triebWerk::CSceneTimer::SetTimer(float a_Time)
{
	m_TimerTillActivation = a_Time;
}

float triebWerk::CSceneTimer::GetTimer() const
{
	return m_TimerTillActivation;
}
