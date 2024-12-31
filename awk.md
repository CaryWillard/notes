# AWK

## Syntax

BEGIN {awk-commands}        # Optional
BEGINFILE {awk-commands}    # Optional. Run before each file
/pattern/ {awk-commands}    # Body block. Pattern is an optional regex
ENDFILE {awk-commands}      # Optional. Run after each file
END {awk-commands}          # Optional

### Flags overview

#### -f

Run awk comands from a script file (.awk)

#### -F

Field separator

#### -v

Pass a variable

#### --dump-vars\[=file\]

Dump vars to `awkvars.out`

#### --lint\[=fatal\]

Enables checking of non-portable or dubious constructs. The `fatal` arg treats warnings as errors

#### -p\[prof-file\], --profile\[=prof-file\]

- Start  a profiling session, and send the profiling data to prof-file
- The default is `awkprof.out`
- The profile contains execution counts of each statement in the program in the left margin and function call counts for each user-defined function
- This option implies --no-optimize

#### -o\[file\], --pretty-print\[=file\]

- Output  a pretty printed version of the program to file.
- If no file is provided, gawk uses a file named `awkprof.out` in the current directory.
- This option implies --no-optimize.

### Vars overview

#### RS

Record separator. Defaults to '\n'. If set to the null string, records are separated by blank lines

#### FS

Field separator. If FS is a single character, fields are separated by that character. If FS is the null string, then each individual character becomes a separate field. Otherwise, FS is expected to be a full regular expression. In the special case that FS is a single space, fields are separated by runs of spaces and/or tabs and/or newlines.

#### OFS

Output field separator.

NOTE: The value of IGNORECASE also affects how fields are split when FS is a regular expression and how records are separated when RS is a regular expression.

#### FIELDWIDTHS

A space separated list of numbers describing the length of each field. If this variable is set, AWK treats _every_ field as fixed-width. Each field width may optionally be preceded by a colon-separated value specifying the number of characters to skip before the field starts. E.g.: `4 1:4` to parse `cats dogs`

#### FPAT

Field pattern. A regex that describes the text of the fields themselves, everything else is discarded

#### $0

The entire record (with leading and trailing whitespace)

#### $1, $2, etc

Individual fields.

#### $NF

Number of fields. Set to the number of fields in the input record.

### Functions overview

#### ~, !~

Operators for regex matching and not matching. E.g.: `awk '$0 ~ 9' marks.txt` finds all records with 9s

#### length()

Gets the length of a field, e.g.:

``` bash
# Print lines that are longer than 18 characters
awk 'length($0) > 18' marks.txt
```

#### close()

Close file, pipe or coprocess. The optional how should only be used when closing one end of a two-way pipe to a coprocess. It must be a string value, either "to" or "from".

``` awk
BEGIN {
   cmd = "tr [a-z] [A-Z]"
   print "hello, world !!!" |& cmd
   
   close(cmd, "to") # Finishes communication to tr
   cmd |& getline out
   print out;
   
   close(cmd); # Finishes communication reading from tr
}
```

#### getline

Set $0 from the next input record; set NF, NR, FNR, RT.

#### getline <file

Set $0 from the next record of file; set NF, RT.

#### getline var

Set var from the next input record; set NR, FNR, RT.

#### getline var <file

Set var from the next record of file; set RT.

#### command | getline [var]

Run command, piping the output either into $0 or var, as above, and RT.

#### command |& getline [var]

Run command as a coprocess piping the output either into $0 or var, as above, and RT. Coprocesses are a gawk extension. (The command can also be a socket. See the subsection Special File Names, in the man page.)

#### next

Stop  processing the current input record. Read the next input record and start processing over with the first pattern in the AWK program. Upon reaching the end of the input data, execute any END rule(s).

#### nextfile

Stop processing the current input file. The next input record read comes from the next input file. Update FILENAME and ARGIND, reset FNR to 1, and start processing over with the first pattern in the AWK program. Upon reaching the end of the input data, execute any ENDFILE and END rule(s).

#### print

Print the current record. The output record is terminated with the value of ORS.

#### print expr-list

Print expressions. Each expression is separated by the value of OFS. The output record is terminated with the value of ORS.

#### print expr-list >file

Print expressions on file. Each expression is separated by the value of OFS. The output record is terminated with the value of ORS.

#### printf fmt, expr-list

Format and print.  See The printf Statement, in the man page.

#### printf fmt, expr-list >file

Format and print on file.

#### system(cmd-line)

Execute the command cmd-line, and return the exit status. (This may not be available on non-POSIX systems.)

```
# This prints the output of ls -l but does not process it inside AWK
awk 'BEGIN { system("ls -l") }'
```

## Examples

Given this file, `marks.txt`

```
1)  Amit    Physics  80
2)  Rahul   Maths    90
3)  Shyam   Biology  87
4)  Kedar   English  85
5)  Hari    History  89
```

### Insert a header before the file

``` bash
awk 'BEGIN{printf "Sr No\tName\tSub\tMarks\n"} {print}' marks.txt

# Output
Sr No   Name    Sub     Marks
1)  Amit    Physics  80
2)  Rahul   Maths    90
3)  Shyam   Biology  87
4)  Kedar   English  85
5)  Hari    History  89
```

### Using an AWK script file (-f)

``` awk
# command.awk
{print}
```

``` bash
awk -f command.awk marks.txt
```

### Passing in a variable (-v)

``` bash
awk -v name=Jerry 'BEGIN{printf "Name = %s\n", name}'
```

### How to dump awk vars to a file (--dump-variables\[=file\])

Prints a sorted list of global variables and their final values to file. The default file is `awkvars.out`.

``` bash
awk --dump-variables ''
```

### Printing a column or field

``` bash
awk '{print $3 "\t" $4}' marks.txt

# Output
Physics   80
Maths     90
Biology   87
English   85
History   89
```

### Count lines that match a pattern

``` bash
# Counts lines that contain 'a'
awk '/a/{++cnt} END {print "Count =", cnt}' marks.txt
```
