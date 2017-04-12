//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
  float4x4 world;
  float4x4 projection;
  float4x4 view;
  float IsInstanced;
  float Timer;
  float2 iResolution; 
  int nGons;
  float radFactor;
  float posSpeed;
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

#define phirad 2.39996322972865332

float gt(float x, float y)
{
    return floor(max(sign(x-y),0.0));
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

float nGonSDF(float2 uv, float2 pos, in int gons, in float radius, float rotation)
{
    uv -= pos;
    float stepSize = 6.28 / float(gons);
    float currentAngle = atan2(uv.y, uv.x) + rotation;
    
    float dist = (cos(floor(0.5 + currentAngle / stepSize)* stepSize - currentAngle)* length(uv)) - radius;
    
    return dist;
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


float3 Illusion(float iGlobalTime, float2 uv)
{
    float3 fColor = float3(1.0,1.0,1.0);
   
    for(float i = 30.; i > 0.; i--)
    {

      float radius = (radFactor + i*0.1f) - (iGlobalTime * 0.3);
      //float radius = (i+-400.0)*radFactor + iGlobalTime * 0.3;
      float2 pos = float2(cos(iGlobalTime+i*0.08) * posSpeed,0.0);
      float rot = sin(-iGlobalTime*0.1+(i/20.0))*6.28;

      float dist = nGonSDF(uv,pos,nGons,radius, rot*0.0);

      float o = 1. - smoothstep(0.0,5.0/iResolution.x, dist);
      float3 oColor = float3(1.0,1.0,1.0) * (1.0 -fmod(i,2.0));
      fColor = lerp(fColor,oColor,o);

    }

      



    //for(float i = 20.0; i > 0.; --i)
   // {
   //     pos = float2(sin(iGlobalTime+(20.0 - i)*0.4)*0.02, sin(iGlobalTime+(20.0 - i)*0.4)*0.02);
   //   float dist = nGonSDF(uv,pos,4,0.5);
  //    float o = 1. - smoothstep(0.0,5.0/iResolution.x, dist);

  //      fColor = lerp(fColor , float3(1.,1.,1.)* (1. -fmod(i,2.)),o);
  //  }
    
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
  float3 a = Illusion(iGlobalTime, uv);

   //float3 s = Singular(iGlobalTime, uv);
   ////float3 e = Edge(iGlobalTime, uv);
   //
   //float t = fmod(iGlobalTime,100.);
 
  return float4(a,1.0);
}