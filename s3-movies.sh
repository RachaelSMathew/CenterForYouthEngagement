#!/bin/sh

#  s3-movies.sh
#  AppBook
#
#  Created by Rachael Mathew on 12/16/20.
#  Copyright © 2020 Project RAISE. All rights reserved.

#no arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

#argument is ./s3-movies.sh push
if [[ "$1" == "push" ]]; && [[ "$0" == "./s3-movies.sh" ]]; then
    if [ $# -eq 2 ]
      then
        #creates an array of all the non-empty files in the directory
        declare -a arr = (find -maxdepth 1 -size +0)
        #for loop that traverses through list of non empty files
        for i in "${arr[@]}"
        do
           s3 sync ~/Appbook/Media/Movies/$i s3://raise-movie-appbook
        done
    fi
fi

#argument is ./s3-movies.sh pull
if [[ "$1" == "pull" ]]; && [[ "$0" == "./s3-movies.sh" ]]; then
    if [ $# -eq 2 ]
      then
        aws s3 sync ~/Appbook/Media/Movies s3://raise-movie-appbook
    fi
    if [ $# -eq 3 ]
      then
        
        ##argument is ./s3-movies.sh push -lite
        if [[ "$2" == "—lite" ]]
          then
            declare -a s3_list_movies = (`aws s3 ls s3://raise-movie-appbook | awk '{print $4}'`)
            
            for movie in "${s3_list_movies[@]}"
                local_movie_path = ../Appbook/Media/Movies/$movie
                if test -f "$local_movie_path"; then
                   continue # already have movie
               else
                   echo "Creating $movie"
                   touch "$local_movie_path".mp4 # quotes ensure spaces are escaped
               fi
            done
            
        fi
    fi
fi
