const std = @import("std");
const input = @embedFile("inputs/day01.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var left_list = std.ArrayList(u32).init(allocator);
    var right_list = std.ArrayList(u32).init(allocator);

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var entries = std.mem.tokenizeScalar(u8, line, ' ');
        try left_list.append(try std.fmt.parseInt(u32, entries.next().?, 10));
        try right_list.append(try std.fmt.parseInt(u32, entries.next().?, 10));
    }

    std.mem.sortUnstable(u32, left_list.items, {}, std.sort.asc(u32));
    std.mem.sortUnstable(u32, right_list.items, {}, std.sort.asc(u32));

    var sum: u64 = 0;

    for (left_list.items, right_list.items) |left, right| {
        const l: i32 = @intCast(left);
        const r: i32 = @intCast(right);
        sum += @abs(l - r);
    }

    try stdout.print("Part one: {}.\n", .{sum});

    var similarity: u32 = 0;

    for (left_list.items) |left| {
        var occurrences: u32 = 0;

        for (right_list.items) |right| {
            if (left == right) {
                occurrences += 1;
            }
        }

        similarity += left * occurrences;
    }

    try stdout.print("Part two: {}.\n", .{similarity});
}
