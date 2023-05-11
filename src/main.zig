
fn string_sanitizer(string_list: *[]u8) !void{
    const ascii_checker = @import("std").ascii.isASCII();
    var string_index: u8 = 0;
    for (string_list) |*char| {
        if ()
    } 
}

fn loop_logic(user_input: *const []u8) ![]u8 {
    const ArrayList = @import("std").ArrayList;
    var gpa = @import("std").heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var math_equation = ArrayList(u8).init(allocator);
    try math_equation.appendSlice(user_input.*);
    


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
