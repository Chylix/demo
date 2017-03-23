//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float isInstance;
	float Diffuse1Power;
	float Diffuse2Power;
	float Diffuse3Power;
	float3 LineColor;
	float3 FaceColor;
	float Time;
	float RandomValue;
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

GS_Data VS_Main(VS_Data input)
{
	GS_Data output;

	output.Position = input.position;
	output.Normal = input.normal;
	output.UV = input.uv;

	return output;
}

//GEOMETRY SHADER

Texture2D NoiseTexture;
Texture2D NoiseTexture2;

SamplerState TrilinearSampler
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

	//float3 normal = (input[0].Normal + input[1].Normal + input[2].Normal) / 3;
	float3 center = (input[0].Position + input[1].Position + input[2].Position) / 3;
	float2 uv = (input[0].UV + input[1].UV + input[2].UV) / 3;

	float3 angles = NoiseTexture.SampleLevel(TrilinearSampler, uv, 0).rgb;
	angles -= 0.5f;
	float speed = NoiseTexture2.SampleLevel(TrilinearSampler, uv, 0).r * 5;
	
	float3 normal = angles;
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

	output[0].Position = mul(mul(mul(float4(position01 + center + direction * Time * speed, 1), world), view), projection);
	output[1].Position = mul(mul(mul(float4(position02 + center + direction * Time * speed, 1), world), view), projection);
	output[2].Position = mul(mul(mul(float4(position03 + center + direction * Time * speed, 1), world), view), projection);

	for (int i = 0; i < 3; i++)
	{
		output[i].Normal = input[i].Normal;
		output[i].UV = input[i].UV;

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

float edgeFactor(float3 t, float str) {
	float3 d = fwidth(t);
	float3 a3 = smoothstep(float3(0.0f, 0.0f, 0.0f), d*str, t);
	return min(min(a3.x, a3.y), a3.z);
}

Texture2D DiffuseTexture1;
Texture2D DiffuseTexture2;
Texture2D DiffuseTexture3;
Texture2D EmissiveTexture1;
Texture2D EmissiveTexture2;
Texture2D EmissiveTexture3;

SamplerState SamplerE
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

//PIXEL SHADER ---------------------------------------------
float4 PS_Main(PS_Data input) : SV_TARGET
{   
	//diffuse

	float3 diffuse1 = DiffuseTexture1.Sample(SamplerE, input.UV).rgb * Diffuse1Power;
	//clip(diffuse1.a - 1);
	//
	float3 diffuse2 = DiffuseTexture2.Sample(SamplerE, input.UV).rgb * Diffuse2Power;
	//clip(diffuse2.a - 1);
	
	float3 diffuse3 = DiffuseTexture3.Sample(SamplerE, input.UV).rgb * Diffuse3Power;
	//clip(diffuse3.a - 1);
	
	//emissive

	float3 emissive1 = EmissiveTexture1.Sample(SamplerE, input.UV).rgb * Diffuse1Power;

	float3 emissive2 = EmissiveTexture2.Sample(SamplerE, input.UV).rgb * Diffuse2Power;

	float3 emissive3 = EmissiveTexture3.Sample(SamplerE, input.UV).rgb * Diffuse3Power;

	float4 emissiveColor = float4(saturate(emissive1 + emissive2 + emissive3), 1.0f);

	float4 diffuseColor = float4(saturate(diffuse1 + diffuse2 + diffuse3), 1.0f);

	float4 finalColor;

	float value = (emissiveColor.r - 1) * -1;
	finalColor = diffuseColor * value + float4(FaceColor, 1) * emissiveColor.r;

	/*if (Diffuse1Power == -2.0f)
	{
		finalColor = float4(lerp(diffuse3, diffuse3 * 1 - Time / 4, edgeFactor(input.Barycentric, Time)), 1);
	}
	if (Diffuse1Power == -1.0f)
	{
		finalColor = float4(LineColor, (1.0f - edgeFactor(input.Barycentric, 1.5f))* 0.95f);
	}
	if (Diffuse1Power == -4.0f)
	{
		finalColor = float4(lerp(diffuse3, float3(0,0,0 ), edgeFactor(input.Barycentric, 1.5f)), 1);
	}*/

	float t = 1.0f - Time / 6.0f;
	t = clamp(t, 0.0f, 1.0f);

	return float4(finalColor.rgb, t);
}//(BuildRandomMin, BuildRandomMax)