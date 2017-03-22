#$pdflatex = 'xelatex -synctex=1 %O %S';
$pdf_mode = 1;

add_cus_dep('glo', 'gls', 0, 'makeindex');
#add_cus_dep('glo2', 'gls2', 0, 'makeglossaries');
#add_cus_dep('acn', 'acr', 0, 'makeglossaries');
#add_cus_dep('slo', 'sls', 0, 'makeglossaries');

sub makeglossaries{
    system( "makeglossaries \"$_[0]\"" );
}

sub makeindex{
  system( "makeindex -s gglo.ist -o \"$_[0].gls\" \"$_[0].glo\"" );
}

push(@generated_exts, qw(glo gls ins hd sty));

$makeindex = "makeindex -s gind.ist %O -o %D %S";
