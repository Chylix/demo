#pragma once
#include <CWorld.h>
#include <CSceneTimer.h>

namespace triebWerk
{
    class IScene
    {
    public:
        CWorld* m_pWorld;
		CSceneTimer m_SceneTimer;

    public:
        IScene();
        virtual ~IScene();

        virtual void Start();
        virtual void Update();
        virtual void End();
        virtual void Pause();
        virtual void Resume();
    };
}