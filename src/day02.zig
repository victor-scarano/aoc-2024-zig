const std = @import("std");
const input = @embedFile("inputs/day02.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var part1: u16 = 0;

    var reports = std.mem.splitScalar(u8, input, '\n');
    while (reports.next()) |unparsed| {
        if (report_foo(unparsed)) |report| {
            _ = report;
            part1 += 1;
        } else {
            continue;
        }
    }

    try stdout.print("Part one answer: {}.\n", .{part1});
}

fn report_foo(report: []const u8) ?std.BoundedArray(i16, 12) {
    var array = try std.BoundedArray(i16, 12).init(0);

    var levels = std.mem.splitScalar(u8, report, ' ');

    var prev = try std.fmt.parseInt(i16, levels.first(), 10);

    var inc = false;
    var dec = false;

    while (levels.next()) |unparsed| {
        const curr = try std.fmt.parseInt(i16, unparsed, 10);
        try array.append(curr);

        if (@abs(prev - curr) > 3) {
            return null;
        }

        if (prev < curr) {
            inc = true;
        } else if (prev > curr) {
            dec = true;
        } else {
            return null;
        }

        prev = curr;
    }

    if (inc and dec) {
        return null;
    }

    return array;
}
