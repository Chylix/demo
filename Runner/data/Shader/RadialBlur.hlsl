//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
    float Strength;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
};

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;
	
	output.position = mul(float4(input.position, 1), world);
	output.position = mul(output.position, view);
	output.position = mul(output.position, projection);

	output.uv = input.uv;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;
Texture2D LookUpTexture;

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float4 alpha = DiffuseTexture.Sample(Sampler, input.uv);
	if (alpha.r == 1.0f && alpha.g == 0.4f && alpha.b == 0.7f)
		return float4(0, 0, 0, 0);

	float2 center = float2(0.5f, 0.5f);
	float blurStart = 1.0f;
	
	float no = LookUpTexture.Sample(Sampler, input.uv);
	
	float blurWidth = -0.01f * Strength * no;

	int samples = 128;

	input.uv -= center;
	float4 c = 0;
	for (int i = 0; i <samples; i++) {
		float scale = blurStart + blurWidth*(i / (float)(samples - 1));
		c += DiffuseTexture.Sample(Sampler, input.uv * scale + center);
	}
	c /= samples;
	return c;
}