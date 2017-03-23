#pragma once
#include <EngineDefines.h>
#include <CInput.h>
#include <CTime.h>
#include <CWindow.h>
#include <CFontManager.h>
#include <CResourceManager.h>
#include <CGraphics.h>
#include <CRandom.h>
#include <CRenderer.h>
#include <CSceneManager.h>
#include <CDebug.h>
#include <CTimeline.h>
#include <SEngineConfiguration.h>

namespace triebWerk
{
    class CEngine
    {
    public:
        CInput* m_pInput;
        CTime* m_pTime;
		CWindow* m_pWindow;
		CGraphics* m_pGraphics;
		CResourceManager* m_pResourceManager;
		CRenderer* m_pRenderer;
        CSceneManager* m_pSceneManager;
        CFontManager* m_pFontManager;
		CDebug* m_pDebug;
		CSoundEngine* m_pSoundEngine;
		CTimeline* m_pTimeline;

	private:
        const double SleepTimeDivisor = 10.0;

		bool m_PausedScenes;
		bool m_IsRunning;
        float m_TimePerFrame;
        float m_CurrentTime;
        float m_PhysicTimeStamp;
        float m_CurrentPhysicTime;

    private:
        CEngine();
        ~CEngine();

    public:
        static CEngine& Instance();

    public:
        bool Initialize();
		bool Initialize(const SEngineConfiguration& a_Config);
        bool Run();
		//This will pause the scene and gameplay
		void Pause(bool a_State);
        void Shutdown();

        void Stop();
	private:
		void ProcessWindowMessages();
    };
}