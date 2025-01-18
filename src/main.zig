const std = @import("std");
const c_string = @cImport({
    @cInclude("c_string.h");
});

pub fn main() !void {}

pub fn toZigStr(input: [*c]u8) []u8 {
    return std.mem.span(input);
}

test "creates a string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.testing.expectEqualStrings("hello world", toZigStr(buffer.*.text));
    try std.testing.expectEqual(11, buffer.*.length);
}

test "creates an empty string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "");

    try std.testing.expectEqualStrings("", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 0);
    try std.testing.expect(buffer.*.isValid);
}

test "frees a string" {
    var buffer: [*c]c_string.String = undefined;

    buffer = c_string.cstring_create(buffer, "hello world");

    try std.testing.expectEqualStrings("hello world", toZigStr(buffer.*.text));

    c_string.cstring_free(buffer);
}

test "checks if strings are equal" {
    var buffer_1: [*c]c_string.String = undefined;

    buffer_1 = c_string.cstring_create(buffer_1, "test string");

    var buffer_2: [*c]c_string.String = undefined;

    buffer_2 = c_string.cstring_create(buffer_2, buffer_1.*.text);

    try std.testing.expect(c_string.cstring_equals(buffer_1, buffer_2));
}

test "concatenation of a single string" {
    var buffer_1: [*c]c_string.String = undefined;
    buffer_1 = c_string.cstring_create(buffer_1, "hello");

    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 1, buffer_1);

    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expect(buffer.*.isValid);
}

test "concatenation of no strings" {
    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 0, @as([*c]c_string.String, null));

    try std.testing.expectEqualStrings("", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 0);
    try std.testing.expect(buffer.*.isValid);
}

test "concatenation of multiple strings" {
    var buffer_1: [*c]c_string.String = undefined;
    buffer_1 = c_string.cstring_create(buffer_1, "hello");

    var buffer_2: [*c]c_string.String = undefined;
    buffer_2 = c_string.cstring_create(buffer_2, "world");

    var buffer_3: [*c]c_string.String = undefined;
    buffer_3 = c_string.cstring_create(buffer_3, "bye");

    var buffer: [*c]c_string.String = undefined;
    buffer = c_string.cstring_concat(buffer, 3, buffer_1, buffer_2, buffer_3);

    try std.testing.expectEqualStrings("helloworldbye", toZigStr(buffer.*.text));
    try std.testing.expect(buffer.*.length == 13);
    try std.testing.expect(buffer.*.isValid);
}

test "splits a string by spaces" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello world how are you");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits a string by commas" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello,world,how,are,you");
    buffer = c_string.cstring_split(buffer, str, ',');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits a string by tabs" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello\tworld\thow\tare\tyou");
    buffer = c_string.cstring_split(buffer, str, '\t');

    try std.testing.expect(buffer.*.length == 5);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
    try std.testing.expectEqualStrings("world", toZigStr(buffer.*.strings[1].*.text));
    try std.testing.expectEqualStrings("how", toZigStr(buffer.*.strings[2].*.text));
    try std.testing.expectEqualStrings("are", toZigStr(buffer.*.strings[3].*.text));
    try std.testing.expectEqualStrings("you", toZigStr(buffer.*.strings[4].*.text));
}

test "splits only 1 word" {
    var buffer: [*c]c_string.StringList = undefined;
    var str: [*c]c_string.String = undefined;

    str = c_string.cstring_create(str, "hello");
    buffer = c_string.cstring_split(buffer, str, ' ');

    try std.testing.expect(buffer.*.length == 1);
    try std.testing.expectEqualStrings("hello", toZigStr(buffer.*.strings[0].*.text));
}
