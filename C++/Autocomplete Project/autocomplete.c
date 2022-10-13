#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "autocomplete.h"

int compare1(const void * a, const void * b){
    char * str1;
    char * str2;
    str1 = (*(struct term *) a).term;
    str2 = (*(struct term *) b).term;
   
    return strcmp (str1, str2);  
}

int compare2(const void * a, const void * b){
    double weight1;
    double weight2;
    weight1 = (*(struct term *) a).weight;
    weight2 = (*(struct term *) b).weight;

    if (weight1 == weight2){
        return 0;
    }

    if (weight1 > weight2){
        return -1;
    }

    if (weight1 < weight2){
        return 1;
    }

return 0;    
}


int check_match(char *substring, char *word){
    int len = strlen(substring);
    if (len > strlen(word)){
        return 0;
    }

    for(int i = 0; i < len; i++){
        if (substring[i] != word[i]){
            return 0;
        }
    }
    return 1;
}



void read_in_terms(struct term **terms, int *pnterms, char *filename){
    char line[300];
    int num_terms;
    char * split_line;
    double w;
    struct term * new_variable;
   
    FILE *fp = fopen(filename, "r");
    fgets(line, sizeof(line), fp);  
    num_terms = atoi(line);
    new_variable = (struct term *) malloc((num_terms) * sizeof(struct term));
 
    for(int i = 0; i < num_terms; i++){  
        fgets(line, sizeof(line), fp);
        split_line = strtok(line, "\t");
        w = atof(split_line);
        new_variable[i].weight = w;

        split_line = strtok(NULL, "\n");
        //int len = strlen(split_line);
        strcpy(new_variable[i].term, split_line);
    }

    compare1((const void *) (new_variable), (const void *) (new_variable));
    qsort(new_variable, num_terms, sizeof(struct term), compare1);
    *terms = new_variable;  
    *pnterms = num_terms;                            
   
}

int find_index(struct term *terms, int nterms, char* substr){
    char *cur_word;
    int upper = nterms;
    int lower = 0;
    int index = nterms/2;

    for (int i = 0; i < nterms; i++){
       
        cur_word = terms[index].term;

        if (check_match(substr, cur_word)){
            return index;
        }
        if (strcmp(substr, cur_word) > 0){
            lower = index;
            index = index + ((upper - index)/2);
           
        }
        else{
            upper = index;
            index = index + ((lower - index)/2);
           
        }
    }
    return 11; ///what am i supposed to return
}  


int lowest_match(struct term *terms, int nterms, char *substr){
    int index;
    index = find_index(terms, nterms, substr);

    for (int i = index; i>0; i--){

        if (check_match(substr, terms[i-1].term)){
            index = i-1;
        }
        else{
            break;
        }
    }
    printf("%s", terms[index].term);
    return index;
}




int highest_match(struct term *terms, int nterms, char *substr){

    int index;
    index = find_index(terms, nterms, substr);

    for (int i = index; i<nterms; i++){

        if (check_match(substr, terms[i+1].term)){

            index = i+1;
        }
        else{
            break;
        }
    }
    printf("%s", terms[index].term);
    return index;
}


void autocomplete(struct term **answer, int *n_answer, struct term *terms, int nterms, char *substr){

    char *cur_word;
    double cur_weight;
    //int len = strlen(substr);
    struct term * copy_answer;
    int na = 0;  //number of answers

    for (int i = 0; i < nterms; i++){
        cur_word = terms[i].term;
        if (check_match(substr, cur_word)){
            na = na + 1;
        }
    }  
    copy_answer = (struct term *) malloc((na) * sizeof(struct term));
    int counter = 0;

    for (int i = 0; i < nterms; i++){
        cur_word = terms[i].term;
        cur_weight = terms[i].weight;
   
        if (check_match(substr, cur_word)){
            strcpy(copy_answer[counter].term, cur_word);
            copy_answer[counter].weight = cur_weight;
            counter++;
        }
    }

    compare2((const void *) (copy_answer), (const void *) (copy_answer));
    qsort(copy_answer, na, sizeof(struct term), compare2);
   
    *n_answer = na;
    *answer = copy_answer;
}