//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
};

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;
	
	output.position = mul(float4(input.position, 1), world);
	output.position = mul(output.position, view);
	output.position = mul(output.position, projection);

	output.uv = input.uv;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D BlurTexture;
Texture2D SceneTexture;

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float4 alpha = BlurTexture.Sample(Sampler, input.uv);
	if (alpha.r == 1.0f && alpha.g == 0.4f && alpha.b == 0.7f)
		return float4(0, 0, 0, 0);

	float SceneMapMultiplier = 0.9f;
	float BlurMapMultiplier = 0.65f;


	float3 blur = BlurTexture.Sample(Sampler, input.uv).rgb * BlurMapMultiplier;
	float3 scene = SceneTexture.Sample(Sampler, input.uv).rgb * SceneMapMultiplier;

	return float4(saturate(scene + blur), 1.0f);

	//return float4(blur, 1.0f);
}