# Lex Parser in LEX/C.

This is an implementation of a lex parser designed to count several stats found from an input file. This program counts the number of positive and negative integers, positive and negative real numbers, as well as the number of words. In addition to this, this program keeps a hash map of the line number each word was found on and prints that data to the user.

i.e.
           Token:  Found On:
        _____________________
        Berkeley:  1.
            argc:  4, 5, 10, 12, 15, 15.
            ...

## What This Is

This is an implementation of a Lex parser designed to demonstrate knowledge of regex.

### Running

Unix users need only proceed with the following commands in your terminal:

```
$ ./run.sh
```

Windows users will need to compile themselves. Simply run the executable after compilation. I use gcc. There are no crazy libraries here only stdlib, string, and stdio.

### Manifest


```
makefile
```
Compilation instructions for users machines.


```
run.sh
```

Setup utility for (\*)nix users.

```
lexparse.l
```
Parser rules and function implementations. Everything is in here.

```
in.c
```

Test file for input. C code example.


## Authors

* **David P. Turner** - https://github.com/dturner1189
