Shader "Custom/Planet" 
{
	Properties
	{
		//_GradientMap("Pole Gradient", 2D) = "black" {}
		//_SurfaceNormalMap("Surface Normal", 2D) = "black" {}	
		_OceanMask("Ocean Mask", 2D) = "black" {}	
		//_HeightMap ("Height Map", 2D) = "black" {}
		_CloudsMap ("Clouds Map", 2D) = "black" {}
        // _SunsetMap ("Sunset Map", 2D) = "black" {}        
        // _CityLightUVMap ("City Light UV Map", 2D) = "black" {}
        // _CityLightMaskMap ("City Light Mask Map", 2D) = "black" {}
        // _CityLightMap ("City Light Map", 2D) = "black" {}
		
        //陆地
        _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,1)
        // _DesertColor ("Desert Color", Color) = (0.5,0.5,0.5,1)
        // _MountainColor ("Mountains Color", Color) = (0.5,0.5,0.5,1)
        // _DesertCoverage ("Desert Coverage", Float) = 0
        // _DesertFactors ("Desert Factors", Float) = 0
        // _MountainCoverage ("Mountains Coverage", Float) = 0
        // _MountainFactors ("Mountains Factors", Float) = 0

        //植被 需要 heightMap
        _VegetationColor ("Vegetation Color", Color) = (0.5,0.5,0.5,1)
        _VegetationCoverage ("Vegetation Coverage", Float) = 0

        //_VegetationFactors ("Vegetation Factors", Float) = 0
        //海水
        _WaterColor ("Water Color", Color) = (0.5,0.5,0.5,1)
        _WaterColorMult ("Water Color Multiplier", Range(0.3, 5)) = 0
        // _WaterSpecularColor("Water Specular Color", Color) = (0.5,0.5,0.5,1)
        // _WaterSpecularPow ("Water Specular Power", Float ) = 0
        // _WaterSpecularMult ("Water Specular Multiplier", Float ) = 0

        // _WaterFresnelPow ("Water Fresnel Power", Float ) = 0
        // _WaterFresnelMult ("Water Fresnel Multiplier", Float ) = 0
        //_ShallowWaterColor ("Shallow Water Color", Color) = (0.5,0.5,0.5,1)
        //_ShoreColor ("Shore Color", Color) = (0.5,0.5,0.5,1)
     	//_ShoreFactor ("Shore Factor", Float ) = 0
        // _WaterDetailPow ("Water Detail Power", Float ) = 0
        // _WaterDetailMult ("Water Detail Multiplier", Float ) = 0

        //Fresnel 边缘光
        _LandSpecularColor("Land Specular Color", Color) = (0.5,0.5,0.5,1)
        _FresnelLandMult ("Fresnel Land Multiplier", Float ) = 0
        //_FresnelLandPow ("Fresnel Land Power", Float ) = 0
        

        //云层
        _CloudsColor("Clouds Color", Color) = (0.5,0.5,0.5,1)       
        // _CloudsShadows ("Clouds Shadow", Float ) = 0      	
      	// _CloudsBrightness ("Clouds Brightness", Float ) = 0
        _CloudsAnimation ("Clouds Animation", Float ) = 0

        //_CloudsSunset ("Sunset Factor", Float ) = 0
        //城市灯光  灯光太少，效果放大后看不见，暂不使用
        // _CityLightColor("City Light Color", Color) = (0.5,0.5,0.5,1)
        // _Population ("City Light Coverage", Float ) = 0

        
        //向光背光
        // _BackLightFactor("back light factor", Range(0,1)) = 0
		// _DiffusePow("Diffuse Power", Float) = 0
        

	    //其他
        //_NormalHeight("Normal Height", Float) = 0   
        //_HeightTile("Height Tile", Float) = 0
        //_ColorPassTrough("Global Multiplier", Float) = 0
        

        //_SurfaceNormalMap2("Surface Normal 2", 2D) = "black" {}	
        //_SurfaceNormalMap2U ("Surface Normal 2 UOffset", Float ) = 0

        //_HeightMap2("Height Map 2", 2D) = "black" {}	
        //_HeightMap2U ("Height Map 2 UOffset", Float ) = 0

        _OceanMask2("Ocean Mask2", 2D) = "black" {}	
        _OceanMask2U ("Ocean Mask2 UOffset", Float ) = 0
        _OceanMask2V ("Ocean Mask2 VOffset", Float ) = 0
	}

	SubShader 
	{ 
		Tags
        {
            "IgnoreProjector"="True"
             "Queue"="Geometry"
            "RenderType"="Opaque" 
            "LightMode"="ForwardBase"
        }
		LOD 200
		Fog {Density 0.0025}
 		
		Pass  
		{
			CGPROGRAM

		  	//#pragma only_renderers opengl d3d9 d3d11
            #pragma glsl
            #pragma target 3.0
			#pragma vertex EarthLikeVert
            #pragma fragment EarthLikeFrag
            
          	#include "UnityCG.cginc"
            #include "AutoLight.cginc" 
            #include "PlanetData.cginc"
            #include "PlanetLighting.cginc"
            #include "PlanetVS.cginc"
			#include "NPlanetPS.cginc" 

            uniform float4 _OceanMask_ST;
            float4 EarthLikeFrag(PlanetOutput i) : COLOR
            {                
            	PlanetData p = GetPlanetData(i);
                
            	float3 baseColor = p.HeightMap.r * _TintColor.rgb;
                //add water & vegatation
                float3 vegColor = _VegetationColor.rgb;
                float mask = saturate(_VegetationCoverage - p.HeightMap.b * p.HeightMap.r);
                baseColor = lerp(baseColor, vegColor, mask);

                float3 waterColor = _WaterColor.rgb * _WaterColorMult;
                baseColor = lerp(baseColor, waterColor, p.OceanMap.r);
                // add cloud
                float3 cloudColor = _CloudsColor.rgb;
                float2 cloudUV = i.uv.xy;
                cloudUV.x += _CloudsAnimation * 0.15 * _Time;
                baseColor += tex2D(_CloudsMap, cloudUV) * _CloudsColor;
                // fresnel
                float rim = 1 - saturate(dot(p.ViewDir, p.NormalDir));
                baseColor = lerp(baseColor, _LandSpecularColor.rgb * _LandSpecularColor.a * _FresnelLandMult, saturate(rim - 0.15));
                //shadow
                //TODO
            	return float4(baseColor, 1);
            }

			ENDCG
		} 
	} 

	FallBack Off
}
