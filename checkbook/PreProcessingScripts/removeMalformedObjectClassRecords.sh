#!/bin/awk -f
{

        line = $0;
        delimiter="|";
        no_of_attributes = split(line,attributes,delimiter);
        echo $no_of_attributes
        if(no_of_attributes==16){
                print $0 >> "goodfile.txt"
        } else
        {
                print "Line Number:" NR " " $0 >> "badfile.txt"
        }
}

