//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float4 Color;
	float Time;
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
Texture2D CutOutTexture;

SamplerState Sampler;

SamplerState BorderSampler
{
	Filter = D3D11_FILTER_MIN_MAG_MIP_POINT;
	AddressU = BORDER;
	AddressV = BORDER;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float rotationSpeed = 0.05f;

	float2 uv = input.uv - 0.5;
	
	float s = -sin(rotationSpeed * Time);
	float c = cos(rotationSpeed * Time);
	
	float2x2 rotationMatrix = float2x2(c, -s, s, c);
	
	rotationMatrix *= 0.5;
	
	rotationMatrix += 0.5;
	
	rotationMatrix = rotationMatrix * 2 - 1;
	
	uv = mul(uv, rotationMatrix);
	
	uv = uv + 0.5f;

	float colorFan = Texture.Sample(BorderSampler, uv).r;
	float cutout = CutOutTexture.Sample(Sampler, input.uv).r;

	if (cutout > 0)
		return float4(0, 0, 0, 0);
	else
		return float4(Color.rgb, colorFan * Color.a);
}