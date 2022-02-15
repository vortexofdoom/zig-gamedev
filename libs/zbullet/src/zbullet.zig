const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

pub const World = opaque {
    pub const init = cbtWorldCreate;
    extern fn cbtWorldCreate() *const World;

    pub const deinit = cbtWorldDestroy;
    extern fn cbtWorldDestroy(world: *const World) void;

    pub const setGravity = cbtWorldSetGravity;
    extern fn cbtWorldSetGravity(world: *const World, gravity: *const [3]f32) void;

    pub const getGravity = cbtWorldGetGravity;
    extern fn cbtWorldGetGravity(world: *const World, gravity: *[3]f32) void;

    pub const stepSimulation = cbtWorldStepSimulation;
    extern fn cbtWorldStepSimulation(
        world: *const World,
        time_step: f32,
        max_sub_steps: c_int,
        fixed_time_step: f32,
    ) c_int;
};

pub const ShapeType = enum(c_int) {
    box = 0,
    sphere = 8,
};

pub const Shape = opaque {
    pub const allocate = cbtShapeAllocate;
    extern fn cbtShapeAllocate(stype: ShapeType) *const Shape;

    pub const deallocate = cbtShapeDeallocate;
    extern fn cbtShapeDeallocate(shape: *const Shape) void;

    pub const destroy = cbtShapeDestroy;
    extern fn cbtShapeDestroy(shape: *const Shape) void;

    pub const isCreated = cbtShapeIsCreated;
    extern fn cbtShapeIsCreated(shape: *const Shape) bool;

    pub const getType = cbtShapeGetType;
    extern fn cbtShapeGetType(shape: *const Shape) ShapeType;

    pub const setMargin = cbtShapeSetMargin;
    extern fn cbtShapeSetMargin(shape: *const Shape, margin: f32) void;

    pub const getMargin = cbtShapeGetMargin;
    extern fn cbtShapeGetMargin(shape: *const Shape) f32;

    pub const isPolyhedral = cbtShapeIsPolyhedral;
    extern fn cbtShapeIsPolyhedral(shape: *const Shape) bool;

    pub const isConvex2d = cbtShapeIsConvex2d;
    extern fn cbtShapeIsConvex2d(shape: *const Shape) bool;

    pub const isConvex = cbtShapeIsConvex;
    extern fn cbtShapeIsConvex(shape: *const Shape) bool;

    pub const isNonMoving = cbtShapeIsNonMoving;
    extern fn cbtShapeIsNonMoving(shape: *const Shape) bool;

    pub const isConcave = cbtShapeIsConcave;
    extern fn cbtShapeIsConcave(shape: *const Shape) bool;

    pub const isCompound = cbtShapeIsCompound;
    extern fn cbtShapeIsCompound(shape: *const Shape) bool;

    pub const calculateLocalInertia = cbtShapeCalculateLocalInertia;
    extern fn cbtShapeCalculateLocalInertia(shape: *const Shape, mass: f32, inertia: *[3]f32) void;

    pub const setUserPointer = cbtShapeSetUserPointer;
    extern fn cbtShapeSetUserPointer(shape: *const Shape, ptr: ?*anyopaque) void;

    pub const getUserPointer = cbtShapeGetUserPointer;
    extern fn cbtShapeGetUserPointer(shape: *const Shape) ?*anyopaque;

    pub const setUserIndex = cbtShapeSetUserIndex;
    extern fn cbtShapeSetUserIndex(shape: *const Shape, slot: c_int, index: c_int) void;

    pub const getUserIndex = cbtShapeGetUserIndex;
    extern fn cbtShapeGetUserIndex(shape: *const Shape, slot: c_int) c_int;
};

fn ShapeFunctions(comptime T: type) type {
    return struct {
        pub fn asShape(shape: *const T) *const Shape {
            return @ptrCast(*const Shape, shape);
        }
        pub fn deallocate(shape: *const T) void {
            shape.asShape().deallocate();
        }
        pub fn destroy(shape: *const T) void {
            shape.asShape().destroy();
        }
        pub fn isCreated(shape: *const T) bool {
            return shape.asShape().isCreated();
        }
        pub fn getType(shape: *const T) ShapeType {
            return shape.asShape().getType();
        }
        pub fn setMargin(shape: *const T, margin: f32) void {
            shape.asShape().setMargin(margin);
        }
        pub fn getMargin(shape: *const T) f32 {
            return shape.asShape().getMargin();
        }
        pub fn isPolyhedral(shape: *const T) bool {
            return shape.asShape().isPolyhedral();
        }
        pub fn isConvex2d(shape: *const T) bool {
            return shape.asShape().isConvex2d();
        }
        pub fn isConvex(shape: *const T) bool {
            return shape.asShape().isConvex();
        }
        pub fn isNonMoving(shape: *const T) bool {
            return shape.asShape().isNonMoving();
        }
        pub fn isConcave(shape: *const T) bool {
            return shape.asShape().isConcave();
        }
        pub fn isCompound(shape: *const T) bool {
            return shape.asShape().isCompound();
        }
        pub fn calculateLocalInertia(shape: *const Shape, mass: f32, inertia: *[3]f32) void {
            shape.asShape().calculateLocalInertia(shape, mass, inertia);
        }
        pub fn setUserPointer(shape: *const T, ptr: ?*anyopaque) void {
            shape.asShape().setUserPointer(ptr);
        }
        pub fn getUserPointer(shape: *const T) ?*anyopaque {
            return shape.asShape().getUserPointer();
        }
        pub fn setUserIndex(shape: *const T, slot: c_int, index: c_int) void {
            shape.asShape().setUserIndex(slot, index);
        }
        pub fn getUserIndex(shape: *const T, slot: c_int) c_int {
            return shape.asShape().getUserIndex(slot);
        }
    };
}

pub const BoxShape = opaque {
    pub fn init(half_extents: *const [3]f32) *const BoxShape {
        const box = allocate();
        box.create(half_extents);
        return box;
    }

    pub fn deinit(box: *const BoxShape) void {
        box.destroy();
        box.deallocate();
    }

    pub fn allocate() *const BoxShape {
        return @ptrCast(*const BoxShape, Shape.allocate(.box));
    }

    pub const create = cbtShapeBoxCreate;
    extern fn cbtShapeBoxCreate(box: *const BoxShape, half_extents: *const [3]f32) void;

    pub const getHalfExtentsWithoutMargin = cbtShapeBoxGetHalfExtentsWithoutMargin;
    extern fn cbtShapeBoxGetHalfExtentsWithoutMargin(box: *const BoxShape, half_extents: *[3]f32) void;

    pub const getHalfExtentsWithMargin = cbtShapeBoxGetHalfExtentsWithMargin;
    extern fn cbtShapeBoxGetHalfExtentsWithMargin(box: *const BoxShape, half_extents: *[3]f32) void;

    usingnamespace ShapeFunctions(@This());
};

pub const SphereShape = opaque {
    pub fn init(radius: f32) *const SphereShape {
        const sphere = allocate();
        sphere.create(radius);
        return sphere;
    }

    pub fn deinit(sphere: *const SphereShape) void {
        sphere.destroy();
        sphere.deallocate();
    }

    pub fn allocate() *const SphereShape {
        return @ptrCast(*const SphereShape, Shape.allocate(.sphere));
    }

    pub const create = cbtShapeSphereCreate;
    extern fn cbtShapeSphereCreate(sphere: *const SphereShape, radius: f32) void;

    pub const getRadius = cbtShapeSphereGetRadius;
    extern fn cbtShapeSphereGetRadius(sphere: *const SphereShape) f32;

    pub const setUnscaledRadius = cbtShapeSphereSetUnscaledRadius;
    extern fn cbtShapeSphereSetUnscaledRadius(sphere: *const SphereShape, radius: f32) void;

    usingnamespace ShapeFunctions(@This());
};

pub const Body = opaque {
    pub fn init(mass: f32, transform: *const [12]f32, shape: *const Shape) *const Body {
        const body = allocate();
        body.create(mass, transform, shape);
        return body;
    }

    pub fn deinit(body: *const Body) void {
        body.destroy();
        body.deallocate();
    }

    pub const allocate = cbtBodyAllocate;
    extern fn cbtBodyAllocate() *const Body;

    pub const deallocate = cbtBodyDeallocate;
    extern fn cbtBodyDeallocate(body: *const Body) void;

    pub const create = cbtBodyCreate;
    extern fn cbtBodyCreate(body: *const Body, mass: f32, transform: *const [12]f32, shape: *const Shape) void;

    pub const destroy = cbtBodyDestroy;
    extern fn cbtBodyDestroy(body: *const Body) void;

    pub const isCreated = cbtBodyIsCreated;
    extern fn cbtBodyIsCreated(body: *const Body) bool;

    pub const setShape = cbtBodySetShape;
    extern fn cbtBodySetShape(body: *const Body, shape: *const Shape) void;

    pub const getShape = cbtBodyGetShape;
    extern fn cbtBodyGetShape(body: *const Body) *const Shape;

    pub const getGraphicsWorldTransform = cbtBodyGetGraphicsWorldTransform;
    extern fn cbtBodyGetGraphicsWorldTransform(body: *const Body, transform: *[12]f32) void;
};

test "zbullet.world.gravity" {
    const world = World.init();
    defer world.deinit();

    world.setGravity(&.{ 0.0, -10.0, 0.0 });

    const num_substeps = world.stepSimulation(1.0 / 60.0, 1, 1.0 / 60.0);
    try expect(num_substeps == 1);

    var gravity: [3]f32 = undefined;
    world.getGravity(&gravity);

    try expect(gravity[0] == 0.0 and gravity[1] == -10.0 and gravity[2] == 0.0);
}

test "zbullet.shape.box" {
    {
        const box = BoxShape.init(&.{ 4.0, 4.0, 4.0 });
        defer box.deinit();
        try expect(box.isCreated());
        try expect(box.getType() == .box);
        box.setMargin(0.1);
        try expect(box.getMargin() == 0.1);

        var half_extents: [3]f32 = undefined;
        box.getHalfExtentsWithoutMargin(&half_extents);
        try expect(half_extents[0] == 3.9 and half_extents[1] == 3.9 and half_extents[2] == 3.9);

        box.getHalfExtentsWithMargin(&half_extents);
        try expect(half_extents[0] == 4.0 and half_extents[1] == 4.0 and half_extents[2] == 4.0);

        box.setUserIndex(0, 123);
        try expect(box.getUserIndex(0) == 123);

        box.setUserPointer(null);
        try expect(box.getUserPointer() == null);

        box.setUserPointer(&half_extents);
        try expect(box.getUserPointer() == @ptrCast(*anyopaque, &half_extents));

        const shape = box.asShape();
        try expect(shape.getType() == .box);
        try expect(shape.isCreated());
    }
    {
        const box = BoxShape.allocate();
        defer box.deallocate();
        try expect(box.isCreated() == false);

        box.create(&.{ 1.0, 2.0, 3.0 });
        defer box.destroy();
        try expect(box.getType() == .box);
        try expect(box.isCreated() == true);
    }
}

test "zbullet.shape.sphere" {
    {
        const sphere = SphereShape.init(3.0);
        defer sphere.deinit();
        try expect(sphere.isCreated());
        try expect(sphere.getType() == .sphere);
        sphere.setMargin(0.1);
        try expect(sphere.getMargin() == 3.0); // For spheres margin == radius.

        try expect(sphere.getRadius() == 3.0);

        sphere.setUnscaledRadius(1.0);
        try expect(sphere.getRadius() == 1.0);

        const shape = sphere.asShape();
        try expect(shape.getType() == .sphere);
        try expect(shape.isCreated());
    }
    {
        const sphere = SphereShape.allocate();
        try expect(sphere.isCreated() == false);

        sphere.create(1.0);
        try expect(sphere.getType() == .sphere);
        try expect(sphere.isCreated() == true);
        try expect(sphere.getRadius() == 1.0);

        sphere.destroy();
        try expect(sphere.isCreated() == false);

        sphere.create(2.0);
        try expect(sphere.getType() == .sphere);
        try expect(sphere.isCreated() == true);
        try expect(sphere.getRadius() == 2.0);

        sphere.destroy();
        try expect(sphere.isCreated() == false);
        sphere.deallocate();
    }
}

test "zbullet.body.basic" {
    {
        const sphere = SphereShape.init(3.0);
        defer sphere.deinit();

        const transform = [12]f32{
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
            2.0, 2.0, 2.0,
        };
        const body = Body.init(1.0, &transform, sphere.asShape());
        defer body.deinit();
        try expect(body.isCreated() == true);
        try expect(body.getShape() == sphere.asShape());
    }
    {
        const zm = @import("zmath");

        const sphere = SphereShape.init(3.0);
        defer sphere.deinit();

        var transform: [12]f32 = undefined;
        zm.storeMat43(transform[0..], zm.translation(2.0, 3.0, 4.0));

        const body = Body.init(1.0, &transform, sphere.asShape());

        try expect(body.isCreated() == true);
        try expect(body.getShape() == sphere.asShape());

        body.destroy();
        try expect(body.isCreated() == false);

        body.deallocate();
    }
    {
        const zm = @import("zmath");

        const sphere = SphereShape.init(3.0);
        defer sphere.deinit();

        const body = Body.init(
            0.0, // static body
            &zm.mat43ToArray(zm.translation(2.0, 3.0, 4.0)),
            sphere.asShape(),
        );
        defer body.deinit();

        var transform: [12]f32 = undefined;
        body.getGraphicsWorldTransform(&transform);

        const m = zm.loadMat43(transform[0..]);
        try expect(zm.approxEqAbs(m[0], zm.f32x4(1.0, 0.0, 0.0, 0.0), 0.0001));
        try expect(zm.approxEqAbs(m[1], zm.f32x4(0.0, 1.0, 0.0, 0.0), 0.0001));
        try expect(zm.approxEqAbs(m[2], zm.f32x4(0.0, 0.0, 1.0, 0.0), 0.0001));
        try expect(zm.approxEqAbs(m[3], zm.f32x4(2.0, 3.0, 4.0, 1.0), 0.0001));
    }
}
