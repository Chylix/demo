//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
    float Diffuse1Power;
    float Diffuse2Power;
    float Diffuse3Power;
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
	float Diffuse1Power : INSTDIF;
	float Diffuse2Power : INSTDI;
	float Diffuse3Power : INSTD;
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
	output.Diffuse1Power = Diffuse1Power;
	output.Diffuse2Power = Diffuse2Power;
	output.Diffuse3Power = Diffuse3Power;
	
	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture1;
Texture2D DiffuseTexture2;
Texture2D DiffuseTexture3;

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float3 diffuse1 = DiffuseTexture1.Sample(Sampler, input.uv).rgb * input.Diffuse1Power;
	//clip(diffuse1.a - 1);

	float3 diffuse2 = DiffuseTexture2.Sample(Sampler, input.uv).rgb * input.Diffuse2Power;
	//clip(diffuse2.a - 1);

	float3 diffuse3 = DiffuseTexture3.Sample(Sampler, input.uv).rgb * input.Diffuse3Power;
	//clip(diffuse3.a - 1);

	float4 finalColor = float4(saturate(diffuse1 + diffuse2 + diffuse3), 1);

	return finalColor;
}