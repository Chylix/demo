//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float ShockwaveValue;
	float ShineValue;
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
SamplerState SamplerTr
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


	//shockwave
	float4 shockwaveColor;
	float3 shockParams = float3(10.0f, 0.8f, 0.1f);
	float2 center = float2(0.5f, 0.65f);
	
	float time = ShockwaveValue;
	
	float2 uv = input.uv.xy;
	float2 texCoord = uv;
	float dist = distance(uv, center);
	if ((dist <= (time + shockParams.z)) &&
		(dist >= (time - shockParams.z)))
	{
		float diff = (dist - time);
		float powDiff = 1.0 - pow(abs(diff*shockParams.x),
			shockParams.y);
		float diffTime = diff  * powDiff;
		float2 diffUV = normalize(uv - center);
		texCoord = uv + (diffUV * diffTime);
	}

	shockwaveColor = DiffuseTexture.Sample(SamplerTr, texCoord);
	
	
	//shine
	float4 color = DiffuseTexture.Sample(SamplerTr, input.uv);
	
	float k = 1.0f * -1.0f;
	float kcube = -0.5f;
	
	float r2 = (input.uv.x - 0.5f) * (input.uv.x - 0.5f) + (input.uv.y - 0.5f) * (input.uv.y - 0.5f);
	float f = 0.0f;
	
	if (kcube == 0.0) {
		f = 1 + r2 * k;
	}
	else {
		f = 1 + r2 * (k + kcube * sqrt(r2));
	};
	
	return lerp(shockwaveColor, float4(0.0f, 1.0f, 1.0f, 1.0f), (ShineValue * f) / 4);
}