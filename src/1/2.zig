const std = @import("std");

fn isDigit(i: u8) bool {
    return (i - '0' >= 0 and i - '0' < 10);
}

fn strComp(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) {
        return false;
    }
    for (0..a.len) |i| {
        if (a[i] != b[i]) {
            return false;
        }
    }
    return true;
}

fn isNumberWord(input: []u8, pos: usize) ?u8 {
    if (pos >= input.len) {
        return null;
    }
    // zero, one, two, three, four, five, six, seven, eight, nine
    switch (input[pos]) {
        'z' => {
            if (pos + 3 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 4], "zero")) {
                return 0;
            }
        },
        'o' => {
            if (pos + 2 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 3], "one")) {
                return 1;
            }
        },
        't' => {
            // two case
            if (pos + 2 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 3], "two")) {
                return 2;
            }

            // three case
            if (pos + 4 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 5], "three")) {
                return 3;
            }
        },
        'f' => {
            // four case
            if (pos + 3 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 4], "four")) {
                return 4;
            }

            // five case
            if (pos + 3 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 4], "five")) {
                return 5;
            }
        },
        's' => {
            // six case
            if (pos + 2 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 3], "six")) {
                return 6;
            }

            // seven case
            if (pos + 4 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 5], "seven")) {
                return 7;
            }
        },
        'e' => {
            if (pos + 4 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 5], "eight")) {
                return 8;
            }
        },
        'n' => {
            if (pos + 3 >= input.len) {
                return null;
            }
            if (strComp(input[pos .. pos + 4], "nine")) {
                return 9;
            }
        },
        else => {
            return null;
        },
    }

    return null;
}

test "simple test" {

    // reads the text file into lines
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    std.debug.print("\n", .{});
    defer std.debug.print("\n", .{});

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    var sum: u16 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});

        var firstDigit: u16 = undefined;
        var lastDigit: u16 = undefined;

        // get first digit
        for (line, 0..) |char, i| {
            const charStr = line[i .. i + 1];
            if (isDigit(char)) {
                std.debug.print("first: {s}\n", .{charStr});
                firstDigit = @intCast(char - '0');
                break;
            }

            if (isNumberWord(line, i)) |digit| {
                firstDigit = @intCast(digit);
                break;
            }
        }

        // get last digit
        var i: usize = line.len;
        while (i > 0) {
            i -= 1;
            const char = line[i];
            const charStr = line[i .. i + 1];
            if (isDigit(char)) {
                std.debug.print("last: {s}\n", .{charStr});
                lastDigit = @intCast(char - '0');
                break;
            }
            if (isNumberWord(line, i)) |digit| {
                lastDigit = @intCast(digit);
                break;
            }
        }

        std.debug.print("should be {d}{d}\n\n", .{ firstDigit, lastDigit });
        sum += (10 * firstDigit) + lastDigit;
    }

    std.debug.print("Sum {d}\n", .{sum});
}
