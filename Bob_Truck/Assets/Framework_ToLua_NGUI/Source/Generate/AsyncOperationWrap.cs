﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class AsyncOperationWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.AsyncOperation), typeof(System.Object));
		L.RegFunction("New", _CreateAsyncOperation);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("isDone", get_isDone, null);
		L.RegVar("progress", get_progress, null);
		L.RegVar("priority", get_priority, set_priority);
		L.RegVar("allowSceneActivation", get_allowSceneActivation, set_allowSceneActivation);
		L.RegVar("completed", get_completed, set_completed);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateAsyncOperation(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				UnityEngine.AsyncOperation obj = new UnityEngine.AsyncOperation();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.AsyncOperation.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isDone(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			bool ret = obj.isDone;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isDone on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_progress(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			float ret = obj.progress;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index progress on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_priority(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			int ret = obj.priority;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index priority on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_allowSceneActivation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			bool ret = obj.allowSceneActivation;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index allowSceneActivation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_completed(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action<UnityEngine.AsyncOperation>)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_priority(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.priority = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index priority on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_allowSceneActivation(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.allowSceneActivation = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index allowSceneActivation on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_completed(IntPtr L)
	{
		try
		{
			UnityEngine.AsyncOperation obj = (UnityEngine.AsyncOperation)ToLua.CheckObject(L, 1, typeof(UnityEngine.AsyncOperation));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'UnityEngine.AsyncOperation.completed' can only appear on the left hand side of += or -= when used outside of the type 'UnityEngine.AsyncOperation'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action<UnityEngine.AsyncOperation> ev = (System.Action<UnityEngine.AsyncOperation>)arg0.func;
				obj.completed += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action<UnityEngine.AsyncOperation> ev = (System.Action<UnityEngine.AsyncOperation>)arg0.func;
				obj.completed -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

