const std = @import("std");
const c_string = @cImport({
    @cInclude("c_string.h");
});

pub fn main() !void {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.io.getStdOut().writer().print("Buffer is: {s}, Length is: {d}\n", .{ buffer.*.text, buffer.*.length });
}
