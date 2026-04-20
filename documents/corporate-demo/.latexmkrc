$pdf_mode = 1;
$bibtex_use = 0;
add_cus_dep('bcf', 'bbl', 0, 'run_biber');
sub run_biber {
    return system("biber \"$_[0]\"");
}
