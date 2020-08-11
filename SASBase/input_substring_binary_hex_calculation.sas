%let maxValCnt=200;

data x;
  attrib id length=8;
  attrib date length=8 format=date9.;
  attrib RawData length=$4;
  array y{%eval(&maxValCnt.)} y1-y%trim(%eval(&maxValCnt.));

  attrib hex1 length=$2;
  attrib val1 length=8;
  attrib hex2 length=$2;
  attrib val2 length=8;

  infile datalines
      dlm='2c'x
      missover
      dsd

      /* store column pointer location in variable 'c' */
      column=c;

  input id
    date : DATE9. +3 @;

  /* find starting position of RawData in input buffer */
  posBase = c;

  /* read 4 characters of raw data since that is all that is needed for calculations */
  input @(posBase) RawData : $CHAR4. @;

  n = 1;
  /* perform calculations and read next 4 characters of raw data until RawData column is empty */
  do while (RawData ne "");
    hex1 = substr(RawData, 1, 2);
    val1 = input(hex1, hex.);
    hex2 = substr(RawData, 3, 2);
    val2 = input(hex2, hex.);

    /* custom calculations */
    y{n} = val1 + val2;

    pos = posBase + n * 4;
    input @(pos) RawData : $CHAR4. @;
    n+1;
  end;

datalines;
1,01JAN2015,80x000000000000CC00A0004A0033003B0032000400440041002C003F00E601B002E3001100170008000F0021001A0015002F0021004C004F0019001B0
;;;;
run;
