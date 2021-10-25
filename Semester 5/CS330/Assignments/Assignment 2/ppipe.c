#include<ppipe.h>
#include<context.h>
#include<memory.h>
#include<lib.h>
#include<entry.h>
#include<file.h>


// Per process information for the ppipe.
struct ppipe_info_per_process {

    // TODO:: Add members as per your need...
        int read_end;
        int is_read_open;
        int is_write_open;
        int can_read;
};

// Global information for the ppipe.
struct ppipe_info_global {

        char *ppipe_buff;       // Persistent pipe buffer: DO NOT MODIFY THIS.

    // TODO:: Add members as per your need...

        int write_end;
        int free_start;
        int free_end;
        int rlow_end;

        int can_write;

        float num_proc;
};

// Persistent pipe structure.
// NOTE: DO NOT MODIFY THIS STRUCTURE.
struct ppipe_info {

    struct ppipe_info_per_process ppipe_per_proc [MAX_PPIPE_PROC];
    struct ppipe_info_global ppipe_global;

};


// Function to allocate space for the ppipe and initialize its members.
struct ppipe_info* alloc_ppipe_info() {

    // Allocate space for ppipe structure and ppipe buffer.
    struct ppipe_info *ppipe = (struct ppipe_info*)os_page_alloc(OS_DS_REG);
    char* buffer = (char*) os_page_alloc(OS_DS_REG);

    // Assign ppipe buffer.
    ppipe->ppipe_global.ppipe_buff = buffer;

    /**
     *  TODO:: Initializing pipe fields
     *
     *  Initialize per process fields for this ppipe.
     *  Initialize global fields for this ppipe.
     *
     */

    // Return the ppipe.

        ppipe->ppipe_global.num_proc = 0.0;
        ppipe->ppipe_global.free_start = 0;
        ppipe->ppipe_global.free_end = 4095;
        ppipe->ppipe_global.can_write = 1;
        ppipe->ppipe_global.write_end = 0;
        ppipe->ppipe_global.rlow_end = 0;

        for(int i=0;i<MAX_PPIPE_PROC;i++){
                ppipe->ppipe_per_proc[i].is_read_open = 0;
                ppipe->ppipe_per_proc[i].is_write_open = 0;
                ppipe->ppipe_per_proc[i].read_end = 0;
                ppipe->ppipe_per_proc[i].can_read = 0;
        }

        return ppipe;

}

// Function to free ppipe buffer and ppipe info object.
// NOTE: DO NOT MODIFY THIS FUNCTION.
void free_ppipe (struct file *filep) {

    os_page_free(OS_DS_REG, filep->ppipe->ppipe_global.ppipe_buff);
    os_page_free(OS_DS_REG, filep->ppipe);

}

// Fork handler for ppipe.
int do_ppipe_fork (struct exec_context *child, struct file *filep) {

    /**
     *  TODO:: Implementation for fork handler
     *
     *  You may need to update some per process or global info for the ppipe.
     *  This handler will be called twice since ppipe has 2 file objects.
     *  Also consider the limit on no of processes a ppipe can have.
     *  Return 0 on success.
     *  Incase of any error return -EOTHERS.
     *
     */

    // Return successfully.

        if(child==NULL || filep==NULL){
                return -EINVAL;
        }

        if((int)(filep->ppipe->ppipe_global.num_proc) == MAX_PPIPE_PROC){
                return -EOTHERS;
        }
        else{
                int index = (child->pid)%(MAX_PPIPE_PROC);
                int index2 = (child->ppid)%(MAX_PPIPE_PROC);
                int var1 = filep->ppipe->ppipe_per_proc[index2].is_read_open;
                int var2 = filep->ppipe->ppipe_per_proc[index2].is_write_open;

                if(var1&&var2){
                        filep->ppipe->ppipe_global.num_proc += 0.5;
                }
                else{
                        filep->ppipe->ppipe_global.num_proc += 1.0;
                }

                if(filep->mode == O_READ){
                        filep->ppipe->ppipe_per_proc[index].is_read_open = 1;
                        filep->ppipe->ppipe_per_proc[index].read_end = filep->ppipe->ppipe_per_proc[index2].read_end;
                        filep->ppipe->ppipe_per_proc[index].can_read = filep->ppipe->ppipe_per_proc[index2].can_read;
                }
                else if(filep->mode == O_WRITE){
                        filep->ppipe->ppipe_per_proc[index].is_write_open = 1;
                }
        }

        return 0;

}


// Function to close the ppipe ends and free the ppipe when necessary.
long ppipe_close (struct file *filep) {

    /**
     *  TODO:: Implementation of Pipe Close
     *
     *  Close the read or write end of the ppipe depending upon the file
     *      object's mode.
     *  You may need to update some per process or global info for the ppipe.
     *  Use free_pipe() function to free ppipe buffer and ppipe object,
     *      whenever applicable.
     *  After successful close, it return 0.
     *  Incase of any error return -EOTHERS.
     *
     */

        int ret_value;

        if(filep==NULL){
                return -EINVAL;
        }

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PPIPE_PROC);

        int num = (int)(filep->ppipe->ppipe_global.num_proc);
        int var1 = filep->ppipe->ppipe_per_proc[index].is_read_open;
        int var2 = filep->ppipe->ppipe_per_proc[index].is_write_open;

        if(filep->mode == O_READ && var2){
                filep->ppipe->ppipe_per_proc[index].is_read_open = 0;
        }
        else if(filep->mode == O_READ && !var2){
                filep->ppipe->ppipe_per_proc[index].is_read_open = 0;
                if(num == 1){
                        free_ppipe(filep);
                }
                else{
                        filep->ppipe->ppipe_global.num_proc -= 1.0;
                }
        }
        else if(filep->mode == O_WRITE && var1){
                filep->ppipe->ppipe_per_proc[index].is_write_open = 0;
        }
        else if(filep->mode == O_WRITE && !var1){
                filep->ppipe->ppipe_per_proc[index].is_write_open = 0;
                if(num == 1){
                        free_ppipe(filep);
                }
                else{
                        filep->ppipe->ppipe_global.num_proc -= 1.0;
                }
        }

    // Close the file.
        ret_value = file_close (filep);         // DO NOT MODIFY THIS LINE.

    // And return.
        return ret_value;

}

// Function to perform flush operation on ppipe.
int do_flush_ppipe (struct file *filep) {

    /**
     *  TODO:: Implementation of Flush system call
     *
     *  Reclaim the region of the persistent pipe which has been read by
     *      all the processes.
     *  Return no of reclaimed bytes.
     *  In case of any error return -EOTHERS.

     */

        int reclaimed_bytes = 0;

    // Return reclaimed bytes.
        if(filep==NULL){
                return -EINVAL;
        }

        if(filep->ppipe->ppipe_global.write_end == filep->ppipe->ppipe_global.free_start){
                filep->ppipe->ppipe_global.can_write = 1;
        }


        int pos = (filep->ppipe->ppipe_global.free_end + 1)%4096;
        int pos1 = (filep->ppipe->ppipe_global.rlow_end);

        while(pos != pos1){
                pos = (1+pos)%4096;
                reclaimed_bytes++;
        }
        filep->ppipe->ppipe_global.free_end = (pos1+4095)%4096;

        return reclaimed_bytes;

}

// Read handler for the ppipe.
int ppipe_read (struct file *filep, char *buff, u32 count) {

    /**
     *  TODO:: Implementation of PPipe Read
     *
     *  Read the data from ppipe buffer and write to the provided buffer.
     *  If count is greater than the present data size in the ppipe then just read
     *      that much data.
     *  Validate file object's access right.
     *  On successful read, return no of bytes read.
     *  Incase of Error return valid error code.
     *      -EACCES: In case access is not valid.
     *      -EINVAL: If read end is already closed.
     *      -EOTHERS: For any other errors.
     *
     */

        int bytes_read = 0;

    // Return no of bytes read.

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PPIPE_PROC);

        if(filep==NULL || buff==NULL || count<0){
                return -EINVAL;
        }

        if(filep->ppipe->ppipe_per_proc[index].is_read_open == 0){
                return -EINVAL;
        }

        if(filep->mode != O_READ){
                return -EINVAL;
        }

        if(filep->ppipe->ppipe_per_proc[index].can_read == 0){
                return -EINVAL;
        }

        if(count == 0){
                return 0;
        }

        int read_pos = filep->ppipe->ppipe_per_proc[index].read_end;
        int write_pos = filep->ppipe->ppipe_global.write_end;

        int i;
        for(i=0;i<count;i++){
                if((i+read_pos)%4096 == write_pos && i!=0){
                        break;
                }
                buff[i] = filep->ppipe->ppipe_global.ppipe_buff[(i+read_pos)%4096];
                bytes_read++;
        }
        filep->ppipe->ppipe_per_proc[index].read_end = (i+read_pos)%4096;

        int pos = filep->ppipe->ppipe_global.free_end;
        int k=1;
        int flag = 0;
        while(1){
                for(int j=0;j<MAX_PPIPE_PROC;j++){
                        int y = filep->ppipe->ppipe_per_proc[j].read_end;
                        if((k+pos)%4096 == y && filep->ppipe->ppipe_per_proc[j].is_read_open){
                                filep->ppipe->ppipe_global.rlow_end = (k+pos)%4096;
                                flag=1;
                                break;
                        }
                }
                k++;
                if(flag){
                        break;
                }
        }

        if(filep->ppipe->ppipe_per_proc[index].read_end == filep->ppipe->ppipe_global.write_end){
                filep->ppipe->ppipe_per_proc[index].can_read = 0;
        }

        return bytes_read;

}


// Write handler for ppipe.
int ppipe_write (struct file *filep, char *buff, u32 count) {

    /**
     *  TODO:: Implementation of PPipe Write
     *
     *  Write the data from the provided buffer to the ppipe buffer.
     *  If count is greater than available space in the ppipe then just write
     *      data that fits in that space.
     *  Validate file object's access right.
     *  On successful write, return no of written bytes.
     *  Incase of Error return valid error code.
     *      -EACCES: In case access is not valid.
     *      -EINVAL: If write end is already closed.
     *      -EOTHERS: For any other errors.
     *
     */

        int bytes_written = 0;

    // Return no of bytes written.

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PPIPE_PROC);

        if(filep==NULL || buff==NULL || count < 0){
                return -EINVAL;
        }

        if(filep->ppipe->ppipe_per_proc[index].is_write_open == 0){
                return -EINVAL;
        }

        if(filep->mode != O_WRITE){
                return -EINVAL;
        }

        if(filep->ppipe->ppipe_global.can_write == 0){
                return -EACCES;
        }

        int write_pos = filep->ppipe->ppipe_global.write_end;

        for(int j=0;j<MAX_PPIPE_PROC;j++){
                if(filep->ppipe->ppipe_per_proc[j].read_end == write_pos){
                        filep->ppipe->ppipe_per_proc[j].can_read = 1;
                }
        }

        int pos = filep->ppipe->ppipe_global.free_end;
        int i;

        for(int i=0;i<count;i++){
                if((i+write_pos)%4096 == pos){
                        filep->ppipe->ppipe_global.ppipe_buff[(i+write_pos)%4096] = buff[i];
                        filep->ppipe->ppipe_global.can_write = 0;
                        filep->ppipe->ppipe_global.free_start +=1;
                        bytes_written++;
                        i++;
                        break;
                }
                else{
                        filep->ppipe->ppipe_global.ppipe_buff[(i+write_pos)%4096] = buff[i];
                        filep->ppipe->ppipe_global.free_start +=1;
                        bytes_written++;
                }
        }
        filep->ppipe->ppipe_global.write_end = (i+write_pos)%4096;

        return bytes_written;

}

// Function to create persistent pipe.
int create_persistent_pipe (struct exec_context *current, int *fd) {

    /**
     *  TODO:: Implementation of PPipe Create
     *
     *  Find two free file descriptors.
     *  Create two file objects for both ends by invoking the alloc_file() function.
     *  Create ppipe_info object by invoking the alloc_ppipe_info() function and
     *      fill per process and global info fields.
     *  Fill the fields for those file objects like type, fops, etc.
     *  Fill the valid file descriptor in *fd param.
     *  On success, return 0.
     *  Incase of Error return valid Error code.
     *      -ENOMEM: If memory is not enough.
     *      -EOTHERS: Some other errors.
     *
     */

    // Simple return.

        if(current==NULL || fd==NULL){
                return -EINVAL;
        }

        struct file* file1 = alloc_file();
        struct file* file2 = alloc_file();
        struct ppipe_info* ppipe_obj = alloc_ppipe_info();

        if(file1==NULL || file2==NULL || ppipe_obj==NULL){
                return -EOTHERS;
        }

        ppipe_obj->ppipe_per_proc[(current->pid)%(MAX_PPIPE_PROC)].is_read_open = 1;
        ppipe_obj->ppipe_per_proc[(current->pid)%(MAX_PPIPE_PROC)].is_write_open = 1;

        file1->type = PPIPE;
        file2->type = PPIPE;

        file1->mode = O_READ;
        file2->mode = O_WRITE;

        file1->offp = 0;
        file2->offp = 0;

        file1->ref_count = 1;
        file2->ref_count = 1;

        file1->inode = NULL;
        file2->inode = NULL;

        file1->fops->read = ppipe_read;
        file2->fops->read = NULL;

        file1->fops->close = ppipe_close;
        file2->fops->close = ppipe_close;

        file1->fops->write = NULL;
        file2->fops->write = ppipe_write;

        file1->ppipe = ppipe_obj;
        file2->ppipe = ppipe_obj;

        int counter = 3;
        while(current->files[counter]){
                counter++;
                if(counter > MAX_OPEN_FILES){
                        return -EOTHERS;
                }
        }
        fd[0] = counter;
        current->files[fd[0]] = file1;

        counter++;

        while(current->files[counter]){
                counter++;
                if(counter > MAX_OPEN_FILES){
                        return -EOTHERS;
                }
        }
        fd[1] = counter;
        current->files[fd[1]] = file2;

        return 0;
}



