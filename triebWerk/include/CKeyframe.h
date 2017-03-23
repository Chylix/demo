#pragma once
#include <functional>
#include <IScene.h>

namespace triebWerk
{
	class CKeyframe
	{
	public:
		struct SKeyFrameEvent
		{
			IScene* pNextScene;
		};

	public:
		CKeyframe(std::function<void(SKeyFrameEvent&)> a_Callback, float a_ActivationTimer);
		~CKeyframe();

		void CallFunction(SKeyFrameEvent& a_rEvent);
		bool Update(float a_DeltaTime);
	private:
		float m_ActivationTimer;
		std::function<void(SKeyFrameEvent)> m_Callback;

	};
}