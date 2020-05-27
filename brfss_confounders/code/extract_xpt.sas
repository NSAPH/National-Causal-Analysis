/* code to extract xpt files to sas database */

libname main '.';
/*libname xpt1999 xport '1999/CDBRFS99.XPT' access=readonly;
libname xpt2000 xport '2000/CDBRFS00.XPT' access=readonly;
libname xpt2001 xport '2001/CDBRFS01.XPT' access=readonly;
libname xpt2002 xport '2002/cdbrfs02.xpt' access=readonly;
libname xpt2003 xport '2003/cdbrfs03.xpt' access=readonly;
libname xpt2004 xport '2004/CDBRFS04.XPT' access=readonly;
libname xpt2005 xport '2005/CDBRFS05.XPT' access=readonly;
libname xpt2006 xport '2006/CDBRFS06.XPT' access=readonly;
libname xpt2007 xport '2007/CDBRFS07.XPT' access=readonly;
libname xpt2008 xport '2008/CDBRFS08.XPT' access=readonly;
libname xpt2009 xport '2009/CDBRFS09.XPT' access=readonly;
libname xpt2010 xport '2010/CDBRFS10.XPT' access=readonly;
libname xpt2011 xport '2011/LLCP2011.XPT' access=readonly;
libname xpt2012 xport '2012/LLCP2012.XPT' access=readonly;
libname xpt2013 xport '2013/LLCP2013.XPT' access=readonly;*/
libname xpt2014 xport "/nfs/nsaph_ci3/users/ci3_mbsabath/brfss/2014/LLCP2014.XPT" access=readonly;
libname xpt2015 xport '2015/LLCP2015.XPT';
libname xpt2016 xport '2016/LLCP2016.XPT';
/*proc copy inlib=xpt1999 outlib=main; 
run;
proc copy inlib=xpt2000 outlib=main;  
run;
proc copy inlib=xpt2001 outlib=main;  run;
proc copy inlib=xpt2002 outlib=main;  run;
proc copy inlib=xpt2003 outlib=main;  run;
proc copy inlib=xpt2004 outlib=main;  run;
proc copy inlib=xpt2005 outlib=main;  run;
proc copy inlib=xpt2006 outlib=main;  run;
proc copy inlib=xpt2007 outlib=main;  run;
proc copy inlib=xpt2008 outlib=main;  run;
proc copy inlib=xpt2009 outlib=main;  run;
proc copy inlib=xpt2010 outlib=main;  run;
proc copy inlib=xpt2011 outlib=main;  run;
proc copy inlib=xpt2012 outlib=main;  run;
proc copy inlib=xpt2013 outlib=main;  run;*/
proc cimport infile=xpt2014 library=main;  run;
proc cimport infile=xpt2015 library=main;  run;
proc cimport infile=xpt2016 library=main;  run;
