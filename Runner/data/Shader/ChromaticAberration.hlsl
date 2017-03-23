//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float DistortionTimer;
	float DistortionStrenght;
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
Texture2D PerlinNoiseTexture;

SamplerState Sampler;
SamplerState SamplerBr
{
	Filter = MIN_MAG_MIP_Linear;
	AddressU = Border;
	AddressV = Border;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float4 alpha = DiffuseTexture.Sample(Sampler, input.uv);
	if (alpha.r == 1.0f && alpha.g == 0.4f && alpha.b == 0.7f)
		return float4(0, 0, 0, 0);

	float levels;
	float2 size;
	DiffuseTexture.GetDimensions(0, size.x, size.y, levels);
	
	float2 uv = -input.uv.xy;
	
	float distortion = 1.0 * DistortionStrenght; //PerlinNoiseTexture.Sample(SamplerBr, input.uv * cos(DistortionTimer * 0.1f)).r * DistortionStrenght;
	//float distortion = PerlinNoiseTexture.Sample(Sampler, input.uv * cos(DistortionTimer * 0.03f)).r;

	//float distortion = 1;  
	const float redAberration = 3.0 * distortion;
	const float greenAberration = 0.0 * distortion;
	const float blueAberration = -3.0 * distortion;
	
	float pctEffect = (uv.x - 0.5) * 2.0;
	
	float3 aberration = float3(redAberration / size.x, greenAberration / size.x, blueAberration / size.x);
	aberration *= pctEffect;
	
	float3 col;
	col.r = DiffuseTexture.Sample(Sampler,float2((uv.x + aberration.x ) * -1.0f,-uv.y)).x;
	col.g = DiffuseTexture.Sample(Sampler,float2((uv.x + aberration.y ) * -1.0f,-uv.y)).y;
	col.b = DiffuseTexture.Sample(Sampler,float2((uv.x + aberration.z ) * -1.0f,-uv.y)).z;

	return float4(col, 1);
}