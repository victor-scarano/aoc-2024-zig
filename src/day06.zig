const std = @import("std");
const input: []const u8 = @embedFile("inputs/day06.txt");

const Guard = struct {
    pos: Pos,
    dir: Dir,

    inline fn init(x: u8, y: u8) Guard {
        const pos = Pos.init(x, y);
        const dir = Dir.init();
        return Guard { .pos = pos, .dir = dir };
    }

    inline fn next(self: *Guard) ?Guard {
        const forward = self.pos.offset(self.dir) orelse return null;
        if (forward.isObstacle()) self.dir.rotate() else self.pos = forward;
        return self.*;
    }

    inline fn nextNoTurn(self: *Guard) ?Guard {
        const forward = self.pos.offset(self.dir) orelse return null;
        if (forward.isObstacle()) return null else self.pos = forward;
        return self.*;
    }

    inline fn nextWithObstacle(self: *Guard, obstacle: Pos) ?Guard {
        const forward = self.pos.offset(self.dir) orelse return null;
        if (forward.isObstacle() or forward == obstacle) self.dir.rotate() else self.pos = forward;
        return self.*;
    }
};

const Pos = packed struct {
    x: u8,
    y: u8,

    inline fn init(x: u8, y: u8) Pos {
        return Pos { .x = x, .y = y };
    }

    inline fn offset(self: Pos, dir: Dir) ?Pos {
        const xo = @as(i16, self.x) + @as(i16, dir.x);
        const yo = @as(i16, self.y) - @as(i16, dir.y);

        if (xo >= 130 or yo >= 130) return null;
        // if (xo >= 10 or yo >= 10) return null;

        const xc = std.math.cast(u8, xo) orelse return null;
        const yc = std.math.cast(u8, yo) orelse return null;

        return Pos.init(xc, yc);
    }

    inline fn isObstacle(self: Pos) bool {
        const index = (@as(usize, self.y) * 131) + @as(usize, self.x);
        // const index = (@as(usize, self.y) * 11) + @as(usize, self.x);
        return input[index] == '#';
    }
};

const Dir = packed struct {
    x: i2,
    y: i2,

    inline fn init() Dir {
        return Dir { .x = 0, .y = 1 };
    }

    inline fn rotate(self: *Dir) void {
        const x = self.x;
        const y = self.y;

        self.x = y;
        self.y = -x;
    }
};

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var visited = std.AutoHashMap(Pos, void).init(allocator);
    defer visited.deinit();

    // var guard = Guard.init(4, 6);
    var guard = Guard.init(56, 54);
    try visited.put(guard.pos, {});

    while (guard.next()) |curr| try visited.put(curr.pos, {});

    try stdout.print("Part one answer: {d}\n", .{ visited.count() });

    var phantomGuard = Guard.init(56, 54);
    _ = visited.remove(phantomGuard.pos);

    while (phantomGuard.nextNoTurn()) |curr|  _ = visited.remove(curr.pos);

    var obstacles: u16 = 0;

    var iterator = visited.keyIterator();
    var remaining: usize = iterator.len();
    while (iterator.next()) |obstacle| {
        var testVisited = std.AutoHashMap(Pos, std.AutoHashMap(Dir, void)).init(allocator);
        defer testVisited.deinit();

        var testGuard = Guard.init(56, 54);
        const entry = try testVisited.getOrPutValue(testGuard.pos, std.AutoHashMap(Dir, void).init(allocator));
        try entry.value_ptr.put(testGuard.dir, {});

        var foundExisting: u16 = 0;
        while (testGuard.nextWithObstacle(obstacle.*)) |curr| {
            const entry1 = try testVisited.getOrPutValue(curr.pos, std.AutoHashMap(Dir, void).init(allocator));
            const result = try entry1.value_ptr.getOrPut(curr.dir);
            if (result.found_existing) foundExisting += 1;
            if (foundExisting > 2) {
                obstacles += 1;
                try stdout.print("found a looping obstacle\n", .{});
                break;
            }
        }
        remaining -= 1;
        try stdout.print("finished simulating an obstacle, {} remaining\n", .{ remaining });
    }

    try stdout.print("Part two answer: {d}\n", .{ obstacles });
}

