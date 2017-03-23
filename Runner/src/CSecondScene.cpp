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

	float re = twTime->GetTimeSinceStartup();

	DirectX::XMVECTOR t =  m_pEntity->m_Transform.GetScale();

	m_pEntity->m_Transform.RotateDegrees(0.0f, 0.0f, 100 * twTime->GetDeltaTime());

	m_pEntity2->m_Transform.RotateDegrees(0.0f, 0.0f, 100 * twTime->GetDeltaTime());

	t.m128_f32[0] = std::sin(re) * 0.5f + 0.6f;

	m_pEntity->m_Transform.SetScale(t);
	m_pEntity2->m_Transform.SetScale(t);

	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(4, &re);
	m_pRipple->m_ConstantBuffer.SetValueInBuffer(4, &re);


}

void CSecondScene::End()
{
}

void CSecondScene::CreatePlayground()
{
	auto* r = twActiveWorld->CreateEntity();

	m_pPostEffect = twRenderer->CreatePostEffecthDrawable();

	m_pChromaticAberration = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Grain"));

	m_pRipple = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Ripple"));

	float a = 1000.0f;
	m_pRipple->m_ConstantBuffer.SetValueInBuffer(5, &a);

	float t = 20;
	m_pChromaticAberration->m_ConstantBuffer.SetValueInBuffer(5, &t);

	r->SetDrawable(m_pPostEffect);

	twActiveWorld->AddEntity(r);

	m_pEntity = twActiveWorld->CreateEntity();
	m_pEntity->m_Transform.SetPosition(0, 0, 0);
	m_pEntity->m_Transform.SetRotationDegrees(0, 0, 0);
	m_pEntity->m_Transform.SetScale(1, 10, 1);

	auto fogMesh = twRenderer->CreateMeshDrawable();
	fogMesh->m_pMesh = twEngine.m_pResourceManager->GetMesh("ms_cube");
	fogMesh->m_RenderMode = triebWerk::CMeshDrawable::ERenderMode::Opaque;
	fogMesh->m_Material.SetMaterial(twEngine.m_pResourceManager->GetMaterial("StandardColor"));
	fogMesh->m_Material.m_ConstantBuffer.SetValueInBuffer(4, &DirectX::XMFLOAT3(1, 0, 1));
	m_pEntity->SetDrawable(fogMesh);

	m_pEntity2 = twActiveWorld->CreateEntity();
	m_pEntity2->m_Transform.SetPosition(0, 0, 0);
	m_pEntity2->m_Transform.SetRotationDegrees(0, 0, 90);
	m_pEntity2->m_Transform.SetScale(10, 10, 1);

	auto fogMesh2 = twRenderer->CreateMeshDrawable();
	fogMesh2->m_pMesh = twEngine.m_pResourceManager->GetMesh("ms_cube");
	fogMesh2->m_RenderMode = triebWerk::CMeshDrawable::ERenderMode::Opaque;
	fogMesh2->m_Material.SetMaterial(twEngine.m_pResourceManager->GetMaterial("StandardColor"));
	fogMesh2->m_Material.m_ConstantBuffer.SetValueInBuffer(4, &DirectX::XMFLOAT3(0, 0, 0));
	m_pEntity2->SetDrawable(fogMesh2);

	twActiveWorld->AddEntity(m_pEntity);
	twActiveWorld->AddEntity(m_pEntity2);
}
