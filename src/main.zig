const std = @import("std");

fn string_sanitizer(string_list: *std.ArrayList(u8)) void {
    const ascii_checker = std.ascii;
    var curr_ind: u8 = 0; //used for inserting items

    //loop for checking for valid characters
    for (string_list.*.items) |char| {
        if (ascii_checker.isAlphanumeric(char)) {
            string_list.*.items[curr_ind] = char;
            curr_ind += 1;
        } else {
            switch (char) {
                //looking for basic operators.
                '/', '+', '-', '=', '^', '*', '.' => {
                    string_list.*.items[curr_ind] = char;
                    curr_ind += 1;
                },
                //skips unnecessary characters.
                else => {},
            }
        }
    }

    //removes unneeded characters
    while (curr_ind < string_list.*.items.len) : (curr_ind += 1) {
        string_list.*.items[curr_ind] = ' ';
    }
}

fn loop_logic(user_input: *const []u8) ![]u8 {
    const ArrayList = @import("std").ArrayList;
    var gpa = @import("std").heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var math_equation = ArrayList(u8).init(allocator);
    try math_equation.appendSlice(user_input.*);

    string_sanitizer(&math_equation);

    return math_equation.toOwnedSlice();
}

pub fn main() !void {
    const stdin = @import("std").io.getStdIn();
    const stdout = @import("std").io.getStdOut();
    const equality = @import("std").mem.eql;

    // Not sure if I might need more buffer space
    var buffer: [128]u8 = undefined;
    var loop_checker = true;
    while (loop_checker) {
        try stdout.writer().print(
            "Input << ",
            .{},
        );
        const user_input = &(try stdin.reader().readUntilDelimiterOrEof(&buffer, '\n')).?;
        const allocated = try loop_logic(user_input);
        try stdout.writer().print(
            "GPA Test:\n{s}\n",
            .{allocated},
        );
        if (equality(u8, allocated, "STOP")) {
            loop_checker = false;
        }
    }
}
