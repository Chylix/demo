//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float Timer;
	float2 iResolution;
	float ScaleOb1;
	float ScaleOb2;
	float ScaleOb3;
	float FancyRot;
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

float gt(float x, float y)
{
    return 1.0 - max(sign(x-y),0.0);
}

float sinIO( float x)
{
    return sin(x)*0.5+0.5;
}

float cosIO( float x)
{
    return cos(x)*0.5+0.5;
}

float sinBetween( float x,  float y,  float z)
{
    return (z - sinIO(x)*z ) + (sinIO(x)*y);
}

float cosBetween( float x,  float y,  float z)
{
    return (z - cosIO(x)*z) + (cosIO(x)*y);
}


float smin(float a, float b, float k) {
  float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
  return lerp(b, a, h) - k * h * (1.0 - h);
}

float3 Singular(float iGlobalTime, float2 uv)
{
  float3 fColor = float3(0.0,0.0,0.0);

  float2 oPos00 = float2(.0,.0);
  float2 oPos01 = float2(.0,.2);
  float2 oPos10 = float2(.0,-.3);
  float2 oPos11 = float2(.3,.0);
  
  float count = 15.;
    
  for(float i = 0.; i <  15.; ++i)
  {
     float2 oPos00 = float2(cos(iGlobalTime*0.5+i/ count * 6.28+0.5)*0.5,sin(i/count * 6.28)*0.5);
     float2 oPos01 = float2(cos(iGlobalTime*0.5+i/ count * 6.28+0.48)*0.5,sin(i/count * 6.28)*0.5);
     float2 oPos10 = float2(cos(iGlobalTime*0.5+i/ count * 6.28+0.45)*0.5,sin(i/count * 6.28)*0.5);
       
     float o00 = length(oPos00 - uv) - 0.05; 
     float o01 = length(oPos01 - uv) - 0.05; 
     float o10 = length(oPos10 - uv) - 0.05; 
        
     float3  mat00 = (1. - smoothstep(0.0,5.0/iResolution.x,o00)) * (float3(1.0,0.0,0.0)*1.0);
     float3  mat01 = (1. - smoothstep(0.0,5.0/iResolution.x,o01)) * (float3(0.0,1.0,0.0)*1.0);
     float3  mat10 = (1. - smoothstep(0.0,5.0/iResolution.x,o10)) * (float3(0.0,0.0,1.0)*1.0);
        
        
     fColor += mat00;
     fColor += mat01;
     fColor += mat10;  
  }
  
  return fColor;
}

float3 Edge(float iGlobalTime, float2 uv)
{
    float3 fColor = float3(0.0,0.0,0.0);
    
    fColor.r = smoothstep(0.0,0.018,(sin(iGlobalTime)*uv.y)+(cos(iGlobalTime)*uv.x));
    fColor.g = smoothstep(0.0,0.018,(sin(iGlobalTime+0.01)*uv.y)+(cos(iGlobalTime+0.01)*uv.x));
    fColor.b = smoothstep(0.0,0.020,(sin(iGlobalTime+0.02)*uv.y)+(cos(iGlobalTime+0.02)*uv.x));
    
    return fColor;
}

float3 MetaBalls(float iGlobalTime, float2 uv)
{

float3 fColor = float3(0.0,0.0,0.0);
  float aaFactor = 0.01; // Antialising Factor for smoothstep
      float rad = 1.0;
    //Sphere Positions

    float fFancyRot = FancyRot;

    float curve1 = (1.28 + (5 * fFancyRot));
    float curve2 = (3.28 + (3 * fFancyRot));
    float curve3 = (4.28 + (2 * fFancyRot));
   	//float curve4 = (-6.28-6.28*sinBetween(iGlobalTime,0.0,0.5)) * FancyRot;

    float2 oPos01 = float2(cos(iGlobalTime+1/3.*6.28)*rad,sin(iGlobalTime+1/3.*curve1)*rad);
    float2 oPos10 = float2(cos(iGlobalTime+2/3.*curve1)*rad,sin(iGlobalTime+2/3.*curve3)*rad);
    float2 oPos11 = float2(cos(iGlobalTime+3/3.*curve2)*rad,sin(iGlobalTime+3/3.*curve2)*rad);
    float mat0 = 1.0;
    //Scene Buildup
    //float mat0 = length(oPos00 - uv) - 0.2;       // Distance field of a sphere
    mat0 = smin(mat0,length(oPos01 - uv) - sinBetween(iGlobalTime,0.8,1.2)*3.2*ScaleOb1,0.3); // smin for merching the objects in the Scene 
    mat0 = smin(mat0,length(oPos10 - uv) - sinBetween(iGlobalTime+111.,0.5,0.9)*3.3*ScaleOb2,0.3);  // 0.3 factor for archiving 
    mat0 = smin(mat0,length(oPos11 - uv) - sinBetween(iGlobalTime+1337.,0.9,1.4)*3.1*ScaleOb3,0.3); // noticable lerping between objects

    // object/scene Mask for coloring
    float object0 = 1.0 - smoothstep(0.0,aaFactor, mat0);
  float scene = 1.0 - object0;
    
    //Coloring
    float3 sceneColor = float3(1.0,1.0,1.0);
    float3 objectColor0 = float3(0.0,0.0,0.0);

    //Uncomment it for eye cancer color
    //sceneColor = vec3(1.0,0.0,0.65);
    //objectColor0 = vec3(0.0,1.0,1.0);
    
    //Mix objectcolor with scenebackgroundcolor
    fColor = float3(lerp(objectColor0,sceneColor,scene));

  return fColor;
}

float3 Illusion(float iGlobalTime, float2 uv)
{
    float3 fColor = float3(0.0,0.0,0.0);
    float2 pos = float2(.0,.0);
    
    for(float i = 20.0; i > 0.; --i)
    {
        pos = float2(sin(iGlobalTime+(20.0 - i)*0.4)*0.02, sin(iGlobalTime+(20.0 - i)*0.4)*0.02);
      float dist = length( pos - uv) - 0.05 * i;
      float o = 1. - smoothstep(0.0,5.0/iResolution.x, dist);

        fColor = lerp(fColor , float3(1.,1.,1.)* (1. -fmod(i,2.)),o);
    }
    
  return fColor;
}



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
Texture2D Texture;

SamplerState Sampler;

float4 PS_Main(PS_Data input) : SV_TARGET
{

  float iGlobalTime = Timer;

  float3 fColor = float3(.0,.0,.0);
  float2 uv = input.uv.xy;
  uv = 2.0 * uv - 1.0;
  uv.x *= iResolution.x / iResolution.y;

	uv *= 1.5;
  float3 a = MetaBalls(iGlobalTime, uv);

   //float3 s = Singular(iGlobalTime, uv);
   ////float3 e = Edge(iGlobalTime, uv);
   //
   //float t = fmod(iGlobalTime,100.);
 
  return float4(a,1.0);
}