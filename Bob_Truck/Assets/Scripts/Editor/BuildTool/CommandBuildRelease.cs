using UnityEditor;
using UnityEngine;
using System.Collections;
using System.IO;

public class CommandBuildRelease : CommandBuild
{
	public static void BuildAndroid()
	{
        CommandBuild.UnityCfg = "CompileScript/ruby/build_unity_release.cfg";
		CommandBuild.BuildAndroidImpl();
	}

    public static void BuildIOS()
    {
        CommandBuild.UnityCfg = "CompileScript/ruby/build_unity_release.cfg";
        CommandBuild.BuildIOSImpl();
    }
}
