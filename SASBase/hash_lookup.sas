data fact;
  attrib id length=$3;
  attrib value length=8;

  id = "001"; value = 1; output;
  id = "002"; value = 5; output;
  id = "003"; value = 4; output;
  id = "001"; value = 1; output;
  id = "003"; value = 3; output;
  id = "002"; value = 2; output;
  id = "002"; value = 4; output;
  id = "001"; value = 1; output;
  id = "001"; value = 3; output;
  id = "002"; value = 9; output;
  id = "001"; value = 8; output;
  id = "002"; value = 7; output;
run;

data dim;
  attrib id length=$3;
  attrib name length=$6;

  id = "001"; name = "Test 1"; output;
  id = "002"; name = "Test 2"; output;
  id = "003"; name = "Test 3"; output;
run;

data join;
  attrib id length=$3;
  attrib name length=$6;

  if _n_ = 1 then do;
    declare hash h(dataset: "work.dim");
    h.defineKey("id");
    h.defineData("name");
    h.defineDone();
    call missing(of _ALL_);
  end;

  set fact;

  rc = h.find();
run;