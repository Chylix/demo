//Vertex Shader -------------------------------------------
cbuffer constBuffer
{
	float4x4 world;
	float4x4 projection;
	float4x4 view;
	float IsInstanced;
	float Timer;
	float2 iResolution;
  float4 scale;
	float FancyRot;
  float Wave;
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

float SphereRadiusPos[24] =
{
0.5,0.5,0.5,
0.75,0.75,0.75,
1.0,1.0,1.0,1.0,
1.25,1.25,1.25,1.25,
1.5,1.5,1.5,1.5,1.5,
1.75,1.75,1.75,1.75,1.75
};


float curves[6] =
{
0.,
0.,
0.,
0.,
0.,
0.
} ;

float2 CalcSpeherePos(int sphereId,float time,float speed)
{
  float t = time * speed;
  float phimod = phirad ;//+ time*0.02;
  float offset = phimod*sphereId;
  float spaceOffset = (0.5 * (sphereId))*FancyRot;

  return float2(cos(t+offset+spaceOffset), sin(t+offset))*(5.0*(sphereId/50.));
}

float3 MetaBalls(float iGlobalTime, float2 uv)
{

  float3 fColor = float3(0.0,0.0,0.0);
  float aaFactor = 0.01; // Antialising Factor for smoothstep

    //Sphere Positions
   	//float curve4 = (-6.28-6.28*sinBetween(iGlobalTime,0.0,0.5)) * FancyRot;

    //float2 oPos01 = float2(cos(iGlobalTime+1/3.*6.28)*rad,sin(iGlobalTime+1/3.*curve1)*rad);
    //float2 oPos10 = float2(cos(iGlobalTime+2/3.*curve1)*rad,sin(iGlobalTime+2/3.*curve3)*rad);
   // float2 oPos11 = float2(cos(iGlobalTime+3/3.*curve2)*rad,sin(iGlobalTime+3/3.*curve2)*rad);
 


 // float2 sPos00 = float2(cos(iGlobalTime*.5+(phirad)), sin(iGlobalTime*.5+phirad))*rad00;
 // float2 sPos01  = float2(cos(iGlobalTime*.5+(phirad*2.)), sin(iGlobalTime*.5+(phirad*2.)))*rad01;
 // float2 sPos10  = float2(cos(iGlobalTime*.5+(phirad*3.)), sin(iGlobalTime*.5+(phirad*3.)))*rad10;
 // float2 sPos11  = float2(cos(iGlobalTime*.5+(phirad*4.)), sin(iGlobalTime*.5+(phirad*4.)))*rad11;
 // float2 sPos100  = float2(cos(iGlobalTime*.5+(phirad*5.)), sin(iGlobalTime*.5+(phirad*5.)))*rad100;
 // float2 sPos101  = float2(cos(iGlobalTime*.5+(phirad*6.)), sin(iGlobalTime*.5+(phirad*6.)))*rad101;


  float mat0 = 1.0;

  for(int i = 0; i < 50; i++)
  {
    float2 sp = CalcSpeherePos(i,iGlobalTime,0.5);
    float wavemod = (0.2*sin(Wave)*(i/50.));
    mat0 = smin(mat0, length(sp - uv) - (scale[i%4]+wavemod),0.3);

  }

    //Scene Buildup
    //float mat0 = length(oPos00 - uv) - 0.2;       // Distance field of a sphere
  //mat0 = smin(mat0,length(sPos00 - uv) - sinBetween(iGlobalTime,0.8,1.2)*0.2*ScaleOb1,0.3); // smin for merching the objects in the Scene 
  //mat0 = smin(mat0,length(sPos01 - uv) - sinBetween(iGlobalTime+111.,0.5,0.9)*0.3*ScaleOb2,0.3);  // 0.3 factor for archiving 
  //mat0 = smin(mat0,length(sPos10 - uv) - sinBetween(iGlobalTime+1337.,0.9,1.4)*0.1*ScaleOb3,0.3); // noticable lerping between objects
  //mat0 = smin(mat0,length(sPos11 - uv) - sinBetween(iGlobalTime+1337.,0.9,1.4)*0.1*ScaleOb3,0.3); // noticable lerping between objects
  //mat0 = smin(mat0,length(sPos100 - uv) - sinBetween(iGlobalTime+1337.,0.9,1.4)*0.1*ScaleOb3,0.3); // noticable lerping between objects
  //mat0 = smin(mat0,length(sPos101 - uv) - sinBetween(iGlobalTime+1337.,0.9,1.4)*0.1*ScaleOb3,0.3); // noticable lerping between objects

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