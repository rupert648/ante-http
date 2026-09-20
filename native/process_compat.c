#include <sys/wait.h>

int ante_process_wnohang(void) {
    return WNOHANG;
}
