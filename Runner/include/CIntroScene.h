#pragma once
#include <CEngine.h>
#include <algorithm>
class CIntroScene : public triebWerk::IScene
{
public:
    CIntroScene();
    ~CIntroScene();

    void Start() final;
    void Update() final;
    void End() final;

	void DoSomething(triebWerk::CKeyframe::SKeyFrameEvent& a_rEvent);
	void DoSomething2(triebWerk::CKeyframe::SKeyFrameEvent& a_rEvent);

private:
	void CreatePlayground();
	void Timeline();
	float Slider(float a_StartTime, float a_EndTime, float a_CurrentTime, float a_StartValue, float a_EndValue);

public:
	triebWerk::CEntity* m_pEntity;
	triebWerk::CPostEffectDrawable* m_pPostEffect;
	triebWerk::CMaterial* m_pMetaBalls;
	triebWerk::CMaterial* m_pChromaticAberration;

private:
	float m_objScales[4] = {0};
	float m_fancyRot = 0;
	float m_wave = 0;
	float m_chromatic = 0.0;
};
