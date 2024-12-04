const std = @import("std");
const input: []const u8 = @embedFile("data/day04.txt");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var part1: usize = 0;
    var part2: usize = 0;
    for (0.., input) |idx, char|  {
        if (char == 'X') part1 += xmas(idx);
        if (char == 'A' and x_mas(idx)) part2 += 1;
    }

    try stdout.print("Part one answer: {d}\n", .{part1});
    try stdout.print("Part two answer: {d}\n", .{part2});
}

fn xmas(idx: usize) u8 {
    var sum: u8 = 0;
    if (rel(idx, 0, 1) == 'M' and rel(idx, 0, 2) == 'A' and rel(idx, 0, 3) == 'S') sum += 1;
    if (rel(idx, 1, 1) == 'M' and rel(idx, 2, 2) == 'A' and rel(idx, 3, 3) == 'S') sum += 1;
    if (rel(idx, 1, 0) == 'M' and rel(idx, 2, 0) == 'A' and rel(idx, 3, 0) == 'S') sum += 1;
    if (rel(idx, 1, -1) == 'M' and rel(idx, 2, -2) == 'A' and rel(idx, 3, -3) == 'S') sum += 1;
    if (rel(idx, 0, -1) == 'M' and rel(idx, 0, -2) == 'A' and rel(idx, 0, -3) == 'S') sum += 1;
    if (rel(idx, -1, -1) == 'M' and rel(idx, -2, -2) == 'A' and rel(idx, -3, -3) == 'S') sum += 1;
    if (rel(idx, -1, 0) == 'M' and rel(idx, -2, 0) == 'A' and rel(idx, -3, 0) == 'S') sum += 1;
    if (rel(idx, -1, 1) == 'M' and rel(idx, -2, 2) == 'A' and rel(idx, -3, 3) == 'S') sum += 1;
    return sum;
}

fn x_mas(idx: usize) bool {
    var valid = true;
    const tr = rel(idx, 1, 1);
    const tl = rel(idx, -1, 1);
    const br = rel(idx, 1, -1);
    const bl = rel(idx, -1, -1);
    if (tr != 'M' and tr != 'S') valid = false;
    if (tl != 'M' and tl != 'S') valid = false;
    if (br != 'M' and br != 'S') valid = false;
    if (bl != 'M' and bl != 'S') valid = false;
    if (tr == bl) valid = false;
    if (tl == br) valid = false;
    return valid;
}

fn rel(idx: usize, x: isize, y: isize) ?u8 {
    const i: isize = @intCast(idx);
    const absolute: isize = i + (y * 141) + x;
    if (absolute < 0 or absolute >= input.len) return null;
    return input[@intCast(absolute)];
}
