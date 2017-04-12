#include <CSecondScene.h>

CSecondScene::CSecondScene()
{
}

CSecondScene::~CSecondScene()
{
}

void CSecondScene::Start()
{
	CreatePlayground();
}

void CSecondScene::Update()
{

	m_timer += twTime->GetDeltaTime();

	Timeline();

	float timer = twTime->GetTimeSinceStartup();


	m_pScene->m_ConstantBuffer.SetValueInBuffer(4, &m_timer);

	//Res
	DirectX::XMFLOAT2 res;
	res.x = twWindow->GetScreenWidth();
	res.y = twWindow->GetScreenHeight();

	triebWerk::CDebugLogfile::Instance().LogfText("%f, %f </br>", res.x, res.y);

	m_pScene->m_ConstantBuffer.SetValueInBuffer(5, &res);
}

void CSecondScene::End()
{
}

void CSecondScene::CreatePlayground()
{
	auto* r = twActiveWorld->CreateEntity();

	m_pPostEffect = twRenderer->CreatePostEffecthDrawable();

	m_pScene = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Scene1"));
	m_pChromaticAberration = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("ChromaticAberration"));
	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(5, &m_chromatic);
	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(7, &m_stepsize);


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

	m_nGons = 6;
	m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
	m_stepsize = 2.5;
	m_pScene->m_ConstantBuffer.SetValueInBuffer(7, &m_stepsize);
	m_posSpeed = 0;
	m_pScene->m_ConstantBuffer.SetValueInBuffer(8, &m_posSpeed);
}

void CSecondScene::Timeline()
{
	float timer = twTime->GetTimeSinceStartup();

	m_posSpeed = Slider(1.0, 4.0, m_timer, 0.0, 1);

	m_pScene->m_ConstantBuffer.SetValueInBuffer(8, &m_posSpeed);
	
	if (timer >= 33.60f)
	{
		if (timer < 33.90f)
		{
			m_nGons = 6;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 35.60f)
	{
		if (timer < 35.90f)
		{
			m_nGons = 7;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 37.60f)
	{
		if (timer < 37.90f)
		{
			m_nGons = 4;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 39.60f)
	{
		if (timer < 39.90f)
		{
			m_nGons = 8;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 41.60f)
	{
		if (timer < 41.90f)
		{
			m_nGons = 4;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 43.60f)
	{
		if (timer < 43.90f)
		{
			m_nGons = 6;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 45.60f)
	{
		if (timer < 45.90f)
		{
			m_nGons = 9;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 47.60f)
	{
		if (timer < 47.90f)
		{
			m_nGons = 4;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}

	if (timer >= 49.60f)
	{
		if (timer < 49.90f)
		{
			m_nGons = 3;
			m_pScene->m_ConstantBuffer.SetValueInBuffer(6, &m_nGons);
		}
	}
}

float CSecondScene::lerp(float a_Start, float a_End, float a_Current)
{
	return (a_Start + a_Current*(a_End - a_Start));
}

float CSecondScene::Slider(float a_StartTime, float a_EndTime, float a_CurrentTime, float a_StartValue, float a_EndValue)
{


	float pt = a_CurrentTime - a_StartTime;
	pt = pt < 0 ? 0. : pt;
	float c = a_EndTime - a_StartTime;
	float w = pt / c;
	w = w > 1 ? 1 : w < 0 ? 0 : w;
	//std::cout << w << std::endl;
	return lerp(a_StartValue, a_EndValue, w);
}