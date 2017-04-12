#pragma once
#include <CEngine.h>

class CSecondScene : public triebWerk::IScene
{
public:
	CSecondScene();
	~CSecondScene();

	void Start() final;
	void Update() final;
	void End() final;

private:
	void CreatePlayground();
	void Timeline();
	float Slider(float a_StartTime, float a_EndTime, float a_CurrentTime, float a_StartValue, float a_EndValue);
	float lerp(float a_Start, float a_End, float a_Current);

public:
	triebWerk::CEntity* m_pEntity;
	triebWerk::CPostEffectDrawable* m_pPostEffect;

	triebWerk::CMaterial* m_pChromaticAberration;
	triebWerk::CMaterial* m_pScene;

	uint32_t m_nGons = 3;
	float m_chromatic = 0.0;
	float m_stepsize = 0.1;
	float m_timer = 0.0f;
	float m_posSpeed = 0.0;
};
