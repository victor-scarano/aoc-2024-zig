const std = @import("std");
const input: []const u8 = @embedFile("data/day06.txt");

const Guard = struct {
    pos: Pos,
    xdir: i8,
    ydir: i8,

    inline fn init(x: u8, y: u8) @This() {
        const pos = Pos.init(x, y);
        return @This() { .pos = pos, .xdir = 0, .ydir = 1 };
    }

    inline fn move(self: *@This()) ?Pos {
        const forward = self.pos.rel(self.xdir, self.ydir) orelse return null;
        if (forward.charAt() == '#') { self.rotate(); }
        else { self.pos = forward; }
        return self.pos;
    }

    inline fn rotate(self: *@This()) void {
        const xdir = self.xdir;
        const ydir = self.ydir;

        self.xdir = ydir;
        self.ydir = -xdir;
    }
};

const Pos = struct {
    x: u8,
    y: u8,

    inline fn init(x: u8, y: u8) @This() {
        return @This() { .x = x, .y = y };
    }

    inline fn rel(self: @This(), x: i8, y: i8) ?@This() {
        const xo = @as(i16, self.x) + @as(i16, x);
        const yo = @as(i16, self.y) - @as(i16, y);

        if (xo >= 130 or yo >= 130) return null;

        const xc = std.math.cast(u8, xo) orelse return null;
        const yc = std.math.cast(u8, yo) orelse return null;

        return @This().init(xc, yc);
    }

    inline fn charAt(self: @This()) u8 {
        const index = (@as(usize, self.y) * 131) + @as(usize, self.x);
        return input[index];
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var set = std.AutoHashMap(Pos, void).init(allocator);
    defer set.deinit();

    var guard = Guard.init(56, 54);
    _ = try set.getOrPut(guard.pos);

    while (guard.move()) |pos| _ = try set.getOrPut(pos);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("Part one answer: {d}\n", .{set.count()});
}

