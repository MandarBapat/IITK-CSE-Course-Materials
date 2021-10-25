#include "wc.h"


extern struct team teams[NUM_TEAMS];
extern int test;
extern int finalTeam1;
extern int finalTeam2;

int processType = HOST;
const char *team_names[] = {
  "India", "Australia", "New Zealand", "Sri Lanka",   // Group A
  "Pakistan", "South Africa", "England", "Bangladesh" // Group B
};


void teamPlay(void)
{
    char input_file[150] = "";
    sprintf(input_file,"./test/%d/inp/%s", test, teams[processType].name);
    int fd = open(input_file, O_RDONLY);
    
    
    while(1){
        char buf1[0];
        read(teams[processType].commpipe[0], buf1, 1);
        int e = buf1[0] - '0';
        if(e == 0){
            char buff[1];
            read(fd, buff, 1);
            write(teams[processType].matchpipe[1], buff, 1);
        }
        else{
            break;
        }
    }
    close(fd);
}

void endTeam(int teamID)
{
    char buff[1] = {'1'};
    write(teams[teamID].commpipe[1], buff, 1);
}

int match(int team1, int team2)
{
    char buf1[1], buf2[1];
    
    char sig[1] = {'0'};
    write(teams[team1].commpipe[1], sig, 1);
    read(teams[team1].matchpipe[0], buf1, 1);
    write(teams[team2].commpipe[1], sig, 1);
    read(teams[team2].matchpipe[0], buf2, 1);
    
    int x = buf1[0] - '0';
    int y = buf2[0] - '0';
    int bats = -1;
    int bowls = -1;
    if((x+y)&1){
        bats = team1;
        bowls = team2;
    }
    else{
        bats = team2;
        bowls = team1;
    }
    
    int fd;
    if((team1 < 4 && team2 < 4) || (team1 >= 4 && team2 >= 4)){
        char filepath[100] = "";
        sprintf(filepath, "./test/%d/out/%sv%s", test, teams[bats].name, teams[bowls].name);
        fd = open(filepath, O_CREAT | O_RDWR, 0644);
    }
    else{
        char filepath[100] = "";
        sprintf(filepath, "./test/%d/out/%sv%s-Final", test, teams[bats].name, teams[bowls].name);
        fd = open(filepath, O_CREAT | O_RDWR, 0644);
    }
    
    char inn1[100] = "";
    sprintf(inn1, "Innings1: %s bats\n", teams[bats].name);
    write(fd, inn1, strlen(inn1));
    
    int temp1 = 0;
    int wickets1 = 10;
    int total_runs1 = 0;
    int batsman_count1 = 1;
    for(int i=1;i<=120;i++){
        char buff1[1];
        char buff2[1];
        
        char sig1[1] = {'0'};
        char sig2[1] = {'0'};
        write(teams[bats].commpipe[1], sig1, 1);
        write(teams[bowls].commpipe[1], sig2, 1);
        read(teams[bats].matchpipe[0], buff1, 1);
        read(teams[bowls].matchpipe[0], buff2, 1);
        int x = buff1[0] - '0';
        int y = buff2[0] - '0';
        if(x != y){
            temp1 += x;
            total_runs1 += x;
            if(i == 120){
                char runout[100] = "";
                sprintf(runout,"%d:%d*\n", temp1,
                        batsman_count1);
                write(fd, runout, strlen(runout));
            }
        }
        else{
            wickets1--;
            char runout[100] = "";
            sprintf(runout,"%d:%d\n", temp1, batsman_count1);
            write(fd, runout, strlen(runout));
            temp1 = 0;
            batsman_count1++;
            if(wickets1 == 0){
                break;
            }
            if(i == 120){
                char runout[100] = "";
                sprintf(runout,"%d:%d*\n", temp1,
                        batsman_count1);
                write(fd, runout, strlen(runout));
                break;
            }
        }
    }
    char final_stat1[200] = "";
    sprintf(final_stat1,"%s Total: %d\n", teams[bats].name, total_runs1);
    write(fd, final_stat1, strlen(final_stat1));
    buf1[0] = '\n';
    write(fd, buf1, 1);

    char inn2[100] = "";
    sprintf(inn2, "Innings2: %s bats\n", teams[bowls].name);
    write(fd, inn2, strlen(inn2));
    
    int temp2 = 0;
    int wickets2 = 10;
    int total_runs2 = 0;
    int batsman_count2 = 1;
    for(int i=1;i<=120;i++){
        char buff1[1];
        char buff2[1];
        
        char sig1[1], sig2[1];
        sig1[0] = '0';
        sig2[0] = '0';
        write(teams[bats].commpipe[1], sig1, 1);
        write(teams[bowls].commpipe[1], sig2, 1);
        read(teams[bowls].matchpipe[0], buff1, 1);
        read(teams[bats].matchpipe[0], buff2, 1);
        int x = buff1[0] - '0';
        int y = buff2[0] - '0';
        if(x != y){
            temp2 += x;
            total_runs2 += x;
            if(i == 120){
                char runout[100] = "";
                sprintf(runout,"%d:%d*\n", temp2,
                        batsman_count2);
                write(fd, runout, strlen(runout));
                break;
            }
            if(total_runs2 > total_runs1){
                break;
            }
        }
        else{
            wickets2--;
            char runout[100] = "";
            sprintf(runout,"%d:%d\n", temp2, batsman_count2);
            write(fd, runout, strlen(runout));
            temp2 = 0;
            batsman_count2++;
            if(wickets2 == 0){
                break;
            }
            if(i == 120){
                char runout[100] = "";
                sprintf(runout,"%d:%d*\n", temp2,
                        batsman_count2);
                write(fd, runout, strlen(runout));
                break;
            }
        }
    }
    char final_stat2[200] = "";
    sprintf(final_stat2,"%s Total: %d\n", teams[bowls].name, total_runs2);
    write(fd, final_stat2, strlen(final_stat2));
    buf1[0] = '\n';
    write(fd, buf1, 1);
    
    if(total_runs1 > total_runs2){
        char result[200] = "";
        sprintf(result, "%s beats %s by %d runs", teams[bats].name, teams[bowls].name, total_runs1-total_runs2);
        write(fd, result, strlen(result));
        close(fd);
        return bats;
    }
    else if(total_runs2 > total_runs1){
        char result[200] = "";
        sprintf(result, "%s beats %s by %d wickets", teams[bowls].name, teams[bats].name, wickets2);
        write(fd, result, strlen(result));
        close(fd);
        return bowls;
    }
    else{
        char result[200] = "";
        sprintf(result, "TIE: %s beats %s", teams[bats].name, teams[bowls].name);
        write(fd, result, strlen(result));
        close(fd);
        return team1;
    }
}

void spawnTeams(void)
{
    for(int i=0;i<8;i++){
        int len = strlen(team_names[i]);
        for(int j=0;j<len;j++){
            teams[i].name[j] = team_names[i][j];
        }
        teams[i].name[len] = '\0';
        pipe(teams[i].matchpipe);
        pipe(teams[i].commpipe);
        if(fork() == 0){
            processType = i;
            teamPlay();
            exit(0);
        }
    }
}

void conductGroupMatches(void)
{
    
    pid_t pid;
    int fd1[2];
    pipe(fd1);
    pid = fork();
    
    if(pid == 0){
        int arr[4] = {0};
        
        for(int i=0;i<4;i++){
            for(int j=i+1;j<4;j++){
                int winner = match(i,j);
                arr[winner]++;
            }
        }
        
        int max1 = 0;
        for(int i=0;i<4;i++){
            if(arr[i] > arr[max1]){
                max1 = i;
            }
        }
        
        for(int i=0;i<4;i++){
            if(i != max1){
                endTeam(i);
            }
        }
        
        char buf1[1] = {'0'};
        buf1[0] = max1 + '0';
        write(fd1[1], buf1, 1);
        exit(0);
    }
    else if(pid > 0){
        char bug1[1];
        read(fd1[0], bug1, 1);
        finalTeam1 = bug1[0] - '0';
        
        int fd2[2];
        pipe(fd2);
        pid_t pid2 = fork();
        if(pid2 == 0){
            int arr[8] = {0};
            
            for(int i=4;i<8;i++){
                for(int j=i+1;j<8;j++){
                    int winner = match(i,j);
                    arr[winner]++;
                }
            }
            
            int max1 = 4;
            for(int i=4;i<8;i++){
                if(arr[i] > arr[max1]){
                    max1 = i;
                }
            }
            
            for(int i=4;i<8;i++){
                if(i != max1){
                    endTeam(i);
                }
            }
            
            char buf1[1] = {'0'};
            buf1[0] = max1 + '0';
            write(fd2[1], buf1, 1);
            exit(0);
        }
        else if(pid2 > 0){
            char bug1[1];
            read(fd2[0], bug1, 1);
            finalTeam2 = bug1[0] - '0';
        }
    }
}
