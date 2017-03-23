#include <CIntroScene.h>

CIntroScene::CIntroScene()
{
}

CIntroScene::~CIntroScene()
{
	int a = 0;
}

void CIntroScene::Start()
{
	CreatePlayground();
	twTime->ResetTimeStart();
}

void CIntroScene::Update()
{
	twTime->GetDeltaTime();

	ChangeRot();
	ScaleObjects();

	float timer = twTime->GetTimeSinceStartup();


	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(4, &timer);

	//Res
	DirectX::XMFLOAT2 res;
	res.x = twWindow->GetScreenWidth();
	res.y = twWindow->GetScreenHeight();
	
	triebWerk::CDebugLogfile::Instance().LogfText("%f, %f </br>", res.x, res.y);

	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(5, &res);
}

void CIntroScene::End()
{
}

void CIntroScene::DoSomething(triebWerk::CKeyframe::SKeyFrameEvent & a_rEvent)
{
	//BLUR = true;
}

void CIntroScene::DoSomething2(triebWerk::CKeyframe::SKeyFrameEvent & a_rEvent)
{
	//BLUR = false;
	//m_BlurA = 0.0f;
	//m_pBlur->m_ConstantBuffer.SetValueInBuffer(4, &m_BlurA);
	//end = true;
}

void CIntroScene::ScaleObjects()
{
	float timer = twTime->GetTimeSinceStartup();
	
	//ob1
	if (timer >= 0.90f)
	{
		if (timer < 1.224f)
		{
			m_scaleObj1 += 0.26f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_scaleObj1);
		}

	}

	//ob2
	if (timer >= 3.20f)
	{
		if (timer < 3.6f)
		{
			m_scaleObj2 += 0.26f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(7, &m_scaleObj2);
		}

	}

	//ob2
	if (timer >= 5.00f)
	{
		if (timer < 5.4f)
		{
			m_scaleObj3 += 0.26f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_scaleObj3);
		}

	}

	if (timer >= 22.3f)
	{
		float superScale = (2.0f * m_uberScale -1.0f ) * (2.0f * m_uberScale - 1.0f);
		m_scaleObj1 *= superScale;
		m_scaleObj2 *= superScale;
		m_scaleObj3 *= superScale;

		m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_scaleObj1);
		m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(7, &m_scaleObj2);
		m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_scaleObj3);
		m_uberScale += 0.3 * twTime->GetDeltaTime();
		triebWerk::CDebugLogfile::Instance().LogfText("Super mega ultra Scale : %f \n", superScale);
	}

	//m_scaleObj1 += 

}

void CIntroScene::ChangeRot()
{
	float timer = twTime->GetTimeSinceStartup();

	if (timer >= 13.00f)
	{
		if (m_fancyRot > 0.0f)
		{
			m_fancyRot -= 0.35f * twTime->GetDeltaTime();
			triebWerk::CDebugLogfile::Instance().LogfText("%f \n", m_fancyRot);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(9, &m_fancyRot);
		}
	}
}


void CIntroScene::CreatePlayground()
{
	auto* r = twActiveWorld->CreateEntity();

	m_pPostEffect = twRenderer->CreatePostEffecthDrawable();

	m_pMetaBalls = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Dem0"));
	m_pChromaticAberration = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("ChromaticAberration"));

	float chromatic = 0.5;
	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(5, &chromatic);

	float scale1 = -0.1f;
	float scale2 = -0.1f;
	float scale3 = -0.1f;
	float fancyRot = 1.0f;

	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &scale1);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(7, &scale2);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &scale3);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(9, &fancyRot);
	r->SetDrawable(m_pPostEffect);

	twActiveWorld->AddEntity(r);

	m_pEntity = twActiveWorld->CreateEntity();
	m_pEntity->m_Transform.SetPosition(0, 0, 0);
	m_pEntity->m_Transform.SetRotationDegrees(0, 0, 0);
	m_pEntity->m_Transform.SetScale(100, 100, 1);

	auto fogMesh = twRenderer->CreateMeshDrawable();
	fogMesh->m_pMesh = twEngine.m_pResourceManager->GetMesh("ms_cube");
	fogMesh->m_RenderMode = triebWerk::CMeshDrawable::ERenderMode::Opaque;
	fogMesh->m_Material.SetMaterial(twEngine.m_pResourceManager->GetMaterial("StandardColor"));
	fogMesh->m_Material.m_ConstantBuffer.SetValueInBuffer(4, &DirectX::XMFLOAT3(1, 1, 1));
	m_pEntity->SetDrawable(fogMesh);

	float value = 10.0f;
	fogMesh->m_Material.m_ConstantBuffer.SetValueInBuffer(4, &value);

	twActiveWorld->AddEntity(m_pEntity);
}

