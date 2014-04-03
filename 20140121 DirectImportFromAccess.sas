* File -> Import Data -> Import Wizard -> Std DB -> Access -> Find the file on S Drive;

PROC IMPORT OUT= WORK.weight 
            DATATABLE= "CRCWGHT" 
            DBMS=ACCESS REPLACE;
     DATABASE="S:\course\Bios532\2014\crc301.mdb"; 
     SCANMEMO=YES;
     USEDATE=NO;
     SCANTIME=YES;
RUN;
