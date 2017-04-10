#include <CEngine.h>
#include <Shlobj.h>
#include <CIntroScene.h>
#include <CSecondScene.h>
#include <CStartUpWindow.h>

void LoadConfig(triebWerk::SEngineConfiguration& a_rConfig);
void SetupSceneOrder();

triebWerk::CSoundStream* pSound;

int main()
{
    //_crtBreakAlloc = 154;
#ifdef _DEBUG
	//Show it
#else
	HWND hWnd = GetConsoleWindow();
	ShowWindow(hWnd, SW_HIDE);
#endif

	triebWerk::CStartUpWindow* pLaunchWindow = new triebWerk::CStartUpWindow();
	pLaunchWindow->Initialize();


    // Initialize the engine
    triebWerk::SEngineConfiguration config;
	

	//Window
	config.m_WindowConfig.m_IconID = 1337;
	config.m_WindowConfig.m_WindowName = "AZ-Tec Racer";
	config.m_WindowConfig.m_WindowStyle = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;

	config.m_Width = 1240;
	config.m_Height = 720;
	config.m_Fullscreen = false;
	config.m_VSync = false;
	config.m_MasterVolume = .0f;
	config.m_BGMVolume = 1.0f;
	config.m_SFXVolume = 1.0f;

	if (twEngine.Initialize(config) == false)
	{
		twEngine.Shutdown();
		return 0;
	}

	twResourceManager->LoadAllFilesInFolder("data");
	pSound = twAudio->PlaySoundSource(twResourceManager->GetSound("song"), false, true);

	twTime->ResetDeltaTime();

	SetupSceneOrder();

    // main loop, update game & engine
    bool run = true;
    while (run == true)
	{
		bool isPaused = twInput->m_Keyboard.IsState(triebWerk::EKey::P, triebWerk::EButtonState::Pressed);
		std::cout << std::to_string(isPaused) << std::endl;
		twEngine.Pause(isPaused);

		run = twEngine.Run();

		if (twInput->m_Keyboard.IsState(triebWerk::EKey::Escape, triebWerk::EButtonState::Down))
		{
			twEngine.Stop();
		}

		if (twInput->m_Keyboard.IsState(triebWerk::EKey::Space, triebWerk::EButtonState::Down))
		{
			twTimeline->Reset();
			twSceneManager->Shutdown();
			SetupSceneOrder();
			twAudio->RemoveSoundStream(pSound);
			pSound = twAudio->PlaySoundSource(twResourceManager->GetSound("song"), false, true);
		}
    }

    twEngine.Shutdown();

    _CrtDumpMemoryLeaks();
    return 0;
}


void SetupSceneOrder()
{
	twSceneManager->AddScene(new CIntroScene(), "Intro");
	twSceneManager->AddScene(new CSecondScene(), "Second");

	triebWerk::CTimeline::SSceneOrder* so1 = new triebWerk::CTimeline::SSceneOrder();
	so1->m_SceneName = "Intro";
	so1->m_SceneTimer.SetTimer(32.7f);

	triebWerk::CTimeline::SSceneOrder* so2 = new triebWerk::CTimeline::SSceneOrder();
	so2->m_SceneName = "Second";
	so2->m_SceneTimer.SetTimer(100000.0f);

	//std::function<void(triebWerk::CKeyframe::SKeyFrameEvent&)> f = std::bind(&CIntroScene::DoSomething, intro, std::placeholders::_1);
	//std::function<void(triebWerk::CKeyframe::SKeyFrameEvent&)> xc = std::bind(&CIntroScene::DoSomething2, intro, std::placeholders::_1);

	//twTimeline->AddKeyframe(new triebWerk::CKeyframe(f, 5.0f));
	//twTimeline->AddKeyframe(new triebWerk::CKeyframe(xc, 5.0f));
	twTimeline->AddSceneOrder(so1);
	twTimeline->AddSceneOrder(so2);
	//twTimeline->AddSceneOrder(so3);
	//twTimeline->AddSceneOrder(so4);
}


void LoadConfig(triebWerk::SEngineConfiguration& a_rConfig)
{
    a_rConfig.m_PhysicTimeStamp = 0.01f;
    a_rConfig.m_TargetFPS = 0;

	//Window
	a_rConfig.m_WindowConfig.m_IconID = 1337;
	a_rConfig.m_WindowConfig.m_WindowName = "AZ-Tec Racer";
	a_rConfig.m_WindowConfig.m_WindowStyle = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX;

    triebWerk::CTWFParser parser;
    triebWerk::CTWFData data;

    CHAR my_documents[MAX_PATH];
    HRESULT result = SHGetFolderPath(NULL, CSIDL_PERSONAL, NULL, SHGFP_TYPE_CURRENT, my_documents);
    std::string path = my_documents;
    path += "\\My Games\\AZ-Tec Racer\\config.twf";

    parser.ParseData(path.c_str(), &data);

    if (data.m_ConfigurationTable.size() == 0)
    {
        a_rConfig.m_Width = 1600;
        a_rConfig.m_Height = 900;
        a_rConfig.m_Fullscreen = false;
        a_rConfig.m_VSync = false;
        a_rConfig.m_MasterVolume = 1.0f;
        a_rConfig.m_BGMVolume = 0.6f;
        a_rConfig.m_SFXVolume = 1.0f;
    }
    else
    {
        a_rConfig.m_Width = std::stoi(data.GetValue("width"));
        a_rConfig.m_Height = std::stoi(data.GetValue("height"));
        a_rConfig.m_Fullscreen = std::stoi(data.GetValue("fullscreen"));
        a_rConfig.m_VSync = static_cast<bool>(std::stoi(data.GetValue("vsync")));
        a_rConfig.m_MasterVolume = std::stof(data.GetValue("mastervolume"));
        a_rConfig.m_BGMVolume = std::stof(data.GetValue("bgmvolume"));
        a_rConfig.m_SFXVolume = std::stof(data.GetValue("sfxvolume"));
    }
}
