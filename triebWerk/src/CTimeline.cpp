#include <CTimeline.h>
#include <CEngine.h>

triebWerk::CTimeline::CTimeline()
	: m_pSceneManagerHandle(nullptr)
{
}

triebWerk::CTimeline::~CTimeline()
{
}

void triebWerk::CTimeline::Initialize(CSceneManager * a_pSceneManager)
{
	m_pSceneManagerHandle = a_pSceneManager;
}

void triebWerk::CTimeline::Update(float a_DeltaTime, float a_TimeSinceStartUp)
{
	UpdareKeyframes(a_DeltaTime);
	UpdateSceneOrder(a_DeltaTime);
}

void triebWerk::CTimeline::Shutdown()
{
	for (auto order : m_SceneOrder)
	{
		delete order;
	}

	m_SceneOrder.clear();
}

void triebWerk::CTimeline::AddSceneOrder(SSceneOrder * a_pSceneOrder)
{
	//if this is the first order set it active
	if (m_SceneOrder.size() == 0)
	{
		m_pSceneManagerHandle->SetActiveScene(a_pSceneOrder->m_SceneName);
	}

	m_SceneOrder.push_back(a_pSceneOrder);
}

void triebWerk::CTimeline::AddKeyframe(CKeyframe * a_pKeyframe)
{
	m_Keyframes.push_back(a_pKeyframe);
}

void triebWerk::CTimeline::Reset()
{
	Shutdown();
	twTime->ResetTimeStart();
	twTime->ResetDeltaTime();
}

void triebWerk::CTimeline::UpdareKeyframes(float a_DeltaTime)
{
	for (size_t i = 0; i < m_Keyframes.size(); i++)
	{
		if (m_Keyframes[i]->Update(a_DeltaTime))
		{
			TriggerKeyframe(m_Keyframes[i]);

			//Remove Keyframe
			m_Keyframes.erase(m_Keyframes.begin() + i);
		}
	}
}

void triebWerk::CTimeline::UpdateSceneOrder(float a_DeltaTime)
{
	SSceneOrder* pSceneOrder = m_SceneOrder.front();

	bool isSceneOver = pSceneOrder->m_SceneTimer.UpdateTimer(a_DeltaTime);

	if (isSceneOver)
	{
		StartNextScene();
	}
}


void triebWerk::CTimeline::ClearCurrentOrder()
{
	SSceneOrder* order = *m_SceneOrder.begin();
	delete m_SceneOrder.front();
	m_SceneOrder.pop_front();
}

void triebWerk::CTimeline::StartNextScene()
{
	//clear the current
	ClearCurrentOrder();

	//if a next scene exists set it
	if (m_SceneOrder.size() != 0)
	{
		SSceneOrder* order = m_SceneOrder.front();
		m_pSceneManagerHandle->SetActiveScene(order->m_SceneName);
	}
	else
	{
		CEngine::Instance().Stop();
	}
}

void triebWerk::CTimeline::TriggerKeyframe(CKeyframe * a_pKeyframe)
{
	//TODO: fill event
	CKeyframe::SKeyFrameEvent event;

	a_pKeyframe->CallFunction(event);
}