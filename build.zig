const std = @import("std");

const MODULE = "table-helper";

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    _ = b.addModule(MODULE, .{
        .source_file = .{ .path = "table-helper.zig" },
    });

    const tests = b.addTest(.{ .target = target, .optimize = optimize, .root_source_file = .{ .path = "example-test.zig" } });

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);
}
