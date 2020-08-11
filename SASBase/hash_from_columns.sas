%let colhash=;

%macro hash(lib=, table=, out=);
  proc sql noprint;
    create table work.cols as
      select name from sashelp.vcolumn
      where libname = upcase(strip("&lib."))
        and memname = upcase(strip("&table."))
      order by name;
    
    select strip(name)
    into :vars separated by ''
    from work.cols;
  quit;

  %let &out.=%sysfunc(sha256(&vars.), HEX64.);
%mend hash;

%hash(lib=sashelp, table=class, out=colhash);
%put &=colhash.;