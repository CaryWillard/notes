# Bash

## Sort command output after a header line

``` bash
CMD | tee >/dev/null >(head -n 1) >(tail -n +2 | sort)
```

## Replace bash vars in a file

``` bash
cat file.txt | envsubst new-file.txt
```

## List open files: lsof


## Output redirection

``` bash
# Output redirection
# Replaces stdout with file
echo foo > file
# Same as
echo foo 1> file

# Input redirection
# Replaces stdin with file
command < file

# Pipe: direct stdout to stdin on the next command

# Duplicating file descriptor
# Redirect both stderr and stdout to stdout
# "Copy whatever file descriptor 1 contains into file descriptor 2"
# Syntax is "target>&source"
command 2>&1 | less

# Note: bash reads file redirects left-to-right and applies changes in that order
# ERROR this does NOT write stderr and stdout to a file
command 2>&1 > file
# Why?
# 2>&1: duplicate file descriptor 1 to file descriptor 2.
# If both were pointing to /dev/pts/5, the terminal, then *nothing will change*
# Note: "pts" stands for "pseudo terminal"
# >: write file descriptor 1 to a file

# Instead
>file 2>&1

```
