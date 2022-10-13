#include <stdio.h>
#include <stdlib.h>


struct node{
    int data; //in python: void *data, and also the data type
    struct node *next; //NULL if the current node is the last one
};


void append(struct node *head, int value){
    struct node *cur = head;
    while(cur->next != NULL){
        cur = cur->next;
    }
    //cur->next is now equal to null
    struct node *node = (struct node *)malloc(sizeof(struct node));
    node->data = value;
    node->next = NULL;
    cur->next = node;
}

void freeList(struct node* head){
   struct node* tmp;
   while (head != NULL) // making sure the list is not empty
    {
       tmp = head;  // save head in temp
       head = head->next;   // head points to next node
       free(tmp);   // frees the tmp node
    }
}

void display(struct node *head)
{
    while (head != NULL)
    {
        printf("%d   ", head->data);
        head = head->next;
    }
    printf("\n");
}

// void printList(node* node)
// {
//     while (node != NULL) 
//     {
//         cout << node->data << " ";
//         node = node->next;
//     }
// }

void push(struct node** head_ref, int new_data){
    struct node* new_node = (struct node*)malloc(sizeof(struct node));
    new_node ->data = new_data;
    new_node->next = (*head_ref);
    (*head_ref) = new_node;
}

void delete_node(struct node** head_ref, int key){
    //head node saved
    struct node *temp = *head_ref, *prev;

    //check if you need to delete the head node
    if (temp != NULL && temp->data == key){
        *head_ref = temp->next; //chnage the head
        free(temp); // free where head used to be
        return;
    }

    //find key, and keep track of prev node
    while (temp != NULL && temp->data != key){
        prev = temp;
        temp = temp->next;
    }

    // incase the key is not in the list
    if (temp == NULL){
        return;
    }

    // unlink node

    prev->next = temp->next;
    free(temp);
}