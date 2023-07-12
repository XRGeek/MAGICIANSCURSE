// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RRF_HumanShaders/EyeShaders/EyeShader_Model2"
{
	Properties
	{
		[NoScaleOffset]_IrisExtraDetail("IrisExtraDetail", 2D) = "white" {}
		[NoScaleOffset]_CustomPupil("CustomPupil", 2D) = "white" {}
		[NoScaleOffset]_EyeExtrasMask("EyeExtrasMask", 2D) = "white" {}
		[NoScaleOffset]_NormalMapBase("NormalMapBase", 2D) = "bump" {}
		_EyeBallColorGlossA("EyeBallColor-Gloss(A)", Color) = (1,1,1,0.878)
		_IrisBaseColor("IrisBaseColor", Color) = (0.8161765,0.4123098,0.1020221,0)
		_IrisExtraColorAmountA("IrisExtraColor-Amount(A)", Color) = (0.1470588,0.1024192,0.06812285,0.441)
		_EyeVeinColorAmountA("EyeVeinColor-Amount(A)", Color) = (0.375,0,0,0)
		_RingColorAmountA("RingColor-Amount(A)", Color) = (0,0,0,0)
		_IrisGlow("IrisGlow", Range( 0 , 10)) = 0
		_LensGloss("LensGloss", Range( 0 , 1)) = 0.98
		_LensPush("LensPush", Range( 0 , 1)) = 0.64
		_CausticPower("CausticPower", Range( 0 , 1)) = 0.3
		_CausticOffset("CausticOffset", Range( 0 , 5)) = 1
		_CausticScale("CausticScale", Range( 0 , 5)) = 1
		_IrisSize("IrisSize", Range( -20 , 20)) = 4.4
		_IrisRotateSpeed("IrisRotateSpeed", Range( -4 , 4)) = 0
		_PupilSize("PupilSize", Range( 0.001 , 89)) = 70
		_PupilHeight1Width1("Pupil Height>1/Width<1", Range( 0.01 , 10)) = 1
		_PupilSharpness("PupilSharpness", Range( 0.1 , 5)) = 5
		_BoostEyeWhite("BoostEyeWhite", Range( 1 , 2)) = 1
		[Toggle]_UseCustomPupil("UseCustomPupil?", Float) = 1
		[Toggle]_InvertCustomPupil("InvertCustomPupil?", Float) = 1
		_CustomPupilRotateSpeed("CustomPupilRotateSpeed", Range( -4 , 4)) = 0
		_PupilParallaxHeight("PupilParallaxHeight", Range( -4 , 8)) = 1.4
		_ParalaxH("ParalaxH", Float) = -0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL

		
		Pass
		{
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106
			#define _NORMALMAP 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			

			sampler2D _EyeExtrasMask;
			sampler2D _CustomPupil;
			sampler2D _IrisExtraDetail;
			sampler2D _NormalMapBase;
			CBUFFER_START( UnityPerMaterial )
			float _BoostEyeWhite;
			float _UseCustomPupil;
			half _PupilSize;
			float _PupilHeight1Width1;
			float _ParalaxH;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float _InvertCustomPupil;
			float _CustomPupilRotateSpeed;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _IrisBaseColor;
			float _IrisSize;
			float _IrisRotateSpeed;
			float4 _IrisExtraColorAmountA;
			float _CausticPower;
			float _CausticScale;
			float _CausticOffset;
			float4 _RingColorAmountA;
			float _LensPush;
			float _IrisGlow;
			float _LensGloss;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				float4 shadowCoord : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
				
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz );

				half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( vertexInput.positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				o.clipPos = vertexInput.positionCS;

				#ifdef _MAIN_LIGHT_SHADOWS
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = _WorldSpaceCameraPos.xyz  - WorldSpacePosition;
	
				#if SHADER_HINT_NICE_QUALITY
					WorldSpaceViewDirection = SafeNormalize( WorldSpaceViewDirection );
				#endif

				float2 uv_EyeExtrasMask166 = IN.ase_texcoord7.xy;
				float4 tex2DNode166 = tex2D( _EyeExtrasMask, uv_EyeExtrasMask166 );
				float temp_output_151_0 = ( 100.0 - _PupilSize );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float3 tanToWorld0 = float3( WorldSpaceTangent.x, WorldSpaceBiTangent.x, WorldSpaceNormal.x );
				float3 tanToWorld1 = float3( WorldSpaceTangent.y, WorldSpaceBiTangent.y, WorldSpaceNormal.y );
				float3 tanToWorld2 = float3( WorldSpaceTangent.z, WorldSpaceBiTangent.z, WorldSpaceNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * WorldSpaceViewDirection.x + tanToWorld1 * WorldSpaceViewDirection.y  + tanToWorld2 * WorldSpaceViewDirection.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset376 = ParallaxOffset( _ParalaxH , _PupilParallaxHeight , ase_tanViewDir );
				float2 uv0147 = IN.ase_texcoord7.xy * appendResult152.xy + paralaxOffset376;
				float clampResult122 = clamp( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) , 0.0 , 1.0 );
				float4 temp_cast_1 = (clampResult122).xxxx;
				float temp_output_269_0 = ( 10.0 - (-20.0 + (_PupilSize - 0.0) * (20.0 - -20.0) / (84.0 - 0.0)) );
				float2 temp_cast_2 = (temp_output_269_0).xx;
				float2 temp_cast_3 = (( ( 1.0 - temp_output_269_0 ) / 2.0 )).xx;
				float2 uv0267 = IN.ase_texcoord7.xy * temp_cast_2 + temp_cast_3;
				float mulTime278 = _Time.y * _CustomPupilRotateSpeed;
				float cos274 = cos( mulTime278 );
				float sin274 = sin( mulTime278 );
				float2 rotator274 = mul( uv0267 - float2( 0.5,0.5 ) , float2x2( cos274 , -sin274 , sin274 , cos274 )) + float2( 0.5,0.5 );
				float4 tex2DNode265 = tex2D( _CustomPupil, rotator274 );
				float4 temp_cast_4 = (_PupilSharpness).xxxx;
				float4 clampResult281 = clamp( pow( ( (( _InvertCustomPupil )?( ( 1.0 - tex2DNode265 ) ):( tex2DNode265 )) + ( 1.0 - tex2DNode166.b ) ) , temp_cast_4 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult304 = lerp( ( _EyeBallColorGlossA * ( 1.0 - tex2DNode166.b ) ) , _EyeVeinColorAmountA , ( _EyeVeinColorAmountA.a * tex2DNode166.g ));
				float4 lerpResult307 = lerp( lerpResult304 , _IrisBaseColor , tex2DNode166.b);
				float temp_output_260_0 = ( 10.0 - _IrisSize );
				float2 temp_cast_5 = (temp_output_260_0).xx;
				float2 temp_cast_6 = (( ( 1.0 - temp_output_260_0 ) / 2.0 )).xx;
				float2 uv0190 = IN.ase_texcoord7.xy * temp_cast_5 + temp_cast_6;
				float mulTime320 = _Time.y * _IrisRotateSpeed;
				float cos319 = cos( mulTime320 );
				float sin319 = sin( mulTime320 );
				float2 rotator319 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos319 , -sin319 , sin319 , cos319 )) + float2( 0.5,0.5 );
				float4 tex2DNode185 = tex2D( _IrisExtraDetail, rotator319 );
				float temp_output_368_0 = pow( ( tex2DNode185.r * _IrisExtraColorAmountA.a * tex2DNode166.b ) , 2.0 );
				float4 lerpResult314 = lerp( lerpResult307 , ( tex2DNode185 * _IrisExtraColorAmountA ) , temp_output_368_0);
				float dotResult340 = dot( reflect( _MainLightPosition.xyz , WorldSpaceViewDirection ) , IN.ase_normal );
				float clampResult343 = clamp( ( 1.0 - (dotResult340*_CausticScale + _CausticOffset) ) , 0.0 , 1.0 );
				float clampResult354 = clamp( ( _CausticPower * clampResult343 ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( ( (( _UseCustomPupil )?( clampResult281 ):( temp_cast_1 )) * lerpResult314 * ( lerpResult314 + ( temp_output_368_0 * clampResult354 ) ) ) , ( tex2DNode166.r * _RingColorAmountA ) , ( tex2DNode166.r * _RingColorAmountA.a ));
				
				float2 uv_NormalMapBase138 = IN.ase_texcoord7.xy;
				float3 lerpResult139 = lerp( float3(0,0,1) , UnpackNormalScale( tex2D( _NormalMapBase, uv_NormalMapBase138 ), 1.0f ) , _LensPush);
				
				float4 clampResult51 = clamp( ( tex2DNode166.b * clampResult354 * float4( _MainLightColor.rgb , 0.0 ) * _MainLightColor.a * lerpResult310 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult160 = lerp( clampResult51 , ( _IrisGlow * lerpResult310 * pow( tex2DNode166.b , 3.0 ) ) , ( _IrisGlow / 10.0 ));
				
				float lerpResult135 = lerp( _EyeBallColorGlossA.a , ( tex2DNode166.b * _LensGloss ) , tex2DNode166.b);
				
				float3 Albedo = ( _BoostEyeWhite * ( 1.0 - tex2DNode166.b ) * lerpResult310 ).rgb;
				float3 Normal = lerpResult139;
				float3 Emission = lerpResult160.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = lerpResult135;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float3 BakedGI = 0;

				InputData inputData;
				inputData.positionWS = WorldSpacePosition;

				#ifdef _NORMALMAP
					inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldSpaceNormal;
					#else
						inputData.normalWS = normalize(WorldSpaceNormal);
					#endif
				#endif

				inputData.viewDirectionWS = WorldSpaceViewDirection;
				inputData.shadowCoord = IN.shadowCoord;

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				
				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex ShadowPassVertex
			#pragma fragment ShadowPassFragment


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			CBUFFER_START( UnityPerMaterial )
			float _BoostEyeWhite;
			float _UseCustomPupil;
			half _PupilSize;
			float _PupilHeight1Width1;
			float _ParalaxH;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float _InvertCustomPupil;
			float _CustomPupilRotateSpeed;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _IrisBaseColor;
			float _IrisSize;
			float _IrisRotateSpeed;
			float4 _IrisExtraColorAmountA;
			float _CausticPower;
			float _CausticScale;
			float _CausticOffset;
			float4 _RingColorAmountA;
			float _LensPush;
			float _IrisGlow;
			float _LensGloss;
			CBUFFER_END


			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			
			float3 _LightDirection;

			VertexOutput ShadowPassVertex( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				o.clipPos = clipPos;

				return o;
			}

			half4 ShadowPassFragment(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			CBUFFER_START( UnityPerMaterial )
			float _BoostEyeWhite;
			float _UseCustomPupil;
			half _PupilSize;
			float _PupilHeight1Width1;
			float _ParalaxH;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float _InvertCustomPupil;
			float _CustomPupilRotateSpeed;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _IrisBaseColor;
			float _IrisSize;
			float _IrisRotateSpeed;
			float4 _IrisExtraColorAmountA;
			float _CausticPower;
			float _CausticScale;
			float _CausticOffset;
			float4 _RingColorAmountA;
			float _LensPush;
			float _IrisGlow;
			float _LensGloss;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			sampler2D _EyeExtrasMask;
			sampler2D _CustomPupil;
			sampler2D _IrisExtraDetail;
			CBUFFER_START( UnityPerMaterial )
			float _BoostEyeWhite;
			float _UseCustomPupil;
			half _PupilSize;
			float _PupilHeight1Width1;
			float _ParalaxH;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float _InvertCustomPupil;
			float _CustomPupilRotateSpeed;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _IrisBaseColor;
			float _IrisSize;
			float _IrisRotateSpeed;
			float4 _IrisExtraColorAmountA;
			float _CausticPower;
			float _CausticScale;
			float _CausticOffset;
			float4 _RingColorAmountA;
			float _LensPush;
			float _IrisGlow;
			float _LensGloss;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_EyeExtrasMask166 = IN.ase_texcoord.xy;
				float4 tex2DNode166 = tex2D( _EyeExtrasMask, uv_EyeExtrasMask166 );
				float temp_output_151_0 = ( 100.0 - _PupilSize );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float3 ase_worldTangent = IN.ase_texcoord1.xyz;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset376 = ParallaxOffset( _ParalaxH , _PupilParallaxHeight , ase_tanViewDir );
				float2 uv0147 = IN.ase_texcoord.xy * appendResult152.xy + paralaxOffset376;
				float clampResult122 = clamp( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) , 0.0 , 1.0 );
				float4 temp_cast_1 = (clampResult122).xxxx;
				float temp_output_269_0 = ( 10.0 - (-20.0 + (_PupilSize - 0.0) * (20.0 - -20.0) / (84.0 - 0.0)) );
				float2 temp_cast_2 = (temp_output_269_0).xx;
				float2 temp_cast_3 = (( ( 1.0 - temp_output_269_0 ) / 2.0 )).xx;
				float2 uv0267 = IN.ase_texcoord.xy * temp_cast_2 + temp_cast_3;
				float mulTime278 = _Time.y * _CustomPupilRotateSpeed;
				float cos274 = cos( mulTime278 );
				float sin274 = sin( mulTime278 );
				float2 rotator274 = mul( uv0267 - float2( 0.5,0.5 ) , float2x2( cos274 , -sin274 , sin274 , cos274 )) + float2( 0.5,0.5 );
				float4 tex2DNode265 = tex2D( _CustomPupil, rotator274 );
				float4 temp_cast_4 = (_PupilSharpness).xxxx;
				float4 clampResult281 = clamp( pow( ( (( _InvertCustomPupil )?( ( 1.0 - tex2DNode265 ) ):( tex2DNode265 )) + ( 1.0 - tex2DNode166.b ) ) , temp_cast_4 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult304 = lerp( ( _EyeBallColorGlossA * ( 1.0 - tex2DNode166.b ) ) , _EyeVeinColorAmountA , ( _EyeVeinColorAmountA.a * tex2DNode166.g ));
				float4 lerpResult307 = lerp( lerpResult304 , _IrisBaseColor , tex2DNode166.b);
				float temp_output_260_0 = ( 10.0 - _IrisSize );
				float2 temp_cast_5 = (temp_output_260_0).xx;
				float2 temp_cast_6 = (( ( 1.0 - temp_output_260_0 ) / 2.0 )).xx;
				float2 uv0190 = IN.ase_texcoord.xy * temp_cast_5 + temp_cast_6;
				float mulTime320 = _Time.y * _IrisRotateSpeed;
				float cos319 = cos( mulTime320 );
				float sin319 = sin( mulTime320 );
				float2 rotator319 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos319 , -sin319 , sin319 , cos319 )) + float2( 0.5,0.5 );
				float4 tex2DNode185 = tex2D( _IrisExtraDetail, rotator319 );
				float temp_output_368_0 = pow( ( tex2DNode185.r * _IrisExtraColorAmountA.a * tex2DNode166.b ) , 2.0 );
				float4 lerpResult314 = lerp( lerpResult307 , ( tex2DNode185 * _IrisExtraColorAmountA ) , temp_output_368_0);
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float dotResult340 = dot( reflect( _MainLightPosition.xyz , ase_worldViewDir ) , IN.ase_normal );
				float clampResult343 = clamp( ( 1.0 - (dotResult340*_CausticScale + _CausticOffset) ) , 0.0 , 1.0 );
				float clampResult354 = clamp( ( _CausticPower * clampResult343 ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( ( (( _UseCustomPupil )?( clampResult281 ):( temp_cast_1 )) * lerpResult314 * ( lerpResult314 + ( temp_output_368_0 * clampResult354 ) ) ) , ( tex2DNode166.r * _RingColorAmountA ) , ( tex2DNode166.r * _RingColorAmountA.a ));
				
				float4 clampResult51 = clamp( ( tex2DNode166.b * clampResult354 * float4( _MainLightColor.rgb , 0.0 ) * _MainLightColor.a * lerpResult310 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult160 = lerp( clampResult51 , ( _IrisGlow * lerpResult310 * pow( tex2DNode166.b , 3.0 ) ) , ( _IrisGlow / 10.0 ));
				
				
				float3 Albedo = ( _BoostEyeWhite * ( 1.0 - tex2DNode166.b ) * lerpResult310 ).rgb;
				float3 Emission = lerpResult160.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero , One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70106

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag


			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			

			sampler2D _EyeExtrasMask;
			sampler2D _CustomPupil;
			sampler2D _IrisExtraDetail;
			CBUFFER_START( UnityPerMaterial )
			float _BoostEyeWhite;
			float _UseCustomPupil;
			half _PupilSize;
			float _PupilHeight1Width1;
			float _ParalaxH;
			float _PupilParallaxHeight;
			float _PupilSharpness;
			float _InvertCustomPupil;
			float _CustomPupilRotateSpeed;
			float4 _EyeBallColorGlossA;
			float4 _EyeVeinColorAmountA;
			float4 _IrisBaseColor;
			float _IrisSize;
			float _IrisRotateSpeed;
			float4 _IrisExtraColorAmountA;
			float _CausticPower;
			float _CausticScale;
			float _CausticOffset;
			float4 _RingColorAmountA;
			float _LensPush;
			float _IrisGlow;
			float _LensGloss;
			CBUFFER_END


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float3 ase_normal : NORMAL;
			};

			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				o.ase_texcoord4.xyz = ase_worldPos;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );
				o.clipPos = vertexInput.positionCS;
				return o;
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				float2 uv_EyeExtrasMask166 = IN.ase_texcoord.xy;
				float4 tex2DNode166 = tex2D( _EyeExtrasMask, uv_EyeExtrasMask166 );
				float temp_output_151_0 = ( 100.0 - _PupilSize );
				float2 appendResult149 = (float2(( temp_output_151_0 / 2.0 ) , ( temp_output_151_0 / ( _PupilHeight1Width1 * 2.0 ) )));
				float4 appendResult152 = (float4(temp_output_151_0 , ( temp_output_151_0 / _PupilHeight1Width1 ) , 0.0 , 0.0));
				float3 ase_worldTangent = IN.ase_texcoord1.xyz;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldPos = IN.ase_texcoord4.xyz;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset376 = ParallaxOffset( _ParalaxH , _PupilParallaxHeight , ase_tanViewDir );
				float2 uv0147 = IN.ase_texcoord.xy * appendResult152.xy + paralaxOffset376;
				float clampResult122 = clamp( pow( distance( appendResult149 , uv0147 ) , ( _PupilSharpness * 7.0 ) ) , 0.0 , 1.0 );
				float4 temp_cast_1 = (clampResult122).xxxx;
				float temp_output_269_0 = ( 10.0 - (-20.0 + (_PupilSize - 0.0) * (20.0 - -20.0) / (84.0 - 0.0)) );
				float2 temp_cast_2 = (temp_output_269_0).xx;
				float2 temp_cast_3 = (( ( 1.0 - temp_output_269_0 ) / 2.0 )).xx;
				float2 uv0267 = IN.ase_texcoord.xy * temp_cast_2 + temp_cast_3;
				float mulTime278 = _Time.y * _CustomPupilRotateSpeed;
				float cos274 = cos( mulTime278 );
				float sin274 = sin( mulTime278 );
				float2 rotator274 = mul( uv0267 - float2( 0.5,0.5 ) , float2x2( cos274 , -sin274 , sin274 , cos274 )) + float2( 0.5,0.5 );
				float4 tex2DNode265 = tex2D( _CustomPupil, rotator274 );
				float4 temp_cast_4 = (_PupilSharpness).xxxx;
				float4 clampResult281 = clamp( pow( ( (( _InvertCustomPupil )?( ( 1.0 - tex2DNode265 ) ):( tex2DNode265 )) + ( 1.0 - tex2DNode166.b ) ) , temp_cast_4 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult304 = lerp( ( _EyeBallColorGlossA * ( 1.0 - tex2DNode166.b ) ) , _EyeVeinColorAmountA , ( _EyeVeinColorAmountA.a * tex2DNode166.g ));
				float4 lerpResult307 = lerp( lerpResult304 , _IrisBaseColor , tex2DNode166.b);
				float temp_output_260_0 = ( 10.0 - _IrisSize );
				float2 temp_cast_5 = (temp_output_260_0).xx;
				float2 temp_cast_6 = (( ( 1.0 - temp_output_260_0 ) / 2.0 )).xx;
				float2 uv0190 = IN.ase_texcoord.xy * temp_cast_5 + temp_cast_6;
				float mulTime320 = _Time.y * _IrisRotateSpeed;
				float cos319 = cos( mulTime320 );
				float sin319 = sin( mulTime320 );
				float2 rotator319 = mul( uv0190 - float2( 0.5,0.5 ) , float2x2( cos319 , -sin319 , sin319 , cos319 )) + float2( 0.5,0.5 );
				float4 tex2DNode185 = tex2D( _IrisExtraDetail, rotator319 );
				float temp_output_368_0 = pow( ( tex2DNode185.r * _IrisExtraColorAmountA.a * tex2DNode166.b ) , 2.0 );
				float4 lerpResult314 = lerp( lerpResult307 , ( tex2DNode185 * _IrisExtraColorAmountA ) , temp_output_368_0);
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float dotResult340 = dot( reflect( _MainLightPosition.xyz , ase_worldViewDir ) , IN.ase_normal );
				float clampResult343 = clamp( ( 1.0 - (dotResult340*_CausticScale + _CausticOffset) ) , 0.0 , 1.0 );
				float clampResult354 = clamp( ( _CausticPower * clampResult343 ) , 0.0 , 1.0 );
				float4 lerpResult310 = lerp( ( (( _UseCustomPupil )?( clampResult281 ):( temp_cast_1 )) * lerpResult314 * ( lerpResult314 + ( temp_output_368_0 * clampResult354 ) ) ) , ( tex2DNode166.r * _RingColorAmountA ) , ( tex2DNode166.r * _RingColorAmountA.a ));
				
				
				float3 Albedo = ( _BoostEyeWhite * ( 1.0 - tex2DNode166.b ) * lerpResult310 ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	//CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=17500
1927;7;1906;1015;-4346.831;944.05;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;377;-1300.485,-1779.168;Inherit;False;1652.929;466.989;Size Control;9;274;267;278;277;270;268;269;271;91;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1250.485,-1404.723;Half;False;Property;_PupilSize;PupilSize;17;0;Create;True;0;0;False;0;70;44.5;0.001;89;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;271;-937.5678,-1650.423;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;84;False;3;FLOAT;-20;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;269;-724.2214,-1610.505;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;380;452.7032,-391.916;Inherit;False;1289.046;546.6973;Size and Iriz/Lens Control - Rotation FX;10;259;320;190;319;226;158;20;321;260;258;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;226;502.8837,-243.9664;Float;False;Property;_IrisSize;IrisSize;15;0;Create;True;0;0;False;0;4.4;5.8;-20;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;268;-565.5194,-1710.454;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;165;126.0547,175.9008;Inherit;False;1788.775;596.6456;IrisConeCaustics - Fake caustic Effect;13;354;353;50;343;341;344;365;340;367;366;337;338;339;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;-402.1608,-1649.605;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;260;817.9438,-267.9163;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-615.8256,-1493.539;Float;False;Property;_CustomPupilRotateSpeed;CustomPupilRotateSpeed;23;0;Create;True;0;0;False;0;0;2.14;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;338;155.9428,248.1877;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;339;159.458,445.0288;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;267;-244.3946,-1634.304;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;258;1007.382,-341.916;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;341;153.5406,616.7927;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;164;378.1715,-1420.241;Inherit;False;2247.17;550.2261;Pupil;14;151;156;153;157;148;154;152;149;147;146;155;122;213;214;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ReflectOpNode;337;419.892,337.7573;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;278;-326.0627,-1458.462;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;168;-361.9856,-847.0782;Inherit;False;803.1489;1005.685;Inputs;8;133;126;170;166;303;305;306;311;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;366;498.9249,569.83;Float;False;Property;_CausticScale;CausticScale;14;0;Create;True;0;0;False;0;1;1.68;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;259;1166.043,-317.7626;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;378;526.427,-1771.338;Inherit;False;2122.931;336.1;Custom Pupil Switching;7;272;279;273;280;282;281;265;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;321;511.783,39.78118;Float;False;Property;_IrisRotateSpeed;IrisRotateSpeed;16;0;Create;True;0;0;False;0;0;0.46;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;488.3008,660.276;Float;False;Property;_CausticOffset;CausticOffset;13;0;Create;True;0;0;False;0;1;1.47;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;274;35.82745,-1643.017;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;340;674.9529,368.7878;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;783.0623,-1334.448;Inherit;False;2;0;FLOAT;100;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;445.1921,-1031.941;Float;False;Property;_PupilHeight1Width1;Pupil Height>1/Width<1;18;0;Create;True;0;0;False;0;1;6.17;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;372;-516.0597,-2177.189;Inherit;False;1316.846;355.723;Parralax;4;376;375;374;373;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;190;1297.989,-249.0651;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,5;False;1;FLOAT2;0.5,0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;320;1014.779,-35.7908;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;365;886.8799,370.4568;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1.54;False;2;FLOAT;1.62;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;170.8089,-2044.893;Float;False;Property;_PupilParallaxHeight;PupilParallaxHeight;24;0;Create;True;0;0;False;0;1.4;1.45;-4;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;153;1035.486,-1301.668;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;803.8835,-1004.653;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;374;-466.0598,-2005.466;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;265;576.427,-1721.338;Inherit;True;Property;_CustomPupil;CustomPupil;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;af50dd7b02abcc04f9f1d88772c41b91;af50dd7b02abcc04f9f1d88772c41b91;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;375;229.5917,-2127.189;Float;False;Property;_ParalaxH;ParalaxH;25;0;Create;True;0;0;False;0;-0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;166;-358.276,-237.6519;Inherit;True;Property;_EyeExtrasMask;EyeExtrasMask;2;1;[NoScaleOffset];Create;True;0;0;False;0;-1;d0431c3a16ed8b54c8d648bb79ca09a5;7279c4b0bec10f442a956ce8acc2046d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;154;1146.966,-1003.015;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;305;17.00527,-702.1861;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;133;-291.8356,-797.0782;Float;False;Property;_EyeBallColorGlossA;EyeBallColor-Gloss(A);4;0;Create;True;0;0;False;0;1,1,1,0.878;0,0,0,0.116;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;379;1733.495,-835.0886;Inherit;False;659.4635;883.3157;Iris Color and mixing;7;307;312;313;186;315;185;187;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;344;1109.448,385.5598;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;376;584.7862,-2038.779;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;152;1197.952,-1361.842;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;272;1132.713,-1661.383;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;319;1528.75,-142.6165;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;1109.383,-1160.573;Inherit;False;2;0;FLOAT;2;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;170;-301.2955,-613.2215;Float;False;Property;_EyeVeinColorAmountA;EyeVeinColor-Amount(A);7;0;Create;True;0;0;False;0;0.375,0,0,0;0,0.5034485,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;24.12505,-570.8032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1213.673,264.795;Float;False;Property;_CausticPower;CausticPower;12;0;Create;True;0;0;False;0;0.3;0.784;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;185;1792.22,-493.9084;Inherit;True;Property;_IrisExtraDetail;IrisExtraDetail;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;7b7c97e104d9817418725e17f5ca2659;f6339c90c4ecdb345b2c589184d78f43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;187;1783.495,-158.7729;Float;False;Property;_IrisExtraColorAmountA;IrisExtraColor-Amount(A);6;0;Create;True;0;0;False;0;0.1470588,0.1024192,0.06812285,0.441;0,0.6689661,1,0.666;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;149;1383.024,-1104.371;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;147;1392.624,-1370.241;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;213;1646.353,-1007.836;Float;False;Property;_PupilSharpness;PupilSharpness;19;0;Create;True;0;0;False;0;5;0.82;0.1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;273;1335.601,-1698.169;Float;False;Property;_InvertCustomPupil;InvertCustomPupil?;22;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;343;1318.027,355.64;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;279;1342.691,-1545.552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;232.9371,-765.0026;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;2223.958,-237.1031;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;169;2555.364,-770.5315;Inherit;False;2125.866;921.7941;Mixing;16;159;160;161;51;18;26;134;135;103;181;284;285;286;310;314;368;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;304;888.5789,-728.1098;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;1944.353,-998.8357;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;146;1744.878,-1265.542;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;126;-293.1781,-437.5083;Float;False;Property;_IrisBaseColor;IrisBaseColor;5;0;Create;True;0;0;False;0;0.8161765,0.4123098,0.1020221,0;0,0.2857506,0.8455882,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;280;1644.139,-1573.546;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;353;1506.526,349.3523;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;307;2162.754,-785.0886;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;354;1701.163,321.1096;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;2211.849,-420.9293;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;155;2064.596,-1271.939;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;368;2614.204,-385.5531;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;282;2118.971,-1568.238;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;281;2474.358,-1678.989;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;370;2905.442,-374.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;314;2720.434,-682.6896;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;122;2450.342,-1246.716;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;266;2774.695,-1510.021;Float;False;Property;_UseCustomPupil;UseCustomPupil?;21;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;369;3071.548,-515.9788;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;311;-331.7957,-30.74805;Float;False;Property;_RingColorAmountA;RingColor-Amount(A);8;0;Create;True;0;0;False;0;0,0,0,0;0,0.8758622,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;2202.901,-547.632;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;3275.843,-715.1325;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;2172.749,-652.2123;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;310;3565.142,-638.1;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;167;3144.018,-1401.414;Inherit;False;836.5276;442.498;FakewLens;4;138;141;139;140;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;285;3928.111,-569.5947;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;284;3929.797,-758.5461;Float;False;Property;_BoostEyeWhite;BoostEyeWhite;20;0;Create;True;0;0;False;0;1;1.326;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;4130.49,-141.9583;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;26;2883.552,-23.85549;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;20;509.524,-59.51176;Float;False;Property;_LensGloss;LensGloss;10;0;Create;True;0;0;False;0;0.98;0.934;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;502.7032,-147.7856;Float;False;Property;_IrisGlow;IrisGlow;9;0;Create;True;0;0;False;0;0;1.67;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;181;3424.897,-349.8592;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;3742.013,-108.759;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;138;3194.018,-1284.083;Inherit;True;Property;_NormalMapBase;NormalMapBase;3;1;[NoScaleOffset];Create;True;0;0;False;0;-1;8ee6d0418eaa08e40ad667b400177c1c;8ee6d0418eaa08e40ad667b400177c1c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;3406.556,-233.4798;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;140;3533.887,-1351.414;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;161;4124.88,-289.5872;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;159;4100.319,-439.6207;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;139;3796.54,-1114.917;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;135;3495.664,-138.4033;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;160;4497.228,-355.3222;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;4531.959,-735.1046;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;141;3194.092,-1079.333;Float;False;Property;_LensPush;LensPush;11;0;Create;True;0;0;False;0;0.64;0.74;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;381;5091.913,-425.2085;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;10;RRF_HumanShaders/EyeShaders/EyeShader_Model2;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;0;Forward;12;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;12;Workflow;1;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;Meta Pass;1;Override Baked GI;0;Vertex Position,InvertActionOnDeselection;1;0;5;True;True;True;True;True;False;;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;382;5091.913,-425.2085;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;383;5091.913,-425.2085;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;384;5091.913,-425.2085;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;385;5091.913,-425.2085;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;4;Universal2D;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;0
WireConnection;271;0;91;0
WireConnection;269;1;271;0
WireConnection;268;0;269;0
WireConnection;270;0;268;0
WireConnection;260;1;226;0
WireConnection;267;0;269;0
WireConnection;267;1;270;0
WireConnection;258;0;260;0
WireConnection;337;0;338;0
WireConnection;337;1;339;0
WireConnection;278;0;277;0
WireConnection;259;0;258;0
WireConnection;274;0;267;0
WireConnection;274;2;278;0
WireConnection;340;0;337;0
WireConnection;340;1;341;0
WireConnection;151;1;91;0
WireConnection;190;0;260;0
WireConnection;190;1;259;0
WireConnection;320;0;321;0
WireConnection;365;0;340;0
WireConnection;365;1;366;0
WireConnection;365;2;367;0
WireConnection;153;0;151;0
WireConnection;153;1;156;0
WireConnection;157;0;156;0
WireConnection;265;1;274;0
WireConnection;154;0;151;0
WireConnection;154;1;157;0
WireConnection;305;0;166;3
WireConnection;344;0;365;0
WireConnection;376;0;375;0
WireConnection;376;1;373;0
WireConnection;376;2;374;0
WireConnection;152;0;151;0
WireConnection;152;1;153;0
WireConnection;272;0;265;0
WireConnection;319;0;190;0
WireConnection;319;2;320;0
WireConnection;148;0;151;0
WireConnection;303;0;170;4
WireConnection;303;1;166;2
WireConnection;185;1;319;0
WireConnection;149;0;148;0
WireConnection;149;1;154;0
WireConnection;147;0;152;0
WireConnection;147;1;376;0
WireConnection;273;0;265;0
WireConnection;273;1;272;0
WireConnection;343;0;344;0
WireConnection;279;0;166;3
WireConnection;306;0;133;0
WireConnection;306;1;305;0
WireConnection;315;0;185;1
WireConnection;315;1;187;4
WireConnection;315;2;166;3
WireConnection;304;0;306;0
WireConnection;304;1;170;0
WireConnection;304;2;303;0
WireConnection;214;0;213;0
WireConnection;146;0;149;0
WireConnection;146;1;147;0
WireConnection;280;0;273;0
WireConnection;280;1;279;0
WireConnection;353;0;50;0
WireConnection;353;1;343;0
WireConnection;307;0;304;0
WireConnection;307;1;126;0
WireConnection;307;2;166;3
WireConnection;354;0;353;0
WireConnection;186;0;185;0
WireConnection;186;1;187;0
WireConnection;155;0;146;0
WireConnection;155;1;214;0
WireConnection;368;0;315;0
WireConnection;282;0;280;0
WireConnection;282;1;213;0
WireConnection;281;0;282;0
WireConnection;370;0;368;0
WireConnection;370;1;354;0
WireConnection;314;0;307;0
WireConnection;314;1;186;0
WireConnection;314;2;368;0
WireConnection;122;0;155;0
WireConnection;266;0;122;0
WireConnection;266;1;281;0
WireConnection;369;0;314;0
WireConnection;369;1;370;0
WireConnection;313;0;166;1
WireConnection;313;1;311;4
WireConnection;103;0;266;0
WireConnection;103;1;314;0
WireConnection;103;2;369;0
WireConnection;312;0;166;1
WireConnection;312;1;311;0
WireConnection;310;0;103;0
WireConnection;310;1;312;0
WireConnection;310;2;313;0
WireConnection;285;0;166;3
WireConnection;51;0;18;0
WireConnection;181;0;166;3
WireConnection;18;0;166;3
WireConnection;18;1;354;0
WireConnection;18;2;26;1
WireConnection;18;3;26;2
WireConnection;18;4;310;0
WireConnection;134;0;166;3
WireConnection;134;1;20;0
WireConnection;161;0;158;0
WireConnection;159;0;158;0
WireConnection;159;1;310;0
WireConnection;159;2;181;0
WireConnection;139;0;140;0
WireConnection;139;1;138;0
WireConnection;139;2;141;0
WireConnection;135;0;133;4
WireConnection;135;1;134;0
WireConnection;135;2;166;3
WireConnection;160;0;51;0
WireConnection;160;1;159;0
WireConnection;160;2;161;0
WireConnection;286;0;284;0
WireConnection;286;1;285;0
WireConnection;286;2;310;0
WireConnection;381;0;286;0
WireConnection;381;1;139;0
WireConnection;381;2;160;0
WireConnection;381;4;135;0
ASEEND*/
//CHKSM=95E4FEA3ED13DA7F122D2A474930D48A35E5EE0E