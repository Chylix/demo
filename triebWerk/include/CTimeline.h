#pragma once
#include "CSceneManager.h"
#include "CKeyframe.h"
#include <list>
#include <vector>

namespace triebWerk
{
	class CTimeline
	{
	public:
		struct SSceneOrder
		{
			std::string m_SceneName;
			CSceneTimer m_SceneTimer;
		};

	public:
		CTimeline();
		~CTimeline();

	public:
		void Initialize(CSceneManager* a_pSceneManager);
		void Update(float a_DeltaTime, float a_TimeSinceStartUp);
		void Shutdown();

		//This will add a new sceneorder to the current end of the timeline
		void AddSceneOrder(SSceneOrder* a_pSceneOrder);
		void AddKeyframe(CKeyframe* a_pKeyframe);

		//Resets the timeline
		void Reset();

	private:
		void ClearCurrentOrder();
		void StartNextScene();
		void TriggerKeyframe(CKeyframe* a_pKeyframe);

		void UpdareKeyframes(float a_DeltaTime);
		void UpdateSceneOrder(float a_DeltaTime);

	private:
		CSceneManager* m_pSceneManagerHandle;

		std::vector<CKeyframe*> m_Keyframes;
		std::list<SSceneOrder*> m_SceneOrder;
	};
}