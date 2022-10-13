#include "seamcarving.h"
#include "c_img.h"
#include <math.h>
#include <stdio.h>
#include <float.h>


void calc_energy(struct rgb_img *im, struct rgb_img **grad){

    int red_x_grad;
    int red_y_grad;
    int blue_x_grad;
    int blue_y_grad;
    int green_x_grad;
    int green_y_grad;
    int left;
    int right;
    int top;
    int bottom;
    double sum;
    int energy;
       
//get height and width
    size_t height = im->height;
    size_t width = im->width;

//loop through x and y coordinates
    for (int i = 0; i < height; i++){
        for (int j = 0; j < width; j++){
            right = j + 1;
            left = j - 1;
            bottom = i + 1;
            top = i - 1;

            //edge cases
            if (i == 0){
                top = height - 1;  
            }
            if (i == height-1){
                bottom = 0;
            }
            if (j == 0){
                left = width - 1;
            }
            if (j == width - 1){
                right = 0;
            }

            //using x and y corrdinate, calculate energy using formula
            //delta x is x+1 - x-1
            red_x_grad = get_pixel(im, i, right, 0) - get_pixel(im, i, left, 0);
            red_y_grad = get_pixel(im, bottom, j, 0) - get_pixel(im, top, j, 0);
            blue_x_grad = get_pixel(im, i, right, 1) - get_pixel(im, i, left, 1);
            blue_y_grad = get_pixel(im, bottom, j, 1) - get_pixel(im, top, j, 1);
            green_x_grad = get_pixel(im, i, right, 2) - get_pixel(im, i, left, 2);
            green_y_grad = get_pixel(im, bottom, j, 2) - get_pixel(im, top, j, 2);

            sum = (pow(red_x_grad,2)) + (pow(blue_x_grad,2)) + (pow(green_x_grad,2)) + (pow(red_y_grad,2)) + (pow(blue_y_grad,2)) + (pow(green_y_grad,2));
            sum = sqrt(sum);
            sum = sum/10;
           
            energy = (uint8_t)sum;
       
            set_pixel(*grad, i, j, energy, energy, energy);
        }    
    }
       
};

double smallest_sum(struct rgb_img *grad, int y, int x){
    double sum1;
    double sum2;
    double sum3;

    if (y == 0){
        return get_pixel(grad, y, x, 0);
    }
    else{
       
        if (x != 0){
            sum1 = smallest_sum(grad, y-1, x-1);
        }
        else{
            sum1 = DBL_MAX;
        }
        if (x != grad->width-1){
            sum2 = smallest_sum(grad, y-1, x+1);
        }
        else{
            sum2 = DBL_MAX;
        }
        sum3 = smallest_sum(grad, y-1, x);

       
        //return smallest
        if (sum1 <= sum2 && sum1 <= sum3){
            return sum1+get_pixel(grad, y, x, 0);
        }
        if (sum2 <= sum1 && sum2 <= sum3){
            return sum2+get_pixel(grad, y, x, 0);
        }
       
        return sum3+get_pixel(grad, y, x, 0);
       
    }
}


void dynamic_seam(struct rgb_img *grad, double **best_arr){

    for (int i = 0; i < grad->width; i++){
        for (int j = 0; j < grad->height; j++){
            (*best_arr)[j*grad->width+i] = smallest_sum(grad, j, i);
        }    
    }

}

// int * find_path(){
//     int y;
//     int x;

//     if (y == 0){
//         return [x];
//     }
// }

void recover_path(double *best, int height, int width, int **path){
//use recursive function but pass an array to it
    double min = DBL_MAX;
    int index;
    double left;
    double middle;
    double right;

    // finding the smallest number in the last row
    for (int i = 0; i < width; i++) {
        if ((best)[(height-1)*width +1] < min) {
            min = (best)[(height-1)*width + i];
            index = i;
            (*path)[height-1] = index;
        }
    }

    for (int j = height - 2; j >= 0; j--) {
        left = (best)[(j*(width)) + index - 1];
        middle = (best)[(j*(width)) + index];
        right = (best)[(j*(width)) + index + 1];

        // check smallest
        if (left <= middle && left <= right){
            index = index - 1;
            (*path)[j] = index;
        }

        if (middle <= left && middle <= right){
            (*path)[j] = index;
        }

        if (right <= middle && right <= left){
            index = index + 1;
            (*path)[j] = index;
        }
    }

}

void remove_seam(struct rgb_img *src, struct rgb_img **dest, int *path) {
    // removing the s-eam
    int height = (int) src->height;    // how many seams to remove
    int width = (int) src->width;
    int j; 
    int i;

    create_img(dest, height, width);

    for (i = 0; i < width; i++) {                 // iterate through by columns
        for (j = 0; i < height; i++) {             // iterate through by column
            if ((path)[j] != i){                   // if the path's index != column...
                (dest)[i][j] = (path)[i][j];     // transfer the value to the new one
            }
        }
    }


}