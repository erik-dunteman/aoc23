const std = @import("std");

fn isDigit(i: u8) bool {
    return (i - '0' >= 0 and i - '0' < 10);
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
        }

        std.debug.print("should be {d}{d}\n\n", .{ firstDigit, lastDigit });
        sum += (10 * firstDigit) + lastDigit;
    }

    std.debug.print("Sum {d}\n", .{sum});
}
