#include <debug.h>
#include <context.h>
#include <entry.h>
#include <lib.h>
#include <memory.h>


/*****************************HELPERS******************************************/

/*
 * allocate the struct which contains information about debugger
 *
 */
struct debug_info *alloc_debug_info()
{
        struct debug_info *info = (struct debug_info *) os_alloc(sizeof(struct debug_info));
        if(info)
                bzero((char *)info, sizeof(struct debug_info));
        return info;
}
/*
 * frees a debug_info struct
 */
void free_debug_info(struct debug_info *ptr)
{
        if(ptr)
                os_free((void *)ptr, sizeof(struct debug_info));
}



/*
 * allocates a page to store registers structure
 */
struct registers *alloc_regs()
{
        struct registers *info = (struct registers*) os_alloc(sizeof(struct registers));
        if(info)
                bzero((char *)info, sizeof(struct registers));
        return info;
}

/*
 * frees an allocated registers struct
 */
void free_regs(struct registers *ptr)
{
        if(ptr)
                os_free((void *)ptr, sizeof(struct registers));
}

/*
 * allocate a node for breakpoint list
 * which contains information about breakpoint
 */
struct breakpoint_info *alloc_breakpoint_info()
{
        struct breakpoint_info *info = (struct breakpoint_info *)os_alloc(
                sizeof(struct breakpoint_info));
        if(info)
                bzero((char *)info, sizeof(struct breakpoint_info));
        return info;
}

/*
 * frees a node of breakpoint list
 */
*/
void free_breakpoint_info(struct breakpoint_info *ptr)
{
       if(ptr)
               os_free((void *)ptr, sizeof(struct breakpoint_info));
}

/*
* Fork handler.
* The child context doesnt need the debug info
* Set it to NULL
* The child must go to sleep( ie move to WAIT state)
* It will be made ready when the debugger calls wait
*/
void debugger_on_fork(struct exec_context *child_ctx)
{
       // printk("DEBUGGER FORK HANDLER CALLED\n");
       child_ctx->dbg = NULL;
       child_ctx->state = WAITING;
}

void copy_registers(struct exec_context* pid1, struct exec_context* pid2){
       struct registers reg1;

       reg1.r15 = pid2->regs.r15;
       reg1.r14 = pid2->regs.r14;
       reg1.r13 = pid2->regs.r13;
       reg1.r12 = pid2->regs.r12;
       reg1.r11 = pid2->regs.r11;
    reg1.r10 = pid2->regs.r10;
    reg1.r9 = pid2->regs.r9;
    reg1.r8 = pid2->regs.r8;
    reg1.rbp = pid2->regs.rbp;
    reg1.rdi = pid2->regs.rdi;
    reg1.rsi = pid2->regs.rsi;
    reg1.rdx = pid2->regs.rdx;
    reg1.rcx = pid2->regs.rcx;
    reg1.rbx = pid2->regs.rbx;
    reg1.rax = pid2->regs.rax;
    reg1.entry_rip = pid2->regs.entry_rip-1;
    reg1.entry_cs = pid2->regs.entry_cs;
    reg1.entry_rflags = pid2->regs.entry_rflags;
    reg1.entry_rsp = pid2->regs.entry_rsp;
    reg1.entry_ss = pid2->regs.entry_ss;

    pid1->dbg->child_regs_info = reg1;
}


/******************************************************************************/


/* This is the int 0x3 handler
* Hit from the childs context
*/

long int3_handler(struct exec_context *ctx)
{

        //Your code

        if(ctx == NULL || ctx->dbg != NULL){
                return -1;
        }

        struct exec_context* parent = get_ctx_by_pid(ctx->ppid);

        if(parent == NULL){
                return -1;
        }

        u64 start = ctx->regs.entry_rip - 1;

        copy_registers(parent, ctx);

        int index = 0;
        u64* arr = parent->dbg->backtrace;
        arr[index] = start;
        index++;
        u64 temp_rbp, temp_rsp;
        temp_rbp = ctx->regs.rbp;
        temp_rsp = ctx->regs.entry_rsp;

        while(*(u64 *)temp_rsp != END_ADDR){
                arr[index] = *(u64 *)temp_rsp;
                index++;
                temp_rsp = temp_rsp + 8;
                temp_rbp = *(u64 *)temp_rbp;
        }

    parent->regs.rax = start;

    struct breakpoint_info* temp = parent->dbg->head;
    int flag = 0;

    while(temp != NULL){
            if(temp->addr == start){
                    flag = temp->end_breakpoint_enable;
                    break;
            }
    }
    
    if(temp == NULL){
        return -1;
    }

    if(temp != NULL && flag){
            ctx->regs.entry_rsp = ctx->regs.entry_rsp - 8;
            u64 top1 = ctx->regs.entry_rsp;
            *(u64 *)top1 = ctx->dbg->end_handler;
    }


    ctx->regs.entry_rsp = ctx->regs.entry_rsp - 8;
    u64 top = ctx->regs.entry_rsp;
    *(u64 *)top = ctx->regs.rbp;

    ctx->state = WAITING;
    parent->state = READY;
    schedule(parent);

    return 0;
}

/*
* Exit handler.
* Deallocate the debug_info struct if its a debugger.
* Wake up the debugger if its a child
*/
void debugger_on_exit(struct exec_context *ctx)
{
    // Your code
    if(ctx->dbg == NULL){
            struct exec_context* parent = get_ctx_by_pid(ctx->ppid);
            parent->state = READY;
        parent->regs.rax = CHILD_EXIT;
}
else{
        struct breakpoint_info* temp1 = ctx->dbg->head;
        struct breakpoint_info* temp2 = temp1;

        while(temp1 != NULL){
                temp1 = temp1->next;
                free_breakpoint_info(temp2);
                temp2 = temp1;
        }

        free_regs(&(ctx->dbg->child_regs_info));
        free_debug_info(ctx->dbg);
        return;
}
}


/*
* called from debuggers context
* initializes debugger state
*/
int do_become_debugger(struct exec_context *ctx, void *addr)
{
// Your code

if(ctx == NULL){
        return -1;
}

    ctx->dbg = alloc_debug_info();
    if(ctx->dbg == NULL){
            return -1;
    }

    *(unsigned char*)addr = INT3_OPCODE;

    ctx->dbg->breakpoint_count = 0;
    ctx->dbg->head = NULL;
    ctx->dbg->end_handler = addr;
    ctx->dbg->total_breakpoints = 0;

    for(int i=0;i<MAX_BACKTRACE;i++){
            ctx->dbg->backtrace[i] = 0;
    }

    struct registers* temp = alloc_regs();
    ctx->dbg->child_regs_info = *temp;

    return 0;
}

/*
* called from debuggers context
*/
int do_set_breakpoint(struct exec_context *ctx, void *addr, int flag)
{

    // Your code

    if(ctx == NULL || ctx->dbg == NULL){
            return -1;
    }

    struct breakpoint_info *temp = ctx->dbg->head;

    if(temp == NULL){
            temp = alloc_breakpoint_info();
            if(temp == NULL){
                    return -1;
            }

            ctx->dbg->total_breakpoints = ctx->dbg->total_breakpoints + 1;
            temp->num = ctx->dbg->total_breakpoints;
            temp->addr = (u64)addr;
            temp->next = NULL;
            temp->end_breakpoint_enable = flag;

            ctx->dbg->breakpoint_count = ctx->dbg->breakpoint_count + 1;
            ctx->dbg->head = temp;
            *(unsigned char*)addr = INT3_OPCODE;
    }
    else{
            struct breakpoint_info* temp1 = temp;

            while(temp1 != NULL){
                    if(temp1->addr == (u64)(addr)){
                            temp1->end_breakpoint_enable = 1;
                            return 0;
                    }
                temp1 = temp1->next;
        }

        if(ctx->dbg->breakpoint_count == MAX_BREAKPOINTS){
                return -1;
        }

        while(temp->next != NULL){
                temp = temp->next;
        }

        temp->next = alloc_breakpoint_info();
        if(temp->next == NULL){
                return -1;
        }

        ctx->dbg->total_breakpoints = ctx->dbg->total_breakpoints + 1;
        ctx->dbg->breakpoint_count = ctx->dbg->breakpoint_count + 1;
        temp->next->num = ctx->dbg->total_breakpoints;
        temp->next->addr = (u64)addr;
        temp->next->next = NULL;
        temp->next->end_breakpoint_enable = flag;
        *(unsigned char*)addr = INT3_OPCODE;
}
return 0;
}

/*
 * called from debuggers context
 */
int do_remove_breakpoint(struct exec_context *ctx, void *addr)
{
        //Your code

        if(ctx == NULL || ctx->dbg == NULL){
                return -1;
        }

        struct breakpoint_info* temp = ctx->dbg->head;

        if(temp->addr == (u64)addr){
                ctx->dbg->head = temp->next;
                *(unsigned char*)addr = PUSHRBP_OPCODE;
                free_breakpoint_info(temp);
                ctx->dbg->breakpoint_count = ctx->dbg->breakpoint_count - 1;
                return 0;
        }
        else{
                int found = 0;

                while(temp->next != NULL){
                        if(temp->next->addr == (u64)addr){
                                found = 1;
                                struct breakpoint_info* temp2 = temp->next;
                                temp->next = temp2->next;
                                free_breakpoint_info(temp2);
                                *(unsigned char*)addr = PUSHRBP_OPCODE;
                                ctx->dbg->breakpoint_count = ctx->dbg->breakpoint_count -1;
                        }
                }
                
                if(found == 0){
                        return -1;
                }
        }
}


/*
 * called from debuggers context
 */

int do_info_breakpoints(struct exec_context *ctx, struct breakpoint *ubp)
{

        // Your code

        if(ctx == NULL || ubp == NULL){
                return NULL;
        }

        struct breakpoint_info* temp = ctx->dbg->head;
        int index = 0;

        while(temp != NULL){
                ubp[index].addr = temp->addr;
                ubp[index].num = temp->num;
                ubp[index].end_breakpoint_enable = temp->end_breakpoint_enable;
            index++;
            temp = temp->next;
    }
    return index;
}


/*
* called from debuggers context
*/
int do_info_registers(struct exec_context *ctx, struct registers *regs)
{
    // Your code

    if(ctx == NULL || regs == NULL || ctx->dbg == NULL){
            return -1;
    }

    *regs = ctx->dbg->child_regs_info;

    return 0;
}

/*
* Called from debuggers context
*/
int do_backtrace(struct exec_context *ctx, u64 bt_buf)
{

    // Your code

    if(ctx == NULL || ctx->dbg == NULL){
            return -1;
    }

    u64 *arr = (u64 *)bt_buf;
    int count = 0;

    while(ctx->dbg->backtrace[count] != 0){
            arr[count] = ctx->dbg->backtrace[count];
            count++;
    }
    return count;
}

/*
* When the debugger calls wait
* it must move to WAITING state
* and its child must move to READY state
*/

s64 do_wait_and_continue(struct exec_context *ctx)
{
    // Your code

    if(ctx == NULL || ctx->dbg == NULL){
            return -1;
    }

    struct exec_context* child = NULL;
    struct exec_context* temp = NULL;

    for(int i=0;i<=MAX_PROCESSES;i++){
            temp = get_ctx_by_pid(i);
            if(temp != NULL && temp->ppid == ctx->pid){
                    child = temp;
                    break;
            }
    }

    if(child == NULL || ctx->regs.rax == CHILD_EXIT){
            return CHILD_EXIT;
    }

    ctx->state = WAITING;
    child->state = READY;

    schedule(child);
}
