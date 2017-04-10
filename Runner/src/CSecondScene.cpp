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

	twTime->GetDeltaTime();

	//Timeline();

	float timer = twTime->GetTimeSinceStartup();


	m_pScene->m_ConstantBuffer.SetValueInBuffer(4, &timer);

}

void CSecondScene::End()
{
}

void CSecondScene::CreatePlayground()
{
	auto* r = twActiveWorld->CreateEntity();

	m_pPostEffect = twRenderer->CreatePostEffecthDrawable();

	m_pScene = m_pPostEffect->AddMaterial(twResourceManager->GetMaterial("Scene1"));

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
