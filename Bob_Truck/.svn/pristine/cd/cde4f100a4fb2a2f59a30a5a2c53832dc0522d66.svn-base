#if UNITY_EDITOR && UNITY_IPHONE
using UnityEditor.iOS.Xcode;
using System.IO;

public static class DirectoryProcessor
{
    // 拷贝并增加到项目
    public static void CopyAndAddBuildToXcode(PBXProject pbxProject, string targetGuid, string copyDirectoryPath, string buildPath, string currentDirectoryPath, bool needToAddBuild = true)
    {
        string unityDirectoryPath = copyDirectoryPath;
        string xcodeDirectoryPath = buildPath;

        if (!string.IsNullOrEmpty(currentDirectoryPath))
        {
            unityDirectoryPath = Path.Combine(unityDirectoryPath, currentDirectoryPath);
            xcodeDirectoryPath = Path.Combine(xcodeDirectoryPath, currentDirectoryPath);
            Delete(xcodeDirectoryPath);
            Directory.CreateDirectory(xcodeDirectoryPath);
        }

        foreach (string filePath in Directory.GetFiles(unityDirectoryPath))
        {
            //过滤.meta文件
            string extension = Path.GetExtension(filePath);
            if (extension == ExtensionName.META)
                continue;
            //
            if (extension == ExtensionName.ARCHIVE)
            {
                pbxProject.AddBuildProperty(targetGuid, XcodeProjectSetting.LIBRARY_SEARCH_PATHS_KEY, XcodeProjectSetting.PROJECT_ROOT + currentDirectoryPath);
            }

            string fileName = Path.GetFileName(filePath);
            string copyPath = Path.Combine(xcodeDirectoryPath, fileName);

            //有可能是.DS_Store文件，直接过滤
            if (fileName[0] == '.')
                continue;
            File.Delete(copyPath);
            File.Copy(filePath, copyPath);

            if (needToAddBuild)
            {
                string relativePath = Path.Combine(currentDirectoryPath, fileName);
                pbxProject.AddFileToBuild(targetGuid, pbxProject.AddFile(relativePath, relativePath, PBXSourceTree.Source));
            }
        }

        foreach (string directoryPath in Directory.GetDirectories(unityDirectoryPath))
        {
            string directoryName = Path.GetFileName(directoryPath);
            if (!directoryName.Contains(ExtensionName.LANGUAGE))
            {
                bool nextNeedToAddBuild = needToAddBuild;
                if (directoryName.Contains(ExtensionName.FRAMEWORK) || directoryName.Contains(ExtensionName.BUNDLE) || directoryName == XcodeProjectSetting.IMAGE_XCASSETS_DIRECTORY_NAME)
                {
                    nextNeedToAddBuild = false;
                }
                CopyAndAddBuildToXcode(pbxProject, targetGuid, copyDirectoryPath, buildPath, Path.Combine(currentDirectoryPath, directoryName), nextNeedToAddBuild);
                if (directoryName.Contains(ExtensionName.FRAMEWORK) || directoryName.Contains(ExtensionName.BUNDLE))
                {
                    string relativePath = Path.Combine(currentDirectoryPath, directoryName);
                    pbxProject.AddFileToBuild(targetGuid, pbxProject.AddFile(relativePath, relativePath, PBXSourceTree.Source));
                    pbxProject.AddBuildProperty(targetGuid, XcodeProjectSetting.FRAMEWORK_SEARCH_PATHS_KEY, XcodeProjectSetting.PROJECT_ROOT + currentDirectoryPath);
                }
            }
            else
            {
                //特殊化处理本地语言，暂时官方PBXProject不支持AddLocalization方法，如果需要，则必须自己扩充
                string relativePath = Path.Combine(currentDirectoryPath, directoryName);
                CopyAndAddBuildToXcode(pbxProject, targetGuid, copyDirectoryPath, buildPath, relativePath, false);
                string[] dirs = Directory.GetDirectories(Path.Combine(xcodeDirectoryPath, directoryName));
                if (dirs.Length > 0)
                {
                    string fileName = Path.GetFileName(Directory.GetFiles(dirs[0], "*.strings")[0]);
                    for (var i = 0; i < dirs.Length; ++i)
                    {
                        string[] files = Directory.GetFiles(dirs[i], "*.strings");
                        //pbxProject.AddLocalization(files[0], fileName, fileName);
                    }
                }
            }
        }
    }

    //拷贝文件夹或者文件
    public static void CopyAndReplace(string sourcePath, string copyPath)
    {
        Delete(copyPath);
        Directory.CreateDirectory(copyPath);
        foreach (var file in Directory.GetFiles(sourcePath))
        {
            if (Path.GetExtension(file) == ExtensionName.META)
                continue;
            File.Copy(file, Path.Combine(copyPath, Path.GetFileName(file)));
        }
        foreach (var dir in Directory.GetDirectories(sourcePath))
        {
            CopyAndReplace(dir, Path.Combine(copyPath, Path.GetFileName(dir)));
        }
    }

    //删除目标文件夹以及文件夹内的所有文件
    public static void Delete(string targetDirectoryPath)
    {
        if (!Directory.Exists(targetDirectoryPath))
            return;
        string[] filePaths = Directory.GetFiles(targetDirectoryPath);
        foreach (string filePath in filePaths)
        {
            File.SetAttributes(filePath, FileAttributes.Normal);
            File.Delete(filePath);
        }
        string[] directoryPaths = Directory.GetDirectories(targetDirectoryPath);
        foreach (string directoryPath in directoryPaths)
        {
            Delete(directoryPath);
        }
        Directory.Delete(targetDirectoryPath, false);
    }
}

#endif