// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GaussianBlur" {
	Properties {
		_MainTex("主纹理", 2D) = "white"{}
	}
	SubShader {
		//关闭深度缓存和融合
		ZWrite Off
		Blend Off

		//降采样通道
		Pass
		{
			ZTest Off
			Cull Off
			CGPROGRAM
			#pragma vertex Vert_DownSmpl
			#pragma fragment Frag_DownSmpl  
			ENDCG
		}
		//水平模糊通道
		Pass
		{
			ZTest Always
			Cull Off

			 CGPROGRAM
			 #pragma vertex Vert_BlurHorizontal
			 #pragma fragment Frag_Blur
			 ENDCG 
		}
		//垂直模糊通道
		Pass
		{
			ZTest Always
			Cull Off

			CGPROGRAM
			#pragma vertex Vert_BlurVertical
			#pragma fragment Frag_Blur
			ENDCG
		}

		CGINCLUDE
		#include "UnityCG.cginc"
		sampler2D _MainTex;		//截屏
		//UnityCG中内置变量，纹理中单个像素的尺寸
		uniform half4 _MainTex_TexelSize;
		//降采样系数
		uniform half _DonwSamplerPara;

		//定义输入结构
		struct VertexInput
		{
			float4 vertex : POSITION;		//顶点位置
			half2 texcoord : TEXCOORD0;		//一级纹理坐标
		};

		//定义降采样输出结构
		struct VertexOutput_DownSmpl
		{
			float4 pos : SV_POSITION;		//像素坐标
			half2 uv20 : TEXCOORD1;			//右上纹理坐标
			half2 uv21 : TEXCOORD2;			//左下纹理坐标
			half2 uv22 : TEXCOORD3;			//右下纹理坐标
			half2 uv23 : TEXCOORD4; 		//左上纹理坐标
		};

		//默认上下左右取偏移为3范围内的像素做加权均值
		static const half4 GaussWeight[7] =  
    	{  
        	half4(0.0205,0.0205,0.0205,0),  
        	half4(0.0855,0.0855,0.0855,0),  
        	half4(0.232,0.232,0.232,0),  
        	half4(0.324,0.324,0.324,1),  
        	half4(0.232,0.232,0.232,0),  
        	half4(0.0855,0.0855,0.0855,0),  
        	half4(0.0205,0.0205,0.0205,0)  
    	};

		
		//降采样顶点着色器函数
		VertexOutput_DownSmpl Vert_DownSmpl(appdata_img i)
		{
			VertexOutput_DownSmpl o;

			//3D坐标投影到2D窗口
			o.pos = UnityObjectToClipPos(i.vertex);
			half2 uv = 0;
			// #if UNITY_UV_STARTS_AT_TOP
			// uv = float2(i.texcoord.x, 1 - i.texcoord.y);
			// #else
			// uv = i.texcoord.xy;
			// #endif
			uv = i.texcoord.xy;
			//将上下左右的纹理坐标分别记录
			o.uv20 = uv + _MainTex_TexelSize.xy * half2(0.5h, 0.5h);
			o.uv21 = uv + _MainTex_TexelSize.xy * half2(-0.5h, -0.5h);
			o.uv22 = uv + _MainTex_TexelSize.xy * half2(0.5h, -0.5h);
			o.uv23 = uv + _MainTex_TexelSize.xy * half2(-0.5h, 0.5h);
			return o;
		}

		//降采样片段着色器函数
		fixed4 Frag_DownSmpl(VertexOutput_DownSmpl IN) : SV_Target
		{
			fixed4 color = 0;
			//将周围四个像素的纹理相加
			color += tex2D(_MainTex, IN.uv20);
			color += tex2D(_MainTex, IN.uv21);
			color += tex2D(_MainTex, IN.uv22);
			color += tex2D(_MainTex, IN.uv23);
			//返回颜色平均值
			return color / 4;
		}

		//高斯模糊输出结构
		struct VertexOutput_Blur
		{
			float4 pos : SV_POSITION;	//像素坐标
			half4 uv : TEXCOORD0;		//纹理坐标
			half2 offset : TEXCOORD1;	//偏移量
		};

		VertexOutput_Blur Vert_BlurHorizontal(VertexInput IN)
		{
			VertexOutput_Blur OUT;

			half2 uv = 0;
			// #if UNITY_UV_STARTS_AT_TOP
			// uv = float2(IN.texcoord.x, 1 - IN.texcoord.y);
			// #else
			// uv = IN.texcoord.xy;
			// #endif
			uv = IN.texcoord.xy;
			//投影
			OUT.pos = UnityObjectToClipPos(IN.vertex);
			//获得纹理坐标
			OUT.uv = half4(uv, 1, 1);
			//计算偏移量
			OUT.offset = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _DonwSamplerPara;
			return OUT;
		}

		VertexOutput_Blur Vert_BlurVertical(VertexInput IN)
		{
			VertexOutput_Blur OUT;

			half2 uv = 0;
			// #if UNITY_UV_STARTS_AT_TOP
			// uv = float2(IN.texcoord.x, 1 - IN.texcoord.y);
			// #else
			// uv = IN.texcoord.xy;
			// #endif
			uv = IN.texcoord.xy;
			//投影
			OUT.pos = UnityObjectToClipPos(IN.vertex);
			//获得纹理坐标
			OUT.uv = half4(uv, 1, 1);
			//计算偏移量
			OUT.offset = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _DonwSamplerPara;
			return OUT;
		}


		half4 Frag_Blur(VertexOutput_Blur IN) : SV_Target
		{
			half2 uv = IN.uv.xy;		//获取原始uv坐标
			half2 offset = IN.offset;	//获取偏移
			half2 uv_withoffset = uv - offset * 3;

			//循环采样 获取加权和
			half4 color = 0;
			for(int i=0; i<7; i++)
			{
				half4 curColor = tex2D(_MainTex, uv_withoffset);
				color += curColor * GaussWeight[i];
				uv_withoffset += offset;
			}
			
			return color;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
