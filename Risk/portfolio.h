#ifndef PORTFOLIO_H
#define PORTFOLIO_H
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "lib.h"

#define RECORDMAX 512

typedef struct security {
    char symbol[SYMBOLMAX];
    float price;
    float target;
} Security;

typedef struct portfoliorecord{
    Security asset;
    unsigned int shares;
} Record;

typedef struct portfolio {
    size_t portsize;
    Record records [RECORDMAX];
} Portfolio;

double valueportfolio (struct portfolio *port);

#endif  /*PORTFOLIO_H*/
