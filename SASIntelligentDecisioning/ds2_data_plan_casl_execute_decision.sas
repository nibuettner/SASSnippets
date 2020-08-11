/* Set variables for decision execution */
_dp_publib="Models";              /* Library for CAS Publish Destination */
_dp_pubtab="sas_model_table";     /* Table for CAS Publish Destination */
_dp_pubmodel="MyModel";           /* Name of Published Decision */

/* Create a copy of the input table to allow input and output datasets of ds2 to be different */
table.partition
  table={caslib=_dp_inputCaslib name=_dp_inputTable}
  casout={caslib=_dp_inputCaslib, name="TMPDS2IN", replace=true};

table.tableExists result=e /
  caslib=_dp_publib
  name=_dp_pubtab; 

_dp_pubtabph=_dp_pubtab || ".sashdat";

haveTable = dictionary(e, "exists"); 

if haveTable <= 0 then do; 
  table.loadTable / 
    caslib=_dp_publib 
    path=_dp_pubtabph;
end; 

ds2.runModel / 
  modelName=_dp_pubmodel
  table={caslib=_dp_inputCaslib, name="TMPDS2IN"} 
  modelTable={caslib=_dp_publib, name=_dp_pubtab} 
  casOut={caslib=_dp_outputCaslib, name=_dp_outputTable};