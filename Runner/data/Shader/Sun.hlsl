//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float Timer;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
	row_major matrix Transformation : INST;
    float3 PointColor : INSTC;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
	float3 color : COLOR;
};

SamplerState Sampler;
 
Texture2D HeightMap;

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;

	float power = 0;

	power = HeightMap.SampleLevel(Sampler, input.uv + Timer / 200, 0, 0).r;

	input.position = input.position + power * input.normal;

	if (isInstance == 1)
	{
		output.position = mul(float4(input.position, 1), input.Transformation);
		output.position = mul(output.position, view);
		output.position = mul(output.position, projection);
		output.normal = mul(input.normal, (float3x3)input.Transformation);
	}
	else if (isInstance == 0)
	{
		output.position = mul(float4(input.position, 1), world);
		output.position = mul(output.position, view);
		output.position = mul(output.position, projection);
		output.normal = mul(input.normal, (float3x3)world);
	}

	output.color = input.PointColor;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;

float4 PS_Main(PS_Data input) : SV_TARGET
{
    //float3 lightDir = float3(0.0, 0.7, -0.6);

    //float3 Ln = normalize(lightDir);
    //float3 Nn = normalize(input.normal);

    //float4 rgba = float4(saturate(color + dot(Nn, Ln) / 3), 1.0f);
    return float4(input.color, 1.0f);
}