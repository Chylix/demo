#pragma once
#include <CEngine.h>

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

public:
	triebWerk::CEntity* m_pEntity;
	triebWerk::CPostEffectDrawable* m_pPostEffect;
	triebWerk::CMaterial* m_pMetaBalls;
	triebWerk::CMaterial* m_pChromaticAberration;

private:
	float m_objScales[4] = {0};
	float m_fancyRot = 0;
	float m_uberScale = 0;
	float m_chromatic = 0.0;
};
