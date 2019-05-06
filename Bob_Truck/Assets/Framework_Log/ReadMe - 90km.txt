2018/04/10 By fireball
- 取消log4net,原因是因为实用性不强
- 使用新版unity的API处理reporter.cs,取消类里诸多的宏限制

2017/12/28 By fireball
- LogViewer/Reporter/Reporter.cs1906行
- 屏蔽不必要的日志

2017/12/11 By fireball
- 更新Unity2017.2，这个版本对web端的支持低了，所以屏蔽掉web检测的代码 
- LogViewer/Reporter/Reporter.cs1954行

2017/11/23 By fireball
- 修改呼出LOG VIEW的方法

2017/9/5 By fireball
- 日志系统需要屏蔽掉webplayer不支持.net2.0 subset的情况
- 取消过滤器（使得不兼容问题更加凸显）#if !UNITY_WEBPLAYER

2017/8/31 By fireball
- Log4net LogViewer Resources构成Framework_Log
- 在Log4net中添加NDebug和Unity3DLogUtility类
- NDebug是整个日志系统的调用接口
- Unity3DLogUtility负责C#代码重定向

- LogViewer使用的第三方插件
- 和NDebug合并，做了兼容，并且通过NDebug和宏OPENLOG统一管理