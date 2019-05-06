2018/03/22 By Gonggaohai
- NGUI 添加创建Button 和 Edit 的组合控件 菜单
- /trunk/client/Assets/Framework_ToLua_NGUI/NGUI/Scripts/Editor/NGUIMenu.cs 125行

2018/03/09 By fireball
- 屏蔽NGUI中UILabel的选项,默认一定使用NGUI的动态字体
- UILabelInspector.cs 35 //mFontType = (bit != null && bit.objectReferenceValue != null) ? FontType.NGUI : FontType.Unity; //一定使用NGUI动态字体0-
- UILabelInspector.cs 78 //mFontType = (FontType)EditorGUILayout.EnumPopup(mFontType, "DropDown", GUILayout.Width(74f));
- Assets/Framework_ToLua_NGUI/NGUI/Scripts/Editor/ComponentSelector.cs 修改editor兼容问题

2018/03/08 By chenpindong
- NGUI/Scripts/Interaction/UIDragScrollView.cs
- OnPress,OnDrag,OnScroll方法添加public权限，外部需要使用
- public void OnPress (bool pressed) -- line.99
- public void OnDrag (Vector2 delta) -- line.126
- public void OnScroll (float delta) -- line.136

2018/1/25 By fireball
- 更新ToLua到最新版本 1.0.7.389

2018/1/15 By fireball
- 在LuaConst.cs添加VSCODE调试相关的接口openLuaVSCodeDebugger
- 并用宏区分,在Release版本中关闭调试

2018/01/03 By chenjun
- lua读取bundle功能实现 使用说明：点击Lua/Build bundle files not jit 然后点击Project Tools/Build Tools/Build Windows AssetBundle 生成bundle 最后在NmanagerResourceModule中修改RunBundle为true

2017/12/25 By fireball
- 在itween中添加#pragma warning disable 0618,屏蔽这个警告

2017/12/21 By fireball
- ToLua/Editor/ToLuaMenu.cs
- private static bool beCheck = false;
- 暂时取消检测自动生成的功能，反复弹非常讨厌！而且检测机制太鸡肋！
- ResourcesAssets修改复制脚本的位置到这个目录下，为了热更新做准备
- 更新ToLua到最新版本 1.0.7.386

2017/12/11 By fireball
- 更新ToLua到最新版本 1.0.7.384

2017/10/9 By fireball
- 更新ToLua到最新版本 1.0.7.377
- ToLua/Editor/ToLuaMenu.cs
- 屏蔽两个功能 
- [MenuItem("Lua/Gen BaseType Wrap", false, 101)]
- [MenuItem("Lua/Clear BaseType Wrap", false, 102)]
- 他们和2017/8/31修改的功能有冲突，如果需要对BASETYPE做生成，需要把这个修改回来再做一次
- 所以针对BaseType的Wrap的使用，最佳方案是使用官方的，不要自己生成，所以屏蔽掉这两个功能

2017/9/11 By fireball
- 更新NGUI到3.11.4版本，这个版本和之前的3.11.1没有太大的区别具体看NGUI版本更新日志

2017/9/11 By fireball
- 解决新版unity和NGUI不兼容的问题
- UIAtlasMaker.cs
- GUILayout.BeginHorizontal("TextArea", GUILayout.MinHeight(20f)); -- line.991
- NGUIEditorTools.cs 
- EditorGUILayout.BeginHorizontal("TextArea", GUILayout.MinHeight(10f)); -- line.1362

2017/9/9 By fireball
- ToLua/Editor/ToLuaMenu.cs
- 添加清理lua的弹框提示
-	public static void ClearLuaFiles()
-    {
-        ClearAllLuaFiles();
-        EditorUtility.DisplayDialog("信息", "清理完毕！", "确定");
-        AssetDatabase.Refresh();
-    }

2017/8/31 By fireball
- ToLua/Editor/ToLuaMenu.cs
- string[] strs = name.Split('.');
- int length = strs.Length;
- wrapName = strs[length - 1];
- 导出的luawrap名字直接为unity类的名字，之前那种做法太长，不利于阅读和开发
- 但是这样就默认关闭代码限制重名的问题了，需要规范来限制重名问题

2017/8/31 By fireball
- LuaConst.cs
- 修改其中的路径，并且重新规划整个ToLua在Framework_ToLua_NGUI中的路径

2017/8/22 By fireball
- 修改NGUI中的NGUIJson.cs
- （1）LoadSpriteData中添加对生成JSON文件的格式判断
-   if((int)jsonString[0] == 65279)
-			jsonString = jsonString.Substring(1);
- （2）LoadSpriteData中添加对TP数据的维护
-	newSprite.borderLeft = int.Parse(frame["bl"].ToString());
-	newSprite.borderRight = int.Parse(frame["br"].ToString());
-	newSprite.borderBottom = int.Parse(frame["bb"].ToString());
-	newSprite.borderTop = int.Parse(frame["bt"].ToString());

2017/8/21 By fireball
- 添加NGUI 3.11.1版本
- 添加ToLua 1.0.7.356版本