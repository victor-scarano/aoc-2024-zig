const std = @import("std");
const rules = std.mem.splitScalar(u8, @embedFile("data/day05-1.txt"), '\n');
const updates = @embedFile("data/day05-2.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var map = std.AutoHashMap(u8, std.ArrayList(u8)).init(allocator);
    while (rules.next()) |rule| {
        const ops = std.mem.splitScalar(u8, rule, '|');
        const before = ops.next().?;
        const after = ops.next().?;
        const entry = try map.getOrPutValue(before, std.ArrayList(u8).init(allocator));
        entry.value_ptr.append(after);
    }

    var ordered = std.ArrayList(u8).init(allocator);
    var iter = map.iterator();
    while (iter.next()) |entry| {
        
    }
}

