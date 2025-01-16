const std = @import("std");
const c_string = @cImport({
    @cInclude("c_string.h");
});

pub fn main() !void {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.io.getStdOut().writer().print("Buffer is: {s}, Length is: {d}\n", .{ buffer.*.text, buffer.*.length });
}

pub fn toZigStr(input: [*c]u8) []u8 {
    return std.mem.span(input);
}

test "creates a string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.testing.expectEqualStrings("hello world", toZigStr(buffer.*.text));
}
