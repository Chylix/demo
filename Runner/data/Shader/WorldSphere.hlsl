//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
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

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;

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
	output.uv = input.uv;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;
Texture2D LookUp;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{


	float4 diffuse = DiffuseTexture.Sample(Sampler, input.uv).rgba;
	float a = LookUp.Sample(Sampler, input.uv).r;

    //float3 rgb = saturate(diffuse.rgb + (dot(Nn, Ln)/3));
	//return float4(rgb, diffuse.a);
	return float4(diffuse.rgb, diffuse.a * a);
}