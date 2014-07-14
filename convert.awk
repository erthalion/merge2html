BEGIN {
    first = 0;
    second = 0;
}
{
    if ($0 ~ /<<<<<<</) { 
        print_header = 1
        first = 1;
    } 

    if (first == 1 || second == 1) {
        print $0
    }

    if (print_header == 1) {
        print "\n"
        print "\n"
        print FILENAME ":" NR;
        print "\n"
    }

    if ($0 ~ /=======/) { 
        first = 0;
        second = 1;
    } 
    if ($0 ~ />>>>>>>/) { 
        second = 0;
    } 

    print_header = 0;
}
