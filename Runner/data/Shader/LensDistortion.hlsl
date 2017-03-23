//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float DistortionPower;
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

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float4 alpha = DiffuseTexture.Sample(Sampler, input.uv);
	if (alpha.r == 1.0f && alpha.g == 0.4f && alpha.b == 0.7f)
		return float4(0, 0, 0, 0);

	float k = DistortionPower * -1.0f;
	float kcube = 0.0f;

	float r2 = (input.uv.x - 0.5f) * (input.uv.x - 0.5f) + (input.uv.y - 0.5f) * (input.uv.y - 0.5f);
	float f = 0.0f;

	if (kcube == 0.0) {
		f = 1 + r2 * k;
	}
	else {
		f = 1 + r2 * (k + kcube * sqrt(r2));
	};

	float x = f*(input.uv.x - 0.5) + 0.5;
	float y = f*(input.uv.y - 0.5) + 0.5;

	float4 texColor = DiffuseTexture.Sample(Sampler, float2(x, y));

	return texColor;

}