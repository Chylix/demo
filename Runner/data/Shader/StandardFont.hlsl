//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float3 color;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
	float uBegin : INSTUB;
	float uEnd : INSTUE;
	float vBegin : INSTVB;
	float vEnd : INSTVE;
	float pixelWidth : INSTPW;
	float pixelHeight : INSTPH;
	float offsetX : INSTOX;
	float offsetY : INSTOY;
};

struct PS_Data
{
	float4 position : SV_POSITION;
	float2 uv : UV;
	float3 color : COLOR;
};

PS_Data VS_Main(VS_Data input)
{
	PS_Data output;

	input.position.x = input.position.x * input.pixelWidth;
	input.position.y = input.position.y * input.pixelHeight;

	 
	output.position = mul(float4(input.position,1), world);
	output.position.x = output.position.x + input.offsetX;
	output.position.y = output.position.y + input.offsetY;

	output.position = mul(output.position, view);
	output.position = mul(output.position, projection);
	output.color = float3(input.offsetX, 0, 0);

	output.uv.x = ((input.uEnd - input.uBegin) * input.uv.x) + input.uBegin;
	output.uv.y = ((input.vEnd - input.vBegin) * input.uv.y) + input.vBegin;

	return output;
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float alpha = DiffuseTexture.Sample(Sampler, input.uv).r;

	return float4(color, alpha);
}