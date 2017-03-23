//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float3 LineColor;
	float3 FaceColor;
	float g_Timer;
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
	float3 Barycentric : BARY;
};
static const int N_WAVES = 3;
GS_Data VS_Main(VS_Data input)
{
	GS_Data output;

	float4 position = float4(input.position, 1.0f);

	float waveAmplitude[N_WAVES];
	float waveFrequency[N_WAVES];
	float wavePhaseConstant[N_WAVES];
	float2 waveDirection[N_WAVES];

	for (int i = 0; i < N_WAVES; i++)
	{
		waveAmplitude[i] = 6.05f;
		waveFrequency[i] = 8.0f;
		wavePhaseConstant[i] = 4;
	}

	waveDirection[0] = float2(0.4f, 1);
	waveDirection[1] = float2(1.0f, 0.4);
	waveDirection[2] = float2(0.3f, 0.1);

	input.normal = float3(0, 1, 0);

	float2 planePos = float2(position.x, position.z);

	float time = g_Timer / 5;

	for (i = 0; i < N_WAVES; i++)
	{
		float dotProduct = dot(waveDirection[i], planePos);

		position.y += waveAmplitude[i] * sin(dotProduct *
			waveFrequency[i] + time * wavePhaseConstant[i]);

		input.normal.x -= waveAmplitude[i] * waveFrequency[i] *
			cos(dotProduct*waveFrequency[i] + time*wavePhaseConstant[i]);
		input.normal.z -= waveAmplitude[i] * waveFrequency[i] *
			cos(dotProduct*waveFrequency[i] + time*wavePhaseConstant[i]);
	}

	input.normal /= N_WAVES;

	input.normal = normalize(input.normal);

	output.Position = position;
	output.Normal = input.normal;
	output.UV = input.uv;

	return output;
}

//GEOMETRY SHADER

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

	float r = 0.0f;

	direction = float3((uv.x - 0.5) * 1.5, r / 8, direction.z);

	direction = normalize(direction);

	float3 position01 = mul(float4(input[0].Position + direction * r, 1), world);
    float3 position02 = mul(float4(input[1].Position + direction * r, 1), world);
    float3 position03 = mul(float4(input[2].Position + direction * r, 1), world);

	output[0].Position = mul(mul(float4(position01, 1), view), projection);
	output[1].Position = mul(mul(float4(position02, 1), view), projection);
	output[2].Position = mul(mul(float4(position03, 1), view), projection);

	for (int i = 0; i < 3; i++)
	{
		output[i].Normal = input[i].Normal;
		output[i].UV = input[i].UV;
		output[i].Barycentric = float3(1, 0, 0);


		if (i == 0)
		{
			output[i].Barycentric = float3(1, 0, 0);
		}
		
		if (i == 1)
		{
			output[i].Barycentric = float3(0, 1, 0);
		}
		
		if (i == 2)
		{
			output[i].Barycentric = float3(0, 0, 1);
		}

		stream.Append(output[i]);
	}
}

float edgeFactor(float3 t) {
	float3 d = fwidth(t);
	float3 a3 = smoothstep(float3(0.0f, 0.0f, 0.0f), d*1.0f, t);
	return min(min(a3.x, a3.y), a3.z);
}

//PIXEL SHADER ---------------------------------------------
float4 PS_Main(PS_Data input) : SV_TARGET
{   
	float3 color = lerp(LineColor, float3(0,0,0), edgeFactor(input.Barycentric));
	
	return float4(color, 1.0f);
}