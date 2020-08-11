%global starttime endtime elapsedtime;

%macro starttime;
%let starttime=%qsysfunc(datetime(), 20.);
%put Start Time: %trim(%qsysfunc(putn(&starttime., datetime20.)));
%mend;

%macro endtime;
%put Start Time: %trim(%qsysfunc(putn(&starttime., datetime20.)));
%let endtime=%qsysfunc(datetime(), 20.);
%put End Time:   %trim(%qsysfunc(putn(&endtime., datetime20.)));
%let elapsedtime=%eval(&endtime. - &starttime);
%put Elapsed Time: %trim(%qsysfunc(putn(&elapsedtime., time8.2)));
%mend;