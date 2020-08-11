%macro fileloop(dir=, data=);
  /** Assigns a fileref to the directory you passed in **/
  %let rc=%sysfunc(filename(filrf, &dir.));

  /** Opens the directory to be read **/
  %let did=%sysfunc(dopen(&filrf.));

  /** Returns the number of members in the directory you passed in **/
  %let memcnt=%sysfunc(dnum(&did.));
  %put &memcnt.;

  /** loop over files in the drectory **/
  %do i = 1 %to &memcnt; 
    %let name=%sysfunc(dread(&did., &i.));
    %let fname=&dir./&name.;
    %put &fname.;
    
    data work.tmp&i.;
      infile "&fname.";
      input record;
    run;

    %if &i. = 1 %then %do;
      data &data.;
        set work.tmp&i.;
      run;
    %end; %else %do;
      proc append base=&data.
        data=work.tmp&i.;
      run;
    %end;
  %end;

  /** Close the directory **/
  %let rc=%sysfunc(dclose(&did));
%mend;
