#!/bin/bash

display_usage() {
    echo "new_blog_post <title>"
}

if [ $# -ne 1 ]
then
	display_usage
	exit
fi

title=$1

modified="$(date +"%Y-%m-%d %H:%M:%S %z")"
filename_date="$(date +"%Y-%m-%d")"
lowercase_title="$(echo "$title" | tr '[:upper:]' '[:lower:]')"
filename_title=${lowercase_title// /-}
filename="$filename_date-$filename_title.md"
directory="$(git rev-parse --show-toplevel)"
full_filename="$directory/_posts/blog/$filename"

echo "---" >> $full_filename
echo "layout: post" >> $full_filename
echo "title: \"$title\"" >> $full_filename
echo 'excerpt: "This is the excerpt for your new post"' >> $full_filename
echo "categories: blog" >> $full_filename
echo "tags: [sample-post, readability, test]" >> $full_filename
echo "author: charles_chen" >> $full_filename
echo "comments: true" >> $full_filename
echo "share: true" >> $full_filename
echo "modified: $modified" >> $full_filename
echo "#image:" >> $full_filename
echo "#  feature: " >> $full_filename
echo "#  credit: " >> $full_filename
echo "#  creditlink: " >> $full_filename
echo "---" >> $full_filename
echo >> $full_filename
echo "Post your content here" >> $full_filename