#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

int main(int argc, char **argv){
    int flag = 1;
    if(argc == 2){
        long long int x = atoll(argv[1]);
        if(x < 0){
            printf("UNABLE TO EXECUTE");
        }
        else{
            printf("%lld", (long long int)round(sqrt(x)));
        }
    }
    else{
        for(int i=1;i<argc-1;i++){
            if(!(strcmp(argv[i], "root") == 0 || strcmp(argv[i], "double") == 0 || strcmp(argv[i], "square") == 0)){
                flag = 0;
            }
        }
        
        if(!flag){
            printf("UNABLE TO EXECUTE");
        }
        else{
            long long int x = atoll(argv[argc-1]);
            x = (long long int)round(sqrt(x));
            char str[100];
            sprintf(str, "%lld", x);
            argv[argc-1] = str;
            if(execv(argv[1], argv+1)){
                printf("UNABLE TO EXECUTE");
                exit(-1);
            }
        }
    }
}
