/*                  I2 Google Web Service

This is an script used by I2 Localization and I2 Data to access your spreadsheets
without storing the username/password in the app.

By using this Web Service, the plugin is able to access the spreadsheets even after
the game is deployed and running on the device. So, if you make any modification to
your data, the games will automatically update without building it again.

***************************************************************************************

Follow this steps to Install the Web Service.
If you find any issue, here is a step by step guide:
     (also, here is a video showing the steps https://www.youtube.com/watch?v=t-7jx_i1IdM)


1- On the menu, select "Publish" and then "Deploy as web app"

2- In the window that opens
    - click "Save Version"
    - In "Execute app as:"  select "me(your email)"
    - In "Who has access to the app:" select "any one, even anonymous"
    
3- In the new window that opens, Copy the URL at "Current Web App URL".
   That URL will have the format: https://script.google.com/macros/s/XXXXXXXXX/exec
   
   3.1- Depending on your account type, you may get a warning from google saying:
        "This app isn't verified"
        In that case, click "Show advanced" and then "Go to Copy of I2GoogleWebServiceV5 (unsafe)"
        Then grant the webservice permisions (i.e. to create/modify spreadsheets files)

4- In the menu, select "Run" and then "DoGet"

   4.1- (If a dialog is shown) Authorize the script to access your spreadsheets and file date data

5- Paste the URL from step 3 in the "Web Service URL" on the Unity Editor

源是使用的I2Location提供的支持,后来fireball在这个基础上修改过
主要修改如下:
(1)统一的前缀"NKM"
(2)增加新的导出ExportCSVEx,主要负责根据公司自己的规则来导出,并且直接转换为lua
***************************************************************************************/
var LocalizationPrefix = "NKM";

function GetVersion()
{
  return 5;
}

function doGet(e)
{
  var result;
  var action;
  
  if (e===undefined || e.parameters.action==undefined)
    action = "Ping";
  else 
    action = e.parameters.action.toString();
  
  //Logger.log(action);
  switch( action)
  {
    case "Ping" : var result = {}; result["script_version"]=GetVersion(); break;
    
    case "NewSpreadsheet": result = doCreateSpreadsheet(e); break;
      
    case "GetSpreadsheetList": result = doGetSpreadsheetList(e); break;

    case "GetLanguageSource": return ContentService.createTextOutput(doGetLanguageSource(e)).setMimeType(ContentService.MimeType.TEXT);

    case "GetLanguageSourceEx": return ContentService.createTextOutput(doGetLanguageSourceEx(e)).setMimeType(ContentService.MimeType.TEXT);
      
    case "SetLanguageSource" : result = doSetLanguageSource(e); break;
      
    case "Translate" : return ContentService.createTextOutput(doTranslate(e)).setMimeType(ContentService.MimeType.TEXT);
      
    default: result = "unknown action";
  }
  
  var JsonValue = JSON.stringify(result);
  
  return ContentService.createTextOutput(JsonValue.toString()).setMimeType(ContentService.MimeType.JSON);
}

function doPost(e)
{
  return doGet(e);
}