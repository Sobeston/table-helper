const Table = @import("table-helper.zig").Table;

const std = @import("std");

test "normal usage" {
    const t = Table(&[_][]const u8{ "Version", "Date" }){
        .data = &[_][2][]const u8{
            .{ "0.7.1", "2020-12-13" },
            .{ "0.7.0", "2020-11-08" },
            .{ "0.6.0", "2020-04-13" },
            .{ "0.5.0", "2019-09-30" },
        },
        .footer = null,
    };

    var out = std.ArrayList(u8).init(std.testing.allocator);
    defer out.deinit();
    try out.writer().print("{}", .{t});

    try std.testing.expectEqualStrings(out.items,
        \\Version Date       
        \\------- ---------- 
        \\0.7.1   2020-12-13 
        \\0.7.0   2020-11-08 
        \\0.6.0   2020-04-13 
        \\0.5.0   2019-09-30 
    );
}

test "footer usage" {
    const t = Table(&[_][]const u8{ "Language", "Files" }){
        .data = &[_][2][]const u8{
            .{ "Zig", "3" },
            .{ "Python", "2" },
        },
        .footer = [2][]const u8{ "Total", "5" },
    };

    var out = std.ArrayList(u8).init(std.testing.allocator);
    defer out.deinit();
    try out.writer().print("{}", .{t});

    try std.testing.expectEqualStrings(out.items,
        \\Language Files 
        \\-------- ----- 
        \\Zig      3     
        \\Python   2     
        \\-------- ----- 
        \\Total    5     
    );
}
