//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float3 color;
	float speed;
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
	float2 UV : UV;
	float3 Normal : NORMAL;
};

GS_Data VS_Main(VS_Data input)
{
	GS_Data output;
	//if (isInstance == 1)
	//{
	//	output.position = mul(float4(input.position, 1), input.Transformation);
	//	output.position = mul(output.position, view);
	//	output.position = mul(output.position, projection);
	//	output.normal = mul(input.normal, (float3x3)input.Transformation);
	//}
	//else if(isInstance == 0)
	//{
	//	output.position = mul(float4(input.position, 1), world);
	//	output.position = mul(output.position, view);
	//	output.position = mul(output.position, projection);
	//	output.normal = mul(input.normal, (float3x3)world);
	//}

	output.Position = input.position;
	output.Normal = input.normal;
	output.UV = input.uv;

	return output;
}

//GEOMETRY SHADER

Texture2D NoiseTexture;

SamplerState Sampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

[maxvertexcount(3)]
void GS_Main(triangle GS_Data input[3], inout TriangleStream<PS_Data> stream)
{
	PS_Data output[3];

	float3 direction = float3(0, 0, 1);

	matrix rotationX = (matrix)0;
	matrix rotationY = (matrix)0;
	matrix rotationZ = (matrix)0;

	float3 normal = (input[0].Normal + input[1].Normal + input[2].Normal) / 3;
	float3 center = (input[0].Position + input[1].Position + input[2].Position) / 3;
	float2 uv = (input[0].UV + input[1].UV + input[2].UV) / 3;

	float r = NoiseTexture.SampleLevel(Sampler, uv, 0).r * 8;

	direction = float3((uv.x - 0.5) * 1.5, r / 8, direction.z);

	direction = normalize(direction);

	float3 position01 = mul(float4(input[0].Position + direction * speed * r, 1), world);
    float3 position02 = mul(float4(input[1].Position + direction * speed * r, 1), world);
    float3 position03 = mul(float4(input[2].Position + direction * speed * r, 1), world);

	output[0].Position = mul(mul(float4(position01, 1), view), projection);
	output[1].Position = mul(mul(float4(position02, 1), view), projection);
	output[2].Position = mul(mul(float4(position03, 1), view), projection);

	for (int i = 0; i < 3; i++)
	{
		output[i].Normal = input[i].Normal;
		output[i].UV = input[i].UV;
		stream.Append(output[i]);
	}
}


//PIXEL SHADER ---------------------------------------------
float4 PS_Main(PS_Data input) : SV_TARGET
{
    float3 lightDir = float3(0.0, 0.7, -0.6);
	
    float3 Ln = normalize(lightDir);
    float3 Nn = normalize(input.Normal);
	
    float4 rgba = float4(saturate(color + dot(Nn, Ln) / 3), 1);
    return rgba;
}