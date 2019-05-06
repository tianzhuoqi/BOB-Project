function testTranslate()
{
  var e = "en:tr=bet";
  var result = myTranslate(e);
  Logger.log(result);
}
function doTranslate(e) 
{
  if (e===undefined || e.parameters==undefined || e.parameters.list==undefined)
    e = "es:en=El jugador no tiene puntos<I2Loc>en:ru=another <I2Loc>en:ru=otro mas<I2Loc>en:ru=last one"
    //e = "auto:es=This is a text";
    //e = "en:es,fr=This is a text<I2Loc>en:es,ko=THIS IS ANOTHER TEXT";
  else
    e = e.parameters.list.toString();
  
  return myTranslate(e);
}

function myTranslate(e)
{ 
  var result = "";
  var lines = e.split("<I2Loc>");
  //var count=0;
  //for (var m=0; m<30; ++m)
  for (var i=0; i<lines.length; i++)
  {
    if (i>0)
      result += "<I2Loc>";
    var line = lines[i];
    var textIdx = line.indexOf("=");
    var text = line.substr(textIdx+1);
    
    var baseLangIdx = line.indexOf(":");
    var baseLang = line.substr(0, baseLangIdx);
    if (baseLang == "auto") baseLang = "";
    
    var targetLangLine = line.substr(baseLangIdx+1, textIdx-baseLangIdx-1);
    var targetLangs = targetLangLine.split(",");
    
    //result += text;
    
    //var translation = []
    for (var t=0; t<targetLangs.length; t++)
    {
      var translated = LanguageApp.translate(text, baseLang, targetLangs[t]);
      translated = fixCase(text, translated);
      
      if (t>0) result += "<i2>";
      result += translated;
      
      //count++;
      //if (count>=90)
      //{
      //  count = 0;
      //  Utilities.sleep(2000);
      //}
      //translation.push( fixCase(text, translated) );
      //Logger.log(targetLangs[i] + "=" +translation[t]);
    }
  }
  //Logger.log(LanguageApp.translate("El jugador no tiene puntos.", "es", "EN"));
  //Logger.log(result);
  return result;
}

function fixCase( original, translated )
{
  /*if (original == original.toUpperCase())
     return translated.toUpperCase();
  
  if (original == original.toLowerCase())
     return translated.toLowerCase();
*/
  if (original == toTitleCase(original))
     return toTitleCase(translated);
  
  /*if (original == toUpperFirst(original))
     return toUpperFirst(translated);*/
  
  return translated;
}

function toUpperFirst(str)
{
  return str.toLowerCase().replace(/(^[a-z]|\. [a-z]|\.\n[a-z])/g, 
        function($1){
            return $1.toUpperCase();
        }
    );
}

function toTitleCase( str )
{
  return str.toLowerCase().replace(/(^[a-z]| [a-z]|-[a-z])/g, 
        function($1){
            return $1.toUpperCase();
        }
    );
}

function testURL()
{
  var options =
     {
       "langpair" : "en|es",
       "text" : "hello%20world",
       "vi" : "c",
       "hl" : "en",
       "submit" : "Translate"
     };  
  var url1 = "https://translate.google.com/?hl=en&vi=c&ie=UTF8&oe=UTF8&text=hello+world#en/es/my%20hello%20world";
  
  var response = UrlFetchApp.fetch(url1/*"http://www.google.com/translate_t", options*/);
  Logger.log(response.getContentText().indexOf("mundo"));
  var result = "";
  Logger.log(result);
}
