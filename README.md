# ArchivesSpace Container Checker

### What is it?

This is some utility scripts that can be used to check for possible issues with data conversion to the 
new top container model. 

There are two SQL script ( container.sql and top_container.sql ). These both output CSV files that have
the associated accessions, resources, archival objects, containers, and locations that are associated to
an instance. Since instances do not change in the top_container conversion, these CSV files should be 
identical. In reality, this will not likely be the case, since there are some changes to the data that 
will happen.

A good way to compare CSV files is to use the [Daff](https://github.com/paulfitz/daff) library. 

There is a bash script ( cc.sh ) that will run the SQL scripts against the database, generate CSV files, run daff 
against the CSV files, then run daff against the CSV diff to generate a HTML file that has a table that highlights the 
changes. Sorry, this script can only be run on Linux/OS X only. You also must install the JavaScript version of Daff ( npm install daff -g  )( require Nodejs )  . 
To run it, pass in your MySQL user name, password, and DB name:

```
$ ./cc.sh root thepassword archivesspace
```

You should see a CSV and HTML file outputs with your data.

Windows people can still run the SQL scripts, generate CSV files ( you might
have to modify the OUTFILE locations ), and use Daff ( or some other tool ) to
generate a diff.


Let us know what you think.
Good luck!
