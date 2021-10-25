#include<pipe.h>
#include<context.h>
#include<memory.h>
#include<lib.h>
#include<entry.h>
#include<file.h>

// Per process info for the pipe.
struct pipe_info_per_process {

    // TODO:: Add members as per your need...
        int is_read_open;
        int is_write_open;
};

// Global information for the pipe.
struct pipe_info_global {

        char *pipe_buff;    // Pipe buffer: DO NOT MODIFY THIS.

    // TODO:: Add members as per your need...

        int read_end;
        int write_end;
        float num_proc;

        int can_read;
        int can_write;
};

// Pipe information structure.
// NOTE: DO NOT MODIFY THIS STRUCTURE.
struct pipe_info {

    struct pipe_info_per_process pipe_per_proc [MAX_PIPE_PROC];
    struct pipe_info_global pipe_global;

};


// Function to allocate space for the pipe and initialize its members.
struct pipe_info* alloc_pipe_info () {

    // Allocate space for pipe structure and pipe buffer.
    struct pipe_info *pipe = (struct pipe_info*)os_page_alloc(OS_DS_REG);
    char* buffer = (char*) os_page_alloc(OS_DS_REG);

    // Assign pipe buffer.
    pipe->pipe_global.pipe_buff = buffer;

    /**
     *  TODO:: Initializing pipe fields
     *
     *  Initialize per process fields for this pipe.
     *  Initialize global fields for this pipe.
     *
     */

    // Return the pipe.
        pipe->pipe_global.read_end = 0;
        pipe->pipe_global.write_end = 0;
        pipe->pipe_global.can_write = 1;
        pipe->pipe_global.can_read = 0;
        pipe->pipe_global.num_proc = 1.0;

        for(int i=0;i<MAX_PIPE_PROC;i++){
                pipe->pipe_per_proc[i].is_read_open = 0;
                pipe->pipe_per_proc[i].is_write_open = 0;
        }

        return pipe;

}

// Function to free pipe buffer and pipe info object.
// NOTE: DO NOT MODIFY THIS FUNCTION.
void free_pipe (struct file *filep) {

    os_page_free(OS_DS_REG, filep->pipe->pipe_global.pipe_buff);
    os_page_free(OS_DS_REG, filep->pipe);

}

// Fork handler for the pipe.

int do_pipe_fork (struct exec_context *child, struct file *filep) {

    /**
     *  TODO:: Implementation for fork handler
     *
     *  You may need to update some per process or global info for the pipe.
     *  This handler will be called twice since pipe has 2 file objects.
     *  Also consider the limit on no of processes a pipe can have.
     *  Return 0 on success.
     *  Incase of any error return -EOTHERS.
     *
     */

    // Return successfully.

        if(filep==NULL || child==NULL){
                return -EINVAL;
        }

        if((int)(filep->pipe->pipe_global.num_proc) == MAX_PIPE_PROC){
                return -EOTHERS;
        }
        else{
                int index = (child->pid)%(MAX_PIPE_PROC);
                int index2 = (child->ppid)%(MAX_PIPE_PROC);
                int var1 = filep->pipe->pipe_per_proc[index2].is_read_open;
                int var2 = filep->pipe->pipe_per_proc[index2].is_write_open;

                if(var1 && var2){
                        filep->pipe->pipe_global.num_proc += 0.5;
                }
                else{
                        filep->pipe->pipe_global.num_proc += 1.0;
                }
                if(filep->mode == O_READ){
                        filep->pipe->pipe_per_proc[index].is_read_open = 1;
                }
                else if(filep->mode == O_WRITE){
                        filep->pipe->pipe_per_proc[index].is_write_open = 1;
                }
        }


        return 0;

}

// Function to close the pipe ends and free the pipe when necessary.
long pipe_close (struct file *filep) {

    /**
     *  TODO:: Implementation of Pipe Close
     *
     *  Close the read or write end of the pipe depending upon the file
     *      object's mode.
     *  You may need to update some per process or global info for the pipe.
     *  Use free_pipe() function to free pipe buffer and pipe object,
     *      whenever applicable.
     *  After successful close, it return 0.
     *  Incase of any error return -EOTHERS.
     *
     */
        if(filep==NULL){
                return -EINVAL;
        }

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PIPE_PROC);

        int num = (int)(filep->pipe->pipe_global.num_proc);
        int var1 = filep->pipe->pipe_per_proc[index].is_read_open;
        int var2 = filep->pipe->pipe_per_proc[index].is_write_open;

        if(filep->mode == O_READ && var2){
                filep->pipe->pipe_per_proc[index].is_read_open = 0;
        }
        else if(filep->mode == O_READ && !var2){
                filep->pipe->pipe_per_proc[index].is_read_open = 0;
                if(num == 1){
                        free_pipe(filep);
                }
                else{
                        filep->pipe->pipe_global.num_proc -= 1.0;
                }
        }
        else if(filep->mode == O_WRITE && var1){
                filep->pipe->pipe_per_proc[index].is_write_open = 0;
        }
        else if(filep->mode == O_WRITE && !var1){
                filep->pipe->pipe_per_proc[index].is_write_open = 0;
                if(num == 1){
                        free_pipe(filep);
                }
                else{
                        filep->pipe->pipe_global.num_proc -= 1.0;
                }
        }

        int ret_value;


    // Close the file and return.
        ret_value = file_close (filep);         // DO NOT MODIFY THIS LINE.

    // And return.
        return ret_value;

}

// Check whether passed buffer is valid memory location for read or write.
int is_valid_mem_range (unsigned long buff, u32 count, int access_bit) {

    /**
     *  TODO:: Implementation for buffer memory range checking
     *
     *  Check whether passed memory range is suitable for read or write.
     *  If access_bit == 1, then it is asking to check read permission.
     *  If access_bit == 2, then it is asking to check write permission.
     *  If range is valid then return 1.
     *  Incase range is not valid or have some permission issue return -EBADMEM.
     *
     */

        if(buff<0 || count < 0){
                return -EINVAL;
        }

        struct exec_context* current = get_current_ctx();
        int flag1 = 0;
        int flag2 = 0;

        for(int i=0;i<MAX_MM_SEGS;i++){
                int per = current->mms[i].access_flags;
                int var1;
                if(access_bit == 1){
                        var1 = (per == 1) || (per == 3) || (per == 5) || (per == 6) || (per == 7);
                }
                else{
                        var1 = (per == 2) || (per == 3) || (per == 6) || (per == 7);
                }
                if(current->mms[i].start <= buff && current->mms[i].end >= (buff+count) && var1){
                        flag1 = 1;
                        break;
                }
        }

        struct vm_area* temp = current->vm_area;

        while(temp){
                int var1;
                int per = temp->access_flags;
                if(access_bit == 1){
                        var1 = (per == 1) || (per == 3) || (per == 5) || (per == 6) || (per == 7);
                }
                else{
                        var1 = (per == 2) || (per == 3) || (per == 6) || (per == 7);
                }
                if( ((temp->vm_start) <= buff) && ((temp->vm_end) >= (buff+count)) && var1){
                        flag2 = 1;
                        break;
                }
                temp = temp->vm_next;
        }

        if(flag1 || flag2){
                return 1;
        }


        int ret_value = -EBADMEM;

    // Return the finding.
        return ret_value;

}

// Function to read given no of bytes from the pipe.
int pipe_read (struct file *filep, char *buff, u32 count) {

    /**
     *  TODO:: Implementation of Pipe Read

     *
     *  Read the data from pipe buffer and write to the provided buffer.
     *  If count is greater than the present data size in the pipe then just read
     *       that much data.
     *  Validate file object's access right.
     *  On successful read, return no of bytes read.
     *  Incase of Error return valid error code.
     *       -EACCES: In case access is not valid.
     *       -EINVAL: If read end is already closed.
     *       -EOTHERS: For any other errors.
     *
     */

        int bytes_read = 0;

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PIPE_PROC);

        if(filep->pipe->pipe_per_proc[index].is_read_open == 0){
                return -EACCES;
        }

        if(filep==NULL || buff==NULL || count<0){
                return -EINVAL;
        }

        if(filep->mode != O_READ){
                return -EACCES;
        }

        if(!(filep->pipe->pipe_global.can_read)){
                return -EACCES;
        }

        int e = is_valid_mem_range((unsigned long)buff, count, 2);
        if(e != 1){
                return e;
        }

        if(count == 0){
                return 0;
        }

        int read_pos = filep->pipe->pipe_global.read_end;
        int write_pos = filep->pipe->pipe_global.write_end;

        if(read_pos == write_pos){
                filep->pipe->pipe_global.can_write = 1;
        }

        int i;
        for(i=0;i<count;i++){
                if((i+read_pos)%4096 == write_pos && i!=0){
                        break;
                }
                buff[i] = filep->pipe->pipe_global.pipe_buff[(i+read_pos)%4096];
                bytes_read++;
        }

        filep->pipe->pipe_global.read_end = (i+read_pos)%4096;

        if(filep->pipe->pipe_global.read_end == filep->pipe->pipe_global.write_end){
                filep->pipe->pipe_global.can_read = 0;
        }

    // Return no of bytes read.
        return bytes_read;

}

// Function to write given no of bytes to the pipe.
int pipe_write (struct file *filep, char *buff, u32 count) {

    /**
     *  TODO:: Implementation of Pipe Write
     *
     *  Write the data from the provided buffer to the pipe buffer.
     *  If count is greater than available space in the pipe then just write data
     *       that fits in that space.
     *  Validate file object's access right.
     *  On successful write, return no of written bytes.
     *  Incase of Error return valid error code.
     *       -EACCES: In case access is not valid.
     *       -EINVAL: If write end is already closed.
     *       -EOTHERS: For any other errors.
     *
     */

        int bytes_written = 0;

        struct exec_context* current = get_current_ctx();
        int index = (current->pid)%(MAX_PIPE_PROC);

        if(filep->pipe->pipe_per_proc[index].is_write_open == 0){
                return -EACCES;
        }

        if(filep==NULL || buff==NULL || count < 0){
                return -EINVAL;
        }

        if(!(filep->pipe->pipe_global.can_write)){
                return -EACCES;
        }

        if(filep->mode != O_WRITE){
                return -EACCES;
        }

        int e = is_valid_mem_range((unsigned long)buff, count, 1);
        if(e != 1){
                return e;
        }

        if(count == 0){
                return 0;
        }

        int read_pos = filep->pipe->pipe_global.read_end;
        int write_pos = filep->pipe->pipe_global.write_end;

        if(read_pos == write_pos){
                filep->pipe->pipe_global.can_read = 1;
        }

        int i;

        for(i=0;i<count;i++){
                if((i+write_pos)%4096 == read_pos && i!=0){
                        break;
                }
                filep->pipe->pipe_global.pipe_buff[(i+write_pos)%4096] = buff[i];
                bytes_written++;
        }

        filep->pipe->pipe_global.write_end = (i+write_pos)%4096;

        if(read_pos == (i+write_pos)%4096){
                filep->pipe->pipe_global.can_write = 0;
        }

    // Return no of bytes written.
        return bytes_written;

}


// Function to create pipe.
int create_pipe (struct exec_context *current, int *fd) {

    /**
     *  TODO:: Implementation of Pipe Create
     *
     *  Find two free file descriptors.
     *  Create two file objects for both ends by invoking the alloc_file() function.
     *  Create pipe_info object by invoking the alloc_pipe_info() function and
     *       fill per process and global info fields.
     *  Fill the fields for those file objects like type, fops, etc.
     *  Fill the valid file descriptor in *fd param.
     *  On success, return 0.
     *  Incase of Error return valid Error code.
     *       -ENOMEM: If memory is not enough.
     *       -EOTHERS: Some other errors.
     *
     */

        if(current==NULL || fd==NULL){
                return -EINVAL;
        }

        struct file* file1 = alloc_file();
        struct file* file2 = alloc_file();
        struct pipe_info* pipe_obj = alloc_pipe_info();

        pipe_obj->pipe_per_proc[(current->pid)%(MAX_PIPE_PROC)].is_read_open = 1;
        pipe_obj->pipe_per_proc[(current->pid)%(MAX_PIPE_PROC)].is_write_open = 1;

        file1->type = PIPE;
        file2->type = PIPE;

        file1->mode = O_READ;
        file2->mode = O_WRITE;

        file1->offp = 0;
        file2->offp = 0;

        file1->ref_count = 1;
        file2->ref_count = 1;


        file1->inode = NULL;
        file2->inode = NULL;

        file1->fops->read = pipe_read;
        file2->fops->read = NULL;

        file1->fops->write = NULL;
        file2->fops->write = pipe_write;

        file1->fops->close = pipe_close;
        file2->fops->close = pipe_close;

        file1->pipe = pipe_obj;
        file2->pipe = pipe_obj;

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
