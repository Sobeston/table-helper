const std = @import("std");

pub fn Table(comptime headers: []const []const u8) type {
    return struct {
        data: []const [headers.len][]const u8,
        footer: ?[headers.len][]const u8,

        const Self = @This();

        fn writeRowDelimiter(writer: anytype, max_row_len: [headers.len]usize) !void {
            inline for (headers, 0..) |header, i| {
                _ = header;
                var j: usize = max_row_len[i];
                while (j > 0) {
                    try writer.writeAll("-");
                    j -= 1;
                }
                try writer.writeAll(" ");
            }

            try writer.writeAll("\n");
        }

        fn writeRow(writer: anytype, row: []const []const u8, max_row_len: [headers.len]usize, last_row: bool) !void {
            for (row, 0..) |column, i| {
                try writer.writeAll(column);
                var k: usize = 1 + max_row_len[i] - column.len;
                while (k > 0) {
                    try writer.writeAll(" ");
                    k -= 1;
                }
            }
            if (!last_row) try writer.writeAll("\n");
        }

        pub fn format(
            self: Self,
            comptime fmt: []const u8,
            options: std.fmt.FormatOptions,
            writer: anytype,
        ) !void {
            _ = options;
            _ = fmt;
            _ = options;
            _ = fmt;
            var max_row_len = comptime blk: {
                var tmp: []const usize = &[_]usize{};
                inline for (headers) |header| {
                    tmp = tmp ++ [_]usize{header.len};
                }
                var new: [tmp.len]usize = undefined;
                std.mem.copy(usize, &new, tmp);
                break :blk new;
            };

            for (self.data) |row| {
                for (row, 0..) |col, i| {
                    if (col.len > max_row_len[i]) {
                        max_row_len[i] = col.len;
                    }
                }
            }
            if (self.footer) |footer| {
                for (footer, 0..) |col, i| {
                    if (col.len > max_row_len[i]) {
                        max_row_len[i] = col.len;
                    }
                }
            }

            try Self.writeRow(writer, headers, max_row_len, false);
            try Self.writeRowDelimiter(writer, max_row_len);

            for (self.data, 0..) |row, i| {
                const last_row = self.footer == null and i == self.data.len - 1;
                try Self.writeRow(writer, &row, max_row_len, last_row);
            }

            if (self.footer) |footer| {
                try Self.writeRowDelimiter(writer, max_row_len);
                try Self.writeRow(writer, &footer, max_row_len, true);
            }
        }
    };
}
