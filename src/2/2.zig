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

    var sum: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
        var it = std.mem.split(u8, line, ": ");

        var id: u16 = undefined;
        if (it.next()) |game_id| {
            id = try std.fmt.parseInt(u16, game_id[5..], 10);
        }

        var min_red: u32 = 0;
        var min_green: u32 = 0;
        var min_blue: u32 = 0;

        if (it.next()) |game_vals| {
            // parse out sets
            var sets = std.mem.split(u8, game_vals, "; ");
            while (sets.next()) |set| {
                // std.debug.print("{s}\n", .{set});
                const blues = parseQuantity(set, "blue");
                const reds = parseQuantity(set, "red");
                const greens = parseQuantity(set, "green");

                if (blues > min_blue) {
                    min_blue = blues;
                }
                if (reds > min_red) {
                    min_red = reds;
                }
                if (greens > min_green) {
                    min_green = greens;
                }
            }
        }

        std.debug.print("min_red {d} min_green {d} min_blue {d}\n", .{ min_red, min_green, min_blue });
        const power: u32 = min_red * min_green * min_blue;
        std.debug.print("power {d}\n", .{power});
        sum += power;
    }

    std.debug.print("\nsum {}\n", .{sum});
}
