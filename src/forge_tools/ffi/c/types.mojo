"""C POSIX types."""

# ===----------------------------------------------------------------------=== #
# Base Types
# ===----------------------------------------------------------------------=== #


struct C:
    """C types. This assumes that the platform is 32 or 64 bit, and char is
    always 8 bit (POSIX standard).
    """

    alias char = Int8
    """Type: `char`. The signedness of `char` is platform specific. Most
    systems, including x86 GNU/Linux and Windows, use `signed char`, but those
    based on PowerPC and ARM processors typically use `unsigned char`."""
    alias s_char = Int8
    """Type: `signed char`."""
    alias u_char = UInt8
    """Type: `unsigned char`."""
    alias short = Int16
    """Type: `short`."""
    alias u_short = UInt16
    """Type: `unsigned short`."""
    alias int = Int32
    """Type: `int`."""
    alias u_int = UInt32
    """Type: `unsigned int`."""
    alias long = Int64
    """Type: `long`."""
    alias u_long = UInt64
    """Type: `unsigned long`."""
    alias long_long = Int64
    """Type: `long long`."""
    alias u_long_long = UInt64
    """Type: `unsigned long long`."""
    alias float = Float32
    """Type: `float`."""
    alias double = Float64
    """Type: `double`."""
    alias void = Int8
    """Type: `void`."""


alias NULL = UnsafePointer[C.void]()
"""Null pointer."""


# ===----------------------------------------------------------------------=== #
# Networking Types
# ===----------------------------------------------------------------------=== #

alias sa_family_t = C.u_short
"""Type: `sa_family_t`."""
alias socklen_t = C.u_int
"""Type: `socklen_t`."""
alias in_addr_t = C.u_int
"""Type: `in_addr_t`."""
alias in_port_t = C.u_short
"""Type: `in_port_t`."""


@value
@register_passable("trivial")
struct in_addr:
    """Incoming IPv4 Socket Address."""

    var s_addr: in_addr_t
    """Source Address."""


@value
@register_passable("trivial")
struct in6_addr:
    """Incoming IPv6 Socket Address."""

    var s6_addr: StaticTuple[C.char, 16]
    """Source IPv6 Address"""


@value
@register_passable("trivial")
struct sockaddr:
    """Socket Address."""

    var sa_family: sa_family_t
    """Socket Address Family."""
    var sa_data: StaticTuple[C.char, 14]
    """Socket Address."""


@value
@register_passable("trivial")
struct sockaddr_in:
    """Incoming Socket Address."""

    var sin_family: sa_family_t
    """Socket Address Family."""
    var sin_port: in_port_t
    """Socket Address Port."""
    var sin_addr: in_addr
    """Socket Address."""
    var sin_zero: StaticTuple[C.char, 8]
    """Socket zero padding."""


@value
@register_passable("trivial")
struct sockaddr_in6:
    """Incoming IPv6 Socket Address."""

    var sin6_family: sa_family_t
    """Socket Address Family."""
    var sin6_port: in_port_t
    """Socket Address Port."""
    var sin6_flowinfo: C.u_int
    """Flow Information."""
    var sin6_addr: in6_addr
    """Socket Address."""
    var sin6_scope_id: C.u_int
    """Scope ID."""


@value
@register_passable("trivial")
struct addrinfo:
    """Address Information."""

    var ai_flags: C.int
    """Address Information Flags."""
    var ai_family: C.int
    """Address Family."""
    var ai_socktype: C.int
    """Socket Type."""
    var ai_protocol: C.int
    """Socket Protocol."""
    var ai_addrlen: socklen_t
    """Socket Address Length."""
    var ai_addr: UnsafePointer[sockaddr]
    """Address Information."""
    var ai_canonname: UnsafePointer[C.char]
    """Canon Name."""
    # FIXME: This should be UnsafePointer[addrinfo]
    var ai_next: UnsafePointer[C.void]
    """Next Address Information struct."""

    fn __init__(inout self):
        """Construct an empty addrinfo struct."""
        var p0 = UnsafePointer[sockaddr]()
        self = Self(0, 0, 0, 0, 0, p0, UnsafePointer[C.char](), NULL)


fn char_ptr_to_string(s: UnsafePointer[C.char]) -> String:
    """Create a String from a char pointer.

    Args:
        s: A pointer to a C string.

    Returns:
        The String.
    """
    return String(ptr=s.bitcast[UInt8](), len=int(strlen(s) + 1))


fn strlen(s: UnsafePointer[C.char]) -> C.u_int:
    """Libc POSIX `strlen` function.

    Args:
        s: A pointer to a C string.

    Returns:
        The length of the string.

    Notes:
        [Reference](https://man7.org/linux/man-pages/man3/strlen.3p.html).
        Fn signature: `size_t strlen(const char *s)`.
    """
    return external_call["strlen", C.u_int, UnsafePointer[C.char]](s)


# ===----------------------------------------------------------------------=== #
# File Types
# ===----------------------------------------------------------------------=== #

alias off_t = Int64
"""Type: `off_t`."""
alias mode_t = UInt32
"""Type: `mode_t`."""


@register_passable("trivial")
struct FILE:
    pass
