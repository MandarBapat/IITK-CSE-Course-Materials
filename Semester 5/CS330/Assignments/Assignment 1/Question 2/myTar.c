#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(int argc, char **argv){
    if(strcmp("-c", argv[1]) == 0){
        char str[200] = "";
        strcat(str, argv[2]);
        strcat(str, "/");
        strcat(str, argv[3]);
        
        char name[200] = "";
        char path[300] = "";
        
        int len = strlen(argv[2]);
        int pos = 0;
        for(int i=0;i<len;i++){
            if(argv[2][i] == '/'){
                pos = i;
            }
        }
        
        int j;
        for(j=pos+1;j<len;j++){
            name[j-pos-1] = argv[2][j];
        }
        name[j] = '\0';
        
        for(int i=0;i<pos;i++){
            path[i] = argv[2][i];
        }
        path[pos+1] = '\0';
        
        int e1;
        e1 = chdir(path);
        if(e1 < 0){
            printf("Failed to complete creation operation");
            return -1;
        }
        
        DIR *dirp = opendir(name);
        if(dirp == NULL){
            printf("Failed to complete creation operation");
            return -1;
        }
        struct dirent *dp = readdir(dirp);
        int fd = open(str, O_CREAT | O_RDWR, 0644);
        
        while(dp != NULL){
            if(dp->d_name[0] == '.' || strcmp(dp->d_name, argv[3]) == 0){
                dp = readdir(dirp);
                continue;
            }
            char str2[100] = "";
            strcat(str2, argv[2]);
            strcat(str2, "/");
            strcat(str2, dp->d_name);
            
            int f1 = open(str2, O_RDONLY);
            char header[201] = "";
            strcat(header, dp->d_name);
            strcat(header, "@");
            struct stat sbuf;
            fstat(f1, &sbuf);
            char sizebuf[30];
            sprintf(sizebuf, "%lld", sbuf.st_size);
            strcat(header,sizebuf);
            strcat(header, "@");
            int len = strlen(header);
            if(len != 200){
                for(int i=len;i<200;i++){
                    header[i] = '@';
                }
            }
            header[200] = '\0';
            write(fd, header, 200);
            char buf[1];
            while(read(f1, buf, 1) > 0){
                write(fd, buf, 1);
            }
            close(f1);
            dp = readdir(dirp);
        }
        close(fd);
    }
    
    else if(strcmp("-d", argv[1]) == 0){
        char dirname[300] = "";
        char path[300] = "";
        
        int pos = 0;
        int len = strlen(argv[2]);
        for(int i=0;i<len;i++){
            if(argv[2][i] == '/'){
                pos = i;
            }
        }
        
        int j = 0;
        for(j=pos+1;j<len-4;j++){
            dirname[j-pos-1] = argv[2][j];
        }
        dirname[j-pos-1] = '\0';
        
        for(j=0;j<=pos;j++){
            path[j] = argv[2][j];
        }
        path[j] = '\0';

        char path3[300] = "";
        strcat(path3, path);
        strcat(dirname, "Dump");
        strcat(path3, dirname);
        strcat(path3, "/");
        
        int e1 = chdir(path);
        
        if(e1 < 0){
            printf("Failed to complete extraction operation");
            return -1;
        }
        
        mkdir(dirname, 0777);
        
        int fd = open(argv[2], O_RDONLY);
        if(fd < 0){
            printf("Failed to complete extraction operation");
            return -1;
        }
        
        while(1){
            char buff[200];
            char s[30] = "";
            char filename[30] = "";
            char filepath[300] = "";
            strcat(filepath, path3);
            
            int status;
            status = read(fd, buff, 200);
            
            if(status <= 0){
                break;
            }
            
            int pos = 0;
            for(int i=0;i<200;i++){
                if(buff[i] == '@'){
                    pos = i;
                    break;
                }
                filename[i] = buff[i];
            }
            filename[pos] = '\0';
            strcat(filepath, filename);
            
            int j;
            for(j=pos+1;j<200;j++){
                if(buff[j] == '@'){
                    break;
                }
                else{
                    s[j-pos-1] = buff[j];
                }
            }
            s[j] = '\0';
            
            long long int len_bytes = atoll(s);
            int f1 = open(filepath, O_CREAT | O_RDWR, 0644);
            if(f1 < 0){
                printf("Failed to complete extraction operation");
                break;
            }
            
            
            for(long long int i=1;i<=len_bytes;i++){
                char buf[1];
                read(fd, buf, 1);
                write(f1, buf, 1);
            }
            
            close(f1);
        }
        close(fd);
    }
    
    else if(strcmp("-e", argv[1]) == 0){
        char dirname[40] = "IndividualDump";
        char path[200] = "";
        
        int pos = 0;
        int len = strlen(argv[2]);
        for(int i=0;i<len;i++){
            if(argv[2][i] == '/'){
                pos = i;
            }
        }
        
        int j;
        for(j=0;j<=pos;j++){
            path[j] = argv[2][j];
        }
        path[j] = '\0';
        
        char path3[300] = "";
        strcat(path3, path);
        strcat(path3, dirname);
        strcat(path3, "/");
        
        
        int e1 = chdir(path);
        if(e1 < 0){
            printf("Failed to complete extraction operation");
            return -1;
        }
        
        mkdir(dirname, 0777);
        
        int fd = open(argv[2], O_RDONLY);
        if(fd < 0){
            printf("Failed to complete extraction operation");
            return -1;
        }
        int flag = 0;
        
        while(1){
            char buff[200];
            char s[30] = "";
            char filename[30] = "";
            char filepath[300] = "";
            strcat(filepath, path3);
            
            int status;
            status = read(fd, buff, 200);
            
            if(status <= 0){
                break;
            }
            
            int pos = 0;
            for(int i=0;i<200;i++){
                if(buff[i] == '@'){
                    pos = i;
                    break;
                }
                filename[i] = buff[i];
            }
            filename[pos] = '\0';
            strcat(filepath, filename);
            
            int j;
            for(j=pos+1;j<200;j++){
                if(buff[j] == '@'){
                    break;
                }
                else{
                    s[j-pos-1] = buff[j];
                }
            }
            s[j] = '\0';
            
            long long int len_bytes = atoll(s);
            if(strcmp(filename, argv[3]) != 0){
                lseek(fd, len_bytes, SEEK_CUR);
                continue;
            }
            else{
                flag = 1;
                int f1 = open(filepath, O_CREAT | O_RDWR, 0644);
                
                if(f1 < 0){
                    printf("Failed to complete extraction operation");
                    break;
                }
                
                
                for(long long int i=1;i<=len_bytes;i++){
                    char buf[1];
                    read(fd, buf, 1);
                    write(f1, buf, 1);
                }
                
                close(f1);
                break;
            }
        }
        close(fd);
        
        if(!flag){
            printf("No such file is present in tar file");
        }
    }
    
    else if(strcmp("-l", argv[1]) == 0){
        char path[300] = "";
        
        int pos = 0;
        int len = strlen(argv[2]);
        for(int i=0;i<len;i++){
            if(argv[2][i] == '/'){
                pos = i;
            }
        }
        
        int j;
        
        for(j=0;j<=pos;j++){
            path[j] = argv[2][j];
        }
        path[j] = '\0';
        
        char structure_path[300] = "";
        
        int e1 = chdir(path);
        if(e1 < 0){
            printf("Failed to complete listing operation");
            return -1;
        }
        
        strcat(structure_path, path);
        strcat(structure_path, "tarStructure");
        
        int fd1 = open(argv[2], O_RDONLY);
        if(fd1 < 0){
            printf("Failed to complete listing operation");
            return -1;
        }
        int fd3 = open(structure_path, O_CREAT | O_RDWR, 0644);
        if(fd3 < 0){
            printf("Failed to complete listing operation");
            return -1;
        }
        
        char size[40] = "";
        long long int s = lseek(fd1, 0, SEEK_END);
        lseek(fd1, 0, SEEK_SET);
        sprintf(size, "%lld", s);
        
        char buf[1] = {'\n'};
        write(fd3, size, strlen(size));
        write(fd3, buf, 1);
        
        int count = 0;
        while(1){
            char buff[200];
            int status = read(fd1, buff, 200);
            if(status <= 0){
                break;
            }
            count++;
            char filename[50] = "";
            char filesize[100] = "";
            
            int pos = 0;
            for(int i=0;i<200;i++){
                if(buff[i] == '@'){
                    pos = i;
                    break;
                }
                else{
                    filename[i] = buff[i];
                }
            }
            filename[pos] = '\0';
            
            int j;
            for(j=pos+1;j<200;j++){
                if(buff[j] == '@'){
                    break;
                }
                else{
                    filesize[j-pos-1] = buff[j];
                }
            }
            filesize[j-pos-1] = '\0';
            
            long long int size_of_file = atoll(filesize);
            lseek(fd1, size_of_file, SEEK_CUR);
        }
        
        char num[200] = "";
        sprintf(num, "%d", count);
        write(fd3, num, strlen(num));
        write(fd3, buf, 1);
        lseek(fd1, 0, SEEK_SET);
        
        while(1){
            char buff[200];
            int status = read(fd1, buff, 200);
            if(status <= 0){
                break;
            }
            char filename[50] = "";
            char filesize[100] = "";
            
            int pos = 0;
            for(int i=0;i<200;i++){
                if(buff[i] == '@'){
                    pos = i;
                    break;
                }
                else{
                    filename[i] = buff[i];
                }
            }
            filename[pos] = '\0';
            
            int j;
            for(j=pos+1;j<200;j++){
                if(buff[j] == '@'){
                    break;
                }
                else{
                    filesize[j-pos-1] = buff[j];
                }
            }
            filesize[j-pos-1] = '\0';
            
            long long int size_of_file = atoll(filesize);
            lseek(fd1, size_of_file, SEEK_CUR);
            write(fd3, filename, strlen(filename));
            buf[0] = ' ';
            write(fd3, buf, 1);
            write(fd3, filesize, strlen(filesize));
            buf[0] = '\n';
            write(fd3, buf, 1);
        }
        close(fd1);
        close(fd3);
    }
}
