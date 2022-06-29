/* rexx  __ANSIBLE_ENCODE_EBCDIC__       */
/*                                       */
/* AUTHOR: Mark Zelden                   */
/*                                       */
/* Trace ?r */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   D I S C L A I M E R                                             */
/*   -------------------                                             */
/*                                                                   */
/* This program is FREEWARE. Use at your own risk.  Neither Mark     */
/* Zelden, nor other contributing organizations or individuals       */
/* accept any liability of any kind howsoever arising out of the use */
/* of this program. You are free to use and modify this program as   */
/* you desire, however, the author does ask that you leave his name  */
/* in the source and give credit to him as the original programmer.  */
/*                                                                   */
/*********************************************************************/
/* IPLINFO:  DISPLAY SYSTEM INFORMATION ON TERMINAL                  */
/*********************************************************************/
/*                                                                   */
/* IPLINFO can be called as an interactive exec / ISPF edit macro    */
/* or in batch to display various system information.  The result    */
/* will be displayed in an ISPF browse data set if ISPF is active.   */
/*                                                                   */
/* IPLINFO can also be called as a REXX function to return from 1    */
/* to 20 variables used in the exec at their final value.  If more   */
/* than one variable is requested the variables are returned with    */
/* a blank or user defined delimiter between each variable so they   */
/* may be parsed if desired.                                         */
/*                                                                   */
/* See below for the sytax of each method.                           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* EXECUTION SYNTAX:                                                 */
/*                                                                   */
/* TSO %IPLINFO <option>                                             */
/*                                                                   */
/* VALID OPTIONS ARE 'ALL', 'IPL', 'VERsion', 'STOrage', 'CPU',      */
/*                   'IPA', 'SYMbols', 'VMAp', 'PAGe', 'SMF', 'SUB', */
/*                   'ASId', 'LPA', 'LNKlst', 'APF' and 'SVC'        */
/*                                                                   */
/* ** 'ALL' is the default option                                    */
/* ** Options may be abbreviated by using 3 or more characters       */
/*                                                                   */
/* ** A 2nd parameter option of 'NOBrowse' may also be specified to  */
/*    eliminate browsing the output even when ISPF is active. This   */
/*    will allow any IPLINFO output to be trapped and parsed from    */
/*    another exec or edit macro if desired.  The 'NOBrowse' option  */
/*    can also be specified as the only option and it will produce   */
/*    all IPLINFO output without browsing it.                        */
/*                                                                   */
/* ** A 2nd parameter option of 'EDIt' may also be specified to      */
/*    EDIT the output instead of browsing it. The 'EDIt' option      */
/*    can also be specified as the only option and it will produce   */
/*    all IPLINFO output without editing it.                         */
/*                                                                   */
/* ** The following options are not documented above as standard     */
/*    options nor in the help panel:                                 */
/*      "ASVt"   - an alias for the "ASId" option                    */
/*      "ASM"    - an alias for the "PAGE" option                    */
/*      "SSI"    - an alias for the "SUB"  option                    */
/*      "SSN"    - an alias for the "SUB"  option                    */
/*      "STOre"  - an alias for the "STORage"  option                */
/*      "MEMory" - an alias for the "STORage"  option                */
/*      "SUBsystems" - an alias for the "SUB"  option                */
/*      "NOBrowse"   - the NOBrowse option                           */
/*      "EDIt"       - the EDIt option                               */
/*                                                                   */
/* Examples:                                                         */
/*  TSO %IPLINFO         (Display all information)                   */
/*  TSO %IPLINFO VMAP    (Display a Virtual Storage Map)             */
/*  TSO %IPLINFO SYM     (Display Static System Symbols)             */
/*  TSO %IPLINFO SUB     (Display Subsystem Information)             */
/*  TSO %IPLINFO APF     (Display APF Library List)                  */
/*  TSO %IPLINFO ALL NOB (Display all infomation, don't browse O/P)  */
/*  TSO %IPLINFO SUB NOB (Display subsys info, don't browse O/P)     */
/*  TSO %IPLINFO NOBROWSE (Display all infomation, don't browse O/P) */
/*  TSO %IPLINFO ALL EDI (Display all infomation, edit O/P)          */
/*  TSO %IPLINFO SUB EDI (Display subsys info, edit O/P)             */
/*  TSO %IPLINFO EDIT    (Display all infomation, edit O/P)          */
/*                                                                   */
/* Edit macro invocation:                                            */
/*  IPLINFO              (Display all information)                   */
/*  IPLINFO VMAP         (Display a Virtual Storage Map)             */
/*  IPLINFO SYM          (Display Static System Symbols)             */
/*  IPLINFO SUB          (Display Subsystem Information)             */
/*  IPLINFO APF          (Display APF Library List)                  */
/*  IPLINFO ALL NOB      (Display all infomation, don't browse O/P)  */
/*  IPLINFO SUB NOB      (Display subsys info, don't browse O/P)     */
/*  IPLINFO NOBROWSE     (Display all infomation, don't browse O/P)  */
/*  IPLINFO ALL EDIT     (Display all infomation, edit O/P)          */
/*  IPLINFO SUB EDIT     (Display subsys info, edit O/P)             */
/*  IPLINFO EDIT         (Display all infomation, edit O/P)          */
/*                                                                   */
/* Sample Unix System Services WEB Server execution via links:       */
/*  <a href="/cgi-bin/iplinfo">MVS Information</a>                   */
/*  <a href="/cgi-bin/iplinfo?vmap">Virtual Storage Map</a>          */
/*  <a href="/cgi-bin/iplinfo?symbols">Static System Symbols</a>     */
/*  <a href="/cgi-bin/iplinfo?sub">Subsystem Information</a>         */
/*  <a href="/cgi-bin/iplinfo?apf">APF Library List</a>              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* FUNCTION SYNTAX:                                                  */
/*                                                                   */
/* IPLINFO(VAR,var1_name)                                            */
/* IPLINFO(VAR,var1_name,var2_name,var3_name, ... var20_name)        */
/*                                                                   */
/* Examples:                                                         */
/*  sysname = IPLINFO(VAR,GRSNAME)                                   */
/*  pvtsize = IPLINFO(VAR,GDAPVTSZ)                                  */
/*                                                                   */
/*                                                                   */
/*  /* REXX one line IPL information using IPLINFO rexx function */  */
/*  IPL_SUM  = IPLINFO(VAR,ipldate,ipltime,iplvol,ipladdr,iplparm)   */
/*  Parse var IPL_SUM ipldate ipltime iplvol ipladdr iplparm         */
/*  Say 'Date:'ipldate  ' Time:'ipltime ' Vol:'iplvol ,              */
/*      ' Load addr:'ipladdr ' LOADPARM:'iplparm                     */
/*                                                                   */
/*                                                                   */
/*  NOTE: The default delimeter between returned variables is a      */
/*        blank. However, this can be problematic when the returned  */
/*        value contains a blank or is null. You can optionally      */
/*        change the delimiter from a blank to one of your choice    */
/*        by using "VAR2" instead of "VAR" in the function call and  */
/*        specifying the delimiter character(s) as the next operand  */
/*        prior to the list of variables you want returned.          */
/*                                                                   */
/*                                                                   */
/* FUNCTION SYNTAX - "VAR2" / USER DEFINED DELIMITER:                */
/*                                                                   */
/* IPLINFO(VAR2,'dlm',var1_name)                                     */
/* IPLINFO(VAR2,'dlm',var1_name,var2_name,var3_name, ... var20_name) */
/*                                                                   */
/* Example:                                                          */
/*  /* REXX one line IPL information using IPLINFO rexx function */  */
/*  IPL_SUM  = IPLINFO(VAR2,'@@',ipldate,ipltime,iplvol, ,           */
/*                     ipladdr,iplparm)                              */
/*  Parse var IPL_SUM ipldate '@@' ipltime '@@' iplvol '@@' ,        */
/*                    ipladdr '@@' iplparm                           */
/*  Say 'Date:'ipldate  ' Time:'ipltime ' Vol:'iplvol ,              */
/*      ' Load addr:'ipladdr ' LOADPARM:'iplparm                     */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/* NOTE: The dynamic APF and dynamic LNKLST code in this exec        */
/*       use undocumented IBM control blocks and may break at        */
/*       any time!                                                   */
/*     ... tested on MVS ESA V4.3 up through z/OS 2.3.               */
/*                                                                   */
/* NOTE: The LNKLST SET displayed is the LNKLST SET of the address   */
/*       space running this exec, not necessarily the most           */
/*       current one. For the current LNKLST SET either:             */
/*       1) Run this exec in batch.                                  */
/*       2) Log off and on TSO before executing this exec.           */
/*       3) Issue SETPROG LNKLST,UPDATE,JOB=userid  (B4 execution)   */
/*                                                                   */
/* NOTE: The APF flag in the LNKLST display is the status if the     */
/*       data set is accessed VIA LNKLST. Therefore, if IEASYSxx     */
/*       specifies LNKAUTH=LNKLST, all entires are marked as APF=Y.  */
/*                                                                   */
/*********************************************************************/
LASTUPD = '09/24/2020'                       /* date of last update  */
/*********************************************************************/
/*                                                                   */
/* B E G I N    C U S T O M I Z A T I O N    S E C T I O N           */
/*                                                                   */
/*   You may changes the variables below to your preference.         */
/*   You may only choose the options that are commented out.         */
/*                                                                   */
/*  DATEFMT - Controls date format:   ISO ; USA ; EUR                */
/*  VMAP    - Controls VMAP order:    HIGHFIRST ; LOWFIRST           */
/*                                                                   */
/*********************************************************************/
DATEFMT = 'ISO'          /* ISO 8601 format YYYY-MM-DD (new default) */
/* DATEFMT = 'USA' */    /* USA format MM/DD/YYYY (original format)  */
/* DATEFMT = 'EUR' */    /* EUR format DD/MM/YYYY                    */
/*********************************************************************/
VMAP = 'HIGHFIRST'       /* new default - show VMAP from top down    */
/* VMAP = 'LOWFIRST' */  /* the old way - show from bottom up        */
/*  Please let me know if you "need" the old way (LOWFIRST) as I     */
/*  will probably remove the duplicate code in the future.           */
/*********************************************************************/
/*                                                                   */
/* E N D    C U S T O M I Z A T I O N    S E C T I O N               */
/*                                                                   */
/*********************************************************************/
Signal On  Syntax  name SIG_ALL     /* trap syntax errors            */
Signal On  Novalue name SIG_ALL     /* trap uninitialized variables  */
Arg OPTION,VAR.1,VAR.2,VAR.3,VAR.4,VAR.5,VAR.6,VAR.7,VAR.8,VAR.9, ,
  VAR.10,VAR.11,VAR.12,VAR.13,VAR.14,VAR.15,VAR.16,VAR.17,VAR.18, ,
  VAR.19,VAR.20,VAR.21
Parse source . EXEC_TYPE . . . . . ENV . .
MML      = Substr(LASTUPD,1,2)             /* MM from MM/DD/YYYY     */
DDL      = Substr(LASTUPD,4,2)             /* DD from MM/DD/YYYY     */
YYYYL    = Substr(LASTUPD,7,4)             /* YYYY from MM/DD/YYYY   */
If DATEFMT = 'USA' then ,                  /* USA format date?       */
  LASTUPD  = LASTUPD                       /* date as MM/DD/YYYY     */
If DATEFMT = 'EUR' then ,                  /* EUR format date?       */
  LASTUPD  = DDL'/'MML'/'YYYYL             /* date as DD/MM/YYYY     */
If DATEFMT = 'ISO' then ,                  /* ISO format date?       */
  LASTUPD  = YYYYL'-'MML'-'DDL             /* date as YYYY-MM-DD     */
SYSISPF = 'NOT ACTIVE'                     /* set SYSISPF=NOT ACTIVE */
FUNCDLM = ' '               /* Delimiter default for function call   */
If ENV <> 'OMVS' then                      /* are we under unix ?    */
  If Sysvar('SYSISPF')='ACTIVE' then do    /* no, is ISPF active?    */
    If Pos('NOB',OPTION) = 0 then ,        /* NOBrowse not used?     */
      Address ISREDIT "MACRO (OPTION)"     /* YES,allow use as macro */
    OPTION = Translate(OPTION)   /* ensure upper case for edit macro */
    Address ISPEXEC "VGET ZENVIR"          /* ispf version           */
    SYSISPF = 'ACTIVE'                     /* set SYSISPF = ACTIVE   */
  End
/*********************************************************************/
/* Process options                                                   */
/*********************************************************************/
BROWSEOP = 'YES'            /* default is to browse OP under ISPF    */
EDITOP   = 'NO'             /* output is not in edit mode            */
/*********************************************************************/
If SYSISPF = 'NOT ACTIVE' & Pos('EDI',OPTION) <> 0 then /* EDIT is   */
  call INVALID_OPTION       /* not valid if ISPF isn't active        */
If OPTION = '' then OPTION = 'ALL' /* Default option. Change to IPL  */
     /* or something else - may want to change help panel if changed */
If Abbrev('NOBROWSE',OPTION,3) = 1 then ,   /* NOBROWSE only opt?    */
  OPTION = 'ALL NOBROWSE'                /* yes, use all option      */
If Abbrev('EDIT',OPTION,3) = 1 then ,    /* EDITonly opt?            */
  OPTION = 'ALL EDIT'                    /* yes, use all option      */
If Abbrev('NOBROWSE',Word(OPTION,2),3) = 1 then do /* NOBROWSE USED? */
  OPTION = Word(OPTION,1)                /* separate out option      */
  BROWSEOP = 'NO'                        /* set BROWSEOP flag to NO  */
End
If Abbrev('EDIT',Word(OPTION,2),3) = 1 then do     /* EDIT USED?     */
  OPTION = Word(OPTION,1)                /* separate out option      */
  EDITOP   = 'YES'                       /* set EDITOP flag to YES   */
End
/*********************************************************************/
If OPTION <> 'IPL'                 & ,   /* check for IPL option     */
   Abbrev('VERSION',OPTION,3) <> 1 & ,   /* check for VERsion option */
   Abbrev('STORAGE',OPTION,3) <> 1 & ,   /* check for STOrage option */
   Abbrev('STORE',OPTION,3)   <> 1 & ,   /* check for STOre   option */
   Abbrev('MEMORY',OPTION,3)  <> 1 & ,   /* check for MEMory  option */
   OPTION <> 'CPU'                 & ,   /* check for CPU option     */
   OPTION <> 'IPA'                 & ,   /* check for IPA option     */
   Abbrev('SYMBOLS',OPTION,3) <> 1 & ,   /* check for SYMbols option */
   Abbrev('VMAP',OPTION,3) <> 1    & ,   /* check for VMAp option    */
   Abbrev('PAGE',OPTION,3) <> 1    & ,   /* check for PAGe option    */
   Abbrev('ASM',OPTION,3) <> 1     & ,   /* check for ASM option     */
   Abbrev('AUX',OPTION,3) <> 1     & ,   /* check for ASM option     */
   OPTION <> 'SMF'                 & ,   /* check for SMF option     */
   OPTION <> 'SSI'                 & ,   /* check for SSI option     */
   OPTION <> 'SSN'                 & ,   /* check for SSN option     */
   OPTION <> 'SUB'                 & ,   /* check for SUB option     */
   Abbrev('SUBSYSTEMS',OPTION,3) <> 1  & ,  /* check for SUB option  */
   Abbrev('ASID',OPTION,3) <> 1    & ,   /* check for ASId option    */
   Abbrev('ASVT',OPTION,3) <> 1    & ,   /* check for ASVt option    */
   OPTION <> 'LPA'                 & ,   /* check for LPA option     */
   Abbrev('LNKLST',OPTION,3) <> 1  & ,   /* check for LNKlst option  */
   Abbrev('LINKLIST',OPTION,3) <> 1 & ,  /* check for LINklist option*/
   OPTION <> 'APF'                 & ,   /* check for APF option     */
   OPTION <> 'SVC'                 & ,   /* check for SVC option     */
   OPTION <> 'ALL'                 & ,   /* check for ALL option     */
   Substr(OPTION,1,3) <> 'VAR'       ,   /* check for VAR option     */
   then call INVALID_OPTION              /* no valid option...       */
Numeric digits 20                           /* dflt of 9 not enough  */
                                            /* 20 can handle 64-bit  */
Call COMMON            /* control blocks needed by multiple routines */
Call HEADING                                /* Heading sub-routine   */
Select
  When OPTION = 'ALL' |  Substr(OPTION,1,3) = 'VAR' then do
    Call IPL                                /* IPL information       */
    Call VERSION                            /* Version information   */
/*  Call STOR                                  Storage information   */
/*  Call CPU                                   CPU information       */
    Call IPA                                /* Initialization info.  */
    Call SYMBOLS                            /* Symbols information   */
/*  Call VMAP                                  Virt. Storage Map     */
/*  Call PAGE                                  Page DSN information  */
/*  Call SMF                                   SMF DSN information   */
/*  Call SUB                                   Subsystem information */
/*  Call ASID                                  ASID usage information*/
/*  Call LPA                                   LPA List information  */
/*  Call LNKLST                                LNKLST information    */
/*  Call APF                                   APF List information  */
/*  Call SVC                                   SVC information       */
  End /* when OPTION = 'ALL' */
  When Abbrev('VERSION',OPTION,3)  = 1 then call VERSION
  When Abbrev('STORAGE',OPTION,3)  = 1 then call STOR
  When Abbrev('STORE',OPTION,3)    = 1 then call STOR
  When Abbrev('MEMORY',OPTION,3)   = 1 then call STOR
  When Abbrev('SYMBOLS',OPTION,3)  = 1 then call SYMBOLS
  When Abbrev('VMAP',OPTION,3)     = 1 then call VMAP
  When Abbrev('ASM',OPTION,3)      = 1 then call PAGE
  When Abbrev('AUX',OPTION,3)      = 1 then call PAGE
  When Abbrev('SSI',OPTION,3)      = 1 then call SUB
  When Abbrev('SSN',OPTION,3)      = 1 then call SUB
  When Abbrev('SUBSYSTEMS',OPTION,3) = 1 then call SUB
  When Abbrev('PAGE',OPTION,3)     = 1 then call PAGE
  When Abbrev('ASID',OPTION,3)     = 1 then call ASID
  When Abbrev('ASVT',OPTION,3)     = 1 then call ASID
  When Abbrev('LNKLST',OPTION,3)   = 1 then call LNKLST
  When Abbrev('LINKLIST',OPTION,3) = 1 then call LNKLST
  Otherwise interpret "Call" OPTION
End /* select */
/*********************************************************************/
/* Done looking at all control blocks                                */
/*********************************************************************/
/*********************************************************************/
/* IPLINFO called as a function with an alternate delimiter.         */
/* Return variable names and exit                                    */
/*********************************************************************/
If Substr(OPTION,1,4) = 'VAR2' & EXEC_TYPE='FUNCTION' then do
  "DROPBUF"                                   /* remove data stack   */
  FUNCDLM  = VAR.1                            /* function delimiter  */
  ALL_VARS = Value(VAR.2)                     /* at least one var    */
  Do V = 3 to 21                              /* check for others    */
    If VAR.V = '' then leave                  /* done, leave loop    */
    Else ALL_VARS = ALL_VARS || ,             /* concat additional   */
                   FUNCDLM || Value(VAR.V)    /*  var + dlm at end   */
  End  /* end Do V */
  Return ALL_VARS                             /* return vars         */
End
/*********************************************************************/
/* IPLINFO called as a function. Return variable names and exit      */
/*********************************************************************/
If Substr(OPTION,1,3) = 'VAR' & EXEC_TYPE='FUNCTION' then do
  "DROPBUF"                                   /* remove data stack   */
  ALL_VARS = Value(VAR.1)                     /* at least one var    */
  Do V = 2 to 20                              /* check for others    */
    If VAR.V = '' then leave                  /* done, leave loop    */
    Else ALL_VARS = ALL_VARS || ,             /* concat additional   */
                   FUNCDLM || Value(VAR.V)    /*  var + dlm at end   */
  End  /* end Do V */
  Return ALL_VARS                             /* return vars         */
End
/*********************************************************************/
/* If ISPF is active and the BROWSEOP option is set (default) then   */
/* browse the output - otherwise write to the terminal               */
/*********************************************************************/
If SYSISPF = 'ACTIVE' & BROWSEOP = 'YES' ,   /* ISPF active and      */
 then call BROWSE_ISPF                       /* BROWSEOP option set? */
Else do queued()                             /* ISPF is not active   */
  Parse pull line                            /* pull queued lines    */
  Say line                                   /* say lines            */
End /* else do  */
Exit 0                                       /* End IPLINFO - RC 0   */
/*********************************************************************/
/*  End of main IPLINFO code                                         */
/*********************************************************************/
/*********************************************************************/
/*  Start of sub-routines                                            */
/*********************************************************************/
INVALID_OPTION:      /* Invalid option sub-routine                   */
If SYSISPF = 'ACTIVE' then do
  Queue ' '
  Queue '   ******************************************************'
  If OPTION <> '?' then,
    Queue '   *            Invalid IPLINFO option.                 *'
  Queue '   *   Please hit PF1/HELP two times for valid options. *'
  Queue '   ******************************************************'
  Queue ' '
  OPTION = 'Invalid'
  Call BROWSE_ISPF
  Exit 16
  End
Else do
  Call CKWEB                               /* call CKWEB sub-routine */
  Say Copies('*',79)
  Say " "
  If OPTION <> '?' then,
    Say "Invalid IPLINFO option."
  Say " "
  Say "EXECUTION SYNTAX: %IPLINFO <option>"
  Say " "
  Say "VALID OPTIONS ARE 'ALL', 'IPL', 'VERsion'," ,
      "'STOrage', 'CPU', 'IPA', 'SYMbols',"
  Say " 'VMAp', 'PAGe', 'SMF', 'SUB'," ,
      "'ASId', 'LPA', 'LNKlst' or 'LINklist' and 'APF'"
  Say " "
  Say "** 'ALL' is the default option"
  Say "** OPTIONS may be abbreviated by using 3 or more characters"
  Say " "
  Say Copies('*',79)
  If OPTION = '?' then Exit 0
    Else exit 16
End
return
 
HEADING:             /* Heading sub-routine                          */
Call CKWEB                                 /* call CKWEB sub-routine */
Call RDATE 'TODAY'                         /* call RDATE sub-routine */
DAY      = Word(RESULT,3)                  /* weekday from RDATE     */
MMT      = Substr(RESULT,1,2)              /* MM from MM/DD/YYYY     */
DDT      = Substr(RESULT,4,2)              /* DD from MM/DD/YYYY     */
YYYYT    = Substr(RESULT,7,4)              /* YYYY from MM/DD/YYYY   */
If DATEFMT = 'USA' then ,                  /* USA format date?       */
  DATE     = Substr(RESULT,1,10)           /* date as MM/DD/YYYY     */
If DATEFMT = 'EUR' then ,                  /* EUR format date?       */
  DATE     = DDT'/'MMT'/'YYYYT             /* date as DD/MM/YYYY     */
If DATEFMT = 'ISO' then ,                  /* ISO format date?       */
  DATE     = YYYYT'-'MMT'-'DDT             /* date as YYYY-MM-DD     */
JUL      = Substr(RESULT,7,8)              /* date as YYYY.DDD       */
CURNNNNN = Substr(RESULT,16,5)             /* date as NNNNN          */
/*Queue Copies('*',79)*/
Queue Copies('*',15) || ,
      Center('IPLINFO - SYSTEM INFORMATION FOR' GRSNAME,49) || ,
      Copies('*',15)
/*Queue Copies('*',79) */
Queue ' '
Queue 'Today is 'DAY DATE '('JUL'). The local time is 'TIME()'.'
Return
 
CKWEB:         /* Create HTML needed for web page output sub-routine */
If ENV = 'OMVS' then do                    /* Are we under OMVS?     */
  Do CKWEB = __ENVIRONMENT.0 to 1 by -1    /* check env. vars        */
     If pos('HTTP_',__ENVIRONMENT.CKWEB) <> 0 then do  /* web server */
       Say 'Content-type: text/html'
       Say ''
       Say '<title>Mark''s MVS Utilities - IPLINFO</title>'
       Say '<meta name="author" content="Mark Zelden -' ,
           'mark@mzelden.com">'
       Say '<meta name="description" content="' || ,
           'IPLINFO -' OPTION 'option.' ,
           'Last updated on' LASTUPD ||'. Written by' ,
           'Mark Zelden. Mark''s MVS Utilities -' ,
           'http://www.mzelden.com/mvsutil.html">'
       Say '<meta http-equiv="pragma" content="no-cache">'
       Say '<body BGCOLOR="#000000" TEXT="#00FFFF">'
       Say '<pre>'
       Leave                               /* exit loop              */
     End /* if pos */
  End /* do CKWEB */
End
Return
 
COMMON:              /* Control blocks needed by multiple routines   */
CVT      = C2d(Storage(10,4))                /* point to CVT         */
CVTFLAG2 = Storage(D2x(CVT+377),1)           /* CVT flag byte 2      */
CVTEXT2  = C2d(Storage(D2x(CVT + 328),4))    /* point to CVTEXT2     */
PRODNAME = Storage(D2x(CVT - 40),7)          /* point to mvs version */
If Substr(PRODNAME,3,1) >= 3 then do         /* HBB3310 ESA V3 & >   */
  CVTOSLV0   = Storage(D2x(CVT + 1264),1)    /* Byte 0 of CVTOSLVL   */
  CVTOSLV1   = Storage(D2x(CVT + 1265),1)    /* Byte 1 of CVTOSLVL   */
  CVTOSLV2   = Storage(D2x(CVT + 1266),1)    /* Byte 2 of CVTOSLVL   */
  CVTOSLV3   = Storage(D2x(CVT + 1267),1)    /* Byte 3 of CVTOSLVL   */
  CVTOSLV4   = Storage(D2x(CVT + 1268),1)    /* Byte 4 of CVTOSLVL   */
  CVTOSLV5   = Storage(D2x(CVT + 1269),1)    /* Byte 5 of CVTOSLVL   */
  CVTOSLV6   = Storage(D2x(CVT + 1270),1)    /* Byte 6 of CVTOSLVL   */
  CVTOSLV7   = Storage(D2x(CVT + 1271),1)    /* Byte 7 of CVTOSLVL   */
  CVTOSLV8   = Storage(D2x(CVT + 1272),1)    /* Byte 8 of CVTOSLVL   */
  CVTOSLV9   = Storage(D2x(CVT + 1273),1)    /* Byte 9 of CVTOSLVL   */
End
If Bitand(CVTOSLV0,'08'x) = '08'x then ,     /* HBB4410 ESA V4 & >   */
  ECVT     = C2d(Storage(D2x(CVT + 140),4))  /* point to CVTECVT     */
FMIDNUM  = Storage(D2x(CVT - 32),7)          /* point to fmid        */
JESCT    = C2d(Storage(D2x(CVT + 296),4))    /* point to JESCT       */
JESCTEXT = C2d(Storage(D2x(JESCT +100),4))   /* point to JESPEXT     */
JESPJESN = Storage(D2x(JESCT + 28),4)        /* name of primary JES  */
CVTSNAME = Storage(D2x(CVT + 340),8)         /* point to system name */
GRSNAME  = Strip(CVTSNAME,'T')               /* del trailing blanks  */
CSD      = C2d(Storage(D2x(CVT + 660),4))    /* point to CSD         */
SMCA     = Storage(D2x(CVT + 196),4)         /* point to SMCA        */
SMCA     = Bitand(SMCA,'7FFFFFFF'x)          /* zero high order bit  */
SMCA     = C2d(SMCA)                         /* convert to decimal   */
ASMVT    = C2d(Storage(D2x(CVT + 704),4))    /* point to ASMVT       */
CVTSCPIN = D2x(CVT+832)                      /* point to SCPINFO     */
If Bitand(CVTOSLV5,'08'x) = '08'x then do    /* z/OS 1.10 and above  */
  ECVTSCPIN = D2x(ECVT+876)                  /* point to cur SCPINFO */
  SCCB      = C2d(Storage(ECVTSCPIN,4))      /* Service Call Cntl Blk*/
End
Else SCCB   = C2d(Storage(CVTSCPIN,4))       /* Service Call Cntl Blk*/
RCE      = C2d(Storage(D2x(CVT + 1168),4))   /* point to RCE         */
MODEL    = C2d(Storage(D2x(CVT - 6),2))      /* point to cpu model   */
/*********************************************************************/
/*  The CPU model is stored in packed decimal format with no sign,   */
/*  so to make the model printable, it needs to be converted back    */
/*  to hex.                                                          */
/*********************************************************************/
MODEL    = D2x(MODEL)                        /* convert back to hex  */
PCCAVT    = C2d(Storage(D2x(CVT + 764),4))   /* point to PCCA vect tb*/
If Bitand(CVTOSLV1,'01'x) = '01'x then do    /* OS/390 R2 and above  */
  ECVTIPA  = C2d(Storage(D2x(ECVT + 392),4)) /* point to IPA         */
  IPASCAT  = Storage(D2x(ECVTIPA + 224),63)  /* SYSCAT  card image   */
End
zARCH = 1                                    /* default ARCHLVL      */
If Bitand(CVTOSLV2,'01'x) = '01'x then do    /* OS/390 R10 and above */
  FLCARCH  = Storage('A3',1)                 /* FLCARCH in PSA       */
  If C2d(FLCARCH) <> 0 then zARCH=2          /* non-zero is z/Arch.  */
End
Return
 
IPL:                 /* IPL information sub-routine                  */
Queue ' '
/*********************************************************************/
/*  The IPL date is stored in packed decimal format - so to make     */
/*  the date printable, it needs to be converted back to hex and     */
/*  the packed sign needs to be removed.                             */
/*********************************************************************/
/*  Converting binary fields to time of day format is described      */
/*  in the MVS SMF manual.                                           */
/*********************************************************************/
IPLTIME  = C2d(Storage(D2x(SMCA + 336),4))   /* IPL Time - binary    */
IPLDATE  = C2d(Storage(D2x(SMCA + 340),4))   /* IPL Date - 0CYYDDDF  */
If IPLDATE  >= 16777231 then do              /*          is C = 1 ?  */
  IPLDATE  = D2x(IPLDATE)                    /* convert back to hex  */
  IPLDATE  = Substr(IPLDATE,2,5)             /* keep YYDDD           */
  IPLDATE  = '20'IPLDATE                     /* use 21st century date*/
End
Else do
  IPLDATE  = D2x(IPLDATE)                    /* convert back to hex  */
  IPLDATE  = Left(IPLDATE,5)                 /* keep YYDDD           */
  IPLDATE  = '19'IPLDATE                     /* use 20th century date*/
End
IPLYYYY  = Substr(IPLDATE,1,4)               /* YYYY portion of date */
IPLDDD   = Substr(IPLDATE,5,3)               /* DDD  portion of date */
Call RDATE IPLYYYY IPLDDD                    /* call RDATE subroutine*/
IPLDAY   = Word(RESULT,3)                    /* weekday from RDATE   */
MMI      = Substr(RESULT,1,2)                /* MM from MM/DD/YYYY   */
DDI      = Substr(RESULT,4,2)                /* DD from MM/DD/YYYY   */
YYYYI    = Substr(RESULT,7,4)                /* YYYY from MM/DD/YYYY */
If DATEFMT = 'USA' then ,                    /* USA format date?     */
  IPLDATE  = Substr(RESULT,1,10)             /* date as MM/DD/YYYY   */
If DATEFMT = 'EUR' then ,                    /* EUR format date?     */
  IPLDATE  = DDI'/'MMI'/'YYYYI               /* date as DD/MM/YYYY   */
If DATEFMT = 'ISO' then ,                    /* ISO format date?     */
  IPLDATE  = YYYYI'-'MMI'-'DDI               /* date as YYYY-MM-DD   */
IPLJUL   = Substr(RESULT,7,8)                /* date as YYYY.DDD     */
IPLNNNNN = Substr(RESULT,16,5)               /* date as NNNNN        */
IPLHH    = Right(IPLTIME%100%3600,2,'0')     /* IPL hour             */
IPLMM    = Right(IPLTIME%100//3600%60,2,'0') /* IPL minute           */
IPLSS    = Right(IPLTIME%100//60,2,'0')      /* IPL seconds          */
IPLTIME  = IPLHH':'IPLMM':'IPLSS             /* time in HH:MM:SS     */
/*                                                                   */
ASMFLAG2 = Storage(D2x(ASMVT + 1),1)         /* point to ASMFLAG2    */
If Bitand(ASMFLAG2,'08'x) = '08'x then ,     /* Check ASMQUICK bit   */
  IPLCLPA    = 'without CLPA'                /* bit on  - no CLPA    */
Else IPLCLPA = 'with CLPA'                   /* bit off - CLPA       */
RESUCB   = C2d(Storage(D2x(JESCT + 4),4))    /* point to SYSRES UCB  */
IPLVOL   = Storage(D2x(RESUCB + 28),6)       /* point to IPL volume  */
If Bitand(CVTOSLV1,'20'x) <> '20'x then ,    /* Below HBB5510 ESA V5 */
  IPLADDR  = Storage(D2x(RESUCB + 13),3)     /* point to IPL address */
Else do
  CVTSYSAD = C2d(Storage(D2x(CVT + 48),4))   /* point to UCB address */
  IPLADDR  = Storage(D2x(CVTSYSAD + 4),2)    /* point to IPL UCB     */
  IPLADDR  = C2x(IPLADDR)                    /* convert to EBCDIC    */
End
SMFNAME  = Storage(D2x(SMCA + 16),4)         /* point to SMF name    */
SMFNAME  = Strip(SMFNAME,'T')                /* del trailing blanks  */
AMCBS    = C2d(Storage(D2x(CVT + 256),4))    /* point to AMCBS       */
If Bitand(CVTOSLV2,'80'x) <> '80'x then do   /*Use CAXWA B4 OS/390 R4*/
  ACB      = C2d(Storage(D2x(AMCBS + 8),4))  /* point to ACB         */
  CAXWA    = C2d(Storage(D2x(ACB + 64),4))   /* point to CAXWA       */
  MCATDSN  = Storage(D2x(CAXWA + 52),44)     /* master catalog dsn   */
  MCATDSN  = Strip(MCATDSN,'T')              /* remove trailing blnks*/
  MCATUCB  = C2d(Storage(D2x(CAXWA + 28),4)) /* point to mcat UCB    */
  MCATVOL  = Storage(D2x(MCATUCB + 28),6)    /* master catalog VOLSER*/
End
Else do                                      /* OS/390 R4 and above  */
  MCATDSN  = Strip(Substr(IPASCAT,11,44))    /* master catalog dsn   */
  MCATVOL  = Substr(IPASCAT,1,6)             /* master catalog VOLSER*/
  IPASCANL = Storage(d2x(ECVTIPA+231),1)     /* mcat alias level     */
  IPASCTYP = Storage(d2x(ECVTIPA+230),1)     /* mcat catalog type    */
  AMCBSFLG = Storage(D2x(AMCBS + 96),1)      /* AMCBS flags          */
  AMCBSALV = C2d(Storage(D2x(AMCBS + 155),1)) /* AMCBS - alias level */
  If IPASCANL = ' ' then IPASCANL = 1  /* SYSCAT col 17 blank / dflt */
  If IPASCTYP = ' ' then IPASCTYP = 1  /* SYSCAT col 16 blank / dflt */
  CTYP.0   = 'VSAM'
  CTYP.1   = 'ICF. SYS%-SYS1 conversion was not active at IPL time'
  CTYP.2   = 'ICF. SYS%-SYS1 conversion was active at IPL time'
End
Queue 'The last IPL was 'IPLDAY IPLDATE '('IPLJUL')' ,
      'at 'IPLTIME' ('CURNNNNN - IPLNNNNN' days ago).'
Queue 'The IPL was done 'IPLCLPA'.'
Queue 'The system IPL address was 'IPLADDR' ('IPLVOL').'
If Bitand(CVTOSLV0,'08'x) = '08'x then do    /* HBB4410 ESA V4 1 & > */
  ECVTSPLX = Storage(D2x(ECVT+8),8)          /* point to SYSPLEX name*/
  ECVTLOAD = Storage(D2x(ECVT+160),8)        /* point to LOAD PARM   */
  IPLPARM  = Strip(ECVTLOAD,'T')             /* del trailing blanks  */
  SEPPARM  = Substr(IPLPARM,1,4) Substr(IPLPARM,5,2),
             Substr(IPLPARM,7,1) Substr(IPLPARM,8,1)
  SEPPARM  = Strip(SEPPARM,'T')              /* del trailing blanks  */
  Queue 'The IPL LOAD PARM used was 'IPLPARM' ('SEPPARM').'
  If Bitand(CVTOSLV1,'20'x) = '20'x then do  /* HBB5510 ESA V5 & >   */
    CVTIXAVL = C2d(Storage(D2x(CVT+124),4))      /* point to IOCM    */
    IOCIOVTP = C2d(Storage(D2x(CVTIXAVL+208),4)) /* IOS Vector Table */
    CDA      = C2d(Storage(D2x(IOCIOVTP+24),4))  /* point to CDA     */
  End
  CVTTZ      = Storage(D2x(CVT + 304),4)     /* point to cvttz       */
  CKTZBYTE   = Storage(D2x(CVT + 304),1)     /* need to chk 1st byte */
  If bitand(CKTZBYTE,'80'x) = '80'x then ,   /* chk for negative     */
    CVTTZ    = C2d(CVTTZ,4)                  /* negative offset C2d  */
  Else CVTTZ = C2d(CVTTZ)                    /* postitive offset C2d */
  CVTTZ      = CVTTZ * 1.048576 / 3600       /* convert to hours     */
  If Format(CVTTZ,3,1) = Format(CVTTZ,3,0) , /* don't use decimal if */
   then CVTTZ = Strip(Format(CVTTZ,3,0))     /* not needed           */
  Else  CVTTZ = Strip(Format(CVTTZ,3,1))     /* display 1 decimal    */
  Queue 'The local time offset from GMT time is' CVTTZ 'hours.'
  If Bitand(CVTOSLV1,'10'x) = '10'x then do  /* HBB5520 ESA V5.2 & > */
    ECVTHDNM = Storage(D2x(ECVT+336),8)      /* point to hardware nam*/
    ECVTLPNM = Storage(D2x(ECVT+344),8)      /* point to LPAR name   */
    If Bitand(CVTOSLV2,'01'x) = '01'x then do  /* OS/390 R10 & above */
      MIFID    = C2d(Storage(D2X(CDA+252),1))  /* MIF ID in decimal  */
      MIFID    = D2x(MIFID)                    /* MIF ID in hex      */
      If Bitand(CVTOSLV3,'04'x) = '04'x then do /* z/OS 1.4 and above*/
        IOCCSSID = C2d(Storage(d2x(CVTIXAVL+275),1))
        IOCCSSID = D2x(IOCCSSID)                /* CSS ID in hex     */
      End
      If zARCH = 2 then ,                    /* z/Architechture      */
        Queue 'The system is running in z/Architecture mode' ,
               '(ARCHLVL = 2).'
      Else ,                                 /* ESA/390 mode         */
        Queue 'The system is running in ESA/390 mode (ARCHLVL = 1).'
    End /* If Bitand(CVTOSLV2,'01'x) = '01'x */
    If ECVTHDNM <> ' ' & ECVTLPNM <> ' ' then do
      CSDPLPN  = C2d(Storage(D2x(CSD + 252),1))    /* point to LPAR #*/
   /* CSDPLPN not valid for z990 (T-REX) or z890 for LPAR number     */
      CPOFF = 0  /* init offset to next PCCA entry                   */
      PCCA  = 0  /* init PCCA to 0                                   */
      Do until PCCA <> 0   /* do until we find a valid PCCA          */
        PCCA = C2d(Storage(D2x(PCCAVT + CPOFF),4)) /* point to PCCA  */
        If PCCA <> 0 then do
          LPAR_#  = X2d(Storage(D2x(PCCA + 6),2))  /* LPAR # in hex  */
          LPAR_#  = D2x(LPAR_#)                    /* display as hex */
        End /* if PCCA <> 0 */
        Else CPOFF = CPOFF + 4  /* bump up offset for next PCCA      */
      End /* do until PCCA <> 0 */
      If Bitand(CVTOSLV2,'01'x) = '01'x then do    /* OS/390 R10 & > */
        Queue 'The Processor name is' Strip(ECVTHDNM)'.' ,
               'The LPAR name is' Strip(ECVTLPNM)'.'
        If Bitand(CVTOSLV3,'04'x) = '04'x then  /* z/OS 1.4 and above*/
          Queue ' ' Strip(ECVTLPNM) 'is (HMC defined) LPAR ID =' ,
                LPAR_#', MIF ID =' mifid 'and CSS ID = 'IOCCSSID'.'
        Else ,
          Queue ' ' Strip(ECVTLPNM) 'is (HMC defined) LPAR ID =' ,
                LPAR_# 'and MIF ID =' mifid'.'
        Queue ' ' Strip(ECVTLPNM) 'is PR/SM partition number' ,
                   CSDPLPN' (internal value from the CSD).'
      End /* If Bitand(CVTOSLV2,'01'x) = '01'x */
      Else ,
        Queue 'The Processor name is' Strip(ECVTHDNM)'.' ,
               'The LPAR name is' Strip(ECVTLPNM)' (LPAR #'CSDPLPN').'
    End  /* If ECVTHDNM <> ' ' & ECVTLPNM <> ' '   */
    Else if ECVTHDNM <> ' ' then ,
      Queue 'The Processor name is' Strip(ECVTHDNM)'.'
    If Bitand(CVTOSLV1,'20'x) = '20'x ,   /* HBB5510 ESA V5 & above  */
       & ECVTSPLX <> 'LOCAL' then do      /* and not a local sysplex */
      JESDSNID = X2d(Storage(D2x(JESCTEXT+120),2)) /*ID for temp dsns*/
      Queue 'The sysplex name is' Strip(ECVTSPLX)'. This was system' ,
            'number' Format(JESDSNID) 'added to the sysplex.'
    End /* If Bitand(CVTOSLV1,'20'x) = '20'x */
    Else queue 'The sysplex name is' Strip(ECVTSPLX)'.'
  End  /* If Bitand(CVTOSLV1,'10'x) = '10'x */
End
Queue 'The GRS system id (SYSNAME) is 'GRSNAME'.'
If Bitand(CVTOSLV1,'10'x) = '10'x then do  /* HBB5520 ESA V5.2 & > */
  ECVTGMOD   = C2d(Storage(D2x(ECVT + 266),1)) /* GRS mode         */
  GMOD.0     = "NONE"  /* Stem for GRS mode: ECVTGNON EQU 0        */
  GMOD.1     = "RING"  /* Stem for GRS mode: ECVTGRNG EQU 1        */
  GMOD.2     = "STAR"  /* Stem for GRS mode: ECVTGSTA EQU 2        */
  Queue '  The GRS mode is' GMOD.ECVTGMOD' (NONE, RING or STAR).'
End
Queue 'The SMF system id (SID) is 'SMFNAME'.'
If Bitand(CVTOSLV1,'20'x) <> '20'x then do   /* Below HBB5510 ESA V5 */
  IOCON    = Storage(D2x(CVTEXT2 + 6),2)       /* HCD IODFxx or MVSCP*/
                                               /* IOCONFIG ID=xx     */
  Queue 'The currently active IOCONFIG or HCD IODF is 'IOCON'.'
End
Else do
  IODF     = Storage(D2X(CDA+32),44)           /* point to IODF name */
  IODF     = Strip(IODF,'T')                   /* del trailing blanks*/
  CONFIGID = Storage(D2X(CDA+92),8)            /* point to CONFIG    */
  EDT      = Storage(D2X(CDA+104),2)           /* point to EDT       */
  IOPROC   = Storage(D2X(CDA+124),8)           /* point to IODF Proc */
  IODATE   = Storage(D2X(CDA+156),8)           /* point to IODF date */
  IOTIME   = Storage(D2X(CDA+164),8)           /* point to IODF time */
  IODESC   = Storage(D2X(CDA+172),16)          /* point to IODF desc */
  Queue 'The currently active IODF data set is 'IODF'.'
  Queue '  Configuration ID =' CONFIGID ' EDT ID =' EDT
  If Substr(IOPROC,1,1) <> '00'x  & ,
     Substr(IOPROC,1,1) <> '40'x then do       /* is token there?    */
    Queue '  TOKEN: Processor  Date      Time      Description'
    Queue '         'IOPROC'   'IODATE'  'IOTIME'  'IODESC
  End
End
Queue 'The Master Catalog is 'MCATDSN' on 'MCATVOL'.'
If Bitand(CVTOSLV2,'80'x) = '80'x then do    /* OS/390 R4 and above  */
 Queue '  The catalog alias level was 'IPASCANL' at IPL time.'
 Queue '    The catalog alias level is currently' AMCBSALV'.'
 Queue '  The catalog type is 'CTYP.IPASCTYP'.'
 If Bitand(AMCBSFLG,'40'x) = '40'x then ,
   Queue '    SYS%-SYS1 conversion is currently active.'
 Else ,
   Queue '    SYS%-SYS1 conversion is not currently active.'
End
/*If OPTION = 'IPL' then interpret call 'VERSION' */ /* incl version*/
Return
 
VERSION:             /* Version information sub-routine              */
Queue ' '
Call SUB 'FINDJES'   /* call SUB routine with FINDJES option         */
If JESPJESN = 'JES3' then do                 /* Is this JES3?        */
  If ENV = 'OMVS' then do  /* running under Unix System Services     */
    JES3FMID = Storage(D2x(JESSSVT+644),8)      /* JES3 FMID         */
    Select  /* determine JES3 version from FMID  */
      When JES3FMID = 'HJS5521' then JESLEV = 'SP 5.2.1'
      When JES3FMID = 'HJS6601' then JESLEV = 'OS 1.1.0'
      When JES3FMID = 'HJS6604' then JESLEV = 'OS 2.4.0'
      When JES3FMID = 'HJS6606' then JESLEV = 'OS 2.6.0'
      When JES3FMID = 'HJS6608' then JESLEV = 'OS 2.8.0'
      When JES3FMID = 'HJS6609' then JESLEV = 'OS 2.9.0'
      When JES3FMID = 'HJS7703' then JESLEV = 'OS 2.10.0'
      When JES3FMID = 'HJS7705' then JESLEV = 'z 1.2.0'
      When JES3FMID = 'HJS7707' then JESLEV = 'z 1.4.0'
      When JES3FMID = 'HJS7708' then JESLEV = 'z 1.5.0'
      When JES3FMID = 'HJS7720' then JESLEV = 'z 1.7.0'
      When JES3FMID = 'HJS7730' then JESLEV = 'z 1.8.0'
      When JES3FMID = 'HJS7740' then JESLEV = 'z 1.9.0'
      When JES3FMID = 'HJS7750' then JESLEV = 'z 1.10.0'
      When JES3FMID = 'HJS7760' then JESLEV = 'z 1.11.0'
      When JES3FMID = 'HJS7770' then JESLEV = 'z 1.12.0'
      When JES3FMID = 'HJS7780' then JESLEV = 'z 1.13.0'
      When JES3FMID = 'HJS7790' then JESLEV = 'z 2.1.0'
      When JES3FMID = 'HJS77A0' then JESLEV = 'z 2.2.0'
      When JES3FMID = 'HJS77B0' then JESLEV = 'z 2.3.0'
      When JES3FMID = 'HJS77C0' then JESLEV = 'z 2.4.0'
      Otherwise JESLEV = JES3FMID /* if not in tbl, use FMID as ver  */
    End /* select */
    JESNODE  = '*not_avail*'                 /* can't do under USS   */
  End /* if env = 'omvs' */
  Else do /* if not running under Unix System Services, use TSO VARs */
    JESLEV   = SYSVAR('SYSJES')              /* TSO/E VAR for JESLVL */
    JESNODE  = SYSVAR('SYSNODE')             /* TSO/E VAR for JESNODE*/
  End
End
Else do  /* JES2 */
  JESLEV   = Strip(Storage(D2x(JESSUSE),8))  /* JES2 Version         */
  /* offset in $HCCT - CCTNDENM */
  Select
    When Substr(JESLEV,1,8) == 'z/OS 2.4' then, /* z/OS 2.4          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+696),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS 2.3' | ,   /* z/OS 2.3          */
      Substr(JESLEV,1,8) == 'z/OS 2.2'  then,   /* z/OS 2.2          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+664),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS 2.1' | ,   /* z/OS 2.1          */
      Substr(JESLEV,1,8) == 'z/OS1.13'    | ,   /* z/OS 1.13         */
      Substr(JESLEV,1,8) == 'z/OS1.12'    | ,   /* z/OS 1.12         */
      Substr(JESLEV,1,8) == 'z/OS1.11'  then,   /* z/OS 1.11         */
      JESNODE  = Strip(Storage(D2x(JESSUS2+656),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS1.10' | ,  /* z/OS 1.10          */
      Substr(JESLEV,1,8) == 'z/OS 1.9' then,    /* z/OS 1.9          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+708),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS 1.8' then, /* z/OS 1.8          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+620),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS 1.7' then, /* z/OS 1.7          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+616),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,8) == 'z/OS 1.5' | , /* z/OS 1.5 & 1.6      */
      Substr(JESLEV,1,8) == 'z/OS 1.4' then   /* z/OS 1.4            */
      JESNODE  = Strip(Storage(D2x(JESSUS2+532),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,7) == 'OS 2.10' | ,  /* OS/390 2.10 and     */
      Substr(JESLEV,1,8) == 'z/OS 1.2' then,  /* z/OS 1.2            */
      JESNODE  = Strip(Storage(D2x(JESSUS2+452),8)) /* JES2 NODE     */
    When Substr(JESLEV,1,6) == 'OS 1.1' | , /* OS/390 1.1  or        */
      Substr(JESLEV,1,4) == 'SP 5' then ,    /* ESA V5 JES2          */
      JESNODE  = Strip(Storage(D2x(JESSUS2+336),8)) /*   JES2 NODE   */
    When Substr(JESLEV,1,5) == 'OS 1.' | ,   /* OS/390 1.2           */
      Substr(JESLEV,1,5) == 'OS 2.' then,    /*  through OS/390 2.9  */
      JESNODE  = Strip(Storage(D2x(JESSUS2+372),8)) /* JES2 NODE     */
    Otherwise ,                              /* Lower than ESA V5    */
      If ENV = 'OMVS' then JESNODE = '*not_avail*'
      else JESNODE  = SYSVAR('SYSNODE')      /* TSO/E VAR for JESNODE*/
  End  /* select */
End /* else do */
/*                                                                   */
CVTVERID = Storage(D2x(CVT - 24),16)         /* "user" software vers.*/
CVTRAC   = C2d(Storage(D2x(CVT + 992),4))    /* point to RACF CVT    */
RCVT     = CVTRAC                            /* use RCVT name        */
RCVTID   = Storage(D2x(RCVT),4)              /* point to RCVTID      */
                                             /* RCVT, ACF2, or RTSS  */
SECNAM = RCVTID                              /* ACF2 SECNAME = RCVTID*/
If RCVTID = 'RCVT' then SECNAM = 'RACF'      /* RCVT is RACF         */
If RCVTID = 'RTSS' then SECNAM = 'Top Secret'  /* RTSS is Top Secret */
RACFVRM  = Storage(D2x(RCVT + 616),4)        /* RACF Ver/Rel/Mod     */
RACFVER  = Substr(RACFVRM,1,1)               /* RACF Version         */
RACFREL  = Substr(RACFVRM,2,2)               /* RACF Release         */
If Bitand(CVTOSLV2,'01'x) <> '01'x then ,    /* below OS/390 R10     */
  RACFREL  = Format(RACFREL)                 /* Remove leading 0     */
RACFMOD  = Substr(RACFVRM,4,1)               /* RACF MOD level       */
RACFLEV  = RACFVER || '.' || RACFREL || '.' || RACFMOD
If RCVTID = 'RCVT' | RCVTID = 'RTSS' then ,
 RCVTDSN = Strip(Storage(D2x(RCVT + 56),44))    /* RACF prim dsn or  */
                                                /* TSS Security File */
If SECNAM = 'ACF2' then do
  SSCVT    = C2d(Storage(D2x(JESCT+24),4))   /* point to SSCVT       */
  Do while SSCVT <> 0
    SSCTSNAM = Storage(D2x(SSCVT+8),4)       /* subsystem name       */
    If SSCTSNAM = 'ACF2' then do
      ACCVT    = C2d(Storage(D2x(SSCVT + 20),4)) /* ACF2 CVT         */
      ACCPFXP  = C2d(Storage(D2x(ACCVT - 4),4))  /* ACCVT prefix     */
      ACCPIDL  = C2d(Storage(D2x(ACCPFXP + 8),2))  /* Len ident area */
      LEN_ID   = ACCPIDL-4 /* don't count ACCPIDL and ACCPIDO in len */
      ACCPIDS  = Strip(Storage(D2x(ACCPFXP + 12),LEN_ID)) /*sys ident*/
      ACF2DSNS = C2d(Storage(D2x(ACCVT + 252) ,4)) /* ACF2 DSNs      */
      ACF2DNUM = C2d(Storage(D2x(ACF2DSNS + 16),2)) /* # OF DSNs     */
      Leave
    End
  SSCVT    = C2d(Storage(D2x(SSCVT+4),4))    /* next sscvt or zero   */
  End  /*  Do while SSCVT <> 0 */
End
/*                                                                   */
CVTDFA   = C2d(Storage(D2x(CVT + 1216),4))   /* point to DFP ID table*/
DFAPROD  = C2d(Storage(D2x(CVTDFA +16),1))   /* point to product byte*/
If DFAPROD = 0 then do                       /* DFP not DF/SMS       */
  DFAREL   = C2x(Storage(D2x(CVTDFA+2),2))   /* point to DFP release */
  DFPVER   = Substr(DFAREL,1,1)              /* DFP Version          */
  DFPREL   = Substr(DFAREL,2,1)              /* DFP Release          */
  DFPMOD   = Substr(DFAREL,3,1)              /* DFP Mod Lvl          */
  DFPRD    = 'DFP'                           /* product is DFP       */
  DFLEV    = DFPVER || '.' || DFPREL || '.' || DFPMOD
End
Else do                                      /* DFSMS not DFP        */
  DFARELS  = C2x(Storage(D2x(CVTDFA+16),4))  /* point to DF/SMS rel  */
  DFAVER   = X2d(Substr(DFARELS,3,2))        /* DF/SMS Version       */
  DFAREL   = X2d(Substr(DFARELS,5,2))        /* DF/SMS Release       */
  DFAMOD   = X2d(Substr(DFARELS,7,2))        /* DF/SMS Mod Lvl       */
  DFPRD    = 'DFSMS'                         /* product is DF/SMS    */
  DFLEV    = DFAVER || '.' || DFAREL || '.' || DFAMOD
  If DFAPROD = 2 then DFLEV = 'OS/390' DFLEV
  If DFAPROD = 3 then do
    DFLEV    = 'z/OS' DFLEV
    /* Next section of code doesn't work because CRT is in key 5 */
       /*
    CVTCBSP  = C2d(Storage(D2x(CVT + 256),4))      /* point to AMCBS */
    CRT      = C2d(Storage(D2x(CVTCBSP + 124),4))  /* point to CRT   */
    CRTFMID  = Storage(D2x(CRT + 472),7)           /* DFSMS FMID     */
       */
  End /* if DFAPROD = 3 */
  JESSMSIB = C2d(Storage(D2x(JESCTEXT+84),4)) /* point to SMS SSIB   */
  IGDSSIVT = C2d(Storage(D2x(JESSMSIB+32),4))  /* SMS vector table   */
  IGDSMS   = Storage(D2x(IGDSSIVT+132),2)      /* IGDSMSxx suffix    */
  SMSACDS  = Strip(Storage(D2x(IGDSSIVT+44),44))   /* ACDS           */
  SMSCMDS  = Strip(Storage(D2x(IGDSSIVT+88),44))   /* COMMDS         */
End
/*                                                                   */
CVTTVT   = C2d(Storage(D2x(CVT + 156),4))    /* point to TSO vect tbl*/
TSVTLVER = Storage(D2x(CVTTVT+100),1)        /* point to TSO Version */
TSVTLREL = Storage(D2x(CVTTVT+101),2)        /* point to TSO Release */
TSVTLREL = Format(TSVTLREL)                  /* Remove leading 0     */
TSVTLMOD = Storage(D2x(CVTTVT+103),1)        /* point to TSO Mod Lvl */
TSOLEV   = TSVTLVER || '.' || TSVTLREL || '.' || TSVTLMOD
/*                                                                   */
CHKVTACT = Storage(D2x(CVTEXT2+64),1)        /* VTAM active flag     */
If bitand(CHKVTACT,'80'x) = '80'x then do      /* vtam is active     */
  CVTATCVT = C2d(Storage(D2x(CVTEXT2 + 65),3)) /* point to VTAM AVT  */
  ISTATCVT = C2d(Storage(D2x(CVTATCVT + 0),4)) /* point to VTAM CVT  */
  ATCVTLVL = Storage(D2x(ISTATCVT + 0),8)      /* VTAM Rel Lvl VOVRP */
  VTAMVER  = Substr(ATCVTLVL,3,1)              /* VTAM Version   V   */
  VTAMREL  = Substr(ATCVTLVL,4,1)              /* VTAM Release    R  */
  VTAMMOD  = Substr(ATCVTLVL,5,1)              /* VTAM Mod Lvl     P */
  If VTAMMOD = ' ' then VTAMLEV =  VTAMVER || '.' || VTAMREL
    else VTAMLEV =  VTAMVER || '.' || VTAMREL || '.' || VTAMMOD
/*                                                                   */
  ATCNETID = Strip(Storage(D2x(ISTATCVT + 2080),8))  /* VTAM NETID   */
  ATCNQNAM = Strip(Storage(D2x(ISTATCVT + 2412),17)) /* VTAM SSCPNAME*/
  VTAM_ACTIVE = 'YES'
End /* if bitand (vtam is active) */
Else VTAM_ACTIVE = 'NO'
If Bitand(CVTOSLV1,'80'x) = '80'x then do    /* HBB4430 ESA V4.3 & > */
  ECVTTCP     = D2x(ECVT + 176)              /* TCPIP                */
  TSAB        = C2d(Storage(ECVTTCP,4))      /* point to TSAB        */
  TSABLEN     = C2d(Storage(D2x(TSAB+4),2))  /* Length of TSAB       */
  TSEBNUM     = (TSABLEN - 64) / 128         /* Number of TSEBs      */
  TCPANUM     = 0                            /* counter of act TSEBs */
  TCP_ACTIVE  = 'NO'                         /* Init active flag     */
  Do SCNTSEBS = 1 to TSEBNUM                 /* Scan TSEB loop       */
    TSEB = TSAB + 64 + (SCNTSEBS-1)*128
    TCPASID = C2x(Storage(D2x(TSEB + 56),2)) /* asid or zero         */
    If TCPASID <> 0 then do                  /* active asid          */
      TCP_ACTIVE = 'YES'
      TCPANUM = TCPANUM + 1                /* add 1 to active count  */
      TCPSTATUS           =     Storage(D2x(TSEB +  8),1)
      TCPNAME.TCPANUM     =     Storage(D2x(TSEB + 16),8)
      TCPNUM.TCPANUM      = C2x(Storage(D2x(TSEB + 24),1))
      TCPVER.TCPANUM      = C2x(Storage(D2x(TSEB + 26),2))
      TCPASID.TCPANUM     = TCPASID '('Right(X2d(TCPASID),4)')'
      Select
        When Bitand(TCPSTATUS,'80'x) = '80'x then TCPST = 'Active'
        When Bitand(TCPSTATUS,'40'x) = '40'x then TCPST = 'Terminating'
        When Bitand(TCPSTATUS,'20'x) = '20'x then TCPST = 'Down'
        When Bitand(TCPSTATUS,'10'x) = '10'x then TCPST = 'Stopped'
        Otherwise say 'Bad TCPSTATUS! Contact Mark Zelden' TCPSTATUS
      End /*  select  */
      TCPST.TCPANUM     = TCPST
    End /* If TCPASID <> 0 */
  End /* Do SCNTSEBS = 1 to TSEBNUM */
End /* If Bitand(CVTOSLV1,'80'x) = '80'x */
If Bitand(CVTOSLV1,'02'x) <> '02'x then ,    /* Below OS/390 R1      */
  Queue 'The MVS version is 'PRODNAME' - FMID 'FMIDNUM'.'
Else do
  PRODNAM2 = Storage(D2x(ECVT+496),16)       /* point to product name*/
  PRODNAM2 = Strip(PRODNAM2,'T')             /* del trailing blanks  */
  VER      = Storage(D2x(ECVT+512),2)        /* point to version     */
  REL      = Storage(D2x(ECVT+514),2)        /* point to release     */
  MOD      = Storage(D2x(ECVT+516),2)        /* point to mod level   */
  VRM      = VER'.'REL'.'MOD
  Queue 'The OS version is 'PRODNAM2 VRM' - FMID' ,
         FMIDNUM' ('PRODNAME').'
End
If CVTVERID <> ' ' then ,
  Queue 'The "user" system software version is' Strip(CVTVERID,'T')'.'
Queue 'The primary job entry subsystem is 'JESPJESN'.'
Queue 'The 'JESPJESN 'level is 'JESLEV'.' ,
      'The 'JESPJESN 'node name is 'JESNODE'.'
If SECNAM <> 'RACF' | RACFVRM < '2608' then do
  Queue 'The security software is 'SECNAM'.'
  If SECNAM = 'ACF2' then do
    Queue 'The ACF2 level is' ACCPIDS'.'
    Queue '  There are 'ACF2DNUM' ACF2 data sets in use:'
    Do ADSNS = 1 to ACF2DNUM
      ADSOFF   = ACF2DSNS + 24 + (ADSNS-1)*64
      ACF2TYPE = Storage(D2x(ADSOFF) , 8)
      ACF2DSN  = Storage(D2x(ADSOFF + 16),44)
      Queue '   ' ACF2TYPE '-' ACF2DSN
    End
  End /* if secname = 'ACF2' */
  If Bitand(CVTOSLV6,'40'x) = '40'x then nop /* z/OS 2.2 and above */
    Else Queue '  The RACF level is 'RACFLEV'.' /*dont show racflev*/
  If SECNAM = 'Top Secret' then ,
   Queue '  The TSS Security File data set is' RCVTDSN'.'
  If SECNAM = 'RACF' then ,
   Queue '  The RACF primary data set is' RCVTDSN'.'
End
Else do
  /* RACF system */
  RCVTDSDT  = C2d(Storage(D2x(RCVT + 224),4))  /* point to RACFDSDT*/
  DSDTNUM   = C2d(Storage(D2x(RCVTDSDT+4),4))  /* num RACF dsns    */
  DSDTPRIM  = Storage(D2x(RCVTDSDT+177),44)    /* point to prim ds */
  DSDTPRIM  = Strip(DSDTPRIM,'T')              /* del trail blanks */
  DSDTBACK  = Storage(D2x(RCVTDSDT+353),44)    /* point to back ds */
  DSDTBACK  = Strip(DSDTBACK,'T')              /* del trail blanks */
  If Bitand(CVTOSLV6,'40'x) = '40'x then do /* z/OS 2.2 and above  */
    Queue 'The security software is' Word(PRODNAM2,1) ,
          'Security Server (RACF).'
    Queue 'The RACF level is' PRODNAM2 VRM || '.'
  End
  Else do
    Queue 'The security software is' Word(PRODNAM2,1) ,
          'Security Server (RACF).' ,
          'The FMID is HRF' || RACFVRM || '.'
  End
  If DSDTNUM = 1 then do
    Queue '  The RACF primary data set is' DSDTPRIM'.'
    Queue '  The RACF backup  data set is' DSDTBACK'.'
  End
  Else do
    Queue '  RACF is using a split database. There are' DSDTNUM ,
          'pairs of RACF data sets:'
    RDTOFF = 0                            /* init cur offset to 0 */
    DSDTENTY_SIZE = 352                   /* dsdtenty size        */
    Do RDSNS = 1 to DSDTNUM
      DSDTPRIM  = Storage(D2x(RCVTDSDT+177+RDTOFF),44) /* prim dsn */
      DSDTPRIM  = Strip(DSDTPRIM,'T')                  /* del blnks*/
      DSDTBACK  = Storage(D2x(RCVTDSDT+353+RDTOFF),44) /* bkup dsn */
      DSDTBACK  = Strip(DSDTBACK,'T')                  /* del blnks*/
      RDTOFF = RDTOFF + DSDTENTY_SIZE            /* next tbl entry */
      Queue '    Primary #'RDSNS' - ' DSDTPRIM
      Queue '    Backup  #'RDSNS' - ' DSDTBACK
    End  /* do RDSNS = 1 to DSDTNUM */
  End
End /* else do */
Queue 'The' DFPRD 'level is' DFLEV'.'
If DFPRD = 'DFSMS' then do
  Queue '  The SMS parmlib member is IGDSMS'igdsms'.'
  Queue '  The SMS ACDS data set name is' SMSACDS'.'
  Queue '  The SMS COMMDS data set name is' SMSCMDS'.'
End
Queue 'The TSO level is 'TSOLEV'.'
If SYSISPF = 'ACTIVE' then do                /* is ISPF active?      */
  Address ISPEXEC "VGET ZISPFOS"             /* yes, is it OS?390?   */
  If RC = 0 then do                          /* yes, get OS/390 var  */
    ISPFLEV = Strip(Substr(ZISPFOS,10,15))   /* only need version    */
    Address ISPEXEC "VGET ZENVIR"            /* ispf internal rel var*/
    ISPFLEVI = Substr(ZENVIR,1,8)            /* internal ISPF release*/
    Queue 'The ISPF level is 'ISPFLEV' ('ISPFLEVI').'
  End  /* if RC */
  Else do                          /* not OS/390 - use old variables */
    Address ISPEXEC "VGET ZPDFREL"           /* get pdf release info */
    ISPFLEV  = Substr(ZENVIR,6,3)            /* ISPF level           */
    PDFLEV   = Substr(ZPDFREL,5,3)           /* PDF  level           */
    Queue 'The ISPF level is 'ISPFLEV'. The PDF level is' PDFLEV'.'
  End /* else do */
End  /* if SYSISPF */
If VTAM_ACTIVE = 'YES' then do
  Queue 'The VTAM level is 'VTAMLEV'.'
  Queue '  The NETID is' ATCNETID'. The SSCPNAME is' ATCNQNAM'.'
End /* if VTAM_ACTIVE = YES */
Else Queue 'The VTAM level is not available - VTAM is not active.'
If Bitand(CVTOSLV1,'80'x) = '80'x then do    /* HBB4430 ESA V4.3 & > */
  If TCP_ACTIVE = 'YES' then do
    Queue 'The TCP/IP stack is active. ',
          'There are 'TCPANUM' active TSEBs out of 'TSEBNUM'.'
    Queue '  SI Proc       Vers   ASID ( dec)   Status'
    Queue '  -- --------   ----   ---- ------   ------'
    Do LSI = 1 to TCPANUM
      Queue '  'Right(TCPNUM.LSI,2)' 'TCPNAME.LSI'   'TCPVER.LSI'  ',
            TCPASID.LSI'   'TCPST.LSI
    End
  End /* if TCP_ACTIVE = YES */
  Else Queue 'The TCP level is not available - TCP is not active.'
End /*  If Bitand(CVTOSLV1,'80'x) = '80'x   */
Return
 
STOR:                /* Storage information sub-routine              */
Queue ' '
CVTRLSTG = C2d(Storage(D2x(CVT + 856),4))    /* point to store at IPL*/
CVTRLSTG = CVTRLSTG/1024                     /* convert to Megabytes */
If zARCH <> 2 then do                        /* not valid in 64-bit  */
  CVTEORM  = C2d(Storage(D2x(CVT + 312),4))  /* potential real high  */
  CVTEORM  = (CVTEORM+1)/1024/1024           /* convert to Megabytes */
  ESTOR    = C2d(Storage(D2x(RCE + 160),4))  /* point to ESTOR frames*/
  ESTOR    = ESTOR*4/1024                    /* convert to Megabytes */
End
  /**********************************************************/
  /* At z/OS 2.1 CVTRLSTG was not always correct. The code  */
  /* below gets the value from the RSM Internal Table       */
  /* field 'RITTOTALONLINESTORAGEATIPL'.                    */
  /* The RIT is documented in the MVS Data Areas manual     */
  /*  - This was a bug fixed by APAR OA48094                */
  /**********************************************************/
 /*
If Bitand(CVTOSLV6,'80'x) = '80'x then do    /* z/OS 2.1  and above  */
CVTPVTP  = C2d(Storage(D2x(CVT+356),4))      /* point page vect tbl  */
PVTRIT   = C2x(Storage(D2x(CVTPVTP+4),4))    /* RSM internal tbl OCO */
RITOLSTG = X2d(C2x(Storage(D2x(X2d(PVTRIT)+X2d(128)),8)))
RITOLSTG = RITOLSTG/1024/1024                /* convert to Megabytes */
CVTRLSTG = RITOLSTG            /* change the name for code below     */
End
  */
If Bitand(CVTOSLV0,'08'x) = '08'x then do    /* HBB4410 ESA V4 & >   */
  ECVTEORM  = C2d(Storage(d2x(ECVT+600),8))  /* potential real high  */
  RECONFIG  = (ECVTEORM-CVTRLSTG*1024*1024+1)/(1024*1024) /* amt of  */
                                             /* reconfigurable stor  */
End
If Bitand(CVTOSLV5,'40'x) = '40'x then do    /* z/OS 1.7 and above   */
  RCECADSUsed = C2d(Storage(D2x(RCE + 572),2)) /* CADS current use   */
  RCECADSHW   = C2d(Storage(D2x(RCE + 574),2)) /* CADS high water    */
End
Call STORAGE_GDA_LDA
If Bitand(CVTOSLV2,'01'x) = '01'x then do    /* OS/390 R10 and above */
  SCCBSAI  = C2d(Storage(D2x(SCCB + 10),1))  /* real stor incr. in M */
  If SCCBSAI =  0 then do                    /* If 0, use SCCBSAIX   */
    SCCBSAIX = C2d(Storage(D2x(SCCB + 100),4)) /* real stor incr in M*/
    SCCBSAI  = SCCBSAIX                      /* using SCCBSAI later  */
  End
  SCCBSAR  = C2d(Storage(D2x(SCCB + 8),2))   /* # of. incr installed */
End
If zARCH <> 2 then do       /* not valid in 64-bit */
  Queue 'The real storage size at IPL time was 'Format(CVTRLSTG,,0)'M.'
  Queue 'The potential real storage size is' ,
         Format(CVTEORM,,0)'M.'
  If ESTOR > 0 then
    Queue 'The expanded storage size is 'ESTOR'M.'
  Else
    Queue 'The system has no expanded storage.'
End /* If zARCH <> 2 */
Else Queue 'The real storage online at IPL time' ,
           'was 'Format(CVTRLSTG,,0)'M.'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
  If SCCBSAI <> 0 then ,
    Queue 'The real storage increment size is 'SCCBSAI'M with' ,
           SCCBSAR 'increments installed.'
If Bitand(CVTOSLV0,'08'x) = '08'x then do    /* HBB4410 ESA V4 & >   */
  Queue 'The potential real storage size is' ,
         (ECVTEORM+1)/(1024*1024)'M.'
  Queue 'The reconfigurable storage size is 'reconfig'MB.'
End
Queue 'The private area size <16M is 'GDAPVTSZ'K.'
Queue 'The private area size >16M is 'GDAEPVTS'M.'
Queue 'The CSA size <16M is 'GDACSASZ'K.'
Queue 'The CSA size >16M is 'GDAECSAS'K.'
Queue 'The SQA size <16M is 'GDASQASZ'K.'
Queue 'The SQA size >16M is 'GDAESQAS'K.'
Queue 'The maximum V=R region size is 'GDAVRSZ'K.'
Queue 'The default V=R region size is 'GDAVREGS'K.'
Queue 'The maximum V=V region size is 'LDASIZEA'K.'
If Bitand(CVTOSLV5,'40'x) = '40'x then do    /* z/OS 1.7 and above   */
  Queue 'The current number of CADS (MAXCADs)' ,
        'in use is 'RCECADSUsed'.'
  Queue 'The maximum number of CADS (MAXCADs)' ,
        'used since IPL is 'RCECADSHW'.'
End
Return
 
CPU:                 /* CPU information sub-routine                  */
Queue ' '
If Bitand(CVTOSLV3,'01'x) = '01'x then ,  /* z/OS 1.6 & above >16 CPs*/
  NUMCPU   = C2d(Storage(D2x(CSD + 212),4))  /* point to # of CPUS   */
Else,
  NUMCPU   = C2d(Storage(D2x(CSD + 10),2))   /* point to # of CPUS   */
SCCBNCPS = C2d(Storage(d2x(SCCB + 16),2))    /* Max No. of CPUs      */
/*                                                                   */
Queue 'The CPU model number is 'MODEL'.'
Queue 'The number of online CPUs is 'NUMCPU'.' ,
      'The maximum number of CPUs is 'SCCBNCPS'.'
If Bitand(CVTOSLV3,'20'x) = '20'x & ,        /* z/OS 1.1 and above   */
   Bitand(CVTOSLV3,'01'x) <> '01'x then do   /* but below z/OS 1.6   */
  CSDICPUS = C2d(Storage(D2x(CSD+161),1))    /* CPUs online @ IPL    */
  Queue '  The number of CPUs online at IPL time was 'CSDICPUS'.'
End
If Bitand(CVTOSLV3,'01'x) = '01'x then do    /* z/OS 1.6 and above   */
  CSDICPUS = C2d(Storage(D2x(CSD+161),1))    /* CPUs online @ IPL    */
  CSDIIFAS = C2d(Storage(D2x(CSD+162),1))    /* zAAPs online @ IPL   */
  Queue '  The number of GPs online at IPL time was 'CSDICPUS'.'
  If CSDIIFAS <> 0 then ,
  Queue '  The number of zAAPs online at IPL time was 'CSDIIFAS'.'
  If Bitand(CVTOSLV4,'02'x) = '02'x then do /* zIIP (SUP) support    */
    CSDISUPS = C2d(Storage(D2x(CSD+163),1))  /* zIIPs online @ IPL   */
    If CSDISUPS <> 0 then ,
    Queue '  The number of zIIPs online at IPL time was 'CSDISUPS'.'
  End
End
/*                                                                   */
CPNUM     = 0
FOUNDCPUS = 0
FOUNDZAPS = 0
FOUNDZIPS = 0
Do until FOUNDCPUS = NUMCPU
PCCA = C2d(Storage(D2x(PCCAVT + CPNUM*4),4)) /* point to PCCA        */
  If PCCA <> 0 then do
    CPUVER   = Storage(D2x(PCCA + 4),2)      /* point to VERSION     */
    CPUID    = Storage(D2x(PCCA + 6),10)     /* point to CPUID       */
    IDSHORT  = Substr(CPUID,2,5)
    PCCAATTR = Storage(D2x(PCCA + 376),1)    /* attribute byte       */
    PCCARCFF = Storage(D2x(PCCA + 379),1)    /* reconfig flag        */
    CP_TYP   = ''                            /* init to null for now */
    If Bitand(PCCAATTR,'01'x) = '01'x then do  /* check PCCAIFA      */
       CP_TYP = '(zAAP)'                       /* zAAP / IFA CP      */
       FOUNDZAPS = FOUNDZAPS + 1
    End
    If Bitand(PCCAATTR,'04'x) = '04'x then do  /* check PCCAzIIP     */
       CP_TYP = '(zIIP)'                       /* zIIP processor     */
       FOUNDZIPS = FOUNDZIPS + 1
    End
    If Bitand(PCCARCFF,'80'x) = '80'x then ,   /* check PCCACWLM     */
       CP_TYP = '(WLM)'                        /* WLM controlled CP  */
    CPNUM_M = D2x(CPNUM)                       /* display in hex     */
    If Bitand(CVTOSLV3,'01'x) = '01'x then ,   /* z/OS 1.6 & above   */
      CPNUM_M = Right(CPNUM_M,2,'0')           /* display as 2 digits*/
    Queue 'The CPU serial number for CPU 'CPNUM_M' is ' || ,
     CPUID' ('IDSHORT'), version code' CPUVER'.' CP_TYP
    FOUNDCPUS = FOUNDCPUS + 1
  End
CPNUM = CPNUM + 1
End  /* do until  */
/**************************************************/
/* SUs/SEC and MIPS calculations                  */
/* SYS1.NUCLEUS(IEAVNP10) CSECT IRARMCPU          */
/**************************************************/
RMCT     = C2d(Storage(D2x(CVT+604),4))      /* point to RMCT        */
SU       = C2d(Storage(D2x(RMCT+64),4))      /* CPU Rate Adjustment  */
SUSEC    = Format((16000000/SU),7,2)         /* SUs per second       */
MIPSCP   = NUMCPU-FOUNDZAPS-FOUNDZIPS        /* Don't include special*/
                                             /* processors for MIPs  */
MIPS     = Format((SUSEC/48.5) * MIPSCP,6,2) /* SRM MIPS calculation */
                                             /* (48.5) borrowed from */
                                             /* Thierry Falissard    */
Queue 'The service units per second per online CPU is' Strip(SUSEC)'.'
Queue 'The approximate total MIPS (SUs/SEC / 48.5 * # general CPUs)' ,
      'is' Strip(MIPS)'.'
  /*
RMCTCCT  = C2d(Storage(D2x(RMCT+4),4))       /* cpu mgmt control tbl */
CCVUTILP = C2d(Storage(D2x(RMCTCCT+102),2))  /* CPU Utilization      */
Queue 'The approximate CPU utilization is' CCVUTILP'%.'
       */
If Bitand(CVTOSLV3,'20'x) = '20'x then do    /* z/OS 1.1 and above   */
                                             /* w/APAR OW55509       */
  RCT      = C2d(Storage(D2x(RMCT+228),4))   /* Resource Control Tbl */
  RCTLACS  = C2d(Storage(D2x(RCT+196),4))    /* 4 hr MSU average     */
  RCTIMGWU = C2d(Storage(D2x(RCT+28),4))     /* Image defined MSUs   */
  RCTCECWU = C2d(Storage(D2x(RCT+32),4))     /* CEC MSU Capacity     */
  If RCTCECWU <> 0 then do
    Queue 'The MSU capacity for this CEC is' RCTCECWU'.'
    Queue 'The defined MSU capacity for this LPAR is' RCTIMGWU'.'
  End
  If RCTLACS <> 0 then do
    Queue 'The 4 hour MSU average usage is' RCTLACS'.'
    If RCTLACS >= RCTIMGWU & RCTIMGWU <> RCTCECWU then ,
      Queue ' ** This LPAR is currently being "soft capped". **'
  End
End
/*                                                                   */
If Bitand(CVTOSLV5,'20'x) = '20'x then do    /* z/OS 1.8 and above   */
  IEAVESVT = C2d(Storage(D2x(CVT + 868),4))  /* supv. vect tbl IHASVT*/
  SVTAFFB  = Storage(D2x(IEAVESVT + 12),1)   /* aff-dispatch byte    */
  If Bitand(SVTAFFB,'80'x) = '80'x then ,
    Queue 'The HiperDispatch feature is active on this LPAR.'
  Else Queue 'The HiperDispatch feature is not active on this LPAR.'
  CPCRPERC = C2d(Storage(D2x(IEAVESVT+1008),4)) /* CPCR Percent      */
  If CPCRPERC <> 0 then
    Queue 'The CP Credits feature is active on this CPC/LPAR' ,
          'at' CPCRPERC'%.'
End
/**************************************************/
/* Central Processing Complex Node Descriptor     */
/**************************************************/
If Bitand(CVTOSLV1,'20'x) = '20'x then do      /* HBB5510 ESA V5 & > */
  CVTHID   = C2d(Storage(D2x(CVT + 1068),4))   /* point to SHID      */
  CPCND_FLAGS = Storage(D2x(CVTHID+22),1)      /* pnt to CPCND FLAGS */
  If CPCND_FLAGS <> 0 then do                  /* Is there a CPC?    */
    CPCND_VALID = Bitand(CPCND_FLAGS,'E0'x)    /* Valid flags        */
    CPCND_INVALID = Bitand('40'x)              /* Invalid flag       */
    If CPCND_VALID <> CPCND_INVALID then do    /* Is it valid?       */
      CPCND_TYPE  = Storage(D2x(CVTHID+26),6)  /* Type               */
      CPCND_MODEL = Storage(D2x(CVTHID+32),3)  /* Model              */
      CPCND_MAN   = Storage(D2x(CVTHID+35),3)  /* Manufacturer       */
      CPCND_PLANT = Storage(D2x(CVTHID+38),2)  /* Plant of manufact. */
      CPCND_SEQNO = Storage(D2x(CVTHID+40),12) /* Sequence number    */
      CPC_ID      = C2x(Storage(D2x(CVTHID+55),1))  /* CPC ID        */
      Queue ' '
   /* Queue 'Central Processing Complex (CPC) Node Descriptor:' */
      Queue 'Central Processing Complex (CPC) Information:'
      Queue '  CPC ND =',
       CPCND_TYPE'.'CPCND_MODEL'.'CPCND_MAN'.'CPCND_PLANT'.'CPCND_SEQNO
      If Bitand(CVTOSLV3,'10'x) = '10'x then do    /*z/OS 1.2 & above*/
        Call GET_CPCSI /* Get CPC SI (STSI) information sub-routine  */
        Queue '  CPC SI ='  CPCSI_TYPE'.'CPCSI_MODEL'.'  || ,
               CPCSI_MAN'.'CPCSI_PLANT'.'CPCSI_CPUID
        Queue '           Model:' CPCSI_MODELID
      End /* If Bitand(CVTOSLV3,'10'x) = '10'x */
      Queue '  CPC ID =' CPC_ID
      Queue '  Type('CPCND_TYPE') Model('CPCND_MODEL')',
            'Manufacturer('CPCND_MAN') Plant('CPCND_PLANT')',
            'Seq Num('CPCND_SEQNO')'
      If Bitand(CVTOSLV3,'20'x) = '20'x then do    /*z/OS 1.1 & above*/
        RMCTX1M  = Storage(D2x(RMCT+500),4)        /* Microcode addr */
                                                   /*   in RMCTX1    */
        If RMCTX1M  <> '7FFFF000'x then do         /* skip VM/FLEX/ES*/
          RMCTX1M  = C2d(RMCTX1M)                  /* change to dec. */
          MCL      = Storage(D2x(RMCTX1M + 40),8)  /* Microcode lvl  */
          MCLDRV   = Substr(MCL,1,4)               /* Driver only..  */
          If Datatype(MCLDRV,'Number') = 1 then ,  /* if all numeric */
             MCLDRV = Format(MCLDRV)               /* rmv leading 0s */
          Queue '  The Microcode level of this CPC is' MCL || ,
                ' (Driver' MCLDRV').'
        End /* If RMCTX1M  <> '7FFFF000'x */
      End /* If Bitand(CVTOSLV3,'20'x) = '20'x */
    End /* if CPCND_VALID <> CPCND_INVALID */
    Else do
      If Bitand(CVTOSLV3,'10'x) = '10'x then do    /*z/OS 1.2 & above*/
        Call GET_CPCSI /* Get CPC SI (STSI) information sub-routine  */
        Queue ' '
        Queue 'Central Processing Complex (CPC) Information:'
        Queue '  CPC SI ='  CPCSI_TYPE'.'CPCSI_MODEL'.'  || ,
               CPCSI_MAN'.'CPCSI_PLANT'.'CPCSI_CPUID
        Queue '           Model:' CPCSI_MODELID
      End /* if Bitand(CVTOSLV3,'10'x) = '10'x */
    End /* else do */
  End  /* if CPCND_FLAGS <>0  */
End
Return
 
IPA:                 /* IPA information sub-routine                  */
Queue ' '
/*********************************************************************/
/* IPL parms from the IPA                                            */
/*********************************************************************/
If Bitand(CVTOSLV1,'01'x) = '01'x then do    /* OS/390 R2 and above  */
  IPAICTOD = Storage(D2x(ECVTIPA + 8),8)     /* point to IPL TOD     */
  IPALPARM = Storage(D2x(ECVTIPA + 16),8)    /* point to LOAD PARM   */
  IPALPDSN = Storage(D2x(ECVTIPA + 48),44)   /* load parm dsn name   */
  IPALPDDV = Storage(D2x(ECVTIPA + 92),4)    /* load parm dev number */
  IPAHWNAM = Storage(D2x(ECVTIPA + 24),8)    /* point to HWNAME      */
  IPAHWNAM = Strip(IPAHWNAM,'T')             /* del trailing blanks  */
  IPALPNAM = Storage(D2x(ECVTIPA + 32),8)    /* point to LPARNAME    */
  IPALPNAM = Strip(IPALPNAM,'T')             /* del trailing blanks  */
  IPAVMNAM = Storage(D2x(ECVTIPA + 40),8)    /* point to VMUSERID    */
  /**************************/
  /* PARMS in LOADxx        */
  /**************************/
  IPANUCID = Storage(D2x(ECVTIPA + 23),1)    /* NUCLEUS ID           */
  IPAIODF  = Storage(D2x(ECVTIPA + 96),63)   /* IODF    card image   */
  IPASPARM = Storage(D2x(ECVTIPA + 160),63)  /* SYSPARM card image   */
  /*IPASCAT= Storage(D2x(ECVTIPA + 224),63)*//* SYSCAT  card image   */
  IPASYM   = Storage(D2x(ECVTIPA + 288),63)  /* IEASYM  card image   */
  IPAPLEX  = Storage(D2x(ECVTIPA + 352),63)  /* SYSPLEX card image   */
  If Bitand(CVTOSLV2,'01'x) = '01'x then do  /* OS/390 R10 and above */
    IPAPLNUMX = Storage(D2x(ECVTIPA + 2134),2) /* number of parmlibs */
    IPAPLNUM  = IPAPLNUMX
  End
  Else ,                                     /* OS/390 R10 and above */
    IPAPLNUM = Storage(D2x(ECVTIPA + 2148),2) /* number of parmlibs  */
  IPAPLNUM = C2d(IPAPLNUM)                   /* convert to decimal   */
  POFF = 0
  Do P = 1 to IPAPLNUM
    IPAPLIB.P = Storage(D2x(ECVTIPA+416+POFF),63) /* PARMLIB cards   */
    IPAPLFLG.P = Storage(D2x(ECVTIPA+479+POFF),1)  /* flag bits      */
    If Bitand(IPAPLFLG.P,'20'x) = '20'x then ,   /* volser from cat? */
      IPAPLIB.P = Overlay('      ',IPAPLIB.P,46) /* no, clear it     */
    POFF = POFF + 64
  End
  IPANLID  = Storage(D2x(ECVTIPA + 2144),2)  /* NUCLSTxx member used */
  IPANUCW  = Storage(D2x(ECVTIPA + 2146),1)  /* load wait state char */
  IPAICTOD = C2x(IPAICTOD)   /* make "readable" for REXXTOD call     */
  Call REXXTOD IPAICTOD      /* convert TOD to YYYY.DDD HH:MM:SS.ttt */
  TOD_RESY = Substr(RESULT,1,4)      /* year portion from REXXTOD    */
  TOD_RESD = Substr(RESULT,6,3)      /* day  portion from REXXTOD    */
  TOD_REST = Substr(RESULT,10,8)     /* time portion from REXXTOD    */
  Call RDATE TOD_RESY TOD_RESD /* call RDATE- format for ISO/USA/EUR */
  MMIPA    = Substr(RESULT,1,2)              /* MM from MM/DD/YYYY   */
  DDIPA    = Substr(RESULT,4,2)              /* DD from MM/DD/YYYY   */
  YYYYIPA  = Substr(RESULT,7,4)              /* YYYY from MM/DD/YYYY */
  If DATEFMT = 'USA' then ,                  /* USA format date?     */
    IPAIDATE = Substr(RESULT,1,10)           /* date as MM/DD/YYYY   */
  If DATEFMT = 'EUR' then ,                  /* EUR format date?     */
    IPAIDATE = DDIPA'/'MMIPA'/'YYYYIPA       /* date as DD/MM/YYYY   */
  If DATEFMT = 'ISO' then ,                  /* ISO format date?     */
    IPAIDATE = YYYYIPA'-'MMIPA'-'DDIPA       /* date as YYYY-MM-DD   */
  Queue 'Initialization information from the IPA:'
  Queue '  IPL TIME (GMT):' IPAIDATE ,
           '('TOD_RESY'.'TOD_RESD') at' TOD_REST
  Queue '  IPLPARM =' IPALPARM   '(merged)'
  Queue '  IPL load parameter data set name: 'IPALPDSN
  Queue '  IPL load parameter data set device address: 'IPALPDDV
  Queue '  HWNAME='IPAHWNAM '  LPARNAME='IPALPNAM ,
        '  VMUSERID='IPAVMNAM
  Queue '  '                    /* add blank line for readability   */
  Queue '  LOADxx parameters from the IPA' ,
        '(LOAD' || Substr(IPALPARM,5,2) || '):'
  Queue '    *---+----1----+----2----+----3----+----4' || ,
            '----+----5----+----6----+----7--'
  If Bitand(CVTOSLV2,'01'x) = '01'x then do    /* OS/390 R10 & above */
    IPAARCHL = Storage(D2x(ECVTIPA + 2143),1)  /* ARCHLVL (1 or 2)   */
    Queue '    ARCHLVL  'IPAARCHL
  End
  If IPASYM   <> '' then queue '    IEASYM   'IPASYM
  If IPAIODF  <> '' then queue '    IODF     'IPAIODF
  If IPANUCID <> '' then queue '    NUCLEUS  'IPANUCID
  If IPANLID  <> '' then queue '    NUCLST   'IPANLID' 'IPANUCW
  Do P = 1 to IPAPLNUM
    Queue '    PARMLIB  'IPAPLIB.P
  End
  If IPASCAT  <> '' then queue '    SYSCAT   'IPASCAT
  If IPASPARM <> '' then queue '    SYSPARM  'IPASPARM
  If IPAPLEX  <> '' then queue '    SYSPLEX  'IPAPLEX
  /**************************/
  /* PARMS in IEASYSxx      */
  /**************************/
  Queue '  '                    /* add blank line for readability   */
  Queue '  IEASYSxx parameters from the IPA:          ',
        '                     (Source)'
  Call BUILD_IPAPDETB    /* Build table for init parms               */
  TOTPRMS = 0            /* tot num of specified or defaulted parms  */
  Do I = 1 to IPAPDETB.0
    Call EXTRACT_SYSPARMS IPAPDETB.I   /* extract parms from the IPA */
  End
 /********************************************************************/
 /* Uncommment a sample below to test IPA PAGE parm "split" code:    */
 /*  PRMLINE.32 = 'SWAP SWAP=(SYS1.SWAP.TEST) IEASYSXX'              */
 /*  PRMLINE.32 = 'NONVIO NONVIO=(SYS1.PAGE.TEST) IEASYSXX'          */
 /*  PRMLINE.32 = 'NONVIO NONVIO=(SYS1.PAGE1,SYS1.PAGE2) IEASYSXX'   */
 /*  PRMLINE.32 = 'NONVIO ' || ,                                     */
 /*  'NONVIO=(SYS1.PAGE1,SYS1.PAGE2,SYS1.PAGE3,SYS1.PAGE4) IEASYSXX' */
 /********************************************************************/
  Call SORT_IPA                       /* sort IPA parms              */
  Call SPLIT_IPA_PAGE                 /* split page/swap dsn parms   */
  Do I = 1 to TOT_IPALINES            /* add ipa parms               */
    If I = TOT_IPALINES then ,        /*   to stack and              */
      IPALINE.I = Translate(IPALINE.I,' ',',') /* remove comma       */
    Queue IPALINE.I                   /*           from last parm    */
  End
End
Return
 
SYMBOLS:             /* System Symbols information sub-routine       */
Queue ' '
/*********************************************************************/
/* Find System Symbols  - ASASYMBP MACRO                             */
/*  ECVT+X'128' = ECVTSYMT                                           */
/*  2nd half word = # of symbols , after that each entry is 4 words  */
/*  1st word = offset to symbol name                                 */
/*  2nd word = length of symbol name                                 */
/*  3rd word = offset to symbol value                                */
/*  4th word = length of symbol value                                */
/*********************************************************************/
If Bitand(CVTOSLV1,'10'x) = '10'x then do    /* HBB5520 ESA V5.2 & > */
  ECVTSYMT = C2d(Storage(D2x(ECVT + 296),4)) /* point to ECVTSYMT    */
  NUMSYMBS = C2d(Storage(D2x(ECVTSYMT + 2),2))  /* number of symbols */
  Queue 'Static System Symbol Values:'
  Do I = 1 to NUMSYMBS
    SOFF = I*16-16
    NAMOFF  = C2d(Storage(D2x(ECVTSYMT+4+SOFF),4))  /*offset to name */
    NAMLEN  = C2d(Storage(D2x(ECVTSYMT+8+SOFF),4))  /*length of name */
    VALOFF  = C2d(Storage(D2x(ECVTSYMT+12+SOFF),4)) /*offset to value*/
    VALLEN  = C2d(Storage(D2x(ECVTSYMT+16+SOFF),4)) /*length of value*/
    SYMNAME = Storage(D2x(ECVTSYMT+4+NAMOFF),NAMLEN) /*symbol name   */
    If VALLEN = 0 then VALNAME = ''                 /* null value    */
    Else ,
    VALNAME = Storage(D2x(ECVTSYMT+4+VALOFF),VALLEN) /* symbol value */
      If Bitand(CVTOSLV6,'40'x) = '40'x then ,   /* z/OS 2.2 and >   */
      Queue ' ' Left(SYMNAME,18,' ') '=' VALNAME /* max 16 + & + .   */
      Else ,
      Queue ' ' Left(SYMNAME,10,' ') '=' VALNAME /* max 8 + & + .    */
  End  /* do NUMSYMBS */
End
Return
 
VMAP:                /* Virtual Storage Map sub-routine              */
Arg VMAPOPT
/* If option <> 'ALL' then, */
  Call STORAGE_GDA_LDA                       /* GDA/LDA stor routine */
SYSEND  = X2d(LDASTRTS) + (LDASIZS*1024) - 1 /* end of system area   */
SYSEND  = D2x(SYSEND)                        /* display in hex       */
If GDAVRSZ = 0 then do                       /* no v=r               */
  VRSTRT = 'N/A     '
  VREND  = 'N/A     '
  VVSTRT = LDASTRTA                          /* start of v=v         */
  VVEND  =  X2d(LDASTRTA) + (LDASIZEA*1024) - 1 /* end of v=v        */
  VVEND  =  D2x(VVEND)                       /* display in hex       */
End
Else do
  VRSTRT =  LDASTRTA                         /* start of v=r         */
  VREND  =  X2d(LDASTRTA) + (GDAVRSZ*1024) - 1 /* end of v=r         */
  VREND  =  D2X(VREND)                       /* display in hex       */
  VVSTRT =  LDASTRTA                         /* start of v=v         */
  VVEND  =  X2d(LDASTRTA) + (LDASIZEA*1024) - 1 /* end of v=v        */
  VVEND  =  D2x(VVEND)                       /* display in hex       */
End
GDACSA   = C2d(Storage(D2x(CVTGDA + 108),4)) /* start of CSA addr    */
GDACSAH  = D2x(GDACSA)                       /* display in hex       */
CSAEND   = (GDACSASZ*1024) + GDACSA - 1      /* end of CSA           */
CSAEND   = D2x(CSAEND)                       /* display in hex       */
CVTSMEXT = C2d(Storage(D2x(CVT +1196),4))    /* point to stg map ext.*/
CVTMLPAS = C2d(Storage(D2x(CVTSMEXT+ 8),4))  /* start of MLPA addr   */
CVTMLPAS = D2x(CVTMLPAS)                     /* display in hex       */
If CVTMLPAS <> 0 then do
  CVTMLPAE = C2d(Storage(D2x(CVTSMEXT+12),4))  /* end of MLPA addr   */
  CVTMLPAE = D2x(CVTMLPAE)                     /* display in hex     */
  MLPASZ   = X2d(CVTMLPAE) - X2d(CVTMLPAS) + 1 /* size of MLPA       */
  MLPASZ   = MLPASZ/1024                       /* convert to Kbytes  */
End
Else do /* no MLPA */
  CVTMLPAS = 'N/A     '
  CVTMLPAE = 'N/A     '
  MLPASZ   = 0
End
CVTFLPAS = C2d(Storage(D2x(CVTSMEXT+16),4))  /* start of FLPA addr   */
CVTFLPAS = D2x(CVTFLPAS)                     /* display in hex       */
If CVTFLPAS <> 0 then do
  CVTFLPAE = C2d(Storage(D2x(CVTSMEXT+20),4))  /* end of FLPA addr   */
  CVTFLPAE = D2x(CVTFLPAE)                     /* display in hex     */
  FLPASZ   = X2d(CVTFLPAE) - X2d(CVTFLPAS) + 1 /* size of FLPA       */
  FLPASZ   = FLPASZ/1024                       /* convert to Kbytes  */
End
Else do /* no FLPA */
  CVTFLPAS = 'N/A     '
  CVTFLPAE = 'N/A     '
  FLPASZ   = 0
End
CVTPLPAS = C2d(Storage(D2x(CVTSMEXT+24),4))  /* start of PLPA addr   */
CVTPLPAS = D2x(CVTPLPAS)                     /* display in hex       */
CVTPLPAE = C2d(Storage(D2x(CVTSMEXT+28),4))  /* end of PLPA addr     */
CVTPLPAE = D2x(CVTPLPAE)                     /* display in hex       */
PLPASZ   = X2d(CVTPLPAE) - X2d(CVTPLPAS) + 1 /* size of PLPA         */
PLPASZ   = PLPASZ/1024                       /* convert to Kbytes    */
GDASQA   = C2d(Storage(D2x(CVTGDA + 144),4)) /* start of SQA addr    */
GDASQAH  = D2x(GDASQA)                       /* display in hex       */
SQAEND   = (GDASQASZ*1024) + GDASQA - 1      /* end of SQA           */
SQAEND   = D2x(SQAEND)                       /* display in hex       */
CVTRWNS  = C2d(Storage(D2x(CVTSMEXT+32),4))  /* start of R/W nucleus */
CVTRWNS  = D2x(CVTRWNS)                      /* display in hex       */
CVTRWNE  = C2d(Storage(D2x(CVTSMEXT+36),4))  /* end of R/W nucleus   */
CVTRWNE  = D2x(CVTRWNE)                      /* display in hex       */
RWNUCSZ  = X2d(CVTRWNE)  - X2d(CVTRWNS)  + 1 /* size of R/W nucleus  */
RWNUCSZ  = Format(RWNUCSZ/1024,,0)           /* convert to Kbytes    */
CVTRONS  = C2d(Storage(D2x(CVTSMEXT+40),4))  /* start of R/O nucleus */
CVTRONS  = D2x(CVTRONS)                      /* display in hex       */
CVTRONE  = C2d(Storage(D2x(CVTSMEXT+44),4))  /* end of R/O nucleus   */
CVTRONE  = D2x(CVTRONE)                      /* display in hex       */
RONUCSZ  = X2d(CVTRONE)  - X2d(CVTRONS)  + 1 /* size of R/O nucleus  */
RONUCSZ  = Format(RONUCSZ/1024,,0)           /* convert to Kbytes    */
RONUCSZB = X2d('FFFFFF') - X2d(CVTRONS) + 1  /* size of R/O nuc <16M */
RONUCSZB = Format(RONUCSZB/1024,,0)          /* convert to Kbytes    */
RONUCSZA = X2d(CVTRONE) - X2d('1000000') + 1 /* size of R/O nuc >16M */
RONUCSZA = Format(RONUCSZA/1024,,0)          /* convert to Kbytes    */
CVTERWNS = C2d(Storage(D2x(CVTSMEXT+48),4))  /* start of E-R/W nuc   */
CVTERWNS = D2x(CVTERWNS)                     /* display in hex       */
CVTERWNE = C2d(Storage(D2x(CVTSMEXT+52),4))  /* end of E-R/W nuc     */
CVTERWNE = D2x(CVTERWNE)                     /* display in hex       */
ERWNUCSZ = X2d(CVTERWNE) - X2d(CVTERWNS) + 1 /* size of E-R/W nuc    */
ERWNUCSZ = ERWNUCSZ/1024                     /* convert to Kbytes    */
GDAESQA  = C2d(Storage(D2x(CVTGDA + 152),4)) /* start of ESQA addr   */
GDAESQAH = D2x(GDAESQA)                      /* display in hex       */
ESQAEND  = (GDAESQAS*1024) + GDAESQA - 1     /* end of ESQA          */
ESQAEND  = D2x(ESQAEND)                      /* display in hex       */
CVTEPLPS = C2d(Storage(D2x(CVTSMEXT+56),4))  /* start of EPLPA addr  */
CVTEPLPS = D2x(CVTEPLPS)                     /* display in hex       */
CVTEPLPE = C2d(Storage(D2x(CVTSMEXT+60),4))  /* end of EPLPA addr    */
CVTEPLPE = D2x(CVTEPLPE)                     /* display in hex       */
EPLPASZ  = X2d(CVTEPLPE) - X2d(CVTEPLPS) + 1 /* size of EPLPA        */
EPLPASZ  = EPLPASZ/1024                      /* convert to Kbytes    */
CVTEFLPS = C2d(Storage(D2x(CVTSMEXT+64),4))  /* start of EFLPA addr  */
CVTEFLPS = D2x(CVTEFLPS)                     /* display in hex       */
If CVTEFLPS <> 0 then do
  CVTEFLPE = C2d(Storage(D2x(CVTSMEXT+68),4))  /* end of EFLPA addr  */
  CVTEFLPE = D2x(CVTEFLPE)                     /* display in hex     */
  EFLPASZ  = X2d(CVTEFLPE) - X2d(CVTEFLPS) + 1 /* size of EFLPA      */
  EFLPASZ  = EFLPASZ/1024                      /* convert to Kbytes  */
End
Else do /* no EFLPA */
  CVTEFLPS = 'N/A     '
  CVTEFLPE = 'N/A     '
  EFLPASZ  = 0
End
CVTEMLPS = C2d(Storage(D2x(CVTSMEXT+72),4))  /* start of EMLPA addr  */
CVTEMLPS = D2x(CVTEMLPS)                     /* display in hex       */
If CVTEMLPS <> 0 then do
  CVTEMLPE = C2d(Storage(D2x(CVTSMEXT+76),4))  /* end of EMLPA addr  */
  CVTEMLPE = D2x(CVTEMLPE)                     /* display in hex     */
  EMLPASZ  = X2d(CVTEMLPE) - X2d(CVTEMLPS) + 1 /* size of EMLPA      */
  EMLPASZ  = EMLPASZ/1024                      /* convert to Kbytes  */
End
Else do /* no EMLPA */
  CVTEMLPS = 'N/A     '
  CVTEMLPE = 'N/A     '
  EMLPASZ  = 0
End
GDAECSA  = C2d(Storage(D2x(CVTGDA + 124),4)) /* start of ECSA addr   */
GDAECSAH = D2x(GDAECSA)                      /* display in hex       */
ECSAEND  = (GDAECSAS*1024) + GDAECSA - 1     /* end of ECSA          */
ECSAEND  = D2x(ECSAEND)                      /* display in hex       */
GDAEPVT  = C2d(Storage(D2x(CVTGDA + 168),4)) /* start of EPVT addr   */
GDAEPVTH = D2x(GDAEPVT)                      /* display in hex       */
EPVTEND  = (GDAEPVTS*1024*1024) + GDAEPVT - 1 /* end of EPVT         */
EPVTEND  = D2x(EPVTEND)                      /* display in hex       */
If VMAPOPT <> 'NODISP' then do         /* no display of vmap desired */
Queue ' '
Queue 'Virtual Storage Map:'
Queue '          '
If VMAP = 'HIGHFIRST' then do
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
 Queue '     Storage Area     Start      End           Size' ,
       '     Used     Conv      HWM'
Else ,
 Queue '     Storage Area     Start      End           Size' ,
       '     Used     Conv'
Queue '          '
Queue '     Ext. Private    '     Right(GDAEPVTH,8,'0') ' ' ,
   Right(EPVTEND,8,'0')           Right(GDAEPVTS,8,' ')'M'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '         Ext. CSA    '     Right(GDAECSAH,8,'0') ' ' ,
   Right(ECSAEND,8,'0')           Right(GDAECSAS,8,' ')'K' ,
   Right(GDA_ECSA_ALLOC,8,' ')'K         ' ,
   Right(GDAECSAHWM,7,' ')'K'
Else ,
Queue '         Ext. CSA    '     Right(GDAECSAH,8,'0') ' ' ,
   Right(ECSAEND,8,'0')           Right(GDAECSAS,8,' ')'K' ,
   Right(GDA_ECSA_ALLOC,8,' ')'K'
Queue '        Ext. MLPA    '     Right(CVTEMLPS,8,'0') ' ' ,
   Right(CVTEMLPE,8,'0')          Right(EMLPASZ,8,' ')'K'
Queue '        Ext. FLPA    '     Right(CVTEFLPS,8,'0') ' ' ,
   Right(CVTEFLPE,8,'0')          Right(EFLPASZ,8,' ')'K'
Queue '        Ext. PLPA    '     Right(CVTEPLPS,8,'0') ' ' ,
   Right(CVTEPLPE,8,'0')          Right(EPLPASZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '         Ext. SQA    '     Right(GDAESQAH,8,'0') ' ' ,
   Right(ESQAEND,8,'0')           Right(GDAESQAS,8,' ')'K' ,
   Right(GDA_ESQA_ALLOC,8,' ')'K' Right(GDA_ECSA_CONV,7,' ')'K',
   Right(GDAESQAHWM,7,' ')'K'
Else ,
Queue '         Ext. SQA    '     Right(GDAESQAH,8,'0') ' ' ,
   Right(ESQAEND,8,'0')           Right(GDAESQAS,8,' ')'K' ,
   Right(GDA_ESQA_ALLOC,8,' ')'K' Right(GDA_ECSA_CONV,7,' ')'K'
Queue ' Ext. R/W Nucleus    '     Right(CVTERWNS,8,'0') ' ' ,
   Right(CVTERWNE,8,'0')          Right(ERWNUCSZ,8,' ')'K'
Queue ' Ext. R/O Nucleus    '     Right('1000000',8,'0') ' ' ,
   Right(CVTRONE,8,'0')           Right(RONUCSZA,8,' ')'K' ,
   '(Total' RONUCSZ'K)'
Queue '             16M line -----------------------------'
Queue '      R/O Nucleus    '     Right(CVTRONS,8,'0') ' ' ,
   Right('FFFFFF',8,'0')          Right(RONUCSZB,8,' ')'K',
   '(Spans 16M line)'
Queue '      R/W Nucleus    '     Right(CVTRWNS,8,'0') ' ' ,
   Right(CVTRWNE,8,'0')           Right(RWNUCSZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '              SQA    '     Right(GDASQAH,8,'0') ' ' ,
   Right(SQAEND,8,'0')            Right(GDASQASZ,8,' ')'K' ,
   Right(GDA_SQA_ALLOC,8,' ')'K'  Right(GDA_CSA_CONV,7,' ')'K' ,
   Right(GDASQAHWM,7,' ')'K'
Else ,
Queue '              SQA    '     Right(GDASQAH,8,'0') ' ' ,
   Right(SQAEND,8,'0')            Right(GDASQASZ,8,' ')'K' ,
   Right(GDA_SQA_ALLOC,8,' ')'K'  Right(GDA_CSA_CONV,7,' ')'K'
Queue '             PLPA    '     Right(CVTPLPAS,8,'0') ' ' ,
   Right(CVTPLPAE,8,'0')          Right(PLPASZ,8,' ')'K'
Queue '             FLPA    '     Right(CVTFLPAS,8,'0') ' ' ,
   Right(CVTFLPAE,8,'0')          Right(FLPASZ,8,' ')'K'
Queue '             MLPA    '     Right(CVTMLPAS,8,'0') ' ' ,
   Right(CVTMLPAE,8,'0')          Right(MLPASZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '              CSA    '     Right(GDACSAH,8,'0') ' ' ,
   Right(CSAEND,8,'0')            Right(GDACSASZ,8,' ')'K' ,
   Right(GDA_CSA_ALLOC,8,' ')'K         ' ,
   Right(GDACSAHWM,7,' ')'K'
Else ,
Queue '              CSA    '     Right(GDACSAH,8,'0') ' ' ,
   Right(CSAEND,8,'0')            Right(GDACSASZ,8,' ')'K' ,
   Right(GDA_CSA_ALLOC,8,' ')'K'
Queue '      Private V=V    '     Right(VVSTRT,8,'0') ' ' ,
   Right(VVEND,8,'0')             Right(LDASIZEA,8,' ')'K'
Queue '      Private V=R    '     Right(VRSTRT,8,'0') ' ' ,
   Right(VREND,8,'0')             Right(GDAVRSZ,8,' ')'K'
Queue '           System    '     Right(LDASTRTS,8,'0') ' ' ,
   Right(SYSEND,8,'0')            Right(LDASIZS,8,' ')'K'
If zARCH = 2 then ,
  Queue '              PSA     00000000   00001FFF        8K'
Else ,
  Queue '              PSA     00000000   00000FFF        4K'
End  /* if VMAP = 'HIGHFIRST'  */
Else do  /* VMAP <> 'HIGHFIRST'  */
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
 Queue '     Storage Area     Start      End           Size' ,
       '     Used     Conv      HWM'
Else ,
 Queue '     Storage Area     Start      End           Size' ,
       '     Used     Conv'
Queue '          '
If zARCH = 2 then ,
  Queue '              PSA     00000000   00001FFF        8K'
Else ,
  Queue '              PSA     00000000   00000FFF        4K'
Queue '           System    '     Right(LDASTRTS,8,'0') ' ' ,
   Right(SYSEND,8,'0')            Right(LDASIZS,8,' ')'K'
Queue '      Private V=R    '     Right(VRSTRT,8,'0') ' ' ,
   Right(VREND,8,'0')             Right(GDAVRSZ,8,' ')'K'
Queue '      Private V=V    '     Right(VVSTRT,8,'0') ' ' ,
   Right(VVEND,8,'0')             Right(LDASIZEA,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '              CSA    '     Right(GDACSAH,8,'0') ' ' ,
   Right(CSAEND,8,'0')            Right(GDACSASZ,8,' ')'K' ,
   Right(GDA_CSA_ALLOC,8,' ')'K         ' ,
   Right(GDACSAHWM,7,' ')'K'
Else ,
Queue '              CSA    '     Right(GDACSAH,8,'0') ' ' ,
   Right(CSAEND,8,'0')            Right(GDACSASZ,8,' ')'K' ,
   Right(GDA_CSA_ALLOC,8,' ')'K'
Queue '             MLPA    '     Right(CVTMLPAS,8,'0') ' ' ,
   Right(CVTMLPAE,8,'0')          Right(MLPASZ,8,' ')'K'
Queue '             FLPA    '     Right(CVTFLPAS,8,'0') ' ' ,
   Right(CVTFLPAE,8,'0')          Right(FLPASZ,8,' ')'K'
Queue '             PLPA    '     Right(CVTPLPAS,8,'0') ' ' ,
   Right(CVTPLPAE,8,'0')          Right(PLPASZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '              SQA    '     Right(GDASQAH,8,'0') ' ' ,
   Right(SQAEND,8,'0')            Right(GDASQASZ,8,' ')'K' ,
   Right(GDA_SQA_ALLOC,8,' ')'K'  Right(GDA_CSA_CONV,7,' ')'K' ,
   Right(GDASQAHWM,7,' ')'K'
Else ,
Queue '              SQA    '     Right(GDASQAH,8,'0') ' ' ,
   Right(SQAEND,8,'0')            Right(GDASQASZ,8,' ')'K' ,
   Right(GDA_SQA_ALLOC,8,' ')'K'  Right(GDA_CSA_CONV,7,' ')'K'
Queue '      R/W Nucleus    '     Right(CVTRWNS,8,'0') ' ' ,
   Right(CVTRWNE,8,'0')           Right(RWNUCSZ,8,' ')'K'
Queue '      R/O Nucleus    '     Right(CVTRONS,8,'0') ' ' ,
   Right('FFFFFF',8,'0')          Right(RONUCSZB,8,' ')'K',
   '(Spans 16M line)'
Queue '             16M line -----------------------------'
Queue ' Ext. R/O Nucleus    '     Right('1000000',8,'0') ' ' ,
   Right(CVTRONE,8,'0')           Right(RONUCSZA,8,' ')'K' ,
   '(Total' RONUCSZ'K)'
Queue ' Ext. R/W Nucleus    '     Right(CVTERWNS,8,'0') ' ' ,
   Right(CVTERWNE,8,'0')          Right(ERWNUCSZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '         Ext. SQA    '     Right(GDAESQAH,8,'0') ' ' ,
   Right(ESQAEND,8,'0')           Right(GDAESQAS,8,' ')'K' ,
   Right(GDA_ESQA_ALLOC,8,' ')'K' Right(GDA_ECSA_CONV,7,' ')'K',
   Right(GDAESQAHWM,7,' ')'K'
Else ,
Queue '         Ext. SQA    '     Right(GDAESQAH,8,'0') ' ' ,
   Right(ESQAEND,8,'0')           Right(GDAESQAS,8,' ')'K' ,
   Right(GDA_ESQA_ALLOC,8,' ')'K' Right(GDA_ECSA_CONV,7,' ')'K'
Queue '        Ext. PLPA    '     Right(CVTEPLPS,8,'0') ' ' ,
   Right(CVTEPLPE,8,'0')          Right(EPLPASZ,8,' ')'K'
Queue '        Ext. FLPA    '     Right(CVTEFLPS,8,'0') ' ' ,
   Right(CVTEFLPE,8,'0')          Right(EFLPASZ,8,' ')'K'
Queue '        Ext. MLPA    '     Right(CVTEMLPS,8,'0') ' ' ,
   Right(CVTEMLPE,8,'0')          Right(EMLPASZ,8,' ')'K'
If Bitand(CVTOSLV2,'01'x) = '01'x then ,     /* OS/390 R10 and above */
Queue '         Ext. CSA    '     Right(GDAECSAH,8,'0') ' ' ,
   Right(ECSAEND,8,'0')           Right(GDAECSAS,8,' ')'K' ,
   Right(GDA_ECSA_ALLOC,8,' ')'K         ' ,
   Right(GDAECSAHWM,7,' ')'K'
Else ,
Queue '         Ext. CSA    '     Right(GDAECSAH,8,'0') ' ' ,
   Right(ECSAEND,8,'0')           Right(GDAECSAS,8,' ')'K' ,
   Right(GDA_ECSA_ALLOC,8,' ')'K'
Queue '     Ext. Private    '     Right(GDAEPVTH,8,'0') ' ' ,
   Right(EPVTEND,8,'0')           Right(GDAEPVTS,8,' ')'M'
End  /* else do (VMAP <> 'HIGHFIRST')  */
 
If bitand(CVTOSLV3,'02'x) = '02'x then do   /* z/OS 1.5 and above?   */
                            /* Yes, get HVSHARE info from the RCE    */
  RCELVSHRSTRT   = C2d(Storage(D2x(RCE + 544),8))  /* low virt addr  */
                                                   /* for 64-bit shr */
  RCELVSHRSTRT_D = C2x(Storage(D2x(RCE + 544),8))  /* make readable  */
  VSHRSTRT_D     = Substr(RCELVSHRSTRT_D,1,8) ,    /*  address range */
                   Substr(RCELVSHRSTRT_D,9,8)      /*   display      */
  RCELVHPRSTRT   = C2d(Storage(D2x(RCE + 552),8))  /* low virt addr  */
                                                   /* for 64-bit prv */
  RCELVHPRSTRT_D = C2d(Storage(D2x(RCE + 552),8)) -1 /*make readable */
  RCELVHPRSTRT_D = Right(D2x(RCELVHPRSTRT_D),16,'0') /* address      */
  VHPRSTRT_D     = Substr(RCELVHPRSTRT_D,1,8) ,    /*   range        */
                   Substr(RCELVHPRSTRT_D,9,8)      /*   display      */
  TOTAL_VHSHR    = RCELVHPRSTRT - RCELVSHRSTRT     /* total shared   */
  TOTAL_VHSHR    = TOTAL_VHSHR/1024/1024           /* change to MB   */
  TOTAL_VHSHR    = FORMAT_MEMSIZE(TOTAL_VHSHR)     /* format size    */
 
  RCELVSHRSTRT   = RCELVSHRSTRT/1024/1024          /* change to MB   */
  RCELVSHRSTRT   = FORMAT_MEMSIZE(RCELVSHRSTRT)    /* format size    */
 
  RCELVHPRSTRT   = RCELVHPRSTRT/1024/1024          /* change to MB   */
  RCELVHPRSTRT   = FORMAT_MEMSIZE(RCELVHPRSTRT)    /* format size    */
 
  RCELVSHRPAGES  = C2d(Storage(D2x(RCE + 584),8))  /* shr pages      */
  RCELVSHRPAGES  = (RCELVSHRPAGES*4)/1024          /* change to MB   */
  RCELVSHRPAGES  = FORMAT_MEMSIZE(RCELVSHRPAGES)   /* format size    */
 
  RCELVSHRGBYTES = C2d(Storage(D2x(RCE + 592),8))  /* shr bytes HWM  */
  RCELVSHRGBYTES = RCELVSHRGBYTES/1024/1024        /* change to MB   */
  RCELVSHRGBYTES = FORMAT_MEMSIZE(RCELVSHRGBYTES)  /* format size    */
 
  Queue '   '
  Queue '  64-Bit Shared Virtual Storage (HVSHARE):'
  Queue '   '
  Queue '    Shared storage total:' TOTAL_VHSHR
  Queue '    Shared storage range:' RCELVSHRSTRT'-'RCELVHPRSTRT ,
        '('VSHRSTRT_D' - 'VHPRSTRT_D')'
  Queue '    Shared storage allocated:' RCELVSHRPAGES
  Queue '    Shared storage allocated HWM:' RCELVSHRGBYTES
 
End /* If bitand(CVTOSLV3,'02'x) = '02'x  */
 
If bitand(CVTOSLV5,'08'x) = '08'x then do   /* z/OS 1.10 and above   */
                            /* Yes, get HVCOMMON info from the RCE   */
  RCEHVCommonStrt = C2d(Storage(D2x(RCE + 872),8)) /*low virt addr */
                                                   /*for 64-bit cmn*/
  CommonStrt_D   = C2x(Storage(D2x(RCE + 872),8))  /*make readable */
  CommonStrt_D   = Substr(CommonStrt_D,1,8) ,      /* address range*/
                   Substr(CommonStrt_D,9,8)        /*  display     */
 
  RCEHVCommonEnd = C2d(Storage(D2x(RCE + 880),8))  /*high virt addr*/
                                                   /*for 64-bit cmn*/
  RCEHVCommonEnd = RCEHVCommonEnd + 1              /* Add 1 to addr*/
  CommonEnd_D    = C2x(Storage(D2x(RCE + 880),8))  /*make readable */
  CommonEnd_D    = Substr(CommonEnd_D,1,8) ,       /* address range*/
                   Substr(CommonEnd_D,9,8)         /*  display     */
 
  TOTAL_VHCOMN   = RCEHVCommonEnd-RCEHVCommonStrt  /* total common */
  TOTAL_VHCOMN   = TOTAL_VHCOMN/1024/1024          /* change to MB */
  TOTAL_VHCOMN   = FORMAT_MEMSIZE(TOTAL_VHCOMN)    /* format size  */
 
  RCEHVCommonStrt = RCEHVCommonStrt/1024/1024      /* chg to MB    */
  RCEHVCommonStrt = FORMAT_MEMSIZE(RCEHVCommonStrt) /* format size */
 
  RCEHVCommonEnd = RCEHVCommonEnd/1024/1024        /* chg to MB    */
  RCEHVCommonEnd = FORMAT_MEMSIZE(RCEHVCommonEnd)  /* format  size */
 
  RCEHVCommonPAGES = C2d(Storage(D2x(RCE + 888),8)) /* comn pages  */
  RCEHVCommonPAGES = (RCEHVCommonPAGES*4)/1024      /* chg to MB   */
  RCEHVCommonPAGES = FORMAT_MEMSIZE(RCEHVCommonPAGES) /*format size*/
 
  RCEHVCommonHWMBytes = C2d(Storage(D2x(RCE + 896),8)) /* comn HWM */
  RCEHVCommonHWMBytes = RCEHVCommonHWMBytes/1024/1024  /*chg to MB */
  RCEHVCommonHWMBytes = FORMAT_MEMSIZE(RCEHVCommonHWMBytes) /* fmt */
 
  Queue '   '
  Queue '  64-Bit Common Virtual Storage (HVCOMMON):'
  Queue '   '
  Queue '    Common storage total:' TOTAL_VHCOMN
  Queue '    Common storage range:' RCEHVCommonStrt'-'RCEHVCommonEnd ,
        '('CommonStrt_D' - 'CommonEnd_D')'
  Queue '    Common storage allocated:' RCEHVCommonPAGES
  Queue '    Common storage allocated HWM:' RCEHVCommonHWMBytes
End /* If bitand(CVTOSLV5,'08'x) = '08'x  */
If Bitand(CVTOSLV5,'10'x) = '10'x &     ,   /* z/OS 1.9 and above &  */
   Bitand(CVTFLAG2,'01'x) = '01'x then do   /*  CVTEDAT on (z10 >)?  */
  LARGEMEM = 1                              /* set LARGEMEM avail flg*/
  RCEReconLFASize  = C2d(Storage(D2x(RCE + 760),8)) /* recon lfarea  */
  RCENonReconLFASize = C2d(Storage(D2x(RCE + 768),8)) /*  LFAREA     */
 /* Comment out or delete the next 2 lines of code if you want the   */
 /* large memory displays even if you specified or defaulted to      */
 /* LFAREA=0M (z/OS 1.9 & above) and have the hardware support.      */
  If RCEReconLFASize = 0 & RCENonReconLFASize = 0 then ,  /* both 0? */
   LARGEMEM = 0
  If Bitand(CVTOSLV6,'80'x) = '80'x then do /* z/OS 2.1 and above    */
    PL = 1                                  /* pageable1m + 2.1 & >  */
    /*****************/
    /* 2G frame code */
    /*****************/
    RCE2GMemoryObjects          = ,
     C2d(Storage(D2x(RCE + 1256),8))    /* Number of 2G objects      */
    RCE2GNonReconLFASize        = ,
     C2d(Storage(D2x(RCE + 1272),8))    /* 2G frame area in 2G units */
    RCE2GNonReconLFAUsed        = ,
     C2d(Storage(D2x(RCE + 1280),8))    /* used 2G frames            */
    RCE2GHWM                    = ,
     C2d(Storage(D2x(RCE + 1288),4))    /* 2G used frames HWM        */
    If RCE2GNonReconLFASize <> 0 then LARGEMEM = 1  /* lfarea used   */
  End
    Else PL = 0                             /* no pageable1m         */
End /* If Bitand(CVTOSLV5,'10'x) */
   Else LARGEMEM = 0                        /* < z/OS 1.9/no hw supt */
If LARGEMEM = 1 then do                      /* z/OS 1.10 & above  */
  RCELargeMemoryObjects = ,
   C2d(Storage(D2x(RCE + 744),8))             /*tot large mem objs */
  RCELargePagesBackedinReal = ,
   C2d(Storage(D2x(RCE + 752),8))             /* tot lrg obj pages */
  RCELFAvailGroups          = ,
   C2d(Storage(D2x(RCE + 796),4))             /* avial lrg frames  */
  RCEReconLFAUsed             = ,
   C2d(Storage(D2x(RCE + 776),8))    /* # recon 1M frames alloc    */
  RCENonReconLFAUsed          = ,
   C2d(Storage(D2x(RCE + 784),8))    /* # nonrecon 1M frames alloc */
 
  LFASize = RCEReconLFASize + RCENonReconLFASize     /* LFAREA size*/
  LFA_Used    = RCEReconLFAUsed + RCENonReconLFAUsed /* used LFAREA*/
  LFA_Alloc1M = RCELargePagesBackedinReal            /* 1M alloc   */
  LFA_Alloc4K = LFA_Used - LFA_Alloc1M               /* 4K alloc   */
 
  If PL = 1 then do            /* z/OS 2.1 / pageable1m support    */
    RCELargeUsed4K              = ,
     C2d(Storage(D2x(RCE + 1032),4))      /* 4K used for 1M req    */
    LFA_Alloc4K = RCELargeUsed4K     /* chg var name for old code  */
    RceLargeAllocatedPL         = ,
     C2d(Storage(D2x(RCE + 1244),4))      /* # used pageable1m     */
    RceLargeUsedPLHWM           = ,
     C2d(Storage(D2x(RCE + 1252),4))      /* pageable1m HWM        */
  End
 
  LFASize     = FORMAT_MEMSIZE(LFASize)          /* format size    */
  LFA_Avail   = FORMAT_MEMSIZE(RCELFAvailGroups) /* format size    */
  LFA_Alloc1M = FORMAT_MEMSIZE(LFA_Alloc1M)      /* format size    */
  LFA_Alloc4K = FORMAT_MEMSIZE(LFA_Alloc4K)      /* format size    */
 
  If PL = 1 then do            /* z/OS 2.1 + pageable1m support    */
    RceLargeAllocatedPL = FORMAT_MEMSIZE(RceLargeAllocatedPL)
    RceLargeUsedPLHWM   = FORMAT_MEMSIZE(RceLargeUsedPLHWM)
    /*****************/
    /* 2G frame code */
    /*****************/
    LFA2G_Size  = FORMAT_MEMSIZE(RCE2GNonReconLFASize*2048)
    LFA2G_Used  = FORMAT_MEMSIZE(RCE2GNonReconLFAUsed*2048)
    LFA2G_avail = ((RCE2GNonReconLFASize-RCE2GNonReconLFAUsed)*2048)
    LFA2G_avail = FORMAT_MEMSIZE(LFA2G_avail)
    LFA2G_Max   = RCE2GHWM*2048
    LFA2G_Max   = FORMAT_MEMSIZE(LFA2G_Max)
  End
 
  If Bitand(CVTOSLV5,'04'x) = '04'x then do /* z/OS 1.12 and above */
    RceLargeUsed1MHWM           = ,
     C2d(Storage(D2x(RCE + 804),4)) /*large pg HWM alloc behalf 1M */
    RceLargeUsed4KHWM           = ,
     C2d(Storage(D2x(RCE + 808),4)) /*large pg HWM alloc behalf 4K */
    LFA_Max1M = FORMAT_MEMSIZE(RceLargeUsed1MHWM)  /* format size  */
    LFA_Max4K = FORMAT_MEMSIZE(RceLargeUsed4KHWM)  /* format size  */
  End
 
  Queue '   '
  Queue '  64-Bit Large Memory Virtual Storage (LFAREA):'
  Queue '   '
  If PL = 1 then do            /* z/OS 2.1 / pageable1m support    */
    Queue '    Large memory area (LFAREA)    :' LFASize ',' LFA2G_Size
    Queue '    Large memory storage available:' LFA_Avail ',' ,
               LFA2G_avail
  End
  Else do
    Queue '    Large memory area (LFAREA)    :' LFASize
    Queue '    Large memory storage available:' LFA_Avail
  End
  Queue '    Large memory storage allocated (1M):' LFA_Alloc1M
  Queue '    Large memory storage allocated (4K):' LFA_Alloc4K
  If Bitand(CVTOSLV5,'04'x) = '04'x then do /* z/OS 1.12 and above */
    Queue '    Large memory storage allocated HWM (1M):' LFA_Max1M
    Queue '    Large memory storage allocated HWM (4K):' LFA_Max4K
  End
  If PL = 1 then do            /* z/OS 2.1 / pageable1m support    */
    Queue '    Large memory storage allocated (PAGEABLE1M):' ,
     RceLargeAllocatedPL
    Queue '    Large memory storage allocated HWM (PAGEABLE1M):' ,
     RceLargeUsedPLHWM
    Queue '    Large memory storage allocated (2G):' LFA2G_Used ,
          '/' RCE2GNonReconLFAUsed 'pages'
    Queue '    Large memory storage allocated HWM (2G):' LFA2G_Max ,
          '/' RCE2GHWM 'pages'
  End
  Queue '    Large memory objects allocated:' RCELargeMemoryObjects
  If PL = 1 then ,             /* z/OS 2.1 / pageable1m support    */
    Queue '    Large memory objects allocated (2G):' RCE2GMemoryObjects
End
End  /* If VMAPOPT <> 'NODISP' */
Return
 
PAGE:                /* Page Data Sets information sub-routine       */
Queue ' '
Queue 'Page Data Set Usage:'
Queue '  Type     Full     Slots  Dev   Volser  Data Set Name'
ASMPART  = C2d(Storage(D2x(ASMVT + 8),4))  /* Pnt to Pag Act Ref Tbl */
PARTSIZE = C2d(Storage(D2x(ASMPART+4),4))  /* Tot number of entries  */
PARTDSNL = C2d(Storage(D2x(ASMPART+24),4)) /* Point to 1st pg dsn    */
PARTENTS = ASMPART+80                      /* Point to 1st parte     */
Do I = 1 to PARTSIZE
  If I > 1 then do
    PARTENTS = PARTENTS + 96
    PARTDSNL = PARTDSNL + 44
  End
  CHKINUSE = Storage(D2x(PARTENTS+9),1)    /* in use flag            */
  If Bitand(CHKINUSE,'80'x) = '80'x then iterate /* not in use       */
  PGDSN    = Storage(D2x(PARTDSNL),44)     /* page data set name     */
  PGDSN    = Strip(PGDSN,'T')              /* remove trailing blanks */
  PARETYPE = Storage(D2x(PARTENTS+8),1)    /* type flag              */
  Select
    When Bitand(PARETYPE,'80'x) = '80'x then PGTYPE = ' PLPA    '
    When Bitand(PARETYPE,'40'x) = '40'x then PGTYPE = ' COMMON  '
    When Bitand(PARETYPE,'20'x) = '20'x then PGTYPE = ' DUPLEX  '
    When Bitand(PARETYPE,'10'x) = '10'x then PGTYPE = ' LOCAL   '
    Otherwise PGTYPE = '??????'
  End  /* Select */
  If PGTYPE = ' LOCAL   ' then do
    PAREFLG1  = Storage(D2x(PARTENTS+9),1)    /* PARTE flags         */
    If Bitand(PAREFLG1,'10'x) = '10'x then PGTYPE = ' LOCAL NV'
  End
  PAREUCBP = C2d(Storage(D2x(PARTENTS+44),4)) /* point to UCB        */
  PGUCB    = C2x(Storage(D2x(PAREUCBP+4),2))  /* UCB address         */
  PGVOL    = Storage(D2x(PAREUCBP+28),6)      /* UCB volser          */
  PARESZSL = C2d(Storage(D2x(PARTENTS+16),4)) /* total slots         */
  PARESZSL = Right(PARESZSL,9,' ')            /* ensure 9 digits     */
  PARESLTA = C2d(Storage(D2x(PARTENTS+20),4)) /* avail. slots        */
  PGFULL   = ((PARESZSL-PARESLTA) / PARESZSL) * 100 /* percent full  */
  PGFULL   = Format(PGFULL,3,2)               /* force 2 decimals    */
  PGFULL   = Left(PGFULL,3)                   /* keep intiger only   */
  Queue  ' 'PGTYPE' 'PGFULL'% 'PARESZSL'  'PGUCB' ' ,
         PGVOL'  'PGDSN
End  /* do I=1 to partsize */
/*********************************************************************/
/* SCM - Storage Class Memory                                        */
/* ASMVX - SYS1.MODGEN(ILRASMVX) pointed to in SYS1.MODGEN(ILRASMVT) */
/*********************************************************************/
 /*If Bitand(CVTOSLV5,'01'x) = '01'x then do */ /* z/OS 1.13 and > */
If Bitand(CVTOSLV6,'80'x) = '80'x then do    /* z/OS 2.1  and above  */
  SCMSTATUS = 'NOT-USED'                     /* set dflt to not used */
  ASMVX = C2d(Storage(D2x(ASMVT + 1236),4))  /* point to ASM tbl ext */
  SCMBLKSAVAIL = C2d(Storage(D2x(ASMVX + 8),8))   /* SCM blks avail  */
  SCMNVBC      = C2d(Storage(D2x(ASMVX + 16),8))  /* SCM blks used   */
  SCMERRS      = C2d(Storage(D2x(ASMVX + 24),8))  /* bad SCM blks    */
  If (SCMBLKSAVAIL > 0) then do              /* SCM is used          */
    SCMSTATUS = 'IN-USE  '                   /* status is IN-USE     */
    SCMPCTUSED = Trunc(SCMNVBC*100/SCMBLKSAVAIL)  /* percent used    */
    SCMPCTUSED = Format(SCMPCTUSED,3,2)      /* format for display   */
    SCMPCTUSED = Left(SCMPCTUSED,3)          /* format for display   */
    Call FORMAT_COMMAS SCMBLKSAVAIL          /* format with commas   */
    SCMBLKSAVAIL = FORMATTED_WHOLENUM        /* save number          */
    Call FORMAT_COMMAS SCMNVBC               /* format with commas   */
    SCMNVBC      = FORMATTED_WHOLENUM        /* save number          */
    Call FORMAT_COMMAS SCMERRS               /* format with commas   */
    SCMERRS      = FORMATTED_WHOLENUM        /* save number          */
    SCMBLKSAVAIL = Right(SCMBLKSAVAIL,16)    /* format for display   */
    SCMNVBC      = Right(SCMNVBC,16)         /* format for display   */
    SCMERRS      = Right(SCMERRS,16)         /* format for display   */
  End
  Queue ' '
  Queue 'Storage Class Memory:'
  Queue '  STATUS      FULL               SIZE             USED' ,
        '        IN-ERROR'
  If SCMSTATUS = 'NOT-USED' then Queue ' ' SCMSTATUS
  Else do
    Queue ' ' SCMSTATUS '  ' SCMPCTUSED || '%  '  ,
          SCMBLKSAVAIL SCMNVBC SCMERRS
  End
End
Return
 
SMF:                 /* SMF Data Set information sub-routine         */
Queue ' '
Queue 'SMF Data Set Usage:'
Queue '  Name                      Volser   Size(Blks)  %Full  Status'
SMCAMISC = Storage(D2x(SMCA + 1),1)          /* misc. indicators     */
If bitand(SMCAMISC,'80'x) <> '80'x then do   /* smf active ??        */
  Queue '  *** SMF recording not being used ***'
  Return
End
SMCAFRDS = C2d(Storage(D2x(SMCA + 244),4))   /* point to first RDS   */
SMCALRDS = C2d(Storage(D2x(SMCA + 248),4))   /* point to last RDS    */
SMCASMCX = C2d(Storage(D2x(SMCA + 376),4))   /* point to SMCX        */
SMCXLSBT = Storage(D2x(SMCASMCX + 88),1)     /* logstream bits       */
If Bitand(SMCXLSBT,'80'x) = '80'x then do    /* logstream recording? */
  If SMCAFRDS = SMCALRDS then do
    Queue '  ***       SMF LOGSTREAM recording is active       ***'
    Queue '  *** LOGSTREAM information not available via REXX  ***'
  Return
  End
  Else do
    Queue '  ***       SMF LOGSTREAM recording is active       ***'
    Queue '  *** LOGSTREAM information not available via REXX  ***'
    Queue '  ***     SMF data sets listed below not in use     ***'
  End
End /* If Bitand(SMCXLSBT,'80'x) */
If SMCAFRDS = SMCALRDS then do
  Queue '  ***    No SMF data sets available     ***'
  Return
End
Do until SMCAFRDS = SMCALRDS    /* end loop when next rds ptr = last */
  RDSNAME  =  Strip(Storage(D2x(SMCAFRDS + 16),44))  /* smf dsn      */
  RDSVOLID = Storage(D2x(SMCAFRDS + 60),6)           /* smf volser   */
  RDSCAPTY = C2d(Storage(D2x(SMCAFRDS + 76),4))      /* size in blks */
  RDSNXTBL = C2d(Storage(D2x(SMCAFRDS + 80),4))      /* next avl blk */
  /* RDSPCT  = (RDSNXTBL / RDSCAPTY) * 100 */ /* not how mvs does it */
  RDSPCT   = Trunc((RDSNXTBL / RDSCAPTY) * 100) /* same as mvs disp. */
  RDSFLG1  = Storage(D2x(SMCAFRDS + 12),1)     /* staus flags        */
  Select
    When Bitand(RDSFLG1,'10'x) = '10'x then RDSSTAT = 'FREE REQUIRED'
    When Bitand(RDSFLG1,'08'x) = '08'x then RDSSTAT = 'DUMP REQUIRED'
    When Bitand(RDSFLG1,'04'x) = '04'x then RDSSTAT = 'ALTERNATE'
    When Bitand(RDSFLG1,'02'x) = '02'x then RDSSTAT = 'CLOSE PENDING'
    When Bitand(RDSFLG1,'01'x) = '01'x then RDSSTAT = 'OPEN REQUIRED'
    When Bitand(RDSFLG1,'00'x) = '00'x then RDSSTAT = 'ACTIVE'
    Otherwise RDSSTAT = '??????'
  End  /* Select */
  If (RDSSTAT = 'ACTIVE' | RDSSTAT = 'DUMP REQUIRED') , /* display   */
    & RDSPCT = 0 then RDSPCT = 1    /* %full the same way mvs does   */
  SMCAFRDS = C2d(Storage(D2x(SMCAFRDS + 4),4)) /* point to next RDS  */
  If Length(RDSNAME) < 26 then do
    Queue ' ' Left(RDSNAME,25,' ') RDSVOLID  Right(RDSCAPTY,11,' ') ,
              ' 'Format(RDSPCT,5,0) ' ' RDSSTAT
  End
  Else do
    Queue ' ' RDSNAME
    Queue copies(' ',27) RDSVOLID  Right(RDSCAPTY,11,' ') ,
              ' 'Format(RDSPCT,5,0) ' ' RDSSTAT
  End
End
Return
 
SUB:                 /* Subsystem information sub-routine            */
Arg SUBOPT
SSCVT    = C2d(Storage(D2x(JESCT+24),4))     /* point to SSCVT       */
SSCVT2   = SSCVT           /* save address for second loop           */
If SUBOPT <> 'FINDJES' then do
  Queue ' '
  Queue 'Subsystem Communications Vector Table:'
  Queue '  Name   Hex        SSCTADDR   SSCTSSVT' ,
        '  SSCTSUSE   SSCTSUS2   Status'
End /* if subopt */
Do until SSCVT = 0
  SSCTSNAM = Storage(D2x(SSCVT+8),4)         /* subsystem name       */
  SSCTSSVT = C2d(Storage(D2x(SSCVT+16),4))   /* subsys vect tbl ptr  */
  SSCTSUSE = C2d(Storage(D2x(SSCVT+20),4))   /* SSCTSUSE pointer     */
  SSCTSUS2 = C2d(Storage(D2x(SSCVT+28),4))   /* SSCTSUS2 pointer     */
  If SUBOPT = 'FINDJES' & SSCTSNAM = JESPJESN then do
     JESSSVT  = SSCTSSVT   /* save SSVTSSVT for "version" section    */
                           /* this points to JES3 Subsystem Vector   */
                           /* Table, mapped by IATYSVT               */
     JESSUSE  = SSCTSUSE   /* save SSCTSUSE for "version" section    */
                           /* this points to version for JES2        */
     JESSUS2  = SSCTSUS2   /* save SSCTSUS2 for "version" section    */
                           /* this points to $HCCT for JES2          */
     Leave  /* found JES info for version section, exit loop */
  End /* if subopt */
  SSCTSNAX = C2x(SSCTSNAM)    /* chg to EBCDIC for non-display chars */
  Call XLATE_NONDISP SSCTSNAM /* translate non display chars         */
  SSCTSNAM = RESULT           /* result from XLATE_NONDISP           */
  If SSCTSSVT = 0 then SSCT_STAT = 'Inactive'
    Else SSCT_STAT = 'Active'
  If SUBOPT <> 'FINDJES' then do
    Queue ' ' SSCTSNAM ' ' SSCTSNAX  ,
          ' ' Right(D2x(SSCVT),8,0)    ' ' Right(D2x(SSCTSSVT),8,0) ,
          ' ' Right(D2x(SSCTSUSE),8,0) ' ' Right(D2x(SSCTSUS2),8,0) ,
          ' ' SSCT_STAT ' '
  End /* if SUBOPT */
 /*SSCTSSID = C2d(Storage(D2x(SSCVT+13),1)) */ /* subsys identifier  */
 /*If bitand(SSCTSSID,'02'x) = '02'x then JESPJESN = 'JES2' */
 /*If bitand(SSCTSSID,'03'x) = '03'x then JESPJESN = 'JES3'*/
  SSCVT    = C2d(Storage(D2x(SSCVT+4),4))    /* next sscvt or zero   */
End /* do until sscvt = 0 */
If SUBOPT <> 'FINDJES' then do
  Queue ' '
  Queue 'Supported Subsystem Function Codes:'
  Do until SSCVT2 = 0 /* 2nd loop for function codes                 */
    SSCTSNAM = Storage(D2x(SSCVT2+8),4)        /* subsystem name     */
    SSCTSSVT = C2d(Storage(D2x(SSCVT2+16),4)) /* subsys vect tbl ptr */
    SSCTSNAX = C2x(SSCTSNAM)  /* chg to EBCDIC for non-display chars */
    Call XLATE_NONDISP SSCTSNAM /* translate non display chars       */
    SSCTSNAM = RESULT           /* result from XLATE_NONDISP         */
    Queue ' ' SSCTSNAM '(X''' || SSCTSNAX || ''')'
    If SSCTSSVT <> 0 then do
      SSVTFCOD = SSCTSSVT + 4                  /* pt to funct. matrix*/
      SSFUNCTB = Storage(D2X(SSVTFCOD),255)    /* function matrix    */
      TOTFUNC = 0       /* counter for total functions per subsystem */
      Drop FUNC.        /* init stem to null for saved functions     */
      Do SUPFUNC = 1 TO 255
        If Substr(SSFUNCTB,SUPFUNC,1) <> '00'x then do /* supported? */
          TOTFUNC = TOTFUNC + 1 /* tot functions for this subsystem  */
          FUNC.TOTFUNC = SUPFUNC  /* save function in stem           */
        End
      End /* do supfunc */
      /***************************************************************/
      /* The following code is used to list the supported function   */
      /* codes by ranges. For example: 1-10,13,18-30,35,70,143-145   */
      /***************************************************************/
      If TOTFUNC >= 1 then do   /* begin loop to list function codes */
        ALLCODES = ''                   /* init var to nulls         */
        NEWRANGE = 'YES'                /* init newrange flag to YES */
        FIRSTRNG = 'YES'                /* init firstrng flag to YES */
        Do FCODES = 1 to TOTFUNC        /* loop though codes         */
          JUNK = TOTFUNC + 1            /* prevent NOVALUE cond.     */
          FUNC.JUNK = ''                /*  in func.chknext at end   */
          CHKNEXT = FCODES + 1          /* stem var to chk next code */
          If FUNC.FCODES + 1 = FUNC.CHKNEXT then do  /* next matches */
            If NEWRANGE = 'YES' & FIRSTRNG = 'YES' then do /* first  */
              ALLCODES =  ALLCODES || FUNC.FCODES || '-'   /* in new */
              NEWRANGE = 'NO'                    /* range - seperate */
              FIRSTRNG = 'NO'                    /* with a dash      */
              Iterate                            /* get next code    */
            End /* if newrange = 'yes' & firstrng = 'yes'            */
            If NEWRANGE = 'YES' & FIRSTRNG = 'NO' then do /* next    */
              ALLCODES =  ALLCODES || FUNC.FCODES  /* matches, but   */
              NEWRANGE = 'NO'   /* is not the first, don't add dash  */
              Iterate                            /* get next code    */
            End /* if newrange = 'yes' & firstrng = 'no'             */
            Else iterate  /* same range + not first - get next code  */
          End /* func.fcodes + 1 */
          If FCODES = TOTFUNC then , /* next doesn't match and this  */
            ALLCODES =  ALLCODES || FUNC.FCODES  /* is the last code */
          Else do /* next code doesn't match - seperate with comma   */
            ALLCODES =  ALLCODES || FUNC.FCODES || ','
            NEWRANGE = 'YES'         /* re-init newrange flag to YES */
            FIRSTRNG = 'YES'         /* re-init firstrng flag to YES */
          End
        End /* do fcodes = 1 to totfunc */
        /*************************************************************/
        /* The code below splits up the ranges to multiple lines if  */
        /* they won't all fit on a single line due to IPLINFO lrecl. */
        /*************************************************************/
        FUN_MAXL = 68      /* max length b4 need to split out codes  */
        If Length(ALLCODES) <= FUN_MAXL then ,  /* fits on one line  */
          Queue '    Codes:' ALLCODES
        Else do                            /* need to split up       */
          FUNSPLT = Pos(',',ALLCODES,FUN_MAXL-6)   /* split at comma */
          ALLCODES_1 = Substr(ALLCODES,1,FUNSPLT)  /* 1st part       */
          ALLCODES_2 = Strip(Substr(ALLCODES,FUNSPLT+1,FUN_MAXL))
          Queue '    Codes:' ALLCODES_1
          Queue '          ' ALLCODES_2
        End /* else do */
      End /* if totfunc >= 1 */
    End
    Else queue '    *Inactive*'
    SSCVT2   = C2d(Storage(D2x(SSCVT2+4),4))   /* next sscvt or zero */
  End /* do until sscvt2 = 0 */
End /* if subopt <> 'findjes' */
Return
 
ASID:                /* ASVT Usage sub-routine                       */
Queue ' '
CVTASVT  = C2d(Storage(D2x(CVT+556),4))     /* point to ASVT         */
ASVTMAXU = C2d(Storage(D2x(CVTASVT+516),4)) /* max number of entries */
ASVTMAXI = C2d(Storage(D2x(CVTASVT+500),4)) /* MAXUSERS from ASVT    */
ASVTAAVT = C2d(Storage(D2x(CVTASVT+480),4)) /* free slots in ASVT    */
ASVTSTRT = C2d(Storage(D2x(CVTASVT+492),4)) /* RSVTSTRT from ASVT    */
ASVTAST  = C2d(Storage(D2x(CVTASVT+484),4)) /* free START/SASI       */
ASVTNONR = C2d(Storage(D2x(CVTASVT+496),4)) /* RSVNONR  from ASVT    */
ASVTANR  = C2d(Storage(D2x(CVTASVT+488),4)) /* free non-reusable     */
Queue 'ASID Usage Summary from the ASVT:'
Queue '  Maximum number of ASIDs:' Right(ASVTMAXU,5,' ')
Queue '                          '
Queue '    MAXUSER from IEASYSxx:' Right(ASVTMAXI,5,' ')
Queue '             In use ASIDs:' Right(ASVTMAXI-ASVTAAVT,5,' ')
Queue '          Available ASIDs:' Right(ASVTAAVT,5,' ')
Queue '                          '
Queue '    RSVSTRT from IEASYSxx:' Right(ASVTSTRT,5,' ')
Queue '           RSVSTRT in use:' Right(ASVTSTRT-ASVTAST,5,' ')
Queue '        RSVSTRT available:' Right(ASVTAST,5,' ')
Queue '                          '
Queue '    RSVNONR from IEASYSxx:' Right(ASVTNONR,5,' ')
Queue '           RSVNONR in use:' Right(ASVTNONR-ASVTANR,5,' ')
Queue '        RSVNONR available:' Right(ASVTANR,5,' ')
Return
 
LPA:                 /* LPA List sub-routine                         */
CVTSMEXT = C2d(Storage(D2x(CVT + 1196),4))   /* point to stg map ext.*/
CVTEPLPS = C2d(Storage(D2x(CVTSMEXT+56),4))  /* start vaddr of ELPA  */
NUMLPA   = C2d(Storage(D2x(CVTEPLPS+4),4))   /* # LPA libs in table  */
LPAOFF   = 8                                 /* first ent in LPA tbl */
Queue '     '
Queue 'LPA Library List  ('NUMLPA' libraries):'
Queue '  POSITION    DSNAME'
Do I = 1 to NUMLPA
  LEN   = C2d(Storage(D2x(CVTEPLPS+LPAOFF),1)) /* length of entry    */
  LPDSN = Storage(D2x(CVTEPLPS+LPAOFF+1),LEN)  /* DSN of LPA library */
  LPAOFF = LPAOFF + 44 + 1                     /* next entry in table*/
  LPAPOS = Right(I,3)                        /* position in LPA list */
  RELLPPOS = Right('(+'I-1')',6)        /* relative position in list */
  Queue LPAPOS  RELLPPOS '  ' LPDSN
End
Return
 
LNKLST:              /* LNKLST sub-routine                           */
If Bitand(CVTOSLV1,'01'x) <> '01'x then do    /* below OS/390 R2     */
  CVTLLTA  = C2d(Storage(D2x(CVT + 1244),4))  /* point to lnklst tbl */
  NUMLNK   = C2d(Storage(D2x(CVTLLTA+4),4))   /* # LNK libs in table */
  LLTAPFTB = CVTLLTA + 8 + (NUMLNK*45)        /* start of LLTAPFTB   */
  LNKOFF   = 8                                /*first ent in LBK tbl */
  LKAPFOFF = 0                                /*first ent in LLTAPFTB*/
  Queue '     '
  Queue 'LNKLST Library List  ('NUMLNK' Libraries):'
  Queue '  POSITION    APF    DSNAME'
  Do I = 1 to NUMLNK
    LEN = C2d(Storage(D2x(CVTLLTA+LNKOFF),1))     /* length of entry */
    LKDSN = Storage(D2x(CVTLLTA+LNKOFF+1),LEN)    /* DSN of LNK lib  */
    CHKAPF = Storage(D2x(LLTAPFTB+LKAPFOFF),1)    /* APF flag        */
    If  bitand(CHKAPF,'80'x) = '80'x then LKAPF = 'Y'  /* flag on    */
      else LKAPF = ' '                            /* APF flag off    */
    LNKOFF = LNKOFF + 44 + 1                      /*next entry in tbl*/
    LKAPFOFF = LKAPFOFF + 1               /* next entry in LLTAPFTB  */
    LNKPOS = Right(I,3)                           /*position in list */
    RELLKPOS = Right('(+'I-1')',6)      /* relative position in list */
    Queue LNKPOS  RELLKPOS '   ' LKAPF '   ' LKDSN
  End
End
Else do  /* OS/390 1.2 and above - PROGxx capable LNKLST             */
  ASCB     = C2d(Storage(224,4))               /* point to ASCB      */
  ASSB     = C2d(Storage(D2x(ASCB+336),4))     /* point to ASSB      */
  DLCB     = C2d(Storage(D2x(ASSB+236),4))     /* point to CSVDLCB   */
  DLCBFLGS = Storage(d2x(DLCB + 32),1)         /* DLCB flag bits     */
  SETNAME  = Storage(D2x(DLCB + 36),16)        /* LNKLST set name    */
  SETNAME  = Strip(SETNAME,'T')                /* del trailing blanks*/
  CVTLLTA  = C2d(Storage(D2x(DLCB + 16),4))    /* point to lnklst tbl*/
  LLTX     = C2d(Storage(D2x(DLCB + 20),4))    /* point to LLTX      */
  NUMLNK   = C2d(Storage(D2x(CVTLLTA+4),4))    /* # LNK libs in table*/
  LLTAPFTB = CVTLLTA + 8 + (NUMLNK*45)         /* start of LLTAPFTB  */
  LNKOFF   = 8                                 /*first ent in LLT tbl*/
  VOLOFF   = 8                                 /*first ent in LLTX   */
  LKAPFOFF = 0                                /*first ent in LLTAPFTB*/
  If Bitand(DLCBFLGS,'10'x) = '10'x then ,     /* bit for LNKAUTH    */
       LAUTH = 'LNKLST'                        /* LNKAUTH=LNKLST     */
  Else LAUTH = 'APFTAB'                        /* LNKAUTH=APFTAB     */
  Queue '     '
  Queue 'LNKLST Library List - Set:' SETNAME ,
        ' LNKAUTH='LAUTH '('NUMLNK' Libraries):'
  If LAUTH = 'LNKLST' then ,
    Queue '     (All LNKLST data sets marked APF=Y due to' ,
          'LNKAUTH=LNKLST)'
  Queue '  POSITION    APF   VOLUME    DSNAME'
  Do I = 1 to NUMLNK
    LEN = C2d(Storage(D2x(CVTLLTA+LNKOFF),1))     /* length of entry */
    LKDSN = Storage(D2x(CVTLLTA+LNKOFF+1),LEN)    /* DSN of LNK lib  */
    LNKVOL = Storage(D2x(LLTX+VOLOFF),6)          /* VOL of LNK lib  */
    CHKAPF = Storage(D2x(LLTAPFTB+LKAPFOFF),1)    /* APF flag        */
    If  bitand(CHKAPF,'80'x) = '80'x then LKAPF = 'Y'    /* flag on  */
      else LKAPF = ' '                            /* APF flag off    */
    LNKOFF   = LNKOFF + 44 + 1                    /*next entry in LLT*/
    VOLOFF   = VOLOFF + 8                         /*next vol in LLTX */
    LKAPFOFF = LKAPFOFF + 1               /* next entry in LLTAPFTB  */
    LNKPOS   = Right(I,3)                         /*position in list */
    RELLKPOS = Right('(+'I-1')',6)      /* relative position in list */
    Queue LNKPOS  RELLKPOS '   ' LKAPF '  ' LNKVOL '  ' LKDSN
  End
End
Return
 
APF:                 /* APF List sub-routine                         */
CVTAUTHL = C2d(Storage(D2x(CVT + 484),4))    /* point to auth lib tbl*/
If CVTAUTHL <> C2d('7FFFF001'x) then do      /* dynamic list ?       */
  NUMAPF   = C2d(Storage(D2x(CVTAUTHL),2))   /* # APF libs in table  */
  APFOFF   = 2                               /* first ent in APF tbl */
  Queue '     '
  Queue 'APF Library List  ('NUMAPF' libraries):'
  Queue '  ENTRY   VOLUME    DSNAME'
  Do I = 1 to NUMAPF
    LEN = C2d(Storage(D2x(CVTAUTHL+APFOFF),1)) /* length of entry    */
    VOL = Storage(D2x(CVTAUTHL+APFOFF+1),6)    /* VOLSER of APF LIB  */
    DSN = Storage(D2x(CVTAUTHL+APFOFF+1+6),LEN-6)  /* DSN of apflib  */
    APFOFF = APFOFF + LEN +1
    APFPOS   = Right(I,4)                      /*position in APF list*/
    Queue '  'APFPOS '  ' VOL '  ' DSN
  End
End
Else Do
  ECVT     = C2d(Storage(D2x(CVT + 140),4))    /* point to CVTECVT   */
  ECVTCSVT = C2d(Storage(D2x(ECVT + 228),4))   /* point to CSV table */
  APFA = C2d(Storage(D2x(ECVTCSVT + 12),4))    /* APFA               */
  AFIRST = C2d(Storage(D2x(APFA + 8),4))       /* First entry        */
  ALAST  = C2d(Storage(D2x(APFA + 12),4))      /* Last  entry        */
  LASTONE = 0   /* flag for end of list     */
  NUMAPF = 1    /* tot # of entries in list */
  Do forever
    DSN.NUMAPF = Storage(D2x(AFIRST+24),44)    /* DSN of APF library */
    DSN.NUMAPF = Strip(DSN.NUMAPF,'T')         /* remove blanks      */
    CKSMS = Storage(D2x(AFIRST+4),1)           /* DSN of APF library */
    if  bitand(CKSMS,'80'x)  = '80'x           /*  SMS data set?     */
      then VOL.NUMAPF = '*SMS* '               /* SMS control dsn    */
    else VOL.NUMAPF = Storage(D2x(AFIRST+68),6)    /* VOL of APF lib */
    If Substr(DSN.NUMAPF,1,1) <> X2c('00')     /* check for deleted  */
      then NUMAPF = NUMAPF + 1                 /*   APF entry        */
    AFIRST = C2d(Storage(D2x(AFIRST + 8),4))   /* next  entry        */
    if LASTONE = 1 then leave
    If  AFIRST = ALAST then LASTONE = 1
  End
  Queue '     '
  Queue 'APF Library List  - Dynamic ('NUMAPF - 1' libraries):'
  Queue '  ENTRY   VOLUME    DSNAME'
  Do I = 1 to NUMAPF-1
    APFPOS   = Right(I,4)                      /*position in APF list*/
    Queue '  'APFPOS '  ' VOL.I '  ' DSN.I
  End
End
Return
 
SVC:                 /* SVC information sub-routine                  */
/*********************************************************************/
/* See SYS1.MODGEN(IHASVC) for descriptions of SVC attributes        */
/*********************************************************************/
CVTABEND  = C2d(Storage(D2x(CVT+200),4))     /* point to CVTABEND    */
SCVT      = CVTABEND        /* this is the SCVT -  mapped by IHASCVT */
SCVTSVCT  = C2d(Storage(D2x(SCVT+132),4))    /* point to SVCTABLE    */
SCVTSVCR  = C2d(Storage(D2x(SCVT+136),4))    /* point to SVC UPD TBL */
Call FIND_NUC 'IGCERROR'     /* Find addr of IGCERROR in NUC MAP     */
IGCERROR_ADDR = RESULT       /* Save address of IGCERROR             */
Call FIND_NUC 'IGCRETRN'     /* Find addr of IGCRETRN in NUC MAP     */
IGCRETRN_ADDR = RESULT       /* Save address of IGCRETRN             */
Call FIND_NUC 'IGXERROR'     /* Find addr of IGXERROR in NUC MAP     */
IGXERROR_ADDR = RESULT       /* Save address of IGXERROR             */
Call VMAP 'NODISP'      /* call virt. stor map routine, "no display" */
/*********************************************************************/
/* The following code is needed to prevent errors in FIND_SVC_LOC    */
/* routine "Select" because the VMAP sub-routine sets the address    */
/* variables to "N/A" when MLPA/E-MLPA/FLPA/E-FLPA do not exist.     */
/*********************************************************************/
If CVTMLPAS = 'N/A' then CVTMLPAS = 0  /* MLPA   strt does not exist */
If CVTMLPAE = 'N/A' then CVTMLPAE = 0  /* MLPA   end  does not exist */
If CVTFLPAS = 'N/A' then CVTFLPAS = 0  /* FLPA   strt does not exist */
If CVTFLPAE = 'N/A' then CVTFLPAE = 0  /* FLPA   end  does not exist */
If CVTEFLPS = 'N/A' then CVTEFLPS = 0  /* E-FLPA strt does not exist */
If CVTEFLPE = 'N/A' then CVTEFLPE = 0  /* E-FLPA end  does not exist */
If CVTEMLPS = 'N/A' then CVTEMLPS = 0  /* E-MLPA strt does not exist */
If CVTEMLPE = 'N/A' then CVTEMLPE = 0  /* E-MLPA end  does not exist */
/*********************************************************************/
/* A little house keeping                                            */
/*********************************************************************/
SVCACT_TOT    = 0   /* total number of active std SVCs               */
SVCUNUSED_TOT = 0   /* total number of unused std SVCs               */
SVCAPF_TOT    = 0   /* total number of std SVCs requiring APF        */
SVCESR_T1_TOT = 0   /* total number of active Type 1 ESR SVCs        */
SVCESR_T2_TOT = 0   /* total number of active Type 2 ESR SVCs        */
SVCESR_T3_TOT = 0   /* total number of active Type 3/4 ESR SVCs      */
SVCESR_T6_TOT = 0   /* total number of active Type 6 ESR SVCs        */
/*********************************************************************/
/* Standard SVC table display loop                                   */
/*********************************************************************/
Queue '     '
Queue 'SVC Table:'
Queue '  Num Hex  EP-Addr  Location  AM TYP APF ESR ASF AR NP UP' ,
      'CNT Old-EPA  LOCKS'
Do SVCLST = 0 to 255
  SVCTENT  = Storage(D2x(SCVTSVCT+(SVCLST*8)),8)  /* SVC Table Entry */
  SVCTENTU = Storage(D2x(SCVTSVCR+(SVCLST*24)),24) /* SVC UP TBL ENT */
  SVCOLDA  = Substr(SVCTENTU,1,4)            /* OLD EP Address       */
  SVCOLDAR = C2x(SVCOLDA)                    /* OLD addr readable    */
  SVCOLDAR = Right(SVCOLDAR,8,'0')           /* ensure leading zeros */
  SVCURCNT = C2d(Substr(SVCTENTU,21,2))      /* SVC update count     */
  SVCAMODE = Substr(SVCTENT,1,1)             /* AMODE indicator      */
  SVCEPA   = Substr(SVCTENT,1,4)             /* Entry point addr     */
  SVCEPAR  = C2x(SVCEPA)                     /* EPA - readable       */
  SVCEPAR  = Right(SVCEPAR,8,'0')            /* ensure leading zeros */
  SVCATTR1 = Substr(SVCTENT,5,1)             /* SVC attributes       */
  SVCATTR3 = Substr(SVCTENT,6,1)             /* SVC attributes       */
  SVCLOCKS = Substr(SVCTENT,7,1)             /* Lock attributes      */
  /**************************/
  /* Save EPAs of ESR SVCs  */
  /**************************/
  If SVCLST = 109 then SVC109AD = SVCEPA
  If SVCLST = 116 then SVC116AD = SVCEPA
  If SVCLST = 122 then SVC122AD = SVCEPA
  If SVCLST = 137 then SVC137AD = SVCEPA
  /**************************/
  /*  Check amode           */
  /**************************/
  If Bitand(SVCAMODE,'80'x) = '80'x then SVC_AMODE = '31'
    Else SVC_AMODE = '24'
  /**************************/
  /*  Check SVC type flag   */
  /**************************/
  Select                                     /* determine SVC type   */
    When Bitand(SVCATTR1,'C0'x) = 'C0'x then SVCTYPE = '3/4'
    When Bitand(SVCATTR1,'80'x) = '80'x then SVCTYPE = ' 2 '
    When Bitand(SVCATTR1,'20'x) = '20'x then SVCTYPE = ' 6 '
    When Bitand(SVCATTR1,'00'x) = '00'x then SVCTYPE = ' 1 '
    Otherwise SVCTYPE = '???'
  End /* select */
  If SVCLST = 109 then SVCTYPE = ' 3 '  /* 109 is type 3 ESR, not 2  */
  /**************************/
  /*  Check other SVC flags */
  /**************************/
  SVCAPF = '   ' ; SVCESR = '   ' ; SVCNP = '  '  /* init as blanks  */
  SVCASF = '   ' ; SVCAR  = '  '  ; SVCUP = '  '  /* init as blanks  */
  If Bitand(SVCATTR1,'08'x) = '08'x then SVCAPF  = 'APF'
  If Bitand(SVCATTR1,'04'x) = '04'x then SVCESR  = 'ESR'
  If Bitand(SVCATTR1,'02'x) = '02'x then SVCNP   = 'NP'
  If Bitand(SVCATTR1,'01'x) = '01'x then SVCASF  = 'ASF'
  If Bitand(SVCATTR3,'80'x) = '80'x then SVCAR   = 'AR'
  If SVCURCNT <> 0 then SVCUP = 'UP'   /* this SVC has been updated  */
  If SVCURCNT = 0 then do              /* svc never updated          */
    SVCURCNT = '   '
    SVCOLDAR = '        '
  End
  Else do /* most, if not all UP nums are sngl digit- center display */
   If SVCURCNT < 10 then SVCURCNT = Right(SVCURCNT,2,' ') || ' '
     Else SVCURCNT = Right(SVCURCNT,3,' ')
  End /* else do */
  /**************************/
  /*  Check lock flags      */
  /**************************/
  SVCLL    = ' '  ; SVCCMS  = ' ' ; SVCOPT = ' '  /* init as blanks  */
  SVCALLOC = ' '  ; SVCDISP = ' '                 /* init as blanks  */
  If Bitand(SVCLOCKS,'80'x) = '80'x then SVCLL    = 'L'  /* LOCAL    */
  If Bitand(SVCLOCKS,'40'x) = '40'x then SVCCMS   = 'C'  /* CMS      */
  If Bitand(SVCLOCKS,'20'x) = '20'x then SVCOPT   = 'O'  /* OPT      */
  If Bitand(SVCLOCKS,'10'x) = '10'x then SVCALLOC = 'S'  /* SALLOC   */
  If Bitand(SVCLOCKS,'08'x) = '08'x then SVCDISP  = 'D'  /* DISP     */
  /*********************************/
  /*  location, location, location */
  /*********************************/
  SVCLOCA = Bitand(SVCEPA,'7FFFFFFF'x)       /* zero high order bit  */
  SVCLOCA = C2d(SVCLOCA)                     /* need dec. for compare*/
  Call FIND_SVC_LOC SVCLOCA                  /* determine SVC loc    */
  SVCLOC = RESULT                            /* Save Result          */
 
  If SVCLOCA = IGCERROR_ADDR | ,             /* this SVC             */
     SVCLOCA = IGCRETRN_ADDR then do         /*          is not used */
    SVC_AMODE = '  '                         /* blank out amode      */
    SVCAPF = '*** Not Used ***'              /* replace other        */
    SVCESR = ''                              /*   fields to line     */
    SVCASF = ''                              /*     up "locks" due   */
    SVCAR  = ''                              /*       to "not used"  */
    SVCNP  = ''                              /*         display      */
    SVCUP  = ''                              /*                      */
    SVCURCNT = ''                            /*                      */
    SVCOLDAR = '          '                  /*                      */
    SVCUNUSED_TOT = SVCUNUSED_TOT + 1        /* add 1 to unused tot  */
  End /* If SVCLOCA = IGCERROR_ADDR */
  Else do /* used SVC */
    SVCACT_TOT = SVCACT_TOT + 1              /* add 1 to tot active  */
    If SVCAPF  = 'APF' then ,
       SVCAPF_TOT = SVCAPF_TOT + 1           /* add 1 to APF total   */
  End /* Else do */
 
  Queue ' '  Right(SVCLST,3,' ') '('Right(D2x(SVCLST),2,0)')' ,
    SVCEPAR SVCLOC SVC_AMODE SVCTYPE SVCAPF SVCESR SVCASF ,
    SVCAR SVCNP SVCUP SVCURCNT SVCOLDAR ,
    SVCLL || SVCCMS || SVCOPT || SVCALLOC || SVCDISP
End /* Do SVCLST = 0 to 255 */
/*********************************************************************/
/* ESR SVC tables display loop                                       */
/*********************************************************************/
Do SVCESRL = 1 to 4  /* ESR display loop  */
  If SVCESRL = 1 then do
    SVCEAD = C2d(SVC116AD)                   /* Type 1 ESR tbl       */
    SVCEHD = 'Type 1 (SVC 116'              /* Type/SVC for heading */
  End
  If SVCESRL = 2 then do
    SVCEAD = C2d(SVC122AD)                   /* Type 2 ESR tbl       */
    SVCEHD = 'Type 2 (SVC 122'              /* Type/SVC for heading */
  End
  If SVCESRL = 3 then do
    SVCEAD = C2d(SVC109AD)                   /* Type 3 ESR tbl       */
    SVCEHD = 'Type 3 (SVC 109'              /* Type/SVC for heading */
  End
  If SVCESRL = 4 then do
    SVCEAD = C2d(SVC137AD)                   /* Type 6 ESR tbl       */
    SVCEHD = 'Type 6 (SVC 137'              /* Type/SVC for heading */
  End
  SVCESRMX = C2d(Storage(D2x(SVCEAD+4),4))   /* Max # ESR entries    */
  Queue '     '
  Queue 'SVC Table for ESR' SVCEHD '- Maximum ESR Number Supported' ,
        'is' SVCESRMX'):'
  Queue '  Num Hex  EP-Addr  Location  AM TYP APF ASF AR NP' ,
        'LOCKS'
  SVCEAD = SVCEAD + 8                        /* bump past ESR hdr    */
  Do SVCELST = 0 to SVCESRMX
    SVCETENT  = Storage(D2x(SVCEAD+(SVCELST*8)),8) /* SVC Tbl Entry  */
    SVCEAMODE = Substr(SVCETENT,1,1)         /* AMODE indicator      */
    SVCEEPA   = Substr(SVCETENT,1,4)         /* Entry point addr     */
    SVCEEPAR  = C2x(SVCEEPA)                 /* EPA - readable       */
    SVCEEPAR  = Right(SVCEEPAR,8,'0')        /* ensure leading zeros */
    SVCEATTR1 = Substr(SVCETENT,5,1)         /* SVC attributes       */
    SVCEATTR3 = Substr(SVCETENT,6,1)         /* SVC attributes       */
    SVCELOCKS = Substr(SVCETENT,7,1)         /* Lock attributes      */
  /**************************/
  /*  Check amode           */
  /**************************/
  If Bitand(SVCEAMODE,'80'x) = '80'x then SVCE_AMODE = '31'
    Else SVCE_AMODE = '24'
  /**************************/
  /*  Check SVC type flag   */
  /**************************/
  Select                                     /* determine SVC type   */
    When Bitand(SVCEATTR1,'C0'x) = 'C0'x then SVCETYPE = '3/4'
    When Bitand(SVCEATTR1,'80'x) = '80'x then SVCETYPE = ' 2 '
    When Bitand(SVCEATTR1,'20'x) = '20'x then SVCETYPE = ' 6 '
    When Bitand(SVCEATTR1,'00'x) = '00'x then SVCETYPE = ' 1 '
    Otherwise SVCETYPE = '???'
  End /* select */
  /**************************/
  /*  Check other SVC flags */
  /**************************/
  SVCEAPF = '   ' ; SVCENP = '  '  /* init as blanks  */
  SVCEASF = '   ' ; SVCEAR = '  '  /* init as blanks  */
  SVCEESR = '   '
  If Bitand(SVCEATTR1,'08'x) = '08'x then SVCEAPF  = 'APF'
  If Bitand(SVCEATTR1,'04'x) = '04'x then SVCEESR  = 'ESR'
  If Bitand(SVCEATTR1,'02'x) = '02'x then SVCENP   = 'NP'
  If Bitand(SVCEATTR1,'01'x) = '01'x then SVCEASF  = 'ASF'
  If Bitand(SVCEATTR3,'80'x) = '80'x then SVCEAR   = 'AR'
  /**************************/
  /*  Check lock flags      */
  /**************************/
  SVCELL    = ' '  ; SVCECMS  = ' ' ; SVCEOPT = ' ' /* init as blanks*/
  SVCEALLOC = ' '  ; SVCEDISP = ' '                 /* init as blanks*/
  If Bitand(SVCELOCKS,'80'x) = '80'x then SVCELL    = 'L' /* LOCAL   */
  If Bitand(SVCELOCKS,'40'x) = '40'x then SVCECMS   = 'C' /* CMS     */
  If Bitand(SVCELOCKS,'20'x) = '20'x then SVCEOPT   = 'O' /* OPT     */
  If Bitand(SVCELOCKS,'10'x) = '10'x then SVCEALLOC = 'S' /* SALLOC  */
  If Bitand(SVCELOCKS,'08'x) = '08'x then SVCEDISP  = 'D' /* DISP    */
  /*********************************/
  /*  location, location, location */
  /*********************************/
  SVCELOCA = Bitand(SVCEEPA,'7FFFFFFF'x)     /* zero high order bit  */
  SVCELOCA = C2d(SVCELOCA)                   /* need dec. for compare*/
  Call FIND_SVC_LOC SVCELOCA                 /* determine SVC loc    */
  SVCELOC = RESULT                           /* Save Result          */
 
  If SVCELOCA = IGXERROR_ADDR then do        /* this SVC is not used */
    SVCE_AMODE = '  '                        /* blank out amode      */
    SVCEAPF = '* Unused *'                   /* replace other fields */
    SVCEASF = ''                             /*  to line up "locks"  */
    SVCEAR  = ''                             /*   due to "unused"    */
    SVCENP  = ''                             /*    display           */
  End /* If SVCELOCA = IGXERROR_ADDR */
  Else do /* used SVC */
    If SVCESRL = 1 then ,
       SVCESR_T1_TOT = SVCESR_T1_TOT + 1     /* add 1 to TYPE 1 tot  */
    If SVCESRL = 2 then ,
       SVCESR_T2_TOT = SVCESR_T2_TOT + 1     /* add 1 to TYPE 2 tot  */
    If SVCESRL = 3 then ,
       SVCESR_T3_TOT = SVCESR_T3_TOT + 1     /* add 1 to TYPE 3/4 tot*/
    If SVCESRL = 4 then ,
       SVCESR_T6_TOT = SVCESR_T6_TOT + 1     /* add 1 to TYPE 6 tot  */
  End /* Else do */
 
  Queue ' '  Right(SVCELST,3,' ') '('Right(D2x(SVCELST),2,0)')' ,
    SVCEEPAR SVCELOC SVCE_AMODE SVCETYPE SVCEAPF SVCEASF ,
    SVCEAR SVCENP ,
    SVCELL || SVCECMS || SVCEOPT || SVCEALLOC || SVCEDISP
  End
 
End /* Do SVCESRL = 1 to 4 */
Queue '    '
Queue '  SVC Usage Summary:'
Queue '    Total number of active standard SVCs (including ESR' ,
      'slots) =' SVCACT_TOT
Queue '    Total number of unused standard SVCs =' SVCUNUSED_TOT
Queue '    Total number of active standard SVCs' ,
      'requiring APF auth =' SVCAPF_TOT
Queue '    Total number of active Type 1   ESR SVCs =' SVCESR_T1_TOT
Queue '    Total number of active Type 2   ESR SVCs =' SVCESR_T2_TOT
Queue '    Total number of active Type 3/4 ESR SVCs =' SVCESR_T3_TOT
Queue '    Total number of active Type 6   ESR SVCs =' SVCESR_T6_TOT
Return
 
FIND_SVC_LOC:  /* determine virtual storage location of SVC  */
Arg SVC_LOC
Select
  When SVC_LOC >= X2d(VVSTRT)    & SVC_LOC <= X2d(VVEND)     ,
       then SVCLOC = 'PRIVATE  ' /* never, but coded anyway */
  When SVC_LOC >= X2d(GDACSAH)   & SVC_LOC <= X2d(CSAEND)    ,
       then SVCLOC = 'CSA      '
  When SVC_LOC >= X2d(CVTMLPAS)  & SVC_LOC <= X2d(CVTMLPAE)  ,
       then SVCLOC = 'MLPA     '
  When SVC_LOC >= X2d(CVTFLPAS)  & SVC_LOC <= X2d(CVTFLPAE)  ,
       then SVCLOC = 'FLPA     '
  When SVC_LOC >= X2d(CVTPLPAS)  & SVC_LOC <= X2d(CVTPLPAE)  ,
       then SVCLOC = 'PLPA     '
  When SVC_LOC >= X2d(GDASQAH)   & SVC_LOC <= X2d(SQAEND)    ,
       then SVCLOC = 'SQA      '
  When SVC_LOC >= X2d(CVTRWNS)   & SVC_LOC <= X2d(CVTRWNE)   ,
       then SVCLOC = 'R/W Nuc  '
  When SVC_LOC >= X2d(RONUCSZB)  & SVC_LOC <= X2d('FFFFFF')  ,
       then SVCLOC = 'R/O Nuc  '
  When SVC_LOC >= X2d('1000000') & SVC_LOC <= X2d(CVTRONE)   ,
       then SVCLOC = 'E-R/O Nuc'
  When SVC_LOC >= X2d(CVTERWNS)  & SVC_LOC <= X2d(CVTERWNE)  ,
       then SVCLOC = 'E-R/W Nuc'
  When SVC_LOC >= X2d(GDAESQAH)  & SVC_LOC <= X2d(ESQAEND)   ,
       then SVCLOC = 'E-SQA    '
  When SVC_LOC >= X2d(CVTEPLPS)  & SVC_LOC <= X2d(CVTEPLPE)  ,
       then SVCLOC = 'E-PLPA   '
  When SVC_LOC >= X2d(CVTEFLPS)  & SVC_LOC <= X2d(CVTEFLPE)  ,
       then SVCLOC = 'E-FLPA   '
  When SVC_LOC >= X2d(CVTEMLPS)  & SVC_LOC <= X2d(CVTEMLPE)  ,
       then SVCLOC = 'E-MLPA   '
  When SVC_LOC >= X2d(GDAECSAH)  & SVC_LOC <= X2d(ECSAEND)   ,
       then SVCLOC = 'E-CSA    '
  When SVC_LOC >= X2d(GDAEPVTH)  & SVC_LOC <= X2d(EPVTEND)   ,
       then SVCLOC = 'E-PRIVATE' /* never, but coded anyway */
  Otherwise SVCLOC = '????     '
End /* select */
Return SVCLOC
 
FIND_NUC: /* Find EP address of "ARG" in NUC MAP  */
Arg NUC_NAME
CVTNUCMP  = C2d(Storage(D2x(CVT+1200),4))    /* NUC map address      */
NUCMAPEND = C2d(Storage(D2x(CVTNUCMP+8),4))  /* End of nucmap        */
 /* NUCMAPLEN = C2d(Storage(D2x(CVTNUCMP+13),3)) */ /* tbl length    */
NUC_CURA  = CVTNUCMP+16                      /* Curent tbl entry     */
Do while  NUC_CURA <  NUCMAPEND              /* go though tbl        */
  NUC_EP    = Storage(D2x(NUC_CURA),8)       /* Nuc EP name          */
  If NUC_EP = NUC_NAME then do               /* NUC_NAME found?      */
    NUC_ADDR = C2d(Storage(D2x(NUC_CURA+8),4)) /* yes, save addr     */
    Leave                                    /* leave this loop      */
  End /* If NUC_EP = NUC_NAME */
  Else NUC_CURA = NUC_CURA + 16              /* bump to next entry   */
End /* do while */
Return NUC_ADDR
 
XLATE_NONDISP:       /* translate non-display characters to a "."    */
Arg XLATEPRM
XLATELEN = Length(XLATEPRM) /* length of parm passed to routine      */
Do I = 1 to XLATELEN                      /* check each byte for     */
  If (Substr(XLATEPRM,I,1) >= '00'x & ,   /* non-display characters  */
    Substr(XLATEPRM,I,1) < '40'x ) | ,    /* and replace each        */
    Substr(XLATEPRM,I,1) = 'FF'x  then ,  /* character that          */
    XLATEPRM = OVERLAY('.',XLATEPRM,I)    /* is non-displayable      */
End                                       /* with a period (.)       */
Return XLATEPRM
 
STORAGE_GDA_LDA:     /* GDA/LDA Storage values sub-routine           */
ASCB     = C2d(Storage(224,4))               /* point to cur ASCB    */
ASCBLDA  = C2d(Storage(D2x(ASCB + 48),4))    /* point to LDA         */
CVTGDA   = C2d(Storage(D2x(CVT + 560),4))    /* point to GDA         */
LDASTRTA = Storage(D2x(ASCBLDA + 60),4)      /* point to V=V start   */
LDASTRTA = C2x(LDASTRTA)                     /* display in hex       */
LDASIZEA = C2d(Storage(D2x(ASCBLDA + 64),4)) /* point to V=V size    */
LDASIZEA = LDASIZEA/1024                     /* convert to Kbytes    */
LDASTRTS = Storage(D2x(ASCBLDA + 92),4)      /* pt. to sysarea start */
LDASTRTS = C2x(LDASTRTS)                     /* display in hex       */
LDASIZS  = C2d(Storage(D2x(ASCBLDA + 96),4)) /* pt. to sysarea size  */
LDASIZS  = LDASIZS/1024                      /* convert to Kbytes    */
GDAPVTSZ = C2d(Storage(D2x(CVTGDA + 164),4)) /* point to MAX PVT<16M */
GDAPVTSZ = GDAPVTSZ/1024                     /* convert to Kbytes    */
GDAEPVTS = C2d(Storage(D2x(CVTGDA + 172),4)) /* point to MAX PVT>16M */
GDAEPVTS = GDAEPVTS/1024/1024                /* convert to Mbytes    */
GDACSASZ = C2d(Storage(D2x(CVTGDA + 112),4)) /* point to CSA<16M     */
GDACSASZ = GDACSASZ/1024                     /* convert to Kbytes    */
GDAECSAS = C2d(Storage(D2x(CVTGDA + 128),4)) /* point to CSA>16M     */
GDAECSAS = GDAECSAS/1024                     /* convert to Kbytes    */
GDASQASZ = C2d(Storage(D2x(CVTGDA + 148),4)) /* point to SQA<16M     */
GDASQASZ = GDASQASZ/1024                     /* convert to Kbytes    */
GDAESQAS = C2d(Storage(D2x(CVTGDA + 156),4)) /* point to SQA>16M     */
GDAESQAS = GDAESQAS/1024                     /* convert to Kbytes    */
GDAVRSZ  = C2d(Storage(D2x(CVTGDA + 196),4)) /* point to V=R global  */
GDAVRSZ  = GDAVRSZ/1024                      /* convert to Kbytes    */
GDAVREGS = C2d(Storage(D2x(CVTGDA + 200),4)) /* point to V=R default */
GDAVREGS = GDAVREGS/1024                     /* convert to Kbytes    */
GDA_CSA_ALLOC  = C2d(Storage(D2x(CVTGDA + 432),4)) /* CSA amt alloc  */
GDA_CSA_ALLOC  = Format(GDA_CSA_ALLOC/1024,,0)     /* conv to Kbytes */
GDA_ECSA_ALLOC = C2d(Storage(D2x(CVTGDA + 436),4)) /* ECSA amt alloc */
GDA_ECSA_ALLOC = Format(GDA_ECSA_ALLOC/1024,,0)    /* conv to Kbytes */
GDA_SQA_ALLOC  = C2d(Storage(D2x(CVTGDA + 440),4)) /* SQA amt alloc  */
GDA_SQA_ALLOC  = Format(GDA_SQA_ALLOC/1024,,0)     /* conv to Kbytes */
GDA_ESQA_ALLOC = C2d(Storage(D2x(CVTGDA + 444),4)) /* ESQA amt alloc */
GDA_ESQA_ALLOC = Format(GDA_ESQA_ALLOC/1024,,0)    /* conv to Kbytes */
GDA_CSA_CONV   = C2d(Storage(D2x(CVTGDA + 448),4)) /* CSA => SQA amt */
GDA_CSA_CONV   = Format(GDA_CSA_CONV/1024,,0)      /* conv to Kbytes */
GDA_ECSA_CONV  = C2d(Storage(D2x(CVTGDA + 452),4)) /* ECSA=>ESQA amt */
GDA_ECSA_CONV  = Format(GDA_ECSA_CONV/1024,,0)     /* conv to Kbytes */
/*********************************************************************/
/* High Water Marks for SQA/ESQA/CSA/ECSA added in OS/390 R10        */
/*********************************************************************/
If Bitand(CVTOSLV2,'01'x) = '01'x then do    /* OS/390 R10 and above */
  GDASQAHWM  = C2d(Storage(D2x(CVTGDA + 536),4))   /* SQA HWM        */
  GDASQAHWM  = Format(GDASQAHWM/1024,,0)           /* conv to Kbytes */
  GDAESQAHWM = C2d(Storage(D2x(CVTGDA + 540),4))   /* ESQA HWM       */
  GDAESQAHWM = Format(GDAESQAHWM/1024,,0)          /* conv to Kbytes */
  If Bitand(CVTOSLV5,'08'x) = '08'x then do  /* z/OS 1.10 and above  */
    GDATotalCSAHWM  = C2d(Storage(D2x(CVTGDA+552),4)) /* CSA HWM     */
    GDATotalCSAHWM  = Format(GDATotalCSAHWM/1024,,0)  /* conv to Kb  */
    GDATotalECSAHWM = C2d(Storage(D2x(CVTGDA+556),4)) /* ECSA HWM    */
    GDATotalECSAHWM = Format(GDATotalECSAHWM/1024,,0) /* conv to Kb  */
    GDACSAHWM       = GDATotalCSAHWM   /* set var used for VMAP disp */
    GDAECSAHWM      = GDATotalECSAHWM  /* set var used for VMAP disp */
  End
  Else do  /* use pre z/OS 1.10 values for CSA/ECSA HWM              */
    GDACSAHWM  = C2d(Storage(D2x(CVTGDA + 544),4)) /* CSA HWM        */
    GDACSAHWM  = Format(GDACSAHWM/1024,,0)         /* conv to Kbytes */
    GDAECSAHWM = C2d(Storage(D2x(CVTGDA + 548),4)) /* ECSA HWM       */
    GDAECSAHWM = Format(GDAECSAHWM/1024,,0)        /* conv to Kbytes */
  End
End
Return
 
EXTRACT_SYSPARMS:    /* Extract IEASYSxx values from the IPA         */
Parse arg IEASPARM
IEASPARM = Strip(IEASPARM,'T')               /* remove trailing blnks*/
If IEASPARM = '<notdef>' then return         /*"blank" parm in IHAIPA*/
/*********************************************************************/
/* This next section of code removes IEASYSxx parameters from the    */
/* IPA output display for parms that are obsolete or undocumented    */
/* but still have to be accounted for when parsing out the parms     */
/* and values from the IPA control block.                            */
/*********************************************************************/
If Bitand(CVTOSLV3,'08'x) = '08'x then ,     /* z/OS 1.3 and above   */
  If Substr(IEASPARM,1,3) = 'IPS'then return /* remove IPS parm      */
If Bitand(CVTOSLV3,'02'x) = '02'x then ,     /* z/OS 1.5 and above   */
  If Pos('ILM',IEASPARM) <> 0  then return   /* remove ILM parms     */
If Bitand(CVTOSLV5,'04'x) = '04'x then do    /* z/OS 1.11 and above  */
  If Pos('IQP',IEASPARM)  <> 0 then return   /* remove IQP parm      */
  If Pos('CPCR',IEASPARM) <> 0 then return   /* remove CPCR parm     */
  If Pos('DDM',IEASPARM)  <> 0 then return   /* remove DDM parm      */
End
If Bitand(CVTOSLV5,'01'x) = '01'x then do    /* z/OS 1.13 and above  */
  If Pos('RTLS',IEASPARM) <> 0 then return   /* remove RTLS parm     */
End
/*********************************************************************/
IPAOFF = ((I-1) * 8)                         /* offset to next entry */
IPASTOR = D2x(ECVTIPA + 2152 + IPAOFF)       /* point to PDE addr    */
IPAPDE  = C2x(Storage((IPASTOR),8))          /* point to PDE         */
If IPAPDE = 0 then return   /* parm not specified and has no default */
TOTPRMS = TOTPRMS + 1    /* tot num of specified or defaulted parms  */
IPAADDR = Substr(IPAPDE,1,8)                 /* PARM address         */
IPALEN  = X2d(Substr(IPAPDE,9,4))            /* PARM length          */
IPAPRM  = Storage((IPAADDR),IPALEN)          /* PARM                 */
IPASRC  = Substr(IPAPDE,13,4)                /* PARM source          */
If X2d(IPASRC) = 65535 then PRMSRC = 'Operator'   /* operator parm   */
Else
  If X2d(IPASRC) = 0     then PRMSRC = 'Default'  /* default  parm   */
Else
  PRMSRC = 'IEASYS' || X2c(IPASRC)           /* IEASYSxx parm        */
PRMLINE = '    'IEASPARM'='IPAPRM
  /**************************************************/
  /* This check just below is for parms that do not */
  /* have an equal sign in IEASYSxx.                */
  /**************************************************/
If IEASPARM = 'PRESCPU' | ,
   IEASPARM = 'WARNUND' | ,
   IEASPARM = 'CVIO'    | ,
   IEASPARM = 'CLPA' then  PRMLINE = '    'IEASPARM
  Else PRMLINE = '    'IEASPARM'='IPAPRM
PRMLINE.TOTPRMS = IEASPARM PRMLINE PRMSRC
PRMLINE.0 = TOTPRMS
Return
 
BUILD_IPAPDETB:      /* Build table for lookup for IPA values        */
NUM=1
IPAPDETB.NUM = 'ALLOC   ' ; NUM = NUM + 1
IPAPDETB.NUM = 'APF     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'APG     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'BLDL    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'BLDLF   ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CLOCK   ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CLPA    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CMB     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CMD     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CON     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CONT    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'COUPLE  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CPQE    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CSA     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CSCBLOC ' ; NUM = NUM + 1
IPAPDETB.NUM = 'CVIO    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'DEVSUP  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'DIAG    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'DUMP    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'DUPLEX  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'EXIT    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'FIX     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'GRS     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'GRSCNF  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'GRSRNL  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'ICS     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'IOS     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'IPS     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LNK     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LNKAUTH ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LOGCLS  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LOGLMT  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LOGREC  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'LPA     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'MAXCAD  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'MAXUSER ' ; NUM = NUM + 1
IPAPDETB.NUM = 'MLPA    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'MSTRJCL ' ; NUM = NUM + 1
IPAPDETB.NUM = 'NONVIO  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'NSYSLX  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'NUCMAP  ' ; NUM = NUM + 1
If Bitand(CVTOSLV1,'04'x) = '04'x then do    /* OS/390 R3 and above  */
   IPAPDETB.NUM = 'OMVS    ' ; NUM = NUM + 1
End
Else do
   IPAPDETB.NUM = 'RESERVED' ; NUM = NUM + 1
End
IPAPDETB.NUM = 'OPI     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'OPT     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PAGE-OPR' ; NUM = NUM + 1
IPAPDETB.NUM = 'PAGE    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PAGNUM  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PAGTOTL ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PAK     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PLEXCFG ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PROD    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PROG    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'PURGE   ' ; NUM = NUM + 1
IPAPDETB.NUM = 'RDE     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'REAL    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'RER     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'RSU     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'RSVNONR ' ; NUM = NUM + 1
IPAPDETB.NUM = 'RSVSTRT ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SCH     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SMF     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SMS     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SQA     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SSN     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SVC     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SWAP    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SYSNAME ' ; NUM = NUM + 1
IPAPDETB.NUM = 'SYSP    ' ; NUM = NUM + 1
IPAPDETB.NUM = 'VAL     ' ; NUM = NUM + 1
IPAPDETB.NUM = 'VIODSN  ' ; NUM = NUM + 1
IPAPDETB.NUM = 'VRREGN  ' ; NUM = NUM + 1
If Bitand(CVTOSLV2,'80'x) = '80'x then do    /* OS/390 R4 and above  */
   IPAPDETB.NUM = 'RTLS    ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV2,'04'x) = '04'x then do    /* OS/390 R8 and above  */
   IPAPDETB.NUM = 'UNI     ' ; NUM = NUM + 1 /* added by APAR OW44581*/
End
If Bitand(CVTOSLV3,'20'x) = '20'x then do    /* z/OS 1.1 and above   */
   IPAPDETB.NUM = 'ILMLIB  ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'ILMMODE ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV3,'08'x) = '08'x then do    /* z/OS 1.3 and above   */
   IPAPDETB.NUM = 'IKJTSO  ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'LICENSE ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV3,'02'x) = '02'x then do    /* z/OS 1.5 and above   */
   IPAPDETB.NUM = '<notdef>' ; NUM = NUM + 1 /*"blank" def in IHAIPA */
   IPAPDETB.NUM = 'HVSHARE ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'ILM     ' ; NUM = NUM + 1
 /********************************************************************/
 /* If you have a z/OS 1.5 or z/OS 1.6 system without OA09649, you   */
 /* may have to delete the next 3 lines of code.                     */
 /********************************************************************/
   IPAPDETB.NUM = '<notdef>' ; NUM = NUM + 1 /*"blank" def in IHAIPA */
   IPAPDETB.NUM = '<notdef>' ; NUM = NUM + 1 /*"blank" def in IHAIPA */
   IPAPDETB.NUM = 'PRESCPU ' ; NUM = NUM + 1 /* added by OA09649 */
End
If Bitand(CVTOSLV5,'40'x) = '40'x then do    /* z/OS 1.7 and above   */
   NUM = NUM-3
   IPAPDETB.NUM = 'DRMODE  ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'CEE     ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'PRESCPU ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'10'x) = '10'x then do    /* z/OS 1.9 and above   */
   IPAPDETB.NUM = 'LFAREA  ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'08'x) = '08'x then do    /* z/OS 1.10 and above  */
   IPAPDETB.NUM = 'CEA     ' ; NUM = NUM + 1
   IPAPDETB.NUM = 'HVCOMMON' ; NUM = NUM + 1
   IPAPDETB.NUM = 'AXR     ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'08'x) = '08'x then do    /* z/OS 1.10 and above  */
 /********************************************************************/
 /* If you have z/OS 1.10 without OA27495, you may have to delete    */
 /* the next line of code. If you have z/OS 1.9 with OA27495 and     */
 /* wish to see the "ZZ" value, change the check above from:         */
 /*   If Bitand(CVTOSLV5,'08'x) = '08'x then do                      */
 /* to:                                                              */
 /*   If Bitand(CVTOSLV5,'10'x) = '10'x then do                      */
 /********************************************************************/
   IPAPDETB.NUM = 'ZZ      ' ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'04'x) = '04'x then do    /* z/OS 1.11 and above  */
   NUM = NUM - 1
   IPAPDETB.NUM = 'ZAAPZIIP' ; NUM = NUM + 1
   IPAPDETB.NUM = 'IQP'      ; NUM = NUM + 1
   IPAPDETB.NUM = 'CPCR'     ; NUM = NUM + 1
   IPAPDETB.NUM = 'DDM'      ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'02'x) = '02'x then do    /* z/OS 1.12 and above  */
   IPAPDETB.NUM = 'AUTOR'    ; NUM = NUM + 1
End
If Bitand(CVTOSLV5,'01'x) = '01'x then do    /* z/OS 1.13 and above  */
   IPAPDETB.NUM = 'CATALOG'  ; NUM = NUM + 1
   IPAPDETB.NUM = 'IXGCNF'   ; NUM = NUM + 1
End
If Bitand(CVTOSLV6,'80'x) = '80'x then do    /* z/OS 2.1  and above  */
   IPAPDETB.NUM = 'PAGESCM'  ; NUM = NUM + 1
   IPAPDETB.NUM = 'WARNUND'  ; NUM = NUM + 1
   IPAPDETB.NUM = 'HZS'      ; NUM = NUM + 1
   IPAPDETB.NUM = 'GTZ'      ; NUM = NUM + 1
   IPAPDETB.NUM = 'HZSPROC'  ; NUM = NUM + 1
End
If Bitand(CVTOSLV6,'40'x) = '40'x then do    /* z/OS 2.2  and above  */
   IPAPDETB.NUM = 'SMFLIM'   ; NUM = NUM + 1
   IPAPDETB.NUM = 'IEFOPZ'   ; NUM = NUM + 1
End
If Bitand(CVTOSLV6,'10'x) = '10'x then do    /* z/OS 2.3  and above  */
   IPAPDETB.NUM = 'RACF'     ; NUM = NUM + 1
   IPAPDETB.NUM = 'FXE'      ; NUM = NUM + 1
   IPAPDETB.NUM = 'IZU'      ; NUM = NUM + 1
   IPAPDETB.NUM = 'SMFTBUFF' ; NUM = NUM + 1  /* APAR OA52828 */
   IPAPDETB.NUM = 'DIAG1'    ; NUM = NUM + 1  /* IBM use only */
   IPAPDETB.NUM = 'OSPROTECT'; NUM = NUM + 1  /* APAR OA54807 */
   IPAPDETB.NUM = 'ICSF'     ; NUM = NUM + 1  /* APAR OA55378 */
   IPAPDETB.NUM = 'ICSFPROC' ; NUM = NUM + 1  /* APAR OA55378 */
End
       /* RUCSA and BOOST on z/OS 2.3 with APARs OA56180 and OA57849 */
If Bitand(CVTOSLV6,'08'x) = '08'x then do    /* z/OS 2.4  and above  */
   IPAPDETB.NUM = 'RUCSA'    ; NUM = NUM + 1
   IPAPDETB.NUM = 'BOOST'    ; NUM = NUM + 1
End
IPAPDETB.0 = NUM-1
Return
 
SPLIT_IPA_PAGE: /* Split up page data set parms to multiple lines */
TOT_IPALINES = 0
Do SPLIT = 1 to PRMLINE.0
   TOT_IPALINES = TOT_IPALINES+1    /* add one total lines    */
   IPA_PDE = Word(PRMLINE.SPLIT,1)  /* keyword                */
   IPA_PRM = Word(PRMLINE.SPLIT,2)  /* value                  */
   IPA_SRC = Word(PRMLINE.SPLIT,3)  /* IEASYSxx, dlft, or OPR */
   IPA_LEN = Length(IPA_PRM)
  If IPA_PDE = 'NONVIO' | IPA_PDE = 'PAGE' | ,
     IPA_PDE = 'PAGE-OPR' | IPA_PDE = 'SWAP' then do
    MORE  = 'YES' /* init flag for more subparms */
    FIRST = 'YES' /* init flag for first subparm */
    SPLITPOS = 1
    Do until MORE = 'NO'
      SPLITPOS = Pos(',',IPA_PRM)
      If SPLITPOS = 0 then do
        If FIRST = 'YES' then do
          IPALINE.TOT_IPALINES = '    'IPA_PRM || ','
          IPALINE.TOT_IPALINES = ,
            Overlay(IPA_SRC,IPALINE.TOT_IPALINES,68)
        End
        Else do
          MBLNK = ''
          If IPA_PDE = 'NONVIO' then MBLNK = '  '     /* align   */
          If IPA_PDE = 'PAGE-OPR' then MBLNK = '    ' /* align   */
          IPALINE.TOT_IPALINES = MBLNK'          'IPA_PRM || ','
          IPALINE.TOT_IPALINES = ,
            Overlay(IPA_SRC,IPALINE.TOT_IPALINES,68)
        End
        MORE = 'NO'  /* no more subparms */
      End /* if SPLITPOS = 0 */
      Else do
        IPAPRM_SPLIT = Substr(IPA_PRM,1,SPLITPOS)
        If FIRST = 'YES' then IPALINE.TOT_IPALINES = '    'IPAPRM_SPLIT
          Else do
            MBLNK = ''
            If IPA_PDE = 'NONVIO' then MBLNK = '  '     /* align   */
            If IPA_PDE = 'PAGE-OPR' then MBLNK = '    ' /* align   */
            IPALINE.TOT_IPALINES = MBLNK'          'IPAPRM_SPLIT
          End
        IPA_PRM  = Substr(IPA_PRM,SPLITPOS+1,IPA_LEN-SPLITPOS)
        IPA_LEN =  Length(IPA_PRM)
        TOT_IPALINES = TOT_IPALINES+1  /* add one total lines */
        FIRST = 'NO'
      End
    End  /* do until more=no */
  End
  Else do
    IPALINE.TOT_IPALINES = '    'IPA_PRM || ','
    IPALINE.TOT_IPALINES = Overlay(IPA_SRC,IPALINE.TOT_IPALINES,68)
  End
End
Return
 
SORT_IPA: Procedure expose PRMLINE.
/* bubble sort the IPA list */
SORT_DONE = 0
SORT_RECS = PRMLINE.0
Do while SORT_DONE = 0
  SORT_DONE = 1
  Do I = 1 to SORT_RECS - 1
    J = I + 1
    If PRMLINE.I > PRMLINE.J then do
      SORT_DONE = 0
      TEMP_SORT = PRMLINE.J
      PRMLINE.J = PRMLINE.I
      PRMLINE.I = TEMP_SORT
    End /* if */
  End /* do i=1 to sort_recs */
  SORT_RECS = SORT_RECS - 1
End /* do while */
Return
 
GET_CPCSI:
SI_OFF=0
IRALCCT = C2d(Storage(D2x(RMCT+620),4))         /* point to IRALCCT  */
                                                /*  (undocumented)   */
If Bitand(CVTOSLV5,'08'x) = '08'x then , /* z/OS 1.10 and above      */
  SI_OFF = 128      /* additional offset to CPC SI info in IRALCCT   */
 /****************************************************************/
 /* If you have z/OS 1.12 or z/OS 1.13 with z13 support          */
 /* maintenance applied you will have to uncomment either the    */
 /* first 2 lines or the 2nd 2 lines to fix the CPCSI display.   */
 /* The 2nd set should work for z/OS 1.12 or z/OS 1.13 systems   */
 /* that do have the maintenance and also for those systems that */
 /* do not have the maintenance.                                 */
 /****************************************************************/
/*If Bitand(CVTOSLV5,'02'x) = '02'x then , */   /* z/OS 1.12 and >   */
/*  SI_OFF = 384 */   /* additional offset to CPC SI info in IRALCCT */
/*If C2x(Storage(D2x(IRALCCT+10),1)) <> '40' then , *//* z13 support */
/*  SI_OFF = 384 */   /* additional offset to CPC SI info in IRALCCT */
If Bitand(CVTOSLV6,'80'x) = '80'x then , /* z/OS 2.1  and above      */
  SI_OFF = 384      /* additional offset to CPC SI info in IRALCCT   */
 /****************************************************************/
 /* The check below was added for a reported problem on          */
 /* z/OS 2.3 at RSU1812 or RSU1903.  I'm not sure what APAR(s)   */
 /* broke this or if the same APAR could apply to earlier z/OS   */
 /* versions.                                                    */
 /*                                                              */
 /* If the CPU node display doesn't look right, delete the code  */
 /* that changes the offset to 392 or comment it out.            */
 /****************************************************************/
If Bitand(CVTOSLV6,'10'x) = '10'x then       /* z/OS 2.3  and above  */
  /* (MODEL='3906' | MODEL='3907') | */      /* z/OS 2.3 + z14       */
  /* (MODEL='2964' | MODEL='2965') then */   /* z/OS 2.3 + z13       */
  SI_OFF = 392      /* additional offset to CPC SI info in IRALCCT   */
CPCSI_TYPE  = Storage(D2x(IRALCCT+332+SI_OFF),4)    /* Type          */
CPCSI_MODEL = Storage(D2x(IRALCCT+336+SI_OFF),4)    /* Model         */
CPCSI_MODEL = Strip(CPCSI_MODEL)                    /* Remove blanks */
CPCSI_MAN   = Storage(D2x(IRALCCT+384+SI_OFF),16)   /* Manufacturer  */
CPCSI_MAN   = Strip(CPCSI_MAN)                      /* Remove blanks */
CPCSI_PLANT = Storage(D2x(IRALCCT+400+SI_OFF),4)    /* Plant         */
CPCSI_PLANT = Strip(CPCSI_PLANT)                    /* Remove blanks */
CPCSI_CPUID = Storage(D2x(IRALCCT+352+SI_OFF),16)   /* CPUID         */
CPCSI_MODELID = Storage(D2x(IRALCCT+592+SI_OFF),4)  /* Model ID      */
CPCSI_MODELID = Strip(CPCSI_MODELID)                /* Remove blanks */
 /*   CPCSI_MODELID may not be valid on emulated    */
 /*   z/OS systems like FLEX, HERC and z/PDT        */
Return
 
FORMAT_MEMSIZE:
/****************************************************************/
/* The following code is used to display the storage size in    */
/* the largest possible unit.  For example, 1023G and 1025G are */
/* displayed as 1023G and 1025G, but 1024G is displayed as 1T.  */
/* The size passed to the routine must be in MB.                */
/****************************************************************/
Arg SIZE_IN_MB
Select
   When SIZE_IN_MB < 1024 then do
     MUNITS = 'M'
   End
   When SIZE_IN_MB >= 1024 & SIZE_IN_MB < 1048576 then do
     If SIZE_IN_MB/1024 == TRUNC(SIZE_IN_MB/1024) then do
       SIZE_IN_MB = SIZE_IN_MB/1024
       MUNITS = 'G'
     End
     Else MUNITS = 'M'
   End
   When SIZE_IN_MB >= 1048576 & SIZE_IN_MB < 1073741824 then do
     If SIZE_IN_MB/1048576 == TRUNC(SIZE_IN_MB/1048576) then do
       SIZE_IN_MB = SIZE_IN_MB/1048576
       MUNITS = 'T'
     End
     Else do
       If SIZE_IN_MB/1024 == TRUNC(SIZE_IN_MB/1024) then do
         SIZE_IN_MB = SIZE_IN_MB/1024
         MUNITS = 'G'
       End
       Else MUNITS = 'M'
     End
   End
   When SIZE_IN_MB >= 1073741824 & ,
        SIZE_IN_MB <= 17591112302592 then do
     If SIZE_IN_MB/1073741824 == TRUNC(SIZE_IN_MB/1073741824) ,
        then do
       SIZE_IN_MB = SIZE_IN_MB/1073741824
       MUNITS = 'P'
     End
     Else do
       SIZE_IN_MB = SIZE_IN_MB/1048576
       MUNITS = 'T'
     End
   End
   When SIZE_IN_MB = 17592186040320 then do
       SIZE_IN_MB = 'NOLIMIT'   /* 16384P */
       MUNITS = ''
   End
   When SIZE_IN_MB > 17592186040320 then do
       SIZE_IN_MB = '*NOLIMT'   /* >16384P  (16EB) ?? */
       MUNITS = ''
   End
   Otherwise do
     Queue ' '
     Queue 'Error in FORMAT_MEMSIZE code. Contact Mark Zelden.'
     Queue 'SIZE_IN_MB=' SIZE_IN_MB
     Queue ' '
     SIZE_IN_MB = '*ERROR*'
     MUNITS = ''
   End
End /* select */
STOR_SIZE =  SIZE_IN_MB || MUNITS
Return STOR_SIZE
 
BROWSE_ISPF:         /* Browse output if ISPF is active              */
Address ISPEXEC "CONTROL ERRORS RETURN"
Address TSO
prefix = sysvar('SYSPREF')        /* tso profile prefix              */
uid    = sysvar('SYSUID')         /* tso userid                      */
If prefix = '' then prefix = uid  /* use uid if null prefix          */
If prefix <> '' & prefix <> uid then /* different prefix than uid    */
   prefix = prefix || '.' || uid  /* use  prefix.uid                 */
ddnm1 = 'DDO'||random(1,99999)    /* choose random ddname            */
ddnm2 = 'DDP'||random(1,99999)    /* choose random ddname            */
junk = MSG('OFF')
"ALLOC FILE("||ddnm1||") UNIT(SYSALLDA) NEW TRACKS SPACE(2,1) DELETE",
      " REUSE LRECL(80) RECFM(F B) BLKSIZE(3120)"
"ALLOC FILE("||ddnm2||") UNIT(SYSALLDA) NEW TRACKS SPACE(1,1) DELETE",
      " REUSE LRECL(80) RECFM(F B) BLKSIZE(3120) DIR(1)"
junk = MSG('ON')
"Newstack"
/*************************/
/* IPLINFOP Panel source */
/*************************/
If Substr(ZENVIR,6,1) >= 4 then
  If EDITOP = 'YES' then ,
    Queue ")PANEL KEYLIST(ISRSPEC,ISR)"
  Else ,
    Queue ")PANEL KEYLIST(ISRSPBC,ISR)"
Queue ")ATTR"
Queue "  _ TYPE(INPUT)   INTENS(HIGH) COLOR(TURQ) CAPS(OFF)" ,
      "FORMAT(&MIXED)"
If EDITOP = 'YES' then ,
  Queue "  | AREA(DYNAMIC) EXTEND(ON)   SCROLL(ON) USERMOD('20')"
Else ,
  Queue "  | AREA(DYNAMIC) EXTEND(ON)   SCROLL(ON)"
Queue "  + TYPE(TEXT)    INTENS(LOW)  COLOR(BLUE)"
Queue "  @ TYPE(TEXT)    INTENS(LOW)  COLOR(TURQ)"
Queue "  % TYPE(TEXT)    INTENS(HIGH) COLOR(GREEN)"
Queue "  ! TYPE(OUTPUT)  INTENS(HIGH) COLOR(TURQ) PAD(-)"
Queue " 01 TYPE(DATAOUT) INTENS(LOW)"
Queue " 02 TYPE(DATAOUT) INTENS(HIGH)"
If EDITOP = 'YES' then do
  Queue " 03 TYPE(DATAOUT) SKIP(ON) /* FOR TEXT ENTER CMD. FIELD */"
  Queue " 04 TYPE(DATAIN)  INTENS(LOW)  CAPS(OFF) FORMAT(&MIXED)"
  Queue " 05 TYPE(DATAIN)  INTENS(HIGH) CAPS(OFF) FORMAT(&MIXED)"
  Queue " 06 TYPE(DATAIN)  INTENS(LOW)  CAPS(IN)  FORMAT(&MIXED)"
  Queue " 07 TYPE(DATAIN)  INTENS(HIGH) CAPS(IN)  FORMAT(&MIXED)"
  Queue " 08 TYPE(DATAIN)  INTENS(LOW)  FORMAT(DBCS) OUTLINE(L)"
  Queue " 09 TYPE(DATAIN)  INTENS(LOW)  FORMAT(EBCDIC) OUTLINE(L)"
  Queue " 0A TYPE(DATAIN)  INTENS(LOW)  FORMAT(&MIXED) OUTLINE(L)"
  Queue " 0D TYPE(DATAIN)  INTENS(LOW)  CAPS(IN)  FORMAT(&MIXED)" || ,
        " COLOR(BLUE)"
  Queue " 20 TYPE(DATAIN)  INTENS(LOW) CAPS(IN) FORMAT(&MIXED)"
End
Else do
  Queue " 0B TYPE(DATAOUT) INTENS(HIGH) FORMAT(DBCS)"
  Queue " 0C TYPE(DATAOUT) INTENS(HIGH) FORMAT(EBCDIC)"
  Queue " 0D TYPE(DATAOUT) INTENS(HIGH) FORMAT(&MIXED)"
  Queue " 10 TYPE(DATAOUT) INTENS(LOW)  FORMAT(DBCS)"
  Queue " 11 TYPE(DATAOUT) INTENS(LOW)  FORMAT(EBCDIC)"
  Queue " 12 TYPE(DATAOUT) INTENS(LOW)  FORMAT(&MIXED)"
End
If EDITOP = 'YES' then do
  Queue ")BODY WIDTH(&ZWIDTH) EXPAND(//)"
  Queue "@EDIT @&ZTITLE  / /  %Columns!ZCL  !ZCR  +"
End
Else do
  Queue ")BODY EXPAND(//)"
  Queue "%BROWSE  @&ZTITLE  / /  %Line!ZLINES  %Col!ZCOLUMS+"
End
Queue "%Command ===>_ZCMD / /           %Scroll ===>_Z   +"
Queue "|ZDATA ---------------/ /-------------------------|"
Queue "|                     / /                         |"
Queue "| --------------------/-/-------------------------|"
Queue ")INIT"
Queue "  .HELP = IPLINFOH"
If EDITOP = 'YES' then ,
  Queue "  .ZVARS = 'ZSCED'"
Else ,
  Queue "  .ZVARS = 'ZSCBR'"
Queue "  &ZTITLE = 'Mark''s MVS Utilities - IPLINFO'"
Queue "  &MIXED = MIX"
Queue "  IF (&ZPDMIX = N)"
Queue "   &MIXED = EBCDIC"
If EDITOP = 'YES' then do
  Queue "  VGET (ZSCED) PROFILE"
  Queue "  IF (&ZSCED = ' ')"
  Queue "   &ZSCED = 'CSR'"
End
Else do
  Queue "  VGET (ZSCBR) PROFILE"
  Queue "  IF (&ZSCBR = ' ')"
  Queue "   &ZSCBR = 'CSR'"
End
Queue ")REINIT"
Queue "  .HELP = IPLINFOH"
If EDITOP = 'YES' then ,
  Queue "  REFRESH(ZCMD,ZSCED,ZDATA,ZCL,ZCR)"
Else ,
  Queue "  REFRESH(ZCMD,ZSCBR,ZDATA,ZLINES,ZCOLUMS)"
Queue ")PROC"
Queue "  &ZCURSOR = .CURSOR"
Queue "  &ZCSROFF = .CSRPOS"
Queue "  &ZLVLINE = LVLINE(ZDATA)"
If EDITOP = 'YES' then ,
  Queue "  VPUT (ZSCED) PROFILE"
Else ,
  Queue "  VPUT (ZSCBR) PROFILE"
Queue ")END"
/*                                    */
Address ISPEXEC "LMINIT DATAID(PAN) DDNAME("ddnm2")"
Address ISPEXEC "LMOPEN DATAID("pan") OPTION(OUTPUT)"
Do queued()
   Parse pull panline
   Address ISPEXEC "LMPUT DATAID("pan") MODE(INVAR)" ,
           "DATALOC(PANLINE) DATALEN(80)"
End
Address ISPEXEC "LMMADD DATAID("pan") MEMBER(IPLINFOP)"
/* Address ISPEXEC "LMFREE DATAID("pan")" */
"Delstack"
"Newstack"
/*************************/
/* IPLINFOH Panel source */
/*************************/
If Substr(ZENVIR,6,1) >= 4 then
  Queue ")PANEL KEYLIST(ISRSPBC,ISR)"
Queue ")ATTR DEFAULT(!+_)"
Queue "  _ TYPE(INPUT)   INTENS(HIGH) COLOR(TURQ) CAPS(OFF)" ,
      "FORMAT(&MIXED)"
Queue "  + TYPE(TEXT)    INTENS(LOW)  COLOR(BLUE)"
Queue "  @ TYPE(TEXT)    INTENS(LOW)  COLOR(TURQ)"
Queue "  ! TYPE(TEXT)    INTENS(HIGH) COLOR(GREEN)"
Queue "  # AREA(SCRL)    EXTEND(ON)"
Queue ")BODY EXPAND(//)"
Queue "!HELP    @&ZTITLE  / / "
Queue "!Command ===>_ZCMD / / "
Queue "#IPLHSCR                                          "  || ,
      "                            #"
Queue ")AREA IPLHSCR"
Queue "@EXECUTION SYNTAX:!TSO %IPLINFO <option>                       "
Queue "+VALID OPTIONS ARE 'ALL', 'IPL', 'VERsion'," ||,
      " 'STOrage', 'CPU', 'IPA', 'SYMbols',"
Queue "+ 'VMAp', 'PAGe', 'SMF', " ||,
      "'SUB', 'ASId', 'LPA', 'LNKlst', 'APF' and 'SVC'"
Queue "@**+OPTIONS may be abbreviated by using 3 or more characters   "
Queue "+Examples:                                                     "
Queue "! TSO %IPLINFO        +(Display all Information)               "
Queue "! TSO %IPLINFO IPL    +(Display IPL Information)               "
Queue "! TSO %IPLINFO VER    +(Display Version Information)           "
Queue "! TSO %IPLINFO STOR   +(Display Storage Information)           "
Queue "! TSO %IPLINFO CPU    +(Display CPU Information)               "
Queue "! TSO %IPLINFO IPA    +(Display Initialization Information)    "
Queue "! TSO %IPLINFO SYM    +(Display Static System Symbols)         "
Queue "! TSO %IPLINFO VMAP   +(Display a Virtual Storage Map)         "
Queue "! TSO %IPLINFO PAGE   +(Display Page Data Set Usage",
                              "Information)"
Queue "! TSO %IPLINFO SMF    +(Display SMF Data Set Usage Information)"
Queue "! TSO %IPLINFO SUB    +(Display Subsystem Information)         "
Queue "! TSO %IPLINFO ASID   +(Display ASID Usage Information)        "
Queue "! TSO %IPLINFO LPA    +(Display LPA List Information)          "
Queue "! TSO %IPLINFO LNK    +(Display LNKLST Information)            "
Queue "! TSO %IPLINFO APF    +(Display APF List Information)          "
Queue "! TSO %IPLINFO SVC    +(Display SVC Information)               "
Queue "@&ADLINE"
Queue ")INIT"
Queue "  .HELP = ISR10000"
Queue "  &ZTITLE = 'Mark''s MVS Utilities - IPLINFO'"
Queue "  &L1 = 'Mark''s MVS Utilities -'"
Queue "  &L2 = 'http://www.mzelden.com/mvsutil.html'"
Queue "  &ADLINE  = '&L1 &L2'"
Queue "  &MIXED = MIX"
Queue "  IF (&ZPDMIX = N)"
Queue "   &MIXED = EBCDIC"
Queue ")END"
/*                                    */
Do queued()
   Parse pull panline
   Address ISPEXEC "LMPUT DATAID("pan") MODE(INVAR)" ,
           "DATALOC(PANLINE) DATALEN(80)"
End
Address ISPEXEC "LMMADD DATAID("pan") MEMBER(IPLINFOH)"
Address ISPEXEC "LMFREE DATAID("pan")"
"Delstack"
"EXECIO" Queued() "DISKW" ddnm1 "(FINIS"
zerrsm  = 'IPLINFO' LASTUPD
zerrlm  = 'IPLINFO -' OPTION 'option.' ,
          'Last updated on' LASTUPD ||'. Written by' ,
          'Mark Zelden. Mark''s MVS Utilities -' ,
          'http://www.mzelden.com/mvsutil.html'
zerralrm = 'NO'        /* msg - no alarm */
zerrhm   = 'IPLINFOH'  /* help panel */
address ISPEXEC "LIBDEF ISPPLIB LIBRARY ID("||ddnm2||") STACK"
address ISPEXEC "SETMSG MSG(ISRZ002)"
address ISPEXEC "LMINIT DATAID(TEMP) DDNAME("||ddnm1||")"
If EDITOP = 'YES' then ,
  address ISPEXEC "EDIT DATAID("||temp") PANEL(IPLINFOP)"
Else ,
  address ISPEXEC "BROWSE DATAID("||temp") PANEL(IPLINFOP)"
address ISPEXEC "LMFREE DATAID("||temp")"
address ISPEXEC "LIBDEF ISPPLIB"
junk = MSG('OFF')
"FREE FI("||ddnm1||")"
"FREE FI("||ddnm2||")"
Return
 
REXXTOD:
/* REXX */
/*                                       */
/* AUTHOR: Mark Zelden                   */
/*                                       */
/***********************************************************/
/* Convert TOD string which is units since January 1, 1990 */
/* Result is in format of YYYY.DDD HH:MM:SS.ttt            */
/*                                                         */
/* Examples:                                               */
/*   REXXTOD B92E37543F000000  -->  2003.086 05:06:06.435  */
/*   REXXTOD C653258535522000  -->  2010.205 13:23:45.154  */
/*   REXXTOD C8B8D8A516A77000  -->  2011.328 16:09:07.768  */
/***********************************************************/
Arg TODIN
 /* Numeric Digits 16 */    /* commented out, IPLINFO already higher */
TODIN  = Left(TODIN,13,0)   /* rtn can only handle 1000s of a second */
TODIN  = X2d(TODIN)         /* convert to decimal for arithmetic     */
TODIN  = TODIN %  1000
  TTT  = TODIN // 1000      /* 1000s of a second  - ".ttt"           */
TODIN  = TODIN %  1000
  SS   = TODIN // 60;       /* Seconds - "SS"                        */
TODIN  = TODIN %  60
  MM   = TODIN // 60;       /* Minutes - "MM"                        */
TODIN  = TODIN %  60
  HH   = TODIN // 24;       /* Hours   - "HH"                        */
TODIN  = TODIN %  24
 
TODIN = TODIN + 1           /* add 1 to remainder, needed for next   */
                            /* section of code taken from "RDATE"    */
 
/* Determine YYYY and DDD */
if TODIN>365 then TODIN=TODIN+1
YEARS_X4=(TODIN-1)%1461
DDD=TODIN-YEARS_X4*1461
if TODIN > 73415 then DDD = DDD +1
EXTRA_YEARS=(DDD*3-3)%1096
DDD=DDD-(EXTRA_YEARS*1096+2)%3
YYYY=YEARS_X4*4+EXTRA_YEARS+1900
 
/* Format prior to result */
DDD     = Right(DDD,3,'0')
HH      = Right(HH,2,'0')
MM      = Right(MM,2,'0')
SS      = Right(SS,2,'0')
TTT     = Right(TTT,3,'0')
 
TOD_VAL = YYYY'.'DDD  HH':'MM':'SS'.'TTT
 /* Say TOD_VAL; Exit 0 */
Return TOD_VAL
 
 
FORMAT_COMMAS:
/* REXX  - Format whole number with commas */
/*                                         */
/* AUTHOR: Mark Zelden                     */
/*                                         */
Arg WHOLENUM
 
WHOLENUM  = Strip(WHOLENUM)
COMMAVAR3 = ''
Parse var WHOLENUM COMMAVAR1
COMMAVAR1 = Reverse(COMMAVAR1)
Do while COMMAVAR1 <> ''
  Parse var COMMAVAR1 COMMAVAR2 4 COMMAVAR1
  If COMMAVAR3 = '' then COMMAVAR3 = COMMAVAR2
  Else COMMAVAR3 = COMMAVAR3','COMMAVAR2
End
FORMATTED_WHOLENUM = Reverse(COMMAVAR3)
Return FORMATTED_WHOLENUM
 
 
/* rexx */
RDATE:
/*                                       */
/* AUTHOR: Mark Zelden                   */
/*                                       */
/************************************************/
/* Convert MM DD YYYY , YYYY DDD, or NNNNN to   */
/* standard date output that includes the day   */
/* of the week and the number of days (NNNNN)   */
/* from January 1, 1900. This is not the same   */
/* as the Century date! Valid input dates range */
/* from 01/01/1900 through 12/31/2172.          */
/*                                              */
/* A parm of "TODAY" can also be passed to      */
/* the date conversion routine.                 */
/* MM DD YYYY can also be specifed as           */
/* MM/DD/YYYY or MM-DD-YYYY.                    */
/*                                              */
/* The output format is always as follows:      */
/*      MM/DD/YYYY.JJJ NNNNN WEEKDAY            */
/*                                              */
/* The above value will be put in the special   */
/* REXX variable "RESULT"                       */
/* example: CALL RDATE TODAY                    */
/* example: CALL RDATE 1996 300                 */
/* example: CALL RDATE 10 26 1996               */
/* example: CALL RDATE 10/26/1996               */
/* example: CALL RDATE 10-26-1996               */
/* example: CALL RDATE 35363                    */
/* result:  10/26/1996.300 35363 Saturday       */
/************************************************/
arg P1 P2 P3
 
If Pos('/',P1) <> 0 | Pos('-',P1) <> 0 then do
  PX =  Translate(P1,'  ','/-')
  Parse var PX P1 P2 P3
End
 
JULTBL = '000031059090120151181212243273304334'
DAY.0 = 'Sunday'
DAY.1 = 'Monday'
DAY.2 = 'Tuesday'
DAY.3 = 'Wednesday'
DAY.4 = 'Thursday'
DAY.5 = 'Friday'
DAY.6 = 'Saturday'
 
Select
  When P1 = 'TODAY' then do
    P1 = Substr(date('s'),5,2)
    P2 = Substr(date('s'),7,2)
    P3 = Substr(date('s'),1,4)
    call CONVERT_MDY
    call THE_END
  end
  When P2 = '' & P3 = '' then do
    call CONVERT_NNNNN
    call THE_END
  end
  When P3 = '' then do
    call CONVERT_JDATE
    call DOUBLE_CHECK
    call THE_END
  end
  otherwise do
    call CONVERT_MDY
    call DOUBLE_CHECK
    call THE_END
  end
end /* end select */
/* say RDATE_VAL; exit 0 */
return RDATE_VAL
/**********************************************/
/*  E N D    O F   M A I N L I N E   C O D E  */
/**********************************************/
 
CONVERT_MDY:
if P1<1 | P1>12 then do
  say 'Invalid month passed to date routine'
  exit 12
end
if P2<1 | P2>31 then do
  say 'Invalid day passed to date routine'
  exit 12
end
if (P1=4 | P1=6 | P1=9 | P1=11) & P2>30 then do
  say 'Invalid day passed to date routine'
  exit 12
end
if P3<1900 | P3>2172 then do
  say 'Invalid year passed to date routine. Must be be 1900-2172'
  exit 12
end
BASE   = Substr(JULTBL,((P1-1)*3)+1,3)
if (P3//4=0 & P3<>1900 & P3<>2100) then LEAP= 1
  else LEAP = 0
if P1 > 2 then BASE = BASE+LEAP
JJJ = BASE + P2
 
MM   = P1
DD   = P2
YYYY = P3
return
 
CONVERT_NNNNN:
if P1<1 | P1>99712 then do
  say 'Invalid date passed to date routine. NNNNN must be 1-99712'
  exit 12
end
/* Determine YYYY and JJJ */
if P1>365 then P1=P1+1
YEARS_X4=(P1-1)%1461
JJJ=P1-YEARS_X4*1461
if P1 > 73415 then JJJ = JJJ +1
EXTRA_YEARS=(JJJ*3-3)%1096
JJJ=JJJ-(EXTRA_YEARS*1096+2)%3
YYYY=YEARS_X4*4+EXTRA_YEARS+1900
P1 = YYYY ; P2 = JJJ ;  call CONVERT_JDATE
 
CONVERT_JDATE:
MATCH = 'N'
if P1<1900 | P1>2172 then do
  say 'Invalid year passed to date routine. Must be be 1900-2172'
  exit 12
end
if P2<1 | P2>366 then do
  say 'Invalid Julian date passed to date routine'
  exit 12
end
if (P1//4=0 & P1<>1900 & P1<>2100) then LEAP= 1
  else LEAP = 0
ADJ1 = 0
ADJ2 = 0
Do MM = 1 to 11
   VAL1 = Substr(JULTBL,((MM-1)*3)+1,3)
   VAL2 = Substr(JULTBL,((MM-1)*3)+4,3)
   if MM >=2 then ADJ2 = LEAP
   if MM >=3 then ADJ1 = LEAP
   if P2 > VAL1+ADJ1 & P2 <= VAL2+ADJ2 then do
        DD = P2-VAL1-ADJ1
        MATCH = 'Y'
        leave
   end
end
if MATCH <> 'Y' then do
    MM = 12
    DD = P2-334-LEAP
end
 
YYYY = P1
JJJ  = P2
return
 
DOUBLE_CHECK:
if MM = 2 then do
   if DD > 28 & LEAP = 0 then do
     say 'Invalid day passed to date routine'
     exit 12
   end
   if DD > 29 & LEAP = 1 then do
     say 'Invalid day passed to date routine'
     exit 12
   end
end
if LEAP = 0 & JJJ > 365 then do
  say 'Invalid Julian date passed to date routine'
  exit 12
end
return
 
THE_END:
YR_1900 = YYYY-1900
NNNNN = (YR_1900*365) +(YR_1900+3)%4 + JJJ
if YYYY > 1900 then NNNNN = NNNNN-1
if YYYY > 2100 then NNNNN = NNNNN-1
INDEX   = NNNNN//7  /* index to DAY stem */
WEEKDAY =  DAY.INDEX
 
DD      = Right(DD,2,'0')
MM      = Right(MM,2,'0')
YYYY    = Strip(YYYY)
NNNNN   = Right(NNNNN,5,'0')
JJJ     = Right(JJJ,3,'0')
 
RDATE_VAL = MM||'/'||DD||'/'||YYYY||'.'||JJJ||' '||NNNNN||' '||WEEKDAY
return
 
SIG_ALL:
SIGTYPE = Condition('C')                   /* condition name         */
If SIGTYPE   = 'SYNTAX' then ,             /* SYNTAX error ?         */
  SIGINFO    = Errortext(RC)               /* rexx error message     */
Else SIGINFO = Condition('D')              /* condition description  */
SIGLINE      = Strip(Sourceline(SIGL))     /* error source code      */
Say 'SIGNAL -' SIGTYPE 'ERROR:' SIGINFO ,  /* display the error info */
    'on source line number' SIGL':'        /*   and line number      */
Say '"'SIGLINE'"'                          /* error source code      */
"Delstack"                                 /* delete data stack      */
Exit 16                                    /* exit RC=16             */
 
