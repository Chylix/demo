//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float4 Color;
	float circlePower1;
	float circlePower2;
	float circlePower3;
	float circlePower4;
	float circlePower5;
	float MultiPower1;
	float MultiPower2;
	float MultiPower3;
	float MultiPower4;
	float MultiPower5;
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
Texture2D Texture2;
Texture2D Texture3;
Texture2D Texture4;
Texture2D Texture5;
Texture2D MultiTexture;
Texture2D MultiTexture2;
Texture2D MultiTexture3;
Texture2D MultiTexture4;
Texture2D MultiTexture5;

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float colorFan = Texture.Sample(Sampler, input.uv).r * 0.6f;

	float colorCircle2 = Texture2.Sample(Sampler, input.uv).r * circlePower2;
										 
	float colorCircle3 = Texture3.Sample(Sampler, input.uv).r * circlePower3;
										 
	float colorCircle4 = Texture4.Sample(Sampler, input.uv).r * circlePower4;
										 
	float colorCircle5 = Texture5.Sample(Sampler, input.uv).r * circlePower5;

	float multiCircle1 = MultiTexture.Sample(Sampler, input.uv).r * MultiPower1;
	float multiCircle2 = MultiTexture2.Sample(Sampler, input.uv).r * MultiPower2;
	float multiCircle3 = MultiTexture3.Sample(Sampler, input.uv).r * MultiPower3;
	float multiCircle4 = MultiTexture4.Sample(Sampler, input.uv).r * MultiPower4;
	float multiCircle5 = MultiTexture5.Sample(Sampler, input.uv).r * MultiPower5;

	return float4(Color.rgb, (colorFan + colorCircle2 + colorCircle3 + colorCircle4 + colorCircle5 + multiCircle1 + multiCircle2 + multiCircle3 + multiCircle4 + multiCircle5)* Color.a);

	//if (colorFan.r > 0.0f)
	//	return float4(Color, colorFan.r);
	//else
	//	return float4(DifColor, colorCircle2.r + colorCircle3.r + colorCircle4.r + colorCircle5.r);
}