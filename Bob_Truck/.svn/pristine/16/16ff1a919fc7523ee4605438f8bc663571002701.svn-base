function doGetSpreadsheetList()
{
  var result = {};
  var Spreadsheets = DriveApp.getFilesByType(MimeType.GOOGLE_SHEETS);

  while (Spreadsheets.hasNext()) 
  {
    var file = Spreadsheets.next();
    var SpreadSheetName = file.getName();

    if (SpreadSheetName.indexOf(LocalizationPrefix)==0)
    {
      result[SpreadSheetName] = file.getId();
    }
  }
  return result;  
}

function doCreateSpreadsheet(e)
{
  var name = e.parameters.name.toString();
  if (name.indexOf(LocalizationPrefix)!=0)
    name = LocalizationPrefix + " " + name;

  var ssNew = SpreadsheetApp.create(name);
  var sheet = ssNew.getActiveSheet();
  
  sheet.setName("Default");
  
  CSVtoSheet("Default", "Key,Type,Desc,English", ssNew, "Replace");
  
  var result = {};
  result["name"] = name;
  result["id"] = ssNew.getId();
  result["script_version"]=GetVersion();
  
  return result;
}


function BasicEncriptation( data, password )
{
  data = "[Header]" + data;
  var s = "";
  for (var i=0; i<data.length; ++i)
  {
    s += String.fromCharCode(data.charCodeAt(i) + password.charCodeAt(i % password.length));
  }
  return s;
}

function BasicDeEncriptation( data, password )
{
  var s = "";
  for (var i=0; i<data.length; ++i)
    s += String.fromCharCode(data.charCodeAt(i) - password.charCodeAt(i % password.length));
  
  if (s.substr(0, "[Header]".length) != "[Header]")
    return null;
  
  return s.substr("[Header]".length);
}