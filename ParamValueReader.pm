#!/usr/local/bin/perl
package Config::ParamValueReader;
###################################################################
#  Chad Granum                                                    #
#                                                                 #
#  http://sourceforge.net/users/exodist/                          #
#                                                                 #
# Contact Info:                                                   #
#  exodist@yifan.net                                              #
#  (530) 583-2746                                                 #
#  ICQ: 14536019                                                  #
#  AIM, MSN, Yahoo: Exodist7                                      #
#  Jabber: Exodist@Jabber.com                                     #
###################################################################

#This package contains meathods for reading a basic config file into a hash.
#config files prefix ';' for comments.
#One config option per line, format: option = value OR option=value, values can be comma seperated to denote an array of values.
$VERSION = '0.1';
use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(ReadConfig);

#-----Declare Functions----
sub ReadConfig($$);

#-----Logic-----

#Opens a config file and reads the information into a hash
#Param 0, path to config file
#Param 1, reference to hash.
sub ReadConfig($$)
{
    my ($FileName, $OutHash) = @_; #Get Parameters
    my $Option; #Hold an option once found
    my $Value;
    my @Values; #Hold an array of values if they are found
    open(CONFIGFILE, "$FileName") || die("\nError opening config file!\n$!\n"); #Open the config file for reading or die trying
    while(<CONFIGFILE>) #While lines still remain in the file
    {
        chomp($_); #Remove the newline from the end of each line
        next if ((/^;/) || (!$_)); #Next iteration if line is only a comment or empty.
        if(/;.*/) #If there is a comment at the end of the line
        {
            $_ = $` #Strip the comment off the end
        }
        if(/ *= */) #If there is an equals sign with optional space on eather side
        {
            ($Option = $`) =~ s/^ +//; #The information on the left of the equals sign is recognised as the option, strip any leading spaces
            ($Value = $') =~ s/ +$//; #The information on the right of the equals sign is recognised as the value, strip any trailing spaces
            if ($Value =~ m/,/) #If the value is acutally a comma seperated set of values
            {
                @Values = split(/ *, */,$Value); #Make an array out fo the values
                foreach my $I (@Values)
                {
                    if ($I =~ m/^".*"$/) #If the value is enclosed in quotes
                    {
                        $I =~ s/^"//; #Remove the quote from the beginning
                        $I =~ s/"$//; #Remove the quote from the end
                    }
                }
                $OutHash->{$Option} = [@Values]; #Place the array inside the hash for the proper option as the value
            }
            else #If the value is not a comma seperated set of values
            {
                if ($Value =~ m/^".*"$/) #If the value is enclosed in quotes
                {
                        $Value =~ s/^"//; #Remove the quote from the beginning
                        $Value =~ s/"$//; #Remove the quote from the end
                }
                $OutHash->{$Option} = [($Value)]; #Set the value to the option in the hash
            }
        }
        else #If there is no equals sign
        {
            $OutHash->{$_} = [(1)]; #Recognise the option as standalone (boolean) and set it to 1 (true/on)
        }
    }
    close(CONFIGFILE); #Close the config file.
}

1;