//Lab 8
// =====
// #include <stdio.h>
//In this lab, you will be working with code from avl_bag.c, to understand it more deeply.
#include <stdio.h>
#include <stdlib.h>
#include "bag.h"

// int compare(a, b){
   
// }

int main(void){

    bag_t *bag;
    bag = bag_create(NULL);//need to create a comparison function
    bag_insert(bag, (bag_elem_t *)10);
    // bag_insert(bag, (bag_elem_t *)14);
    // bag_insert(bag, (bag_elem_t *)12);
    is_avl_tree(bag);
    return 1;

};

/* 1. In avl_bag.c, implement the function

   bool is_avl_tree(bag_t *bag)

   The function takes in a pointer to a BST, and returns True if the BST is an AVL tree. */


/*2. To test your function from (1), you need to create AVL trees (easy) as well as BSTs
   that are not AVL trees. Make a function 

   bool bag_insert_norot(bag_t *bag, bag_elem_t elem)
 
   which inserts an element into a BST without performing any rotations. Using this function,
   create BSTs that are not AVL trees.

   Show your TA that your is_avl_tree function returns true for AVL trees and returns false
   for non-AVL trees. */



// 3. Rewrite avl_remove from scratch.

bool avl_remove(avl_node_t **root, bag_elem_t elem, int (*cmp)(bag_elem_t, bag_elem_t))
{
    bool removed;

    if (! *root) {
        removed = false;
    } else if ((*cmp)(elem, (*root)->elem) < 0) {
        if ((removed = avl_remove(&(*root)->left, elem, cmp))) {
            /* Check if the subtree needs rebalancing; update its height. */
            if (HEIGHT((*root)->left) + 1 < HEIGHT((*root)->right))
                avl_rebalance_to_the_left(root);
            else
                avl_update_height(*root);
        }
    } else if ((*cmp)(elem, (*root)->elem) > 0) {
        if ((removed = avl_remove(&(*root)->right, elem, cmp))) {
            /* Check if the subtree needs rebalancing; update its height. */
            if (HEIGHT((*root)->right) + 1 < HEIGHT((*root)->left))
                avl_rebalance_to_the_right(root);
            else
                avl_update_height(*root);
        }
    } else { /* ((*cmp)(elem, (*root)->elem) == 0) */
        if ((*root)->left && (*root)->right) {
            /* Remove from the subtree with larger height. */
            if (HEIGHT((*root)->left) > HEIGHT((*root)->right))
                (*root)->elem = avl_remove_max(&(*root)->left);
            else
                (*root)->elem = avl_remove_min(&(*root)->right);
            /* No rebalancing necessary, but update height. */
            avl_update_height(*root);
        } else {
            /* Remove *root. */
            avl_node_t *old = *root;
            *root = (*root)->left ? (*root)->left : (*root)->right;
            free(old);
        }
        removed = true;
    }

    return removed;
}