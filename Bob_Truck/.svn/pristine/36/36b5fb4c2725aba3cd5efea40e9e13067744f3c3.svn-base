function testGetSource()
{
  var res = doGetLanguageSource()
  Logger.log(res);
}

function doGetLanguageSource(e)
{
  var key;
  var version;
  //Logger.log("start");
  
  if (e===undefined || e.parameters===undefined || e.parameters.key===undefined) 
    id = "1nNwzZkSK-olYxOzmqY-pBQFx-PpsdFTXh-daUUN2tMA";
  else 
    id = e.parameters.key;
    
  if (e===undefined || e.parameters===undefined || e.parameters.version===undefined) 
    version = -1;
  else
    version = e.parameters.version;
  
  var currentVersion = getFileLastUpdateTime(id);
  
  if (currentVersion <= version)
     return "";

  var spreadsheet = SpreadsheetApp.openById(id);
  if (spreadsheet===null) return "";
  
  if (spreadsheet.getName().indexOf(LocalizationPrefix)!=0)
    return "";

  var results = "version="+currentVersion+",script_version="+ GetVersion()+",";
  if (e!=undefined && e.parameters!=undefined && e.parameters.justcheck=="true")
  {
    return results;
  }
  
  var sheets = spreadsheet.getSheets();
  for (var i=0; i<sheets.length; ++i)
  {
    var sheetName = sheets[i].getName();
    if (StartsWith(sheetName, "~"))
      continue;
    results+="[i2category]"+sheetName+"[/i2category]";
    results+= SheetToCSV(sheets[i])+"[/i2csv]";
  }
  //Logger.log(results);
  return results;
}

function doGetLanguageSourceEx(e)
{
  var key;
  
  if (e===undefined || e.parameters===undefined || e.parameters.key===undefined) 
    return "";
  else 
    id = e.parameters.key;

  var spreadsheet = SpreadsheetApp.openById(id);
  if (spreadsheet===null || spreadsheet.getName().indexOf(LocalizationPrefix)!=0) 
    return "";

  var currentVersion = getFileLastUpdateTime(id);
  var results = "version="+currentVersion+",script_version="+ GetVersion()+",";
  
  var sheets = spreadsheet.getSheets();
  for (var i=0; i<sheets.length; ++i)
  {
    var sheetName = sheets[i].getName();
    if (StartsWith(sheetName, "~"))
      continue;
    results+="[i2category]"+sheetName+"[/i2category]";
    results+= SheetToCSV(sheets[i])+"[/i2csv]";
  }
  
  return results;
}

function SheetToCSV(sheet) 
{
  // This represents ALL the data
  var range = sheet.getDataRange();
  var values = range.getValues();
  //var formulas = range.getFormulas();

  // In the new format, the Type and Description comes from the notes
  // this section reconstructs those columns before sending the CSV
  if (values[0][1] != "Type")
  {
    var notes = range.getNotes();
    
    values[0][0] = "Description";
    values[0].unshift("Keys","Type");
    
    for (var i=1; i<values.length; ++i)
    {
      var note = notes[i][0];
      var key = values[i][0];
      if (note.indexOf("Type:")==0)
      {
        var iLineEnd = note.indexOf("\n");
        if (iLineEnd<0) iLineEnd = note.length;
        var type = note.substr(5, iLineEnd-5);
        var desc = note.substr(iLineEnd+1);
        if (type[0]==' ') type = type.substr(1, type.length-1);
        values[i][0] = desc;
        values[i].unshift(key, type);
      }
      else
      {
        values[i][0] = note;
        values[i].unshift(key, "");
      }
    }
  }
  
  // Remove any column that starts with ~
  for (var i=values[0].length-1; i>2; i--)
  {
    if (StartsWith(values[0][i], "~"))
    {
      for (var j = 0; j < values.length; j++)
        values[j].splice(i,1);
    }
  }
  
  // Remove any row that starts with ~
  for (var i=values.length-1; i>0; i--)
  {
    if (StartsWith(values[i][0], "~"))
        values.splice(i,1);
  }
  
    
  for (var i = 0; i < values.length; i++)
    values[i] = values[i].join("[*]");
  var row = values.join("[ln]");

  return row;
}

function getFileLastUpdateTime(id)
{
  try
  {
    var file = DriveApp.getFileById(id);
    if (file===null)
      return 0;
    
    var date = file.getLastUpdated();// this is not very accurate
    return date.getTime();
  }
  catch (e)
  {
  }
    
  /*try  // this method is more accurate but requires user to enable Drive SDK on their developer console
  {
    var revisions = Drive.Revisions.list(id);
     Logger.log(JSON.stringify(revisions));
    if (revisions && revisions.items && revisions.items.length > 0)
    {
      var lastRevision = revisions.items.length-1;
      var lastModified = new Date(revisions.items[lastRevision].modifiedDate);
      return lastModified.getTime();
    }
  }
  catch (e)
  {
         Logger.log(e);
  }*/
  
  return 0;
}