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
  var results = spreadsheet.getName() + "[*]";
  
  var sheets = spreadsheet.getSheets();
  for (var i=0; i<sheets.length; ++i)
  {
    results+= SheetToCSVEx(sheets[i]);
  }
  
  return results;
}

function SheetToCSVEx(sheet) 
{
  // This represents ALL the data
  var range = sheet.getDataRange();
  var values = range.getValues();
  for (var i = 0; i < values.length; i++)
    values[i] = values[i].join("[*]");
  var row = values.join("[ln]");
  return row;
}
