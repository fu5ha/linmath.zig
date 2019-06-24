const std = @import("std");
const math = std.math;

const root = @import("main.zig");
use @import("vec2.zig");
use @import("vec3.zig");

pub const vec4 = Vec4(f32);
pub const vec4_64 = Vec4(f64);

pub fn Vec4(comptime T: type) type {
    if (T != f32 and T != f64) {
        @compileError("Vec4 only implemented for f32 and f64");
    }

    return struct {
        pub data: [4]T,

        pub const ZERO = Vec4(T).init(0.0, 0.0, 0.0);
        pub const X_AXIS = Vec4(T).init(1.0, 0.0, 0.0);
        pub const Y_XIS = Vec4(T).init(0.0, 1.0, 0.0);
        pub const Z_XIS = Vec4(T).init(0.0, 0.0, 1.0);
        
        ///// Initialization /////

        /// Initialize new vec4
        pub fn init(x_val: T, y_val: T, z_val: T, w_val: T) Vec4(T) {
            return Vec4(T){
                .data = [4]T{x_val, y_val, z_val, w_val},
            };
        }

        /// Create new vec4 from an array
        pub fn from_slice(s: []const T) Vec4(T) {
            assert(s.len == 4);
            return Vec4(T){
                .data = [4]T{s[0], s[1], s[2], s[3]}
            };
        }

        /// Create unit length vec4 from an angle
        pub fn from_spherical_angles(theta: T, phi: T) Vec4(T) {
            return Vec4(T).init(
                math.cos(theta) * math.cos(phi),
                math.sin(phi),
                math.sin(theta) * math.cos(phi),
                1.0);
        }

        /// Create new vec4 from vec2 and z value
        pub fn from_vec2(vec: Vec2(T), z_val: T) Vec4(T) {
            return Vec4(T).init(vec.x(), vec.y(), z_val);
        }

        /// Create new vec4 from vec2 and z value
        pub fn from_vec3(vec: Vec3(T), w_val: T) Vec4(T) {
            return Vec4(T).init(vec.x(), vec.y(), vec.z(), w_val);
        }

        /// Copy a vec4
        pub fn copy(self: Vec4(T)) Vec4(T) {
            return Vec4(T).from_slice(self.data[0..4]);
        }

        ///// Accessors /////

        /// Get x component of `self`
        pub fn x(self: Vec4(T)) T {
            return self.data[0];
        }

        /// Get y component of `self`
        pub fn y(self: Vec4(T)) T {
            return self.data[1];
        }

        /// Get z component of `self`
        pub fn z(self: Vec4(T)) T {
            return self.data[2];
        }

        /// Get vec2 repreesntation of `self`
        pub fn vec3(self: Vec4(T)) Vec3(T) {
            return Vec3(T).from_slice(self.data[0..3]);
        }

        /// Get square magnitude (length) of `self`
        pub fn mag_sq(self: Vec4(T)) T {
            var sum: T = 0.0;
            for (self.data) |v| sum += v * v;
            return sum;
        }

        /// Get magnitude (length) of `self`
        pub fn mag(self: Vec4(T)) T {
            return math.sqrt(self.mag_sq());
        }

        ///// Operations /////

        /// Add `o` to `self` in-place
        pub fn add_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* += o.data[i];
            return self.*;
        }

        /// Add `o` to `self` and return result
        pub fn add(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().add_ip(o);
        }

        /// Divide `self` by `o` component-wise in-place
        pub fn component_div_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* /= o.data[i];
            return self.*;
        }

        /// Divide `self` by `o` component-wise and return result
        pub fn component_div(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().component_div_ip(o);
        }

        /// Perform component-wise maximum between `self` and `o` in-place
        pub fn component_max_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* = math.max(v.*, o.data[i]);
            return self.*;
        }

        /// Perform component-wise maximum between `self` and `o` and return result
        pub fn component_max(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().component_max_ip(o);
        }

        /// Perform component-wise minimum between `self` and `o` in-place
        pub fn component_min_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* = math.min(v.*, o.data[i]);
            return self.*;
        }

        /// Perform component-wise minimum between `self` and `o` and return result
        pub fn component_min(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().component_min_ip(o);
        }

        /// Multiply `self` by `o` component-wise in-place
        pub fn component_mul_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* *= o.data[i];
            return self.*;
        }

        /// Multiply `self` by `o` component-wise and return result
        pub fn component_mul(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().component_mul_ip(o);
        }

        /// Cross-multiply `self` with `o` in-place
        pub fn cross_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            var sa = self.*.data;
            const oa = o.data;
            sa[0] = sa[1] * oa[2] - sa[2] * oa[1];
            sa[1] = sa[2] * oa[0] - sa[0] * oa[2];
            sa[2] = sa[0] * oa[1] - sa[1] * oa[0];
            return self.*;
        }

        /// Cross-multiply `self` with `o` and return result
        pub fn cross(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().cross_ip(o);
        }

        /// Get the dot product of `self` and `o`
        pub fn dot(self: Vec4(T), o: Vec4(T)) T {
            var sum: T = 0.0;
            for (self.data) |v, i| sum += v * o.data[i];
            return sum;
        }

        /// Check if `self` and `o` are equal
        pub fn equals(self: Vec4(T), o: Vec4(T)) bool {
            for (self.data) |v, i| if (v != o.data[i]) return false;
            return true;
        }

        /// Check if `self` and `o` are equal to within a degree of confidence delta, `eps`.
        pub fn equals_eps(self: Vec4(T), o: Vec4(T), eps: T) bool {
            for (self.data) |v, i| if (!root.equals_eps(T, v, o.data[i], eps)) return false;
            return true;
        }

        /// Invert `self` in-place
        pub fn invert_ip(self: *Vec4(T)) Vec4(T) {
            _ = self.scale_ip(-1.0);
            return self.*;
        }

        /// Invert `self` an return result
        pub fn invert(self: Vec4(T)) Vec4(T) {
            return self.copy().invert_ip();
        }

        /// Sets `self` to the vector with larger magnitude bewteen `self` and `o`
        pub fn max_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            if (o.mag_sq() > self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the larger magnitude
        pub fn max(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().max_ip();
        }

        /// Sets `self` to the vector with smaller magnitude bewteen `self` and `o`
        pub fn min_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            if (o.mag_sq() < self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the smaller magnitude
        pub fn min(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().min_ip();
        }

        /// Normalize `self` in-place
        pub fn normalize_ip(self: *Vec4(T)) Vec4(T) {
            _ = self.scale_ip(1.0 / self.mag());
            return self.*;
        }

        /// Normalize `self` and return result
        pub fn normalize(self: Vec4(T)) Vec4(T) {
            return self.copy().normalize_ip();
        }

        /// Project `self` along `o` in-place. `o` *MUST* be normalized.
        pub fn project_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            self.* = o.scale(self.dot(o));
            return self.*;
        }

        /// Project `self` along `o` and return result. `o` *MUST* be normalized.
        pub fn project(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().project_ip(o);
        }

        /// Scale self by `c` in-place.
        pub fn scale_ip(self: *Vec4(T), c: T) Vec4(T) {
            for (self.*.data) |*v, i| v.* *= c;
            return self.*;
        }

        /// Scale self by `c` and return result;
        pub fn scale(self: Vec4(T), c: T) Vec4(T) {
            return self.copy().scale_ip(c);
        }

        /// Sets the magnitude of `self` to `c`
        pub fn set_mag_ip(self: *Vec4(T), c: T) Vec4(T) {
            _ = self.scale_ip(c / self.mag());
            return self.*;
        }
        /// Sets the magnitude (length) of `self` to `c`
        pub fn set_mag(self: Vec4(T), c: T) Vec4(T) {
            return self.copy().set_mag_ip(c);
        }

        /// Subtract `o` from `self` in-place
        pub fn sub_ip(self: *Vec4(T), o: Vec4(T)) Vec4(T) {
            for (self.*.data) |*v, i| v.* -= o.data[i];
            return self.*;
        }

        /// Subtract `o` from `self` and return the result
        pub fn sub(self: Vec4(T), o: Vec4(T)) Vec4(T) {
            return self.copy().sub_ip(o);
        }
    };
}

const assert = std.debug.assert;

test "equals" {
    const a = vec4.init(1.0, 2.0, 3.0, 4.0);
    const b = vec4.init(1.0, 2.0, 3.0, 4.0);
    const c = vec4.init(2.0, 2.0, 2.0, 2.0);
    assert(a.equals(b) == true);
    assert(a.equals(c) == false);
}

test "add" {
    const a = vec4.init(1.0, 2.0, 3.0, 4.0);
    const b = vec4.init(3.0, 2.0, 1.0, 0.0);
    assert(a.add(b).equals(vec4.init(4.0, 4.0, 4.0, 4.0)));
    assert(a.add(b).add(a).equals(vec4.init(5.0, 6.0, 7.0, 8.0)));
}

test "sub" {
    const a = vec4.init(3.0, 2.0, 1.0, 0.0);
    const b = vec4.init(1.0, 1.0, 1.0, 1.0);
    assert(a.sub(b).equals(vec4.init(2.0, 1.0, 0.0, -1.0)));
    assert(a.sub(b).sub(a).equals(vec4.init(-1.0, -1.0, -1.0, -1.0)));
}

test "component_max" {
    const a = vec4.init(1.0, 2.0, 4.0, 2.0);
    const b = vec4.init(3.0, 1.0, 3.5, 5.0);
    assert(a.component_max(b).equals(vec4.init(3.0, 2.0, 4.0, 5.0)));
}

test "component_min" {
    const a = vec4.init(1.0, 2.0, 4.0, 2.0);
    const b = vec4.init(3.0, 1.0, 3.5, 5.0);
    assert(a.component_min(b).equals(vec4.init(1.0, 1.0, 3.5, 2.0)));
}

test "compoment_div" {
    const a = vec4.init(8.0, 10.0, 12.0, 14.0);
    const b = vec4.init(4.0, 5.0, 6.0, 7.0);
    assert(a.component_div(b).equals(vec4.init(2.0, 2.0, 2.0, 2.0)));
}

test "component_mul" {
    const a = vec4.init(5.0, 6.0, 7.0, 8.0);
    const b = vec4.init(3.0, 5.0, 4.0, 3.0);
    assert(a.component_mul(b).equals(vec4.init(15.0, 30.0, 28.0, 24.0)));
}

test "scale" {
    const a = vec4.init(5.0, 6.0, 7.0, 8.0);
    assert(a.scale(3.0).equals(vec4.init(15.0, 18.0, 21.0, 24.0)));
}

test "invert" {
    const a = vec4.init(3.0, 3.0, 2.0, 2.0);
    assert(a.invert().equals(vec4.init(-3.0, -3.0, -2.0, -2.0)));
}

test "magSq" {
    const a = vec4.init(2.0, 3.0, 4.0, 5.0);
    assert(a.mag_sq() == 54.0);
}

test "mag" {
    const a = vec4.init(2.0, 3.0, 4.0, 5.0);
    assert(a.mag() == math.sqrt(54.0));
}

test "set_mag" {
    const a = vec4.init(2.0, 3.0, 4.0, 5.0);
    assert(root.equals_eps(f32, a.set_mag(3.0).mag(), 3.0, 0.0001));
}

test "dot" {
    const a = vec4.init(2.0, 3.0, 5.0, 2.0);
    const b = vec4.init(3.0, 4.0, 1.0, 2.0);
    assert(a.dot(b) == 27.0);
}

test "normalize" {
    const a = vec4.init(2.0, 2.0, 2.0, 2.0);
    assert(a.normalize().equals_eps(vec4.init(math.sqrt(1.0/4.0), math.sqrt(1.0/4.0), math.sqrt(1.0/4.0), math.sqrt(1.0/4.0)), 0.0001));
}

test "project" {
    const a = vec4.init(1.0, 2.0, 3.0, 4.0);
    const b = vec4.init(0.0, 1.0, 0.0, 0.0);
    assert(a.project(b).equals(vec4.init(0.0, 2.0, 0.0, 0.0)));
}

test "vec3" {
    const a = vec4.init(3.0, 2.0, 1.0, 5.0);
    const b = vec3.init(3.0, 2.0, 1.0);
    assert(a.vec3().equals(b));
}
