using UnityEditor;
using UnityEngine;
using System.Collections;
using System.IO;

public class CommandBuildDebug : CommandBuild
{
    static public void BuildAndroid()
	{
        CommandBuild.UnityCfg = "CompileScript/ruby/build_unity_debug.cfg";
		CommandBuild.BuildAndroidImpl();
	}

    static public void BuildIOS()
    {
        CommandBuild.UnityCfg = "CompileScript/ruby/build_unity_debug.cfg";
        CommandBuild.BuildIOSImpl();
    }
}