// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.35 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.35;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.1280277,fgcg:0.1953466,fgcb:0.2352941,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:0,x:36044,y:31275,varname:node_0,prsc:2|custl-5192-OUT,olwid-8827-OUT,olcol-1268-RGB;n:type:ShaderForge.SFN_Dot,id:40,x:33145,y:32162,varname:node_40,prsc:2,dt:1|A-42-OUT,B-41-OUT;n:type:ShaderForge.SFN_NormalVector,id:41,x:32823,y:32323,prsc:2,pt:True;n:type:ShaderForge.SFN_LightVector,id:42,x:32753,y:32160,varname:node_42,prsc:2;n:type:ShaderForge.SFN_Tex2d,id:720,x:34767,y:31261,ptovrint:False,ptlb:Diffsue,ptin:_Diffsue,varname:node_720,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:7925,x:33299,y:31884,ptovrint:False,ptlb:Shadow_area,ptin:_Shadow_area,varname:node_7925,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:1,max:1;n:type:ShaderForge.SFN_Posterize,id:5549,x:34361,y:31821,varname:node_5549,prsc:2|IN-8702-OUT,STPS-4927-OUT;n:type:ShaderForge.SFN_Add,id:9526,x:33671,y:31679,varname:node_9526,prsc:2|A-40-OUT,B-7925-OUT;n:type:ShaderForge.SFN_Lerp,id:9733,x:34743,y:31541,varname:node_9733,prsc:2|A-8601-RGB,B-4464-OUT,T-5549-OUT;n:type:ShaderForge.SFN_Vector1,id:4464,x:34294,y:31697,varname:node_4464,prsc:2,v1:0.99;n:type:ShaderForge.SFN_Color,id:8601,x:34294,y:31423,ptovrint:False,ptlb:ShadowColor,ptin:_ShadowColor,varname:node_8601,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.4926471,c2:0.01811201,c3:0.01811201,c4:1;n:type:ShaderForge.SFN_Multiply,id:1133,x:35019,y:31305,varname:node_1133,prsc:2|A-720-RGB,B-9733-OUT;n:type:ShaderForge.SFN_Slider,id:8827,x:34984,y:31702,ptovrint:False,ptlb:OutlineWidth,ptin:_OutlineWidth,varname:node_8827,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Clamp01,id:8702,x:33986,y:31734,varname:node_8702,prsc:2|IN-9526-OUT;n:type:ShaderForge.SFN_Fresnel,id:9457,x:34792,y:31883,varname:node_9457,prsc:2|EXP-9860-OUT;n:type:ShaderForge.SFN_Add,id:5192,x:35495,y:31714,varname:node_5192,prsc:2|A-1294-OUT,B-1133-OUT;n:type:ShaderForge.SFN_Slider,id:9860,x:34437,y:32072,ptovrint:False,ptlb:FresnelExp,ptin:_FresnelExp,varname:node_9860,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:4,max:10;n:type:ShaderForge.SFN_Multiply,id:1294,x:35190,y:31902,varname:node_1294,prsc:2|A-9457-OUT,B-9940-RGB;n:type:ShaderForge.SFN_Color,id:9940,x:34965,y:32056,ptovrint:False,ptlb:FresnelColor,ptin:_FresnelColor,varname:node_9940,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:4927,x:33955,y:32011,ptovrint:False,ptlb:PosterizeSteps,ptin:_PosterizeSteps,varname:node_4927,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:3,max:5;n:type:ShaderForge.SFN_Color,id:1268,x:35495,y:31938,ptovrint:False,ptlb:OutlineColor,ptin:_OutlineColor,varname:node_1268,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;proporder:720-7925-8601-8827-9860-9940-4927-1268;pass:END;sub:END;*/

Shader "Across/CharCustomLighting" {
    Properties {
        _Diffsue ("Diffsue", 2D) = "white" {}
        _Shadow_area ("Shadow_area", Range(-1, 1)) = 1
        _ShadowColor ("ShadowColor", Color) = (0.4926471,0.01811201,0.01811201,1)
        _OutlineWidth ("OutlineWidth", Range(0, 1)) = 0
        _FresnelExp ("FresnelExp", Range(1, 10)) = 4
        _FresnelColor ("FresnelColor", Color) = (0.5,0.5,0.5,1)
        _PosterizeSteps ("PosterizeSteps", Range(1, 5)) = 3
        _OutlineColor ("OutlineColor", Color) = (0.5,0.5,0.5,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "Outline"
            Tags {
            }
            Cull Front
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float _OutlineWidth;
            uniform float4 _OutlineColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal*_OutlineWidth,1) );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                return fixed4(_OutlineColor.rgb,0);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _Diffsue; uniform float4 _Diffsue_ST;
            uniform float _Shadow_area;
            uniform float4 _ShadowColor;
            uniform float _FresnelExp;
            uniform float4 _FresnelColor;
            uniform float _PosterizeSteps;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float4 _Diffsue_var = tex2D(_Diffsue,TRANSFORM_TEX(i.uv0, _Diffsue));
                float node_4464 = 0.99;
                float3 finalColor = ((pow(1.0-max(0,dot(normalDirection, viewDirection)),_FresnelExp)*_FresnelColor.rgb)+(_Diffsue_var.rgb*lerp(_ShadowColor.rgb,float3(node_4464,node_4464,node_4464),floor(saturate((max(0,dot(lightDirection,normalDirection))+_Shadow_area)) * _PosterizeSteps) / (_PosterizeSteps - 1))));
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _Diffsue; uniform float4 _Diffsue_ST;
            uniform float _Shadow_area;
            uniform float4 _ShadowColor;
            uniform float _FresnelExp;
            uniform float4 _FresnelColor;
            uniform float _PosterizeSteps;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float4 _Diffsue_var = tex2D(_Diffsue,TRANSFORM_TEX(i.uv0, _Diffsue));
                float node_4464 = 0.99;
                float3 finalColor = ((pow(1.0-max(0,dot(normalDirection, viewDirection)),_FresnelExp)*_FresnelColor.rgb)+(_Diffsue_var.rgb*lerp(_ShadowColor.rgb,float3(node_4464,node_4464,node_4464),floor(saturate((max(0,dot(lightDirection,normalDirection))+_Shadow_area)) * _PosterizeSteps) / (_PosterizeSteps - 1))));
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
