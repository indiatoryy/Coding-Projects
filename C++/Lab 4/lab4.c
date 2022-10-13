#include <stdio.h>
#include <stdlib.h>
#include "lab4.h"

int main(void)
{
    struct node *node0 = (struct node *)malloc(sizeof(struct node));
    node0->data = 3;
    node0->next = NULL;
    append(node0, 5);
    append(node0, 15);
    append(node0, 12);
    display(node0);
    freeList(node0);
    // display(node0); // is this supposed to give an error??
    // deleteNode(node0, 1);
    // display(node0);

}

