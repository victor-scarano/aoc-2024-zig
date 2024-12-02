const std = @import("std");
const data = @embedFile("data/day02.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var valid_reports: u16 = 0;
    var reports = std.mem.splitScalar(u8, data, '\n');
    while (reports.next()) |report| {
        var levels = std.mem.splitScalar(u8, report, ' ');
        var last = std.fmt.parseInt(i16, levels.first(), 10) catch break;
        const increasing = last < try std.fmt.parseInt(i16, levels.peek().?, 10);
        const is_valid = while (levels.next()) |slice| {
            const curr = std.fmt.parseInt(i16, slice, 10) catch break false;
            if ((last == curr) or (increasing != (last < curr)) or (@abs(last - curr) > 3)) {
                break false;
            }
            last = curr;
        } else true;

        if (is_valid) {
            valid_reports += 1;
            try stdout.print("VALID REPORT: {s}\n", .{report});
        } else {
            try stdout.print("INVALID REPORT: {s}\n", .{report});
        }
    }
    try stdout.print("Part one: {}.\n", .{valid_reports});
}

