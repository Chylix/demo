//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float3 color;
	float LineSize;
	float SquareCount;
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

float edgeFactor(float3 t) {
	float3 d = fwidth(t);
	float3 a3 = smoothstep(float3(0.0f, 0.0f, 0.0f), d*2.0f, t);
	return min(min(a3.x, a3.y), a3.z);
}

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
	else if(isInstance == 0)
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
Texture2D NoiseTexture;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float x = frac(input.uv.x*SquareCount);
	float y = frac(input.uv.y*SquareCount);
	
	if (x > LineSize || y > LineSize) {
		return float4(color.r, color.g, color.b, 1);
	}
	else
	{
		if (x < (LineSize - 1.0f) * -1.0f || y < (LineSize - 1.0f) * -1.0f)
		{
			return float4(color.r, color.g, color.b,1);
		}
	
		return float4(0,0,0,1);
	}
}