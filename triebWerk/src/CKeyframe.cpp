#include <CKeyframe.h>

triebWerk::CKeyframe::CKeyframe(std::function<void(SKeyFrameEvent&)> a_Callback, float a_ActivationTimer)
{
	m_Callback = a_Callback;
	m_ActivationTimer = a_ActivationTimer;
}

triebWerk::CKeyframe::~CKeyframe()
{
}

void triebWerk::CKeyframe::CallFunction(SKeyFrameEvent & a_rEvent)
{
	m_Callback(a_rEvent);
}

bool triebWerk::CKeyframe::Update(float a_DeltaTime)
{
	m_ActivationTimer -= a_DeltaTime;

	return (m_ActivationTimer <= 0.0f);
}
