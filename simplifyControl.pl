#!/bin/perl
# print a control file for OPS
$usage = "usage: '$0 [-x] [FS_ROOT]'
Options:
\t-x\tcreate the two example files

Arguments:
FS_ROOT is the root to your file system; eg
\t/mnt/\t\tLinux
\t/drives/d/\tMobaXterm
\t/cygdrive/d/\tCygwin
\tC:\\\t\tWindows
The last character must be / or \\
If FS_ROOT is not given it will be tried from the environment
From the environment also get OPS_STEM (e.g. 'Applics\OPS-Pro_2020')
Probably you'd want to edit $0 or its output to your own needs\n";

$base = shift;
if ( $base eq '-x' ) {
   $examples = 1;
   undef $base;
}
$base = $base || shift || $ENV{ FS_ROOT } || die $usage;

# The file system must exist
-d $base  || die "$base is not a directory\n$usage";
$dirsign = substr( $base, -1 );
$dirsign =~ /[\/\\]/ || die "last character in $base is not / or \\\n$usage";

# get the stem from the environment
$stem = $ENV{ OPS_STEM } || die "OPS_STEM not in the environment; $usage";

# assignments; variables capitalised if to be used in the control file as is
$PROJECT	= "example2";
$RUNID		= "${PROJECT}_MyRun";

# after the following assignments, the /-sign will be replaced as needed

$DATADIR	= "$base$stem/Data/";
$EMFILE		= "$base$stem/examples/$PROJECT.brn";
$RCPFILE	= "$base$stem/examples/$PROJECT.rcp";
$USPSDFILE	= "$base$stem/examples/$PROJECT.psd";
$Z0FILE		= "${DATADIR}z0_jr_250_lgn7.ops";
$LUFILE		= "${DATADIR}lu_250_lgn7.ops";
$MTFILE		= "$base$stem/Meteo/m095104c.*";
$PLTFILE	= "$base$stem/Output/$RUNID.plt";
$PRNFILE	= "$base$stem/Output/$RUNID.lpt";

# replace the /-sign
foreach my $name ( qw/ base stem DATADIR EMFILE RCPFILE Z0FILE LUFILE MTFILE PLTFILE PRNFILE / ) {
   $$name =~ s/\//$dirsign/g;
}

-d $DATADIR || die "$DATADIR is not a directory\n";
foreach my $name ( qw/ EMFILE Z0FILE LUFILE / ) {
   -s $$name || "die $$name does not exist or has 0 size\n";
}

$text2 = <<EOD;
*-----------------------directory layer---------------------------------*
DATADIR        $DATADIR
*-----------------------identification layer----------------------------*
PROJECT        $PROJECT
RUNID          $RUNID
YEAR           2020
*-----------------------substance layer---------------------------------*
COMPCODE       22
COMPNAME       Pb (lead) - aer.
MOLWEIGHT      207.2
PHASE          0
LOSS           1
DDSPECTYPE
DDPARVALUE
WDSPECTYPE
WDPARVALUE
DIFFCOEFF
WASHOUT
CONVRATE
LDCONVRATE
*-----------------------emission layer----------------------------------*
EMFILE         $EMFILE
USDVEFILE      
USPSDFILE      $USPSDFILE
EMCORFAC       1.0
TARGETGROUP    0
COUNTRY        0
*-----------------------receptor layer----------------------------------*
RECEPTYPE      2
XCENTER
YCENTER
NCOLS
NROWS
RESO
OUTER
RCPFILE        $RCPFILE
*-----------------------meteo & surface char layer----------------------*
ROUGHNESS      0.0
Z0FILE         $Z0FILE
LUFILE         $LUFILE
METEOTYPE      0
MTFILE         $MTFILE
*-----------------------output layer------------------------------------*
DEPUNIT        3
PLTFILE        $PLTFILE
PRNFILE        $PRNFILE
INCLUDE        1
GUIMADE        1
EOD

unless ( $examples ) {
   print $text2;
   exit;
}
$ctr = "$PROJECT.ctr";
open ( CTR, ">$ctr") or die "cannot open $ctr: $!\n";
print CTR $text2;
close CTR;

#________________________________________________________________________
# The remainder of this schript is a repetition but for example1
$PROJECT	= "example1";
$RUNID		= "${PROJECT}_MyRun";

# after the following assignments, the /-sign will be replaced as needed

$DATADIR	= "$base$stem/Data/";
$EMFILE		= "$base$stem/examples/$PROJECT.brn";
$PLTFILE	= "$base$stem/Output/$RUNID.plt";
$PRNFILE	= "$base$stem/Output/$RUNID.lpt";

# replace the /-sign
foreach my $name ( qw/ base stem DATADIR EMFILE RCPFILE Z0FILE LUFILE MTFILE PLTFILE PRNFILE / ) {
   $$name =~ s/\//$dirsign/g;
}

$ctr = "$PROJECT.ctr";
open ( CTR, ">$ctr") or die "cannot open $ctr: $!\n";
print CTR <<EOD;
*-----------------------directory layer---------------------------------*
DATADIR        $DATADIR
*-----------------------identification layer----------------------------*
PROJECT        $PROJECT
RUNID          $RUNID
YEAR           2020
*-----------------------substance layer---------------------------------*
COMPCODE       4
COMPNAME       HF (fluorine)- gas.
MOLWEIGHT      20.0
PHASE          1
LOSS           1
DDSPECTYPE     2
DDPARVALUE     13
WDSPECTYPE     3
WDPARVALUE     1000000
DIFFCOEFF      .230
WASHOUT        0
CONVRATE       .0000
LDCONVRATE     .0000
*-----------------------emission layer----------------------------------*
EMFILE         $EMFILE
USDVEFILE
USPSDFILE
EMCORFAC       1.0
TARGETGROUP    0
COUNTRY        0
*-----------------------receptor layer----------------------------------*
RECEPTYPE      1
XCENTER        128730
YCENTER        432028
NCOLS          15
NROWS          15
RESO           500
OUTER
RCPFILE
*-----------------------meteo & surface char layer----------------------*
ROUGHNESS      0.25
Z0FILE
LUFILE
METEOTYPE      0
MTFILE         $MTFILE
*-----------------------output layer------------------------------------*
DEPUNIT        3
PLTFILE        $PLTFILE
PRNFILE        $PRNFILE
INCLUDE        1
GUIMADE        1
EOD
close CTR;

