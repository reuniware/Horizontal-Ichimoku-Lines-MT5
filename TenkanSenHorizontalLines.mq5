//+------------------------------------------------------------------+
//|                                     TenkanSenHorizontalLines.mq5 |
//|                                Copyright 2018, InvestDataSystems |
//|                 https://tradingbot.wixsite.com/robots-de-trading |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, InvestDataSystems"
#property link      "https://tradingbot.wixsite.com/robots-de-trading"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   IchimokuHorizontalLines();

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
int minNumberOfSameConsecutiveValuesNeeded=5;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
color ExtClr[140]=
  {
   clrAliceBlue,clrAntiqueWhite,clrAqua,clrAquamarine,clrAzure,clrBeige,clrBisque,clrBlack,clrBlanchedAlmond,
   clrBlue,clrBlueViolet,clrBrown,clrBurlyWood,clrCadetBlue,clrChartreuse,clrChocolate,clrCoral,clrCornflowerBlue,
   clrCornsilk,clrCrimson,clrCyan,clrDarkBlue,clrDarkCyan,clrDarkGoldenrod,clrDarkGray,clrDarkGreen,clrDarkKhaki,
   clrDarkMagenta,clrDarkOliveGreen,clrDarkOrange,clrDarkOrchid,clrDarkRed,clrDarkSalmon,clrDarkSeaGreen,
   clrDarkSlateBlue,clrDarkSlateGray,clrDarkTurquoise,clrDarkViolet,clrDeepPink,clrDeepSkyBlue,clrDimGray,
   clrDodgerBlue,clrFireBrick,clrFloralWhite,clrForestGreen,clrFuchsia,clrGainsboro,clrGhostWhite,clrGold,
   clrGoldenrod,clrGray,clrGreen,clrGreenYellow,clrHoneydew,clrHotPink,clrIndianRed,clrIndigo,clrIvory,clrKhaki,
   clrLavender,clrLavenderBlush,clrLawnGreen,clrLemonChiffon,clrLightBlue,clrLightCoral,clrLightCyan,
   clrLightGoldenrod,clrLightGreen,clrLightGray,clrLightPink,clrLightSalmon,clrLightSeaGreen,clrLightSkyBlue,
   clrLightSlateGray,clrLightSteelBlue,clrLightYellow,clrLime,clrLimeGreen,clrLinen,clrMagenta,clrMaroon,
   clrMediumAquamarine,clrMediumBlue,clrMediumOrchid,clrMediumPurple,clrMediumSeaGreen,clrMediumSlateBlue,
   clrMediumSpringGreen,clrMediumTurquoise,clrMediumVioletRed,clrMidnightBlue,clrMintCream,clrMistyRose,clrMoccasin,
   clrNavajoWhite,clrNavy,clrOldLace,clrOlive,clrOliveDrab,clrOrange,clrOrangeRed,clrOrchid,clrPaleGoldenrod,
   clrPaleGreen,clrPaleTurquoise,clrPaleVioletRed,clrPapayaWhip,clrPeachPuff,clrPeru,clrPink,clrPlum,clrPowderBlue,
   clrPurple,clrRed,clrRosyBrown,clrRoyalBlue,clrSaddleBrown,clrSalmon,clrSandyBrown,clrSeaGreen,clrSeashell,
   clrSienna,clrSilver,clrSkyBlue,clrSlateBlue,clrSlateGray,clrSnow,clrSpringGreen,clrSteelBlue,clrTan,clrTeal,
   clrThistle,clrTomato,clrTurquoise,clrViolet,clrWheat,clrWhite,clrWhiteSmoke,clrYellow,clrYellowGreen
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void IchimokuHorizontalLines()
  {
   long cid=ChartID();
   ObjectsDeleteAll(cid);

   double tenkan_sen_buffer[];
   double kijun_sen_buffer[];
   double senkou_span_a_buffer[];
   double senkou_span_b_buffer[];
   double chikou_span_buffer[];

   int tenkan_sen_param = 9;              // period of Tenkan-sen
   int kijun_sen_param = 26;              // period of Kijun-sen
   int senkou_span_b_param = 52;          // period of Senkou Span B
   int handleIchimoku=INVALID_HANDLE;
   int max;
   int nbt=-1,nbk=-1,nbssa=-1,nbssb=-1,nbc=-1;
   int numO=-1,numH=-1,numL=-1,numC=-1;

   ArraySetAsSeries(tenkan_sen_buffer,true);
   ArraySetAsSeries(kijun_sen_buffer,true);
   ArraySetAsSeries(senkou_span_a_buffer,true);
   ArraySetAsSeries(senkou_span_b_buffer,true);
   ArraySetAsSeries(chikou_span_buffer,true);

   handleIchimoku=iIchimoku(Symbol(),Period(),tenkan_sen_param,kijun_sen_param,senkou_span_b_param);
   //handleIchimoku=iIchimoku(Symbol(),PERIOD_D1,tenkan_sen_param,kijun_sen_param,senkou_span_b_param);
   max=512;

   int start=0; // bar index
   int count=max; // number of bars
   datetime tm[]; // array storing the returned bar time
   ArraySetAsSeries(tm,true);
   CopyTime(Symbol(),Period(),start,count,tm);

   nbt=-1;nbk=-1;nbssa=-1;nbssb=-1;nbc=-1;
   nbt = CopyBuffer(handleIchimoku, TENKANSEN_LINE, 0, max, tenkan_sen_buffer);
   nbk = CopyBuffer(handleIchimoku, KIJUNSEN_LINE, 0, max, kijun_sen_buffer);
   nbssa = CopyBuffer(handleIchimoku, SENKOUSPANA_LINE, 0, max, senkou_span_a_buffer);
   nbssb = CopyBuffer(handleIchimoku, SENKOUSPANB_LINE, 0, max, senkou_span_b_buffer);
   nbc=CopyBuffer(handleIchimoku,CHIKOUSPAN_LINE,0,max,chikou_span_buffer);
   
   // kijun sen horizontal lines
   /*for(int i=0;i<nbk-minNumberOfSameConsecutiveValuesNeeded;i+=minNumberOfSameConsecutiveValuesNeeded)
     {
      bool equal=true;
      for(int j=0;j<minNumberOfSameConsecutiveValuesNeeded-1;j++)
        {
         if(kijun_sen_buffer[i+j]!=kijun_sen_buffer[i+j+1])
           {
            equal=false;
            continue;
           }
        }
      if(equal==true)
        {
         //printf("one horizontal line found at "+tm[i]+" with kijun sen line = "+DoubleToString(kijun_sen_buffer[i]));
         if(!ObjectCreate(cid,"kijun"+i,OBJ_HLINE,0,0,kijun_sen_buffer[i]) || GetLastError()!=0)
            Print("Error creating object: ",GetLastError());
         else
           {
            ObjectSetInteger(0,"kijun"+i,OBJPROP_COLOR,clrIndianRed);
            ChartRedraw(cid);
           }
        }
     }*/

   // tenkan sen horizontal lines
   for(int i=0;i<nbt-minNumberOfSameConsecutiveValuesNeeded;i+=minNumberOfSameConsecutiveValuesNeeded)
     {
      bool equal=true;
      for(int j=0;j<minNumberOfSameConsecutiveValuesNeeded-1;j++)
        {
         if(tenkan_sen_buffer[i+j]!=tenkan_sen_buffer[i+j+1])
           {
            equal=false;
            continue;
           }
        }
      if(equal==true)
        {
         //printf("one horizontal line found at "+tm[i]+" with kijun sen line = "+DoubleToString(kijun_sen_buffer[i]));
         if(!ObjectCreate(cid,"tenkan"+i,OBJ_HLINE,0,0,tenkan_sen_buffer[i]) || GetLastError()!=0)
            Print("Error creating object: ",GetLastError());
         else
           {
            ObjectSetInteger(0,"tenkan"+i,OBJPROP_COLOR,clrDarkTurquoise);
            ChartRedraw(cid);
           }
        }
     }

   ArrayFree(tm);

   ArrayFree(tenkan_sen_buffer);
   ArrayFree(kijun_sen_buffer);
   ArrayFree(senkou_span_a_buffer);
   ArrayFree(senkou_span_b_buffer);
   ArrayFree(chikou_span_buffer);

   IndicatorRelease(handleIchimoku);

  }
//+------------------------------------------------------------------+
