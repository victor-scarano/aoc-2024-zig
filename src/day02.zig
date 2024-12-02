const std = @import("std");
const data = @embedFile("data/day02.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var valid_reports: u16 = 0;

    var reports = std.mem.splitScalar(u8, data, '\n');
    while (reports.next()) |report| {
        var levels = std.mem.splitScalar(u8, report, ' ');

        var inc: u8 = 0;
        var dec: u8 = 0;
        var eq: u8 = 0;
        var gap: u8 = 0;

        var prev = std.fmt.parseInt(i16, levels.first(), 10) catch break;

        while (levels.next()) |level| {
            const curr = std.fmt.parseInt(i16, level, 10) catch break;

            if (prev == curr) {
                eq += 1;
            } else if (prev < curr) {
                inc += 1;
            } else {
                dec += 1;
            }

            if (@abs(prev - curr) > 3) {
                gap += 1;
            }

            prev = curr;
        }

        if (@min(inc, dec) + eq + gap == 0) {
            valid_reports += 1;
        } else {
            // check whats wrong with these
            try stdout.print("{} | {} | {} | {s}\n", .{ @min(inc, dec), eq, gap, report });
        }
    }

    try stdout.print("Part one: {}.\n", .{valid_reports});
}
