﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class NGameObjectUtilWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(NGameObjectUtil), typeof(System.Object));
		L.RegFunction("SetPosition", SetPosition);
		L.RegFunction("SetRotation", SetRotation);
		L.RegFunction("SetLocalPosition", SetLocalPosition);
		L.RegFunction("SetLocalRotation", SetLocalRotation);
		L.RegFunction("SetScale", SetScale);
		L.RegFunction("SetLineRenderPos", SetLineRenderPos);
		L.RegFunction("RayCastFloor", RayCastFloor);
		L.RegFunction("ScreenPickCastFloor", ScreenPickCastFloor);
		L.RegFunction("CamForwardCastFloor", CamForwardCastFloor);
		L.RegFunction("World3DPos2WorldUIPos", World3DPos2WorldUIPos);
		L.RegFunction("UIPos2ScreenPoint", UIPos2ScreenPoint);
		L.RegFunction("ScreenPoint2UIPos", ScreenPoint2UIPos);
		L.RegFunction("IsWorld3DPosInScreen", IsWorld3DPosInScreen);
		L.RegFunction("ScreenPickCastFloorByLayer", ScreenPickCastFloorByLayer);
		L.RegFunction("ToLocalPos", ToLocalPos);
		L.RegFunction("GetMeshRendererMaterials", GetMeshRendererMaterials);
		L.RegFunction("SetMeshRendererMaterials", SetMeshRendererMaterials);
		L.RegFunction("SetMaterialsColor", SetMaterialsColor);
		L.RegFunction("SetMaterialsFloat", SetMaterialsFloat);
		L.RegFunction("SetMaterialsTexture", SetMaterialsTexture);
		L.RegFunction("SetUITextureMainTex", SetUITextureMainTex);
		L.RegFunction("SendMessage", SendMessage);
		L.RegFunction("SetFlip", SetFlip);
		L.RegFunction("GetCenter", GetCenter);
		L.RegFunction("SetButtonState", SetButtonState);
		L.RegFunction("New", _CreateNGameObjectUtil);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNGameObjectUtil(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				NGameObjectUtil obj = new NGameObjectUtil();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: NGameObjectUtil.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPosition(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			NGameObjectUtil.SetPosition(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetRotation(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			float arg4 = (float)LuaDLL.luaL_checknumber(L, 5);
			NGameObjectUtil.SetRotation(arg0, arg1, arg2, arg3, arg4);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLocalPosition(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			NGameObjectUtil.SetLocalPosition(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLocalRotation(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 4)
			{
				UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
				float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
				NGameObjectUtil.SetLocalRotation(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (count == 5)
			{
				UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
				float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
				float arg4 = (float)LuaDLL.luaL_checknumber(L, 5);
				NGameObjectUtil.SetLocalRotation(arg0, arg1, arg2, arg3, arg4);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NGameObjectUtil.SetLocalRotation");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetScale(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			NGameObjectUtil.SetScale(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLineRenderPos(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			float arg4 = (float)LuaDLL.luaL_checknumber(L, 5);
			NGameObjectUtil.SetLineRenderPos(arg0, arg1, arg2, arg3, arg4);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RayCastFloor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Ray arg0 = ToLua.ToRay(L, 1);
			UnityEngine.Plane arg1 = StackTraits<UnityEngine.Plane>.Check(L, 2);
			UnityEngine.Vector3 o = NGameObjectUtil.RayCastFloor(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ScreenPickCastFloor(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				UnityEngine.Vector3 o = NGameObjectUtil.ScreenPickCastFloor(arg0, arg1);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 4)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
				UnityEngine.Camera arg3 = (UnityEngine.Camera)ToLua.CheckObject(L, 4, typeof(UnityEngine.Camera));
				UnityEngine.Vector3 o = NGameObjectUtil.ScreenPickCastFloor(arg0, arg1, arg2, arg3);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NGameObjectUtil.ScreenPickCastFloor");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CamForwardCastFloor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			UnityEngine.Vector3 o = NGameObjectUtil.CamForwardCastFloor();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int World3DPos2WorldUIPos(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			UnityEngine.Vector2 o = NGameObjectUtil.World3DPos2WorldUIPos(arg0, arg1, arg2);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIPos2ScreenPoint(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			UnityEngine.Vector2 o = NGameObjectUtil.UIPos2ScreenPoint(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ScreenPoint2UIPos(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			UnityEngine.Vector2 o = NGameObjectUtil.ScreenPoint2UIPos(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsWorld3DPosInScreen(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			bool o = NGameObjectUtil.IsWorld3DPosInScreen(arg0, arg1, arg2);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ScreenPickCastFloorByLayer(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				UnityEngine.Vector3 o = NGameObjectUtil.ScreenPickCastFloorByLayer(arg0, arg1, arg2);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 4)
			{
				float arg0 = (float)LuaDLL.luaL_checknumber(L, 1);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				UnityEngine.Camera arg3 = (UnityEngine.Camera)ToLua.CheckObject(L, 4, typeof(UnityEngine.Camera));
				UnityEngine.Vector3 o = NGameObjectUtil.ScreenPickCastFloorByLayer(arg0, arg1, arg2, arg3);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NGameObjectUtil.ScreenPickCastFloorByLayer");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToLocalPos(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 1);
			UnityEngine.Transform arg1 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 2);
			UnityEngine.Vector3 o = NGameObjectUtil.ToLocalPos(arg0, arg1);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetMeshRendererMaterials(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.MeshRenderer arg0 = (UnityEngine.MeshRenderer)ToLua.CheckObject<UnityEngine.MeshRenderer>(L, 1);
			System.Collections.Generic.List<UnityEngine.Material> o = NGameObjectUtil.GetMeshRendererMaterials(arg0);
			ToLua.PushSealed(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetMeshRendererMaterials(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.MeshRenderer arg0 = (UnityEngine.MeshRenderer)ToLua.CheckObject<UnityEngine.MeshRenderer>(L, 1);
			System.Collections.Generic.List<UnityEngine.Material> arg1 = (System.Collections.Generic.List<UnityEngine.Material>)ToLua.CheckObject(L, 2, typeof(System.Collections.Generic.List<UnityEngine.Material>));
			NGameObjectUtil.SetMeshRendererMaterials(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetMaterialsColor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			UnityEngine.Material arg0 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg3 = (float)LuaDLL.luaL_checknumber(L, 4);
			float arg4 = (float)LuaDLL.luaL_checknumber(L, 5);
			NGameObjectUtil.SetMaterialsColor(arg0, arg1, arg2, arg3, arg4);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetMaterialsFloat(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Material arg0 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 3);
			NGameObjectUtil.SetMaterialsFloat(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetMaterialsTexture(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			UnityEngine.Material arg0 = (UnityEngine.Material)ToLua.CheckObject<UnityEngine.Material>(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			string arg2 = ToLua.CheckString(L, 3);
			NGameObjectUtil.SetMaterialsTexture(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetUITextureMainTex(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UITexture arg0 = (UITexture)ToLua.CheckObject<UITexture>(L, 1);
			UnityEngine.Transform arg1 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 2);
			UnityEngine.Camera o = NGameObjectUtil.SetUITextureMainTex(arg0, arg1);
			ToLua.PushSealed(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SendMessage(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				string arg1 = ToLua.CheckString(L, 2);
				NGameObjectUtil.SendMessage(arg0, arg1);
				return 0;
			}
			else if (count == 3)
			{
				UnityEngine.GameObject arg0 = (UnityEngine.GameObject)ToLua.CheckObject(L, 1, typeof(UnityEngine.GameObject));
				string arg1 = ToLua.CheckString(L, 2);
				object arg2 = ToLua.ToVarObject(L, 3);
				NGameObjectUtil.SendMessage(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: NGameObjectUtil.SendMessage");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetFlip(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UISprite arg0 = (UISprite)ToLua.CheckObject<UISprite>(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			NGameObjectUtil.SetFlip(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetCenter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 1);
			UnityEngine.Vector3 o = NGameObjectUtil.GetCenter(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetButtonState(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UIButton arg0 = (UIButton)ToLua.CheckObject<UIButton>(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			NGameObjectUtil.SetButtonState(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}
