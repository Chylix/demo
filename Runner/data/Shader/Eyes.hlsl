//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float Timer;
	float4 PointColor;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
	row_major matrix Transformation : INST;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
};

SamplerState Sampler;
 
Texture2D HeightMap;

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;

	float power = 0;

	power = HeightMap.SampleLevel(Sampler, input.uv + Timer / 200, 0, 0).r * 2;

	input.position = input.position + power * input.normal;

	output.position = mul(float4(input.position, 1), world);
	output.position = mul(output.position, view);
	output.position = mul(output.position, projection);
	output.normal = mul(input.normal, (float3x3)world);


	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;

float4 PS_Main(PS_Data input) : SV_TARGET
{
    return PointColor;
}