%if %sysfunc(exist(lib.table)) %then %do;
  proc casutil incaslib="caslib";
    droptable casdata="castable";
  run;
%end;