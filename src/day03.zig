const std = @import("std");
const data = @embedFile("data/day03.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Part one answer: {d}\n", .{part1()});
    try stdout.print("Part two answer: {d}\n", .{part2()});
}

fn part2() u32 {
    var sum: u32 = 0;
    var dos = std.mem.splitSequence(u8, data, "do()");
    while (dos.next()) |until_next_do| {
        var donts = std.mem.splitSequence(u8, until_next_do, "don't()");
        while (donts.next()) |until_next_dont| {
            var muls = std.mem.splitSequence(u8, until_next_dont, "mul(");
            while (muls.next()) |mul| {
                var end = std.mem.splitScalar(u8, mul, ')');
                var inside = std.mem.splitScalar(u8, end.first(), ',');
                const first = std.fmt.parseInt(u32, inside.next().?, 10) catch continue;
                const last = std.fmt.parseInt(u32, inside.next().?, 10) catch continue;
                if (inside.next()) |_| continue;
                sum += first * last;
            }
        }
    }
    return sum;
}

fn part1() u32 {
    var sum: u32 = 0;
    var muls = std.mem.splitSequence(u8, data, "mul(");
    while (muls.next()) |mul| {
        var end = std.mem.splitScalar(u8, mul, ')');
        var inside = std.mem.splitScalar(u8, end.first(), ',');
        const first = std.fmt.parseInt(u32, inside.next().?, 10) catch continue;
        const last = std.fmt.parseInt(u32, inside.next().?, 10) catch continue;
        if (inside.next()) |_| continue;
        sum += first * last;
    }
    return sum;
}

