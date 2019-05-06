function doSetLanguageSource(e)
{
  //var id = "1nNwzZkSK-olYxOzmqY-pBQFx-PpsdFTXh-daUUN2tMA";
  var id = e.parameters.key.toString();
    
  var spreadsheet = SpreadsheetApp.openById(id);
  if (spreadsheet===null) return false;
  
  if (spreadsheet.getName().indexOf(LocalizationPrefix)!=0)
    return false;  
  
  //var updateMode = "AddNewTerms";//"Replace";
  //var CSVstring = "Category<I2Loc>Key[*]Type[*]Desc[*]English[*]Spanish[*]Arabic[*]$TestLang[ln]Term2[*]Text[*][*]Anotherthis is'frank' hey [font] and [/final] more <tag></tag> text 524[*]Anotherthis is'frank' hey [font] and [/final] more <tag></tag> text 524[*]Anotherthis is'frank' hey [font] and [/final] more <tag></tag> text 524[*]Anotherthis is'frank' hey [font] and [/final] more <tag></tag> text524<I2Loc>Default<I2Loc>Key[*]Type[*]Desc[*]English[*]Spanish[*]Arabic[*]$TestLang[ln]Term1[*]Text[*][*]My text524[*]My text524[*]My text524[*]My text524[ln]Term4[*]Text[*][*]''SpecialCases[*]'''SpecialCases'[*]''SpecialCases'[*]'=SpecialCases";
  //var CSVstring = "Default<I2Loc>Key[*]Type[*]Desc[*]English[*]French[*]German[*]Spanish[*]Japanese[*]Korean[*]Portuguese (Brazil)[*]Russian[*]Italian[*]Chinese (Simplified)[ln]TestPhrase1[*]Text[*][*]T1-This is English (update)[*]T1-This is French[*]T1-This is German[*]''T1-This is Spanish[*]'=T1-This is Japanese[*]T1-This is Korean[*]T1-This is Portuguese[*]T1-This is Russian[*]T1-This is Italian[*]T1-This is Chinese[ln]Amaranth-Regular[*]Text[*][*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[ln]_CurrentLanguageLocalizedName[*]Text[*][*]English[*]Français[*]Deutsch[*]Español[*]日本語[*]한국어[*]Português[*]Русский[*]Italiano[*]中文[ln]Test3[*]Text[*][*]T3-En[*]T3-Fr[*]T3-Gr[*]T3-Es[*]T3-Ja[*]T3-Ko[*]T3-Pr[*]T3-Ru[*]T3-It[*]T3-Cn[ln]NewKey1[*]Text[*][*]New1_English[*]New1_French[*]New1_German[*]New1_Spanish[*]New1_Japanese[*]New1_Korean[*]New1_Portuguese (Brazil)[*]New1_Russian[*]New1_Italian[*]New1_Chinese (Simplified)<I2Loc>Quests<I2Loc>Key[*]Type[*]Desc[*]English[*]French[*]German[*]Spanish[*]Japanese[*]Korean[*]Portuguese (Brazil)[*]Russian[*]Italian[*]Chinese (Simplified)[ln]Quest1[*]Text[*][*]quest1-English[*]quest1-French[*]quest1-German[*]quest1-Spanish[*]quest1-Japanese[*]quest1-Korean[*]quest1-Portuguese[*]quest1-Russian[*]quest1-Italian[*]quest1-Chinese[ln]Quest2[*]Text[*][*]quest2-English[*]quest2-French[*]quest2-German[*]quest2-Spanish[*]quest2-Japanese[*]quest2-Korean[*]quest2-Portuguese (Brazil)[*]quest2-Russian[*]quest2-Italian[*]quest2-Chinese (Simplified)";
  
  var updateMode = e.parameters.updateMode.toString();  
  var CSVstring = e.parameters.data.toString();
  
  

  
  var lines = CSVstring.split("<I2Loc>");
  
  for (var i=0; i<lines.length; i+=2)
    CSVtoSheet(lines[i], lines[i+1], spreadsheet, updateMode);
  
  if (updateMode=="Replace")
  {
    // Remove non existent categories
    var sheets = spreadsheet.getSheets();
    for (var i=sheets.length-1; i>=0; --i)
      if (!ContainsCSV(lines, sheets[i].getName()))
        spreadsheet.deleteSheet(sheets[i]);
  }
  
  return true;
}

function ContainsCSV( lines, category )
{
  for (var i=0; i<lines.length; i+=2)
    if (lines[i]==category)
      return true;
  return false;
}

function CSVtoSheet(sheetname, CSVstring, spreadsheet, updateMode) 
{
  var sheet = spreadsheet.getSheetByName(sheetname);
  if (sheet===null)
    sheet = spreadsheet.insertSheet(sheetname);

  var csv = ParseI2CSV(CSVstring);
  
  if (updateMode=="Replace")
  {
    sheet.clear();
  }
  else
    RemoveOldHeaders(sheet);
  
  var range = sheet.getDataRange();
  var rangeData = range.getValues();
  var notes = range.getNotes();

  //--[ Combine Languages ]---  
  var languages = [];
  for (var i=1; i<rangeData[0].length; ++i)
    languages.push(rangeData[0][i]);
  
  for (var i=3; i<csv[0].length; ++i)
  {
    var index = LanguageIndex(languages, csv[0][i]);
    if (index<0)
      languages.push(csv[0][i]);
  }
  
  //--[Add new languages to the existing data]---
  
  for (var i=0; i<rangeData.length; ++i)
  {
      for (var j=rangeData[i].length; j<languages.length+1; ++j)
        rangeData[i].push("");
    notes[i].length = rangeData[i].length;
    
    for (var j=0; j<notes[i].length; ++j)
      notes[i][j] = "";
  }
  rangeData[0][0] = "Keys";
  for (var i=0; i<languages.length; ++i)
    rangeData[0][i+1] = languages[i];

  //--[ Add/Update the terms in the CSV array ]------
  for (var i=1; i<csv.length; i++)
  {
    var index = TermIndex(rangeData, csv[i][0]);
    var termData;
    
    if (index<0)
    {
      termData = [csv[i][0]];//, csv[i][1], csv[i][2]];
      termData.length = rangeData[0].length;
      
      for (var j=0; j<languages.length; ++j)
        termData[j+1] = "";
      
      rangeData.push(termData);
      notes.push([]);
      index=rangeData.length-1;
    }
    else
    {
      termData = rangeData[index];
      if (updateMode == "AddNewTerms") // This term already exist and we only want to Add New terms
      {
        // Fix any value that has a Prefix Character (') or (=)
        for (var j=1; j<termData.length; ++j)
        {
          var ss=termData[j].toString();
          if (ss.length>1 && (ss[0]=='\'' || ss[0]=='='))
            termData[j] = "'" + termData[j];
        }
        continue;
      }
    }
    
    for (var j=3; j<csv[i].length; ++j)
    {
      var idx = 1+LanguageIndex(languages, csv[0][j]);
      var val = csv[i][j];
      termData[idx] = val;//(StartsWith(val, "[i2auto]") ? "" : val);
    }
    
    notes[index].length = rangeData[index].length;
    for (var j=1; j<notes[index].length; ++j)
      notes[index][j] = "";
    notes[index][0] = GetCellNote(csv[i][1], csv[i][2]);
  }
  
  var range = sheet.getRange(1,1, rangeData.length, rangeData[0].length);

  range.setValues(rangeData);
  range.setNotes(notes);
  
  SetupSheetFormat( sheet, range );
  //SetupAutoTranslated( range, rangeData, languages, csv );
}

function RemoveOldHeaders( sheet )
{
  var range = sheet.getDataRange();
  var rangeData = range.getValues();
  if (rangeData.length==0 || rangeData[0].length<3 || rangeData[0][1]!="Type" || rangeData[0][2]!="Description")
    return;
  
  var notes = range.getNotes();
  for (var i=1; i<rangeData.length; ++i)
    if (notes[i][0]=="")
      notes[i][0] = GetCellNote( rangeData[i][1], rangeData[i][2] );
  
  range.setNotes(notes);
  sheet.deleteColumns(2, 2);
}

function LanguageIndex( languages, languageName )
{
  for (var i=0; i<languages.length; ++i)
    if (languages[i] == languageName)
      return i;
  return -1;
}

function TermIndex( data, termName )
{
  for (var i=1; i<data.length; ++i)
    if (data[i][0] == termName && data[i][0]!="")
      return i;
  return -1;
}

function GetCellNote( mType, mDesc )
{
    var note = "";
    if (mType!="" && mType!="Text")
      note = "Type:"+mType;
  
    if (mDesc!="")
      note += (note!="" ? "\n"+mDesc : mDesc);
  return note;
}

function MyTest()
{
  var spreadsheet = SpreadsheetApp.openById("1-ypADjz2_09_SJwV0hjq6Mn7o1f1XlaAQB0HZRovuwY");
  if (spreadsheet===null) return false;
  
  //var I2CSVstring = "Key[*]Type[*]Desc[*]English[*]Spanish[ln]Texto de ejemplo[*]Text[*]cc[*]Texto de ejemplo[*][ln]Abajo[*]Text[*][*]Down1[*]Abajo[ln]Ar[*]Text[*][*]Up[*]Arriba[ln]";
  //var CSVstring = "Default=Keys,Type,Description,English,Spanish\nTexto de ejemplo,bb,cc,Texto de ejemplo,[i2auto]Texto de EJEMPLO\nAbajo,,,[i2auto]Down,[i2auto]Abajo\nAr,,,[i2auto]Above,Arriba\n"
  var I2CSVstring = "Default<I2Loc>Key[*]Type[*]Desc[*]English[*]French[*]German[*]Spanish[*]Japanese[*]Korean[*]Portuguese (Brazil)[*]Russian[*]Italian[*]Chinese (Simplified)[ln]TestPhrase1[*]Text[*][*]T1-This is English (update)[*]T1-This is French[*]T1-This is German[*]T1-This is Spanish[*]T1-This is Japanese[*]T1-This is Korean[*]T1-This is Portuguese[*]T1-This is Russian[*]T1-This is Italian[*]T1-This is Chinese[ln]Amaranth-Regular[*]Text[*][*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[*]Amaranth-Regular[ln]_CurrentLanguageLocalizedName[*]Text[*][*]English[*]Français[*]Deutsch[*]Español[*]日本語[*]한국어[*]Português[*]Русский[*]Italiano[*]中文[ln]Test3[*]Text[*][*]T3-En[*]T3-Fr[*]T3-Gr[*]T3-Es[*]T3-Ja[*]T3-Ko[*]T3-Pr[*]T3-Ru[*]T3-It[*]T3-Cn[ln]NewKey1[*]Text[*][*]New1_English[*]New1_French[*]New1_German[*]New1_Spanish[*]New1_Japanese[*]New1_Korean[*]New1_Portuguese (Brazil)[*]New1_Russian[*]New1_Italian[*]New1_Chinese (Simplified)<I2Loc>Quests<I2Loc>Key[*]Type[*]Desc[*]English[*]French[*]German[*]Spanish[*]Japanese[*]Korean[*]Portuguese (Brazil)[*]Russian[*]Italian[*]Chinese (Simplified)[ln]Quest1[*]Text[*][*]quest1-English[*]quest1-French[*]quest1-German[*]quest1-Spanish[*]quest1-Japanese[*]quest1-Korean[*]quest1-Portuguese[*]quest1-Russian[*]quest1-Italian[*]quest1-Chinese[ln]Quest2[*]Text[*][*]quest2-English[*]quest2-French[*]quest2-German[*]quest2-Spanish[*]quest2-Japanese[*]quest2-Korean[*]quest2-Portuguese (Brazil)[*]quest2-Russian[*]quest2-Italian[*]quest2-Chinese (Simplified)";
  //var I2CSVstring = "Key[*]Type[*]Desc[*]English US [en-US][*]French CAN[*]German[*]Italian[*]Portuguese (Brazil)[*]Russian[*]Spanish[*]Polish[ln]Award_Name_Audience[*]Text[*][*]Audience[*][*]Publikum[*]Pubblico[*]Plateia[*]Зритель[*]Audiencia[*]Publiczność[ln]Award_Name_Steadfast[*]Text[*][*]Steadfast[*]Résolu[*]Resolut[*]Deciso[*]Inabalável[*]Стоик[*]Firme[*]Niezłomny[ln]Award_Name_Lethal[*]Text[*][*]Lethal[*]Mortel[*]Tödlich[*]Letale[*]Letal[*]Убийца[*]Letal[*]Śmiertelny[ln]Award_Name_Fleet[*]Text[*][*]Fleet[*]Rapide[*]Schnell[*]Veloce[*]Pé de vento[*]Ловкач[*]Veloz[*]Flota[ln]Award_Name_Greedy[*]Text[*][*]Greedy[*]Avare[*]Gierig[*]Avido[*]Ganancioso[*]Жадина[*]Materialista[*]Chciwy[ln]Award_Name_Hot Temper[*]Text[*][*]Hot Temper[*]Tempérament Fort[*]Temperamentvoll[*]Irascibile[*]Pavio curto[*]Сорвиголова[*]Temperamental[*]Gorący temperament[ln]Award_Name_Cautious[*]Text[*][*]Cautious[*]Prudent[*]Vorsichtig[*]Prudente[*]Cuidadoso[*]Скромник[*]Prudente[*]Ostrożny[ln]Award_Name_Efficient[*]Text[*][*]Efficient[*]Efficace[*]Effizient[*]Efficiente[*]Eficiente[*]Мастер[*]Eficiente[*]Wydajny[ln]Award_Name_Champion[*]Text[*][*]Champion[*]Champion[*]Ass[*]Asso[*]Campeão[*]Победитель[*]As[*]Mistrz[ln]Award_Name_Fragile[*]Text[*][*]Fragile[*]Fragile[*]Zerbrechlich[*]Fragile[*]Frágil[*]Хлюпик[*]Frágil[*]Kruchy[ln]Award_Name_Most Helpful[*]Text[*][*]Most Helpful[*]Serviable[*]Hilfreich[*]Servizievole[*]Grande auxílio[*]Доброе сердце[*]Más Servicial[*]najbardziej pomocne[ln]Award_Name_Impatient[*]Text[*][*]Impatient[*]Impatient[*]Ungeduldig[*]Impaziente[*]Impaciente[*]Торопыга[*]Impaciente[*]Jestem cierpliwy[ln]Award_Name_Intrusive[*]Text[*][*]Intrusive[*]Intrusif[*]Aufdringlich[*]Invadente[*]Intruso[*]Забияка[*]Metomentodo[*]Natrętny[ln]Award_Name_Outspoken[*]Text[*][*]Outspoken[*]Franc[*]Freimütig[*]Franco[*]Tagarela[*]Краснобай[*]Cotorra[*]Szczery[ln]Award_Name_Obstinate[*]Text[*][*]Obstinate[*]Obstiné[*]Stur[*]Ostinato[*]Obstinado[*]Упрямец[*]Cabezota[*]Uparty[ln]Award_Name_Pacifist[*]Text[*][*]Pacifist[*]Pacifiste[*]Pazifist[*]Pacifista[*]Pacífico[*]Пацифист[*]Pacifista[*]Pacyfista[ln]Award_Name_Push Over[*]Text[*][*]Push Over[*]Frêle[*]Schwächling[*]Debole[*]Pressionado[*]Тряпка[*]Endeble[*]Wywracać pchnięciem[ln]Award_Name_Rampager[*]Text[*][*]Rampager[*]Ravageur[*]Wüter[*]Furioso[*]Vândalo[*]Вандал[*]Apisonadora[*]Rampager[ln]Award_Name_Most Skilled[*]Text[*][*]Most Skilled[*]Le plus habile[*]Am geschicktesten[*]Abilissimo[*]Habilidoso[*]Умелец[*]Más Hábil[*]najbardziej wykwalifikowanych[ln]Award_Name_Rowdy[*]Text[*][*]Rowdy[*]Désobéissant[*]Schläger[*]Turbolento[*]Arruaceiro[*]Буян[*]Bullebulle[*]Hałaśliwy[ln]";
     
  Logger.log("start");
  Logger.log( ParseI2CSV(I2CSVstring));
  //CSVtoSheet("Default", I2CSVstring, spreadsheet, "Replace") ;
  //CSVtoSheet("Default", I2CSVstring, spreadsheet, "Replace") ;
  //CSVtoSheet("Default", I2CSVstring, spreadsheet, "Replace") ;
  //CSVtoSheet("Default", I2CSVstring, spreadsheet, "Replace") ;
  //CSVtoSheet("Default", I2CSVstring, spreadsheet, "Replace") ;
  Logger.log("done");
}

function SetupSheetFormat( sheet, range )
{
  sheet.clearFormats();
  range.clearDataValidations();
  
  //-- COLORS ------------------------
  range.setBackground("white");
  sheet.getRange(1, 1, 1, sheet.getLastColumn()).setBackground("#e6b8af");
  if (sheet.getLastRow()>1)
    sheet.getRange(2, 1, sheet.getLastRow()-1, 1).setBackground("#c9daf8");
  
  //-- LAYOUT ------------------------
  sheet.setFrozenColumns(1);
  sheet.setFrozenRows(1);
  
  //sheet.autoResizeColumn(1);
  //if (sheet.getColumnWidth(1)>150) sheet.setColumnWidth(1, 150);
}

function SetupAutoTranslated( range, values, languages, csv )
{
  var backgrounds = range.getBackgrounds();
  for (var r=1; r<values.length; ++r)
  for (var c=1; c<values[r].length; ++c)
      if (values[r][c]==="" && (csv[r][1]=="" || csv[r][1]=="Text"))
      {
        SetAutoTranslateCell(values, r, c, languages);
        backgrounds[r][c] = "#f0f0f0";
      }
  range.setBackgrounds( backgrounds );
  range.setValues( values );
}

function SetAutoTranslateCell( values, r, c, languages )
{
  var code = "auto";
  var term = values[0];
  var fc = 0;
  for (var cc=1; cc<values[r].length; ++cc)
    if (cc!=c && values[r][cc]!="")
    {
      term = values[r][cc];
      fc = cc;
      code = GetLangCode( languages[fc-1] );
      break;
    }
  
  var targetCell = GetCellName(fc,r);
  values[r][c] = '=GOOGLETRANSLATE('+targetCell+';"'+code+'";"'+GetLangCode( languages[c-1] )+'")';
}


function GetCellName( c, r )
{
  return ("ABCDEFGHIJKLMNOPQRSTUVWXYZ")[c] + (r+1);
}

function GetLangCode( lan )
{
  if (lan==undefined) return "auto";
  if (lan.toLowerCase().indexOf("afrikaans")>=0) return "af";
  if (lan.toLowerCase().indexOf("albanian")>=0) return "sq";
  if (lan.toLowerCase().indexOf("arabic")>=0) return "ar";
  if (lan.toLowerCase().indexOf("azerbaijani")>=0) return "az";
  if (lan.toLowerCase().indexOf("basque")>=0) return "eu";
  if (lan.toLowerCase().indexOf("bengali")>=0) return "bn";
  if (lan.toLowerCase().indexOf("belarusian")>=0) return "be";
  if (lan.toLowerCase().indexOf("bulgarian")>=0) return "bg";
  if (lan.toLowerCase().indexOf("catalan")>=0) return "ca";
  if (lan.toLowerCase().indexOf("simplified")>=0) return "zh-cn";
  if (lan.toLowerCase().indexOf("traditional")>=0) return "zh-tw";
  if (lan.toLowerCase().indexOf("chinese")>=0) return "zh-cn";
  if (lan.toLowerCase().indexOf("croatian")>=0) return "hr";
  if (lan.toLowerCase().indexOf("czech")>=0) return "cs";
  if (lan.toLowerCase().indexOf("danish")>=0) return "da";
  if (lan.toLowerCase().indexOf("dutch")>=0) return "nl";
  if (lan.toLowerCase().indexOf("english")>=0) return "en";
  if (lan.toLowerCase().indexOf("esperanto")>=0) return "eo";
  if (lan.toLowerCase().indexOf("estonian")>=0) return "et";
  if (lan.toLowerCase().indexOf("filipino")>=0) return "tl";
  if (lan.toLowerCase().indexOf("finnish")>=0) return "fi";
  if (lan.toLowerCase().indexOf("french")>=0) return "fr";
  if (lan.toLowerCase().indexOf("galician")>=0) return "gl";
  if (lan.toLowerCase().indexOf("georgian")>=0) return "ka";
  if (lan.toLowerCase().indexOf("german")>=0) return "de";
  if (lan.toLowerCase().indexOf("greek")>=0) return "el";
  if (lan.toLowerCase().indexOf("gujarati")>=0) return "gu";
  if (lan.toLowerCase().indexOf("haitian")>=0) return "ht";
  if (lan.toLowerCase().indexOf("hebrew")>=0) return "iw";
  if (lan.toLowerCase().indexOf("hindi")>=0) return "hi";
  if (lan.toLowerCase().indexOf("hungarian")>=0) return "hu";
  if (lan.toLowerCase().indexOf("icelandic")>=0) return "is";
  if (lan.toLowerCase().indexOf("indonesian")>=0) return "id";
  if (lan.toLowerCase().indexOf("irish")>=0) return "ga";
  if (lan.toLowerCase().indexOf("italian")>=0) return "it";
  if (lan.toLowerCase().indexOf("japanese")>=0) return "ja";
  if (lan.toLowerCase().indexOf("kannada")>=0) return "kn";
  if (lan.toLowerCase().indexOf("korean")>=0) return "ko";
  if (lan.toLowerCase().indexOf("latin")>=0) return "la";
  if (lan.toLowerCase().indexOf("latvian")>=0) return "lv";
  if (lan.toLowerCase().indexOf("lithuanian")>=0) return "lt";
  if (lan.toLowerCase().indexOf("macedonian")>=0) return "mk";
  if (lan.toLowerCase().indexOf("malay")>=0) return "ms";
  if (lan.toLowerCase().indexOf("maltese")>=0) return "mt";
  if (lan.toLowerCase().indexOf("norwegian")>=0) return "no";
  if (lan.toLowerCase().indexOf("persian")>=0) return "fa";
  if (lan.toLowerCase().indexOf("polish")>=0) return "pl";
  if (lan.toLowerCase().indexOf("portuguese")>=0) return "pt";
  if (lan.toLowerCase().indexOf("romanian")>=0) return "ro";
  if (lan.toLowerCase().indexOf("russian")>=0) return "ru";
  if (lan.toLowerCase().indexOf("serbian")>=0) return "sr";
  if (lan.toLowerCase().indexOf("slovak")>=0) return "sk";
  if (lan.toLowerCase().indexOf("slovenian")>=0) return "sl";
  if (lan.toLowerCase().indexOf("spanish")>=0) return "es";
  if (lan.toLowerCase().indexOf("swahili")>=0) return "sw";
  if (lan.toLowerCase().indexOf("swedish")>=0) return "sv";
  if (lan.toLowerCase().indexOf("tamil")>=0) return "ta";
  if (lan.toLowerCase().indexOf("telugu")>=0) return "te";
  if (lan.toLowerCase().indexOf("thai")>=0) return "th";
  if (lan.toLowerCase().indexOf("turkish")>=0) return "tr";
  if (lan.toLowerCase().indexOf("ukrainian")>=0) return "uk";
  if (lan.toLowerCase().indexOf("urdu")>=0) return "ur";
  if (lan.toLowerCase().indexOf("vietnamese")>=0) return "vi";
  if (lan.toLowerCase().indexOf("welsh")>=0) return "cy";
  if (lan.toLowerCase().indexOf("yiddish")>=0) return "yi";
  return "auto";    
}

function StartsWith( text, tag )
{
  if (typeof text !== 'string')
    return false;
  
  if (text.length < tag.length)
    return false;
  
  return (text.substr(0, tag.length) == tag);
}

