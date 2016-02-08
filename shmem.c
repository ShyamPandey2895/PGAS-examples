#include <stdio.h>
#include <stdlib.h>

/***************************************************************/
#include <shmem.h>
int main(void) {
    shmem_init();
    if (shmem_n_pes()<2) shmem_global_exit(1);
    /* allocate from the global heap */
    int * A = shmem_malloc(sizeof(int));
    int B = 0x86;
    /* store contents of local data B at PE 0 into A at PE 1 */
    if (shmem_my_pe()==0) shmem_int_put(A,&B,1,1);
    /* global synchronization of execution and data */
    shmem_barrier_all();
    /* observe the result of the store */
    if (shmem_my_pe()==1) printf("A@1=%d\n",*A);
    shmem_free(A);
    shmem_finalize();
    return 0;
}
/***************************************************************/
