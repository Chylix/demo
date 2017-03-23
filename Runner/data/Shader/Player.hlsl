//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float Time;
};

struct VS_Data
{
	float3 position : POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
	row_major matrix Transformation : INST;
};

struct GS_Data
{
	float3 Position   : POSITION;
	float3 Normal     : NORMAL;
	float2 UV         : TEXCOORD0;
};

struct PS_Data
{
	float4 Position : SV_POSITION;
	float2 uv : UV;
	float3 normal : NORMAL;
};

GS_Data VS_Main(VS_Data input)
{
	GS_Data output;

	output.Position = input.position;
	output.Normal = input.normal;
	output.UV = input.uv;

	return output;
}

Texture2D NoiseTexture;
Texture2D NoiseTexture2;


SamplerState SamplerT
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

[maxvertexcount(3)]
void GS_Main(triangle GS_Data input[3], inout TriangleStream<PS_Data> stream)
{
	PS_Data output[3];

	matrix rotationX = (matrix)0;
	matrix rotationY = (matrix)0;
	matrix rotationZ = (matrix)0;
	matrix final = (matrix)0;

	float3 normal = (input[0].Normal + input[1].Normal + input[2].Normal) / 3;
	float3 center = (input[0].Position + input[1].Position + input[2].Position) / 3;
	float2 uv = (input[0].UV + input[1].UV + input[2].UV) / 3;

	float3 angles = NoiseTexture.SampleLevel(SamplerT, uv, 0).rgb;
	angles -= 0.5f;
	float speed = NoiseTexture2.SampleLevel(SamplerT, uv, 0).r * 5;

	normal = angles;
	//angles = float3(0, 0, 0);

	rotationX[0] = float4(1, 0, 0, 0);
	rotationX[1] = float4(0, cos(angles.x * Time), -sin(angles.x * Time), 0);
	rotationX[2] = float4(0, sin(angles.x * Time), cos(angles.x * Time), 0);
	rotationX[3] = float4(0, 0, 0, 1);

	rotationY[0] = float4(cos(angles.y * Time), 0, sin(angles.y * Time), 0);
	rotationY[1] = float4(0, 1, 0, 0);
	rotationY[2] = float4(-sin(angles.y * Time), 0, cos(angles.y * Time), 0);
	rotationY[3] = float4(0, 0, 0, 1);

	rotationZ[0] = float4(cos(angles.z * Time), -sin(angles.z * Time), 0, 0);
	rotationZ[1] = float4(sin(angles.z * Time), cos(angles.z * Time), 0, 0);
	rotationZ[2] = float4(0, 0, 1, 0);
	rotationZ[3] = float4(0, 0, 0, 1);

	final = mul(mul(rotationX, rotationY), rotationZ);

	float3 position01 = mul(float4(input[0].Position - center, 1), final).xyz;
	float3 position02 = mul(float4(input[1].Position - center, 1), final).xyz;
	float3 position03 = mul(float4(input[2].Position - center, 1), final).xyz;

	float3 direction = float3(0.0f, -1.0f * angles.y, -6.0f * angles.x);

	output[0].Position = mul(mul(mul(float4(position01 + center + normal * Time * speed, 1), world), view), projection);
	output[1].Position = mul(mul(mul(float4(position02 + center + normal * Time * speed, 1), world), view), projection);
	output[2].Position = mul(mul(mul(float4(position03 + center + normal * Time * speed, 1), world), view), projection);

	for (int i = 0; i < 3; i++)
	{
		output[i].normal = input[i].Normal;
		output[i].uv = input[i].UV;
		stream.Append(output[i]);
	}
}

//PIXEL SHADER ---------------------------------------------
Texture2D DiffuseTexture;
Texture2D EmissivTexture;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4 PS_Main(PS_Data input) : SV_TARGET
{
	float4 diffuse = DiffuseTexture.Sample(Sampler, input.uv).rgba;
	float4 emissiv = EmissivTexture.Sample(Sampler, input.uv).rgba;

	float4 color = float4(0, 0, 0, 0);

	if (emissiv.r == 0)
		color = diffuse;
	else
		color = emissiv * 2;

	return color;
}