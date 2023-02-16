const std = @import("std");
const ecs = @import("zflecs.zig");

const expect = std.testing.expect;

const Position = struct { x: f32, y: f32 };
const Walking = struct {};
const Direction = enum { north, south, east, west };

test "zflecs.entities.basics" {
    std.debug.print("\n", .{});

    const world = ecs.init();
    defer _ = ecs.fini(world);

    ecs.COMPONENT(world, Position);
    ecs.COMPONENT(world, Position);
    ecs.TAG(world, Walking);

    const bob = ecs.set_name(world, 0, "Bob");

    _ = ecs.set(world, bob, Position, .{ .x = 10, .y = 20 });
    ecs.add(world, bob, Walking);

    const ptr = ecs.get(world, bob, Position).?;
    std.debug.print("({d}, {d})\n", .{ ptr.x, ptr.y });

    _ = ecs.set(world, bob, Position, .{ .x = 20, .y = 30 });

    const alice = ecs.set_name(world, 0, "Alice");
    _ = ecs.set(world, alice, Position, .{ .x = 10, .y = 20 });
    ecs.add(world, alice, Walking);

    const str = ecs.type_str(world, ecs.get_type(world, alice));
    defer ecs.os_free(str);
    std.debug.print("[{s}]\n", .{str});

    ecs.remove(world, alice, Walking);
}

test "zflecs.basic" {
    std.debug.print("\n", .{});

    const world = ecs.init();
    defer _ = ecs.fini(world);

    try expect(ecs.is_fini(world) == false);

    ecs.dim(world, 100);

    const e0 = ecs.entity_init(world, &.{ .name = "aaa" });
    try expect(e0 != 0);
    try expect(ecs.is_alive(world, e0));
    try expect(ecs.is_valid(world, e0));

    const e1 = ecs.new_id(world);
    try expect(ecs.is_alive(world, e1));
    try expect(ecs.is_valid(world, e1));

    _ = ecs.clone(world, e1, e0, false);
    try expect(ecs.is_alive(world, e1));
    try expect(ecs.is_valid(world, e1));

    ecs.delete(world, e1);
    try expect(!ecs.is_alive(world, e1));
    try expect(!ecs.is_valid(world, e1));

    try expect(ecs.table_str(world, null) == null);

    ecs.COMPONENT(world, *const Position);
    ecs.COMPONENT(world, ?*const Position);
    ecs.COMPONENT(world, *Position);
    ecs.COMPONENT(world, Position);
    ecs.COMPONENT(world, ?*const Position);
    ecs.COMPONENT(world, Direction);
    ecs.COMPONENT(world, f64);
    ecs.COMPONENT(world, u31);
    ecs.COMPONENT(world, u32);
    ecs.COMPONENT(world, f32);
    ecs.COMPONENT(world, f64);
    ecs.COMPONENT(world, i8);
    ecs.COMPONENT(world, ?*const i8);

    ecs.TAG(world, Walking);

    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(*const Position)), ecs.id(*const Position) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(?*const Position)), ecs.id(?*const Position) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(*Position)), ecs.id(*Position) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(Position)), ecs.id(Position) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(Direction)), ecs.id(Direction) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(Walking)), ecs.id(Walking) });
    std.debug.print("{?s} id: {d}\n", .{ ecs.id_str(world, ecs.id(u31)), ecs.id(u31) });

    const p: Position = .{ .x = 1.0, .y = 2.0 };
    _ = ecs.set(world, e0, *const Position, &p);
    _ = ecs.set(world, e0, ?*const Position, null);
    _ = ecs.set(world, e0, Position, .{ .x = 1.0, .y = 2.0 });
    _ = ecs.set(world, e0, Direction, .west);
    _ = ecs.set(world, e0, u31, 123);
    _ = ecs.set(world, e0, u31, 1234);
    _ = ecs.set(world, e0, u32, 987);

    ecs.add(world, e0, Walking);

    try expect(ecs.get(world, e0, u31).?.* == 1234);
    try expect(ecs.get(world, e0, u32).?.* == 987);
    try expect(ecs.get(world, e0, ?*const Position).?.* == null);
    try expect(ecs.get(world, e0, *const Position).?.* == &p);
    if (ecs.get(world, e0, Position)) |pos| {
        try expect(pos.x == p.x and pos.y == p.y);
    }

    const e0_type_str = ecs.type_str(world, ecs.get_type(world, e0));
    defer ecs.os_free(e0_type_str);

    const e0_table_str = ecs.table_str(world, ecs.get_table(world, e0));
    defer ecs.os_free(e0_table_str);

    const e0_str = ecs.entity_str(world, e0);
    defer ecs.os_free(e0_str);

    std.debug.print("type str: {s}\n", .{e0_type_str});
    std.debug.print("table str: {?s}\n", .{e0_table_str});
    std.debug.print("entity str: {?s}\n", .{e0_str});

    {
        const str = ecs.type_str(world, ecs.get_type(world, ecs.id(Position)));
        defer ecs.os_free(str);
        std.debug.print("{s}\n", .{str});
    }
    {
        const str = ecs.id_str(world, ecs.id(Position));
        defer ecs.os_free(str);
        std.debug.print("{?s}\n", .{str});
    }
}
