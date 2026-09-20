#include <errno.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>

int ante_socket_tcp_ipv4(void) {
    return socket(AF_INET, SOCK_STREAM, 0);
}

int ante_socket_set_reuse_address(int socket_fd) {
    int enabled = 1;

    return setsockopt(
        socket_fd,
        SOL_SOCKET,
        SO_REUSEADDR,
        &enabled,
        sizeof(enabled)
    );
}

int ante_socket_bind_any_ipv4(int socket_fd, uint16_t port) {
    struct sockaddr_in address;
    memset(&address, 0, sizeof(address));

#ifdef __APPLE__
    address.sin_len = sizeof(address);
#endif

    address.sin_family = AF_INET;
    address.sin_port = htons(port);
    address.sin_addr.s_addr = htonl(INADDR_ANY);

    return bind(
        socket_fd,
        (struct sockaddr *)&address,
        sizeof(address)
    );
}

int ante_socket_listen(int socket_fd, int backlog) {
    return listen(socket_fd, backlog);
}

int ante_socket_accept(int socket_fd) {
    return accept(socket_fd, NULL, NULL);
}

ssize_t ante_socket_receive(int socket_fd, void *buffer, size_t length) {
    return recv(socket_fd, buffer, length, 0);
}

ssize_t ante_socket_send(int socket_fd, const void *buffer, size_t length) {
    return send(socket_fd, buffer, length, 0);
}

int ante_socket_close(int socket_fd) {
    return close(socket_fd);
}

int ante_socket_errno(void) {
    return errno;
}
