function ParseCSV( Line )
{
  var iStart = 0;
  var CSV = [];
                                                               
  while (iStart < Line.length)
  {
    var list = [];
    
    var TextLength = Line.length;
    var iWordStart = iStart;
    var InsideQuote = false;
    
    while (iStart < TextLength)
    {
      var c = Line[iStart];

      if (InsideQuote)
      {
        if (c=='"') //--[ Look for Quote End ]------------
        {
          if (iStart+1 >= TextLength || Line[iStart+1] != '"')  //-- Single Quote:  Quotation Ends
          {
            InsideQuote = false;
          }
          else
          if (iStart+2 < TextLength && Line[iStart+2]=='"')  //-- Tripple Quotes: Quotation ends
          {
            InsideQuote = false;
            iStart+=2;
          }
          else 
            iStart++;  // Skip Double Quotes
        }
      }
      
      else  //-----[ Separators ]----------------------
        
        if (c=='\n' || c==',')
        {
          list.push( AddCSVtoken(Line, iStart, iWordStart) );
          iWordStart = iStart+1;
          
          if (c=='\n')  // Stop the row on line breaks
          {
            iStart++;
            break;
          }
        }
      
      else //--------[ Start Quote ]--------------------
        
        if (c=='"')
          InsideQuote = true;
      
      iStart++;
    }
    if (iStart>iWordStart)
    {
      list.push( AddCSVtoken(Line, iStart, iWordStart) );
      iWordStart = iStart+1;
    }
    
    CSV.push( list );
  }
  return CSV;
}

function AddCSVtoken( Line, iEnd, iWordStart)
{
  var Text = Line.substr(iWordStart, iEnd-iWordStart);
  
  Text = Text.replace(/""/gi, '"' );
  if (Text.length>1 && Text[0]=='"' && Text[Text.length-1]=='"')
    Text = Text.substr(1, Text.length-2 );
  
  return Text;
}

function ParseI2CSV( Line )
{
  var lines = Line.split("[ln]");
  for (var i=0; i<lines.length; ++i)
    lines[i] = lines[i].split("[*]");
  return lines;
}