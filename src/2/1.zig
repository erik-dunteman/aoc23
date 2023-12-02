const std = @import("std");

fn parseQuantity(str: []const u8, ident: []const u8) u8 {
    var set_it = std.mem.split(u8, str, ",");
    while (set_it.next()) |color_item| {
        var color_it = std.mem.split(u8, color_item, ident);
        // there will be two items if ident is found
        const count_str = color_it.next();
        if (color_it.next()) |_| {
            if (count_str) |c| {
                const stripped = std.mem.trim(u8, c, " ");
                const parsed = std.fmt.parseInt(u8, stripped, 10) catch 0;
                return parsed;
            }
        }
    }
    return 0;
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

    const max_red: u8 = 12;
    const max_green: u8 = 13;
    const max_blue: u8 = 14;

    var sum: u16 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
        var it = std.mem.split(u8, line, ": ");

        var id: u16 = undefined;
        if (it.next()) |game_id| {
            id = try std.fmt.parseInt(u16, game_id[5..], 10);
        }

        var valid_game = true;
        if (it.next()) |game_vals| {
            // parse out sets
            var sets = std.mem.split(u8, game_vals, "; ");
            while (sets.next()) |set| {
                // std.debug.print("{s}\n", .{set});
                const blues = parseQuantity(set, "blue");
                const reds = parseQuantity(set, "red");
                const greens = parseQuantity(set, "green");

                if (blues > max_blue or reds > max_red or greens > max_green) {
                    valid_game = false;
                    break;
                }
            }
        }
        if (valid_game) {
            std.debug.print("{d} valid\n", .{id});
            sum += id;
        } else {
            std.debug.print("{d} invalid\n", .{id});
        }
    }

    std.debug.print("\nsum {}\n", .{sum});
}
