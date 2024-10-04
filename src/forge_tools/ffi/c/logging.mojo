"""Libc POSIX logging syscalls."""

from sys.ffi import external_call, DLHandle
from sys.info import os_is_windows
from memory import UnsafePointer, stack_allocation, memcpy
from .types import *


fn get_errno() -> C.int:
    """Get a copy of the current value of the `errno` global variable.

    Returns:
        A copy of the current value of `errno`.
    """
    var errno = stack_allocation[1, C.int]()

    @parameter
    if os_is_windows():
        _ = external_call[
            "_get_errno", UnsafePointer[C.void], UnsafePointer[C.int]
        ](errno)
    else:
        var ptr = external_call["__errno_location", UnsafePointer[C.int]]()
        memcpy(errno, ptr, 1)

    return errno[0]


fn set_errno(errnum: C.int):
    """Set the `errno` global variable."""

    @parameter
    if os_is_windows():
        _ = external_call["_set_errno", C.int, C.int](errnum)
    else:
        external_call[
            "__errno_location", UnsafePointer[C.int]
        ]().init_pointee_copy(errnum)


fn strerror(errnum: C.int) -> UnsafePointer[C.char]:
    """Libc POSIX `strerror` function.

    Args:
        errnum: The number of the error.

    Returns:
        A Pointer to the error message.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/strerror.3.html).
        Fn signature: `char *strerror(int errnum)`.
    """
    return external_call["strerror", UnsafePointer[C.char], C.int](errnum)


fn perror(s: UnsafePointer[C.char]):
    """Libc POSIX `perror` function.

    Args:
        s: The string to print in front of the error message.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/perror.3.html).
        Fn signature: `char *perror(int errnum)`.
    """
    _ = external_call["perror", C.void, UnsafePointer[C.char]](s)


fn openlog(ident: UnsafePointer[C.char], logopt: C.int, facility: C.int):
    """Libc POSIX `openlog` function.

    Args:
        ident: A File Descriptor to open the file with.
        logopt: An offset to seek to.
        facility: Arguments for the format string.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/closelog.3p.html).
        Fn signature: `void openlog(const char *ident, int logopt,
            int facility)`.
    """
    _ = external_call["openlog", C.void, UnsafePointer[C.char], C.int, C.int](
        ident, logopt, facility
    )


# FIXME: this should take in  *args: *T
fn syslog(priority: C.int, message: UnsafePointer[C.char]):
    """Libc POSIX `syslog` function.

    Args:
        priority: A File Descriptor to open the file with.
        message: An offset to seek to.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/closelog.3p.html).
        Fn signature: `void syslog(int priority, const char *message,
            ... /* arguments */)`.
    """
    _ = external_call["syslog", C.void, C.int, UnsafePointer[C.char]](
        priority, message
    )


fn setlogmask(maskpri: C.int) -> C.int:
    """Libc POSIX `setlogmask` function.

    Args:
        maskpri: A File Descriptor to open the file with.

    Returns:
        The previous log priority mask.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/closelog.3p.html).
        Fn signature: ` int setlogmask(int maskpri)`.
    """
    return external_call["setlogmask", C.int, C.int](maskpri)


fn closelog():
    """Libc POSIX `closelog` function.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/closelog.3p.html).
        Fn signature: `void closelog(void)`.
    """
    _ = external_call["closelog", C.void]()