//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float ScreenSize;
	float BlurFactor;
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

#define TW_0 0.20f
#define TW_1 0.15f
#define TW_2 0.12f
#define TW_3 0.07f
#define TW_4 0.05f

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;

SamplerState Sampler;

SamplerState SamplerT
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Border;
	AddressV = Border;
};


float4 PS_Main(PS_Data input) : SV_TARGET
{
	float r = DiffuseTexture.Sample(Sampler, input.uv);

	if (r > 50)
		return float4(0, 0, 0, 0);

	return (
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, -3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, -3.0f / 1000.0f)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, -2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, -2.0f / 1000.0f)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, -1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, -1.0f / 1000.0f)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, 0)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, 0)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, 1.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, 1.0f / 1000.0f)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, 2.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, 2.0f / 1000.0f)) +

			DiffuseTexture.Sample(SamplerT, input.uv + float2(-3.0f / 1600.0f, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-2.0f / 1600.0f, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(-1.0f / 1600.0f, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(0, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(1.0f / 1600.0f, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(2.0f / 1600.0f, 3.0f / 1000.0f)) +
			DiffuseTexture.Sample(SamplerT, input.uv + float2(3.0f / 1600.0f, 3.0f / 1000.0f))
			) / 49;
}