//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float Timer;
	float CurvatureValue;
	float BlendValue;
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
Texture2D TextureRed;
Texture2D NoiseTrail;
Texture2D TextureBlue;

SamplerState Sampler;

SamplerState SuperSampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = BORDER;
	AddressV = BORDER;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float ripplePower = 1;
	
	float noisePower = NoiseTrail.Sample(Sampler, input.uv - Timer).r;

	//float2 uv = float2(input.uv.x - CurvatureValue * pow(1 - input.uv.y, 2.0f), (input.uv.y * noisePower * 4) - 0.5f);
	
	float2 uv = float2(input.uv.x + CurvatureValue * 0.2f * pow(input.uv.y * 1.8f, 2.0f), 1 - input.uv.y * noisePower * 2.5f);
	float4 textureColorRed = TextureRed.Sample(SuperSampler, uv);
	float4 textureColorBlue = TextureBlue.Sample(SuperSampler, uv);

	textureColorRed = saturate(textureColorRed + float4(1.0f,1.0f, 1.0f,0) * sin(input.uv.y + Timer * 8) * 0.2f);
	
	float4 finalColor = saturate((textureColorRed * (1 - BlendValue)) + (textureColorBlue * BlendValue));

	clip(textureColorRed.a - 0.9f);

	return finalColor;
}