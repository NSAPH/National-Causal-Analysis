/* code to extract xpt files to sas database */

libname main '../raw_data/sas_files';
libname xpt1999 xport '../raw_data/1999/CDBRFS99.XPT' access=readonly;
libname xpt2000 xport '../raw_data/2000/CDBRFS00.XPT' access=readonly;
libname xpt2001 xport '../raw_data/2001/CDBRFS01.XPT' access=readonly;
libname xpt2002 xport '../raw_data/2002/cdbrfs02.xpt' access=readonly;
libname xpt2003 xport '../raw_data/2003/cdbrfs03.xpt' access=readonly;
libname xpt2004 xport '../raw_data/2004/CDBRFS04.XPT' access=readonly;
libname xpt2005 xport '../raw_data/2005/CDBRFS05.XPT' access=readonly;
libname xpt2006 xport '../raw_data/2006/CDBRFS06.XPT' access=readonly;
libname xpt2007 xport '../raw_data/2007/CDBRFS07.XPT' access=readonly;
libname xpt2008 xport '../raw_data/2008/CDBRFS08.XPT' access=readonly;
libname xpt2009 xport '../raw_data/2009/CDBRFS09.XPT' access=readonly;
libname xpt2010 xport '../raw_data/2010/CDBRFS10.XPT' access=readonly;
libname xpt2011 xport '../raw_data/2011/LLCP2011.XPT' access=readonly;
libname xpt2012 xport '../raw_data/2012/LLCP2012.XPT' access=readonly;

proc copy inlib=xpt1999 outlib=main; 
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

