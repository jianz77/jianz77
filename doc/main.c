#include <stdio.h>
int mun[10] = {1,13,54,93,56,49,49,74,87,33};
int *Bubble_Sort(int *ptr, int size);

int main(){
    int *p;
    p = Bubble_Sort(mun,10);
    for (int i = 0; i < 10; i++)
    {
        printf("num[%d]=%d\n",i,p[i]);
    }    
    return 0;
}
int *Bubble_Sort(int *ptr,int size){
    int tmp = 0;
    for (int i = 0; i < size-1; i++)
    {
        for (int j = 0; j < size-i-1; j++)
        {
            if (ptr[j] > ptr[j+1])
            {
                tmp = ptr[j];
                ptr[j] = ptr[j+1];
                ptr[j+1] = tmp;
            }          
        }        
    }
    return ptr;
    
}