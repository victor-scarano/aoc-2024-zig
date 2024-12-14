const std = @import("std");
const builtin = @import("builtin");

const required_zig_version = std.SemanticVersion.parse("0.13.0") catch unreachable;
pub fn build(b: *std.Build) void {
    if (comptime builtin.zig_version.order(required_zig_version) == .lt) {
        std.debug.print("zig 0.13.0+ is required", .{});
        std.os.exit(1);
    }

    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    // set up an executable for each day
    var day: u8 = 1;
    while (day <= 25) : (day += 1) {
        const dayString = b.fmt("day{:0>2}", .{ day });
        const zigFile = b.fmt("src/{s}.zig", .{ dayString });

        const exe = b.addExecutable(.{
            .name = dayString,
            .root_source_file = b.path(zigFile),
            .target = target,
            .optimize = mode,
        });

        const run_cmd = b.addRunArtifact(exe);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_desc = b.fmt("Run {s}", .{dayString});
        const run_step = b.step(dayString, run_desc);
        run_step.dependOn(&run_cmd.step);
    }
}
