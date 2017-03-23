//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float4 Color;
	float SpeedX;
	float SpeedY;
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
Texture2D Texture;
Texture2D TextureCutOut;
SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float2 scrollUV = input.uv;
	scrollUV.x = input.uv.x + SpeedX;
	scrollUV.y = input.uv.y + SpeedY;
	float4 colorFan = Texture.Sample(Sampler, scrollUV);
	float cutOutStrength = TextureCutOut.Sample(Sampler, input.uv).r;
	return float4(Color.rgb, colorFan.r * cutOutStrength * Color.a);
	//return float4(Color.rgb, cutOutStrength);
}