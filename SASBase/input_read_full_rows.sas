data rows;
  attrib row length=$2048;
  infile "&folder.\data.txt";
  input;
  row = _infile_;
run;