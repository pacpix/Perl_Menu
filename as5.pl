#!/usr/bin/perl

use feature "switch";  #line needed for given-when statement
use File::Copy qw(copy);  #line needed to copy files for backup
use File::Copy::Recursive qw(dircopy); #line needed to copy directories for backup

do #Main loop for menu
{
    print "a. Append line numbers to a text file.\n";
    print "b. Remove line numbers from a text file.\n";
    print "c. Remove any and all underscores from a given file name.\n";
    print "d. Backup files and directories into a special sub-directory called \" .backup \".\n";
    print "e. Exit.\n";
    print "Please select an option: ";
    chomp($option = <stdin>); #stores user option and removes new line

    $tempfile = "temp.txt";  #used to temporarily store file data throughout program
    given ($option)
    {
        when ('a')  #add lines option
        {
            print "Please enter a file name: ";
            chomp($file = <stdin>);
            if ( -e $file )
            {
                open my $out, "+>", "$tempfile";
                open my $in, "<", "$file";

                my $index = 1;

                while (<$in>) #while loop adds numbers to line and outputs them to new file
                {
                    chomp;
                    print {$out} $index."."." ".$_."\n";
                    $index++;
                }
                close($out);
                close($in);
                rename $tempfile, $file; #Replaces old file with the file with line numbers
            }
            else
            {
                print "File does not exist";
            }
        }
        when ('b') #remove lines option
        {
            print "Please enter a file name: ";
            chomp($file = <stdin>);
            if ( -e $file )
            {
                open my $out, "+>", "$tempfile";
                open my $in,  "<", "$file";

                while (<$in>) #while loop removes line numbers and outputs them to new file
                {
                    s/^[0-9]*\..//g;
                    print {$out} $_;
                }
                close($out);
                close($in);
                rename $tempfile, $file; #Replaces old file with the file without line numbers
            }
            else
            {
                print "File does not exist";
            }
        }
        when ('c') #remove filename underscores option
        {
            print "Please enter a file name: ";
            chomp($file = <stdin>);
            if ( -e $file )
            {
                $newfile = $file;
                $newfile =~ s/_//g;  #regex replaces _ with nothing
                rename $file, $newfile;  #Replaces the filename
            }
            else
            {
                print "File does not exist.";
            }
        }
        when ('d') #Backup option
        {
            $backupdir = ".backup"; #backup directory name
            print "Enter 1 to backup a directory or 2 to backup a file: ";
            chomp($option2 = <stdin>); #commands are different for directory vs file so need user input
            if ($option2 == "1")
            {
                print "Please enter a directory name: ";
                chomp($directory = <stdin>);
                if ( -d $backupdir ) #checks to see if .backup already exists
                {
                    if ( -d $directory ) #checks to see if user directory actually exists
                    {
                        dircopy("$directory/*", $backupdir); #copies directory
                    }
                    else
                    {
                        print "Directory does not exist\n";
                    }
                }
                else
                {
                    print "Backup folder was not found, thus it has been created\n";
                    mkdir $backupdir; #makes .backup directory if it does not exist
                    if ( -d $directory) #checks to see if user directory actually exists
                    {
                        dircopy("$directory/*", $backupdir); #copies directory
                    }
                    else
                    {
                        print "Directory does not exist\n";
                    }
                }
            }
            elsif ($option2 == "2")
            {
                print "Please enter a file name: ";
                chomp($file = <stdin>);
                if ( -d $backupdir )
                {
                    if ( -e $file )
                    {
                        copy $file, $backupdir;
                    }
                    else
                    {
                        print "File does not exist\n";
                    }
                }
                else
                {
                    print "Backup folder was not found, thus it has been created\n";
                    mkdir $backupdir;
                    if ( -e $file )
                    {
                        copy $file, $backupdir;
                    }
                    else
                    {
                        print "File does not exist\n";
                    }
                }
            }
            else
            {
                print "Invalid selection\n";
            }

        }
        when ('e') #Exit option
        {
            die "Thank you. Exiting now...\n";
        }
    }

} while (1)
