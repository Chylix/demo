//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float a;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
};

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;

	output.position = mul(float4(input.position, 1), world);
	output.position = mul(output.position, view);
	output.position = mul(output.position, projection);
    output.normal = mul(input.normal, (float3x3)world);
	output.uv = input.uv;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;
Texture2D NoiseTexture;
float A;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float3 lightDir = float3(-0.1,-0.7,-0.6);

	float3 Ln = normalize(lightDir);
	float3 Nn = normalize(input.normal);

	float3 diffuse = float3(0, 0, 0);
	diffuse = saturate(DiffuseTexture.Sample(Sampler, input.uv).rgb + NoiseTexture.Sample(Sampler, input.uv).rgb);
	//diffuse = DiffuseTexture.Sample(Sampler, input.uv).rgb;

	float4 color = float4(saturate(diffuse + dot(Nn, Ln)), 1);
	return color;
}