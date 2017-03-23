//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
    float Timer;
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
Texture2D DiffuseTexture;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState SamplerT
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Border;
	AddressV = Border;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float ripplePower = 3;

	float rr = DiffuseTexture.Sample(Sampler,input.uv).x;

	if (rr > 90)
		return float4(0, 0, 0, 0);

	float2 uv = float2(input.uv.x + sin(input.uv.y*ripplePower + Timer) / 60, input.uv.y);

	float4 refColor = DiffuseTexture.Sample(SamplerT, uv);

	refColor.r = 0.0f;
	refColor.g = 1.0f * sin(Timer * 3) * 0.5f + 0.9f;
	refColor.b = 1.0f * sin(Timer * 3) * 0.5f + 0.9f;

	return refColor;
}