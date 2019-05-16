/*
David Turner

    Print stats found from an input file. this finds
    the number of pos/neg integers and pos/neg reals.
    this counts number of words, lines and prints the
    line numbers each word was found on.
*/

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define MAXTOKENS 1000

struct Node {
    char *name;
    int *lines;
    int length;
} tokens[MAXTOKENS], temp;

int token_count = 0;

void sortData(struct Node idt[], int *num);
void insertId(char* strlpo, int l);
void compareLongest(char*);

int longest_word = 0; /* stores the number of chars in the current largest word. */
int line_count = 1;

int number_words = 0; /*increment when a valid word is encountered.*/

char *Word; /* Stores the string of the current longest word. */

int NumberPositive = 0;/* counter for the number of pos ints. */
int NumberNegative = 0;/* counter for the number of neg ints. */
int NumberPosReal = 0;/* counter for the number of pos real numbers. */
int NumberNegReal = 0;/* counter for the number of neg real numbers.*/

%}
/*
[.][a-zA-Z]      ;
   words are seperated by a space, not a { . }
   this prevents things like { hello.pld }  as
   counting

[^a-zA-Z0-9_]+   ;
   words should not contain numbers.

[0-9]+           ;
    ignore any numbers.

[a-zA-Z]*      {number_words++;}
    Just alpha chars are a match. the word
    counter is incremented. this does not
    check any dictionaries for words, this
    just assumes a continious string of chars
    is a word.

[a-zA-Z]+        Compare(yytext);
   These are the valid word strings. send the
   string into the function to be compared with
   the current largest.

.
    Catch unknowns.
*/

%option noyywrap
%option nounput
%x comment
%s stringline
%option yylineno
%%


\+?[0-9]+             {NumberPositive++;}
-[0-9]+               {NumberNegative++;}
\+?[0-9]*\.[0-9]+     {NumberPosReal++;}
-[0-9]*\.[0-9]+       {NumberNegReal++;}
[*]?[a-zA-Z]+     {compareLongest(yytext), insertId(yytext, yylineno), number_words++;}
[a-zA-Z]*             {number_words++;}

[.][a-zA-Z]      ;
[^a-zA-Z0-9_]+   ;
%%


int main(void) {
    yylex();
    printf("\n\t_____Break-down of File Info_____\n\n");

    printf("\tWords in file: %d, Number of lines: %d.\n", number_words, line_count);
    printf("\tLongest Word found: %s, with length %d.\n", Word, longest_word);

    printf("\tPositive Integers: %d, Positive Real Numbers: %d.\n", NumberPositive, NumberPosReal);
    printf("\tNegative Integers: %d, Negative Real Numbers: %d.\n", NumberNegative, NumberNegReal);

    printf("\tNumber of Tokens: %d\n\n", token_count);
    printf("\t%*s:%*s:", longest_word, "Token", longest_word + 2, "Found On");
    printf("\n\t_____________________\n");

    sortData(tokens, &token_count);
    int e;
    int u;
      for (e = 0; e < token_count; e++) {
          printf("\t%*s:  ",longest_word, tokens[e].name);
          if (tokens[e].length == 1) {
              printf("%d.\n", tokens[e].lines[0]);
          }
          else if (tokens[e].length == 2) {
              printf("%d, %d.\n", tokens[e].lines[0], tokens[e].lines[1]);
          }
          else if (tokens[e].length == 3) {
              printf("%d, %d, %d.\n", tokens[e].lines[0], tokens[e].lines[1], tokens[e].lines[2]);
          }
          else if (tokens[e].length > 3) {
              for (u = 0; u <= tokens[e].length -2 ; ++u) {
                  printf("%d, ", tokens[e].lines[u]);
              }
              for (u = tokens[e].length - 2; u < tokens[e].length - 1; ++u) {
                  printf("%d.", tokens[e].lines[u]);
              }
              printf("\n");
          }

      }

    return 0;
}


void compareLongest(char* str) {
    if (strlen(str) > longest_word) {
        longest_word = strlen(str);
        Word = (char*)realloc(Word, longest_word + 1 );
        strcpy(Word, str);
    }
}

void insertId(char* str, int line_num_yylineno) {
    line_count = line_num_yylineno;

    int x;
    for (x = 0; x < token_count; x++) {

        if (strcmp(str, tokens[x].name) == 0) {

            tokens[x].lines = realloc(tokens[x].lines, sizeof(int) * (tokens[x].length + 1 ));
            tokens[x].lines[tokens[x].length] = line_count;

            tokens[x].length++;

            return;
        }

    }

    tokens[token_count].name = strdup(str);
    tokens[token_count].lines = realloc(tokens[token_count].lines, sizeof(int) * (tokens[x].length + 1));

    tokens[token_count].lines[0] = line_count;

    tokens[token_count].length=1;

    token_count++;
}

void sortData(struct Node idt[], int *num) {
    int i;
    int moved;

    do {
        moved = 0;
        for (i = 0; i < (*num) - 1; i++) {
            if (strcmp(idt[i].name, idt[i+1].name) > 0) {
                memcpy(&temp, idt + i, sizeof(struct Node));
                memcpy(idt + i, idt + i + 1, sizeof(struct Node));
                memcpy(idt + i + 1, &temp, sizeof(struct Node));
                moved = 1;
            }
        }
    } while (moved != 0);
}
