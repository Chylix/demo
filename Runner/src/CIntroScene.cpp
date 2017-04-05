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

	Timeline();

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

float lerp(float a_Start, float a_End, float a_Current)
{
	return (a_Start + a_Current*(a_End - a_Start));
}

float CIntroScene::Slider(float a_StartTime, float a_EndTime, float a_CurrentTime, float a_StartValue, float a_EndValue)
{
	

	float pt =  a_CurrentTime - a_StartTime;
	pt = pt < 0 ? 0. : pt;
	float c = a_EndTime - a_StartTime;
	float w = pt / c;

	return lerp(a_StartValue, a_EndValue, w);
}

void CIntroScene::Timeline()
{
	float timer = twTime->GetTimeSinceStartup();
	
	//ob1
	if (timer >= 0.90f)
	{
		if (timer < 1.224f)
		{
			m_objScales[0] += 0.56f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
		}

	}

	//ob2
	if (timer >= 3.20f)
	{
		if (timer < 3.6f)
		{
			m_objScales[1] += 0.36f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
		}

	}

	//ob2
	if (timer >= 4.778f)
	{
		if (timer < 5.1f)
		{
			m_objScales[2] += 0.53f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
		}

	}
	//ob2
	if (timer >= 5.00f)
	{
		if (timer < 5.4f)
		{
			m_objScales[3] += 0.26f * twTime->GetDeltaTime();
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
		}

	}

	if (timer >= 7.45f)
	{
		if (timer < 8.0f)
		{
			m_chromatic += 0.75 * twTime->GetDeltaTime();
			m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(5, &m_chromatic);
		}

	}

	if (timer >= 9.0f)
	{
		if (timer < 32.20f)
		{
			m_fancyRot = Slider(9.0,15.20,timer,0.0,0.1337);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(7, &m_fancyRot);
		}

	}

	if (timer >= 25.50f)
	{
		if (timer < 26.5f)
		{
			m_wave = Slider(25.50f, 26.50f, timer, 0.0, 3.14159265f);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_wave);
		}

	}

	if (timer >= 27.50f)
	{
		if (timer < 28.5f)
		{
			m_wave = Slider(27.50f, 28.50f, timer, 0.0, 3.14159265f);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_wave);
		}

	}

	if (timer >= 29.50f)
	{
		if (timer < 30.5f)
		{
			m_wave = Slider(29.50f, 30.50f, timer, 0.0, 3.14159265f);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_wave);
		}

	}


	if (timer >= 32.00f)
	{
		if (timer < 32.2f)
		{

			m_objScales[0] = Slider(32.00f, 32.20f, timer, m_objScales[0], 0.20f);
			m_objScales[1] = Slider(32.00f, 32.20f, timer, m_objScales[1], 0.20f);
			m_objScales[2] = Slider(32.00f, 32.20f, timer, m_objScales[2], 0.20f);
			m_objScales[3] = Slider(32.00f, 32.20f, timer, m_objScales[3], 0.20f);

			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
		}

	}

	if (timer >= 32.20f)
	{ 
		if (timer < 32.72f)
		{

			m_wave = Slider(32.20f, 32.72f, timer, -0.5, 1.5);
			m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_wave);
		}

	}

	/*if (timer >= 22.3f)
	{
		float superScale = (2.0f * m_uberScale -1.0f ) * (2.0f * m_uberScale - 1.0f);
		m_objScales[0] *= superScale;
		m_objScales[1] *= superScale;
		m_objScales[2] *= superScale;

		m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);

		m_uberScale += 0.3 * twTime->GetDeltaTime();
		triebWerk::CDebugLogfile::Instance().LogfText("Super mega ultra Scale : %f \n", superScale);
	}*/

	//m_scaleObj1 += 

}


void CIntroScene::CreatePlayground()
{
	auto* r = twActiveWorld->CreateEntity();

	m_pPostEffect = twRenderer->CreatePostEffecthDrawable();

	m_pMetaBalls = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Dem0"));
	m_pChromaticAberration = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("ChromaticAberration"));

	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(5, &m_chromatic);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(6, &m_objScales);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(7, &m_fancyRot);
	m_pMetaBalls->m_ConstantBuffer.SetValueInBuffer(8, &m_wave);

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

