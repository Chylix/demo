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

public:
	triebWerk::CEntity* m_pEntity;
	triebWerk::CEntity* m_pEntity2;
	triebWerk::CPostEffectDrawable* m_pPostEffect;
	triebWerk::CMaterial* m_pChromaticAberration;
	triebWerk::CMaterial* m_pRipple;
};
