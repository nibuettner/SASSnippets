cas sess;

libname casuser cas caslib="casuser";
libname vd07 cas caslib="viyademo07";

/*
%if %sysfunc(exist(casuser.SWISSLIFE_SCORED_NEW)) %then %do;
  proc casutil incaslib="casuser";
    droptable casdata="SWISSLIFE_SCORED_NEW";
  run;
%end;

data casuser.SWISSLIFE_SCORED_NEW;
  set vd07.SWISSLIFE_SCORED_NEW(obs=100);
run;
*/

proc ds2 sessref=sess;
  data "casuser".tmp / OVERWRITE=YES;
    keep colname;

    dcl package datagrid grid();
    dcl double coln i;

    dcl varchar(50) colname;
    dcl double coln;

    method run();
      set "viyademo07".SWISSLIFE_SCORED_NEW;

      if _N_ > 1 then stop;

      grid.deserialize(SLS_MVP_Impulse_out);

      coln = grid.columnCount();
  
      do i = 1 to coln;
        colname = grid.columnName(i);
        output;
      end;
    end;
  enddata;
run; quit;

data work.tmp;
  set casuser.tmp end=eof;

  call symput("colin" !! strip(put(_N_, 10.)), strip(colname));

  colname = tranwrd(colname, "Ä", "AE");
  colname = tranwrd(colname, "DEFINITION", "DEF");
  call symput("col" !! strip(put(_N_, 10.)), strip(colname));
  if eof then call symput("colcnt",  strip(put(_N_, 10.)));
run;

options mprint symbolgen;

%macro deserialize;

%do i = 1 %to &colcnt.;
  %put &&colin&i.. = &&col&i..;
%end;

proc ds2 sessref=sess;
  data "casuser".SWISSLIFE_RESULTS_NEW / OVERWRITE=YES;
    drop coln rown i j n;

    dcl package datagrid grid();
    dcl double coln rown i j;

    dcl varchar(50) colname;
    dcl varchar(64000) value;

    dcl double coln;
    dcl double rown;
    dcl double n;

    %do i = 1 %to &colcnt.;
      dcl varchar(1000) &&col&i.;
    %end;

    method run();
      set "viyademo07".SWISSLIFE_SCORED_NEW;
      n = _N_;

      grid.deserialize(SLS_MVP_Impulse_out);

      coln = grid.columnCount();
      rown = grid.rowCount() ;
   
      put 'row in data : ' n;
      put '# of columns: ' coln;
      put '# of rows   : ' rown;
  
      do j = 1 to rown;
        %do i = 1 %to &colcnt.;
          &&col&i.. = grid.getValue(grid.columnName(&i.), j);
        %end;

        output;
      end; 
    end;
  enddata;
run; quit;

%mend;

%deserialize;

%if %sysfunc(exist(vd07.SWISSLIFE_RESULTS_NEW)) %then %do;
  proc casutil incaslib="viyademo07";
    droptable casdata="SWISSLIFE_RESULTS_NEW";
  run;
%end;

proc casutil sessref=sess;
  promote incaslib="casuser" casdata="SWISSLIFE_RESULTS_NEW"
    outcaslib="viyademo07" casout="SWISSLIFE_RESULTS_NEW";
run;

cas sess terminate;