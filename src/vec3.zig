const std = @import("std");
const math = std.math;

const root = @import("main.zig");
use @import("vec2.zig");

pub const vec3 = Vec3(f32);
pub const vec3_64 = Vec3(f64);

fn Vec3(comptime T: type) type {
    if (T != f32 and T != f64) {
        @compileError("Vec3 only implemented for f32 and f64");
    }

    return packed struct {
        pub a: [3]T,

        pub const ZERO = Vec3(T).init(0.0, 0.0, 0.0);
        pub const X_AXIS = Vec3(T).init(1.0, 0.0, 0.0);
        pub const Y_XIS = Vec3(T).init(0.0, 1.0, 0.0);
        pub const Z_XIS = Vec3(T).init(0.0, 0.0, 1.0);
        
        ///// Initialization /////

        /// Initialize new vec3
        pub fn init(x_val: T, y_val: T, z_val: T) Vec3(T) {
            return Vec3(T){
                .a = [3]T{x_val, y_val, z_val},
            };
        }

        /// Create new vec3 from an array
        pub fn from_array(arr: [3]T) Vec3(T) {
            return Vec3(T){
                .a = arr,
            };
        }

        /// Create unit length vec3 from an angle
        pub fn from_spherical_angles(theta: T, phi: T) Vec3(T) {
            return Vec3(T).init(
                math.cos(theta) * math.cos(phi),
                math.sin(phi),
                math.sin(theta) * math.cos(phi));
        }

        /// Create new vec3 from vec2 and z value
        pub fn from_vec2(vec: Vec2(T), z_val: T) Vec3(T) {
            return Vec3(T).init(vec.x(), vec.y(), z_val);
        }

        /// Copy a vec3
        pub fn copy(self: Vec3(T)) Vec3(T) {
            return Vec3(T).from_array(self.a);
        }

        ///// Accessors /////

        /// Get x component of `self`
        pub fn x(self: Vec3(T)) T {
            return self.a[0];
        }

        /// Get y component of `self`
        pub fn y(self: Vec3(T)) T {
            return self.a[1];
        }

        /// Get z component of `self`
        pub fn z(self: Vec3(T)) T {
            return self.a[2];
        }

        /// Get square magnitude (length) of `self`
        pub fn mag_sq(self: Vec3(T)) T {
            var sum: T = 0.0;
            for (self.a[0..3]) |v| sum += v * v;
            return sum;
        }

        /// Get magnitude (length) of `self`
        pub fn mag(self: Vec3(T)) T {
            return math.sqrt(self.mag_sq());
        }

        ///// Operations /////

        /// Add `o` to `self` in-place
        pub fn add_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..2]) |*v, i| v.* += o.a[i];
            return self.*;
        }

        /// Add `o` to `self` and return result
        pub fn add(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().add_ip(o);
        }

        /// Divide `self` by `o` component-wise in-place
        pub fn component_div_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..2]) |*v, i| v.* /= o.a[i];
            return self.*;
        }

        /// Divide `self` by `o` component-wise and return result
        pub fn component_div(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().component_div_ip(o);
        }

        /// Perform component-wise maximum between `self` and `o` in-place
        pub fn component_max_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..3]) |*v, i| v.* = math.max(v.*, o.a[i]);
            return self.*;
        }

        /// Perform component-wise maximum between `self` and `o` and return result
        pub fn component_max(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().component_max_ip(o);
        }

        /// Perform component-wise minimum between `self` and `o` in-place
        pub fn component_min_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..3]) |*v, i| v.* = math.min(v.*, o.a[i]);
            return self.*;
        }

        /// Perform component-wise minimum between `self` and `o` and return result
        pub fn component_min(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().component_min_ip(o);
        }

        /// Multiply `self` by `o` component-wise in-place
        pub fn component_mul_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..3]) |*v, i| v.* *= o.a[i];
            return self.*;
        }

        /// Multiply `self` by `o` component-wise and return result
        pub fn component_mul(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().component_mul_ip(o);
        }

        /// Cross-multiply `self` with `o` in-place
        pub fn cross_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            var sa = self.*.a[0..3];
            const oa = o.a[0..3];
            sa[0] = sa[1] * oa[2] - sa[2] * oa[1];
            sa[1] = sa[2] * oa[0] - sa[0] * oa[2];
            sa[2] = sa[0] * oa[1] - sa[1] * oa[0];
            return self.*;
        }

        /// Cross-multiply `self` with `o` and return result
        pub fn cross(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().cross_ip(o);
        }

        /// Get the dot product of `self` and `o`
        pub fn dot(self: Vec3(T), o: Vec3(T)) T {
            var sum: T = 0.0;
            for (self.a[0..3]) |v, i| sum += v * o.a[i];
            return sum;
        }

        /// Check if `self` and `o` are equal
        pub fn equals(self: Vec3(T), o: Vec3(T)) bool {
            for (self.a[0..3]) |v, i| if (v != o.a[i]) return false;
            return true;
        }

        /// Check if `self` and `o` are equal to within a degree of confidence delta, `eps`.
        pub fn equals_eps(self: Vec3(T), o: Vec3(T), eps: T) bool {
            for (self.a[0..3]) |v, i| if (!root.equals_eps(T, v, o.a[i], eps)) return false;
            return true;
        }

        /// Invert `self` in-place
        pub fn invert_ip(self: *Vec3(T)) Vec3(T) {
            _ = self.scale_ip(-1.0);
            return self.*;
        }

        /// Invert `self` an return result
        pub fn invert(self: Vec3(T)) Vec3(T) {
            return self.copy().invert_ip();
        }

        /// Sets `self` to the vector with larger magnitude bewteen `self` and `o`
        pub fn max_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            if (o.mag_sq() > self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the larger magnitude
        pub fn max(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().max_ip();
        }

        /// Sets `self` to the vector with smaller magnitude bewteen `self` and `o`
        pub fn min_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            if (o.mag_sq() < self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the smaller magnitude
        pub fn min(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().min_ip();
        }

        /// Normalize `self` in-place
        pub fn normalize_ip(self: *Vec3(T)) Vec3(T) {
            _ = self.scale_ip(1.0 / self.mag());
            return self.*;
        }

        /// Normalize `self` and return result
        pub fn normalize(self: Vec3(T)) Vec3(T) {
            return self.copy().normalize_ip();
        }

        /// Project `self` along `o` in-place. `o` *MUST* be normalized.
        pub fn project_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            self.* = o.scale(self.dot(o));
            return self.*;
        }

        /// Project `self` along `o` and return result. `o` *MUST* be normalized.
        pub fn project(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().project_ip(o);
        }

        /// Reflect incident vector `self` off surface with normal `norm` in-place
        /// `norm` *MUST* be normalized.
        pub fn reflect_ip(self: *Vec3(T), norm: Vec3(T)) Vec3(T) {
            var b = self.copy().project_ip(norm).scale_ip(2.0);
            _ = self.sub_ip(b);
            return self.*;
        }

        /// Reflect incident vector `self` of surface with normal `norm` and return result. 
        /// `norm` *MUST* be normalized.
        pub fn reflect(self: Vec3(T), norm: Vec3(T)) Vec3(T) {
            return self.copy().reflect_ip(norm);
        }

        /// Refract incident vector `self` into surface with normal `norm` and return result. 
        /// `eta` is the ratio between the indexes of refraction of the participating media, i.e.
        /// `iorA / iorB` where iorA is the index of refraction of the medium the ray
        /// is exiting and iorB is the index of refraction of the medium the ray is entering.
        ///
        /// `self` AND `norm` *MUST* be normalized.
        ///
        /// Result could be null if `eta` > 1.0 and the angle between the incident and normal vector
        /// is high enough. This is due to a phenomenon called total internal reflection which is caused
        /// by Snell's law, the equations that describe reflection and refraction.
        pub fn refract(self: Vec3(T), norm: Vec3(T), eta: T) ?Vec3(T) {
            var ndi = self.dot(norm);
            var k = 1.0 - eta * eta * (1.0 - ndi * ndi);
            if (k < 0.0)
                return null;

            return self.scale(eta).sub(norm.scale(eta * ndi + math.sqrt(k)));
        }

        /// Scale self by `c` in-place.
        pub fn scale_ip(self: *Vec3(T), c: T) Vec3(T) {
            for (self.*.a[0..3]) |*v, i| v.* *= c;
            return self.*;
        }

        /// Scale self by `c` and return result;
        pub fn scale(self: Vec3(T), c: T) Vec3(T) {
            return self.copy().scale_ip(c);
        }

        /// Sets the magnitude of `self` to `c`
        pub fn set_mag_ip(self: *Vec3(T), c: T) Vec3(T) {
            _ = self.scale_ip(c / self.mag());
            return self.*;
        }
        /// Sets the magnitude (length) of `self` to `c`
        pub fn set_mag(self: Vec3(T), c: T) Vec3(T) {
            return self.copy().set_mag_ip(c);
        }

        /// Subtract `o` from `self` in-place
        pub fn sub_ip(self: *Vec3(T), o: Vec3(T)) Vec3(T) {
            for (self.*.a[0..3]) |*v, i| v.* -= o.a[i];
            return self.*;
        }

        /// Subtract `o` from `self` and return the result
        pub fn sub(self: Vec3(T), o: Vec3(T)) Vec3(T) {
            return self.copy().sub_ip(o);
        }
    };
}

const assert = std.debug.assert;

test "vec3 equals" {
    const a = vec3.init(1.0, 2.0, 3.0);
    const b = vec3.init(1.0, 2.0, 3.0);
    const c = vec3.init(2.0, 2.0, 2.0);
    assert(a.equals(b) == true);
    assert(a.equals(c) == false);
}

test "vec3 add" {
    const a = vec3.init(1.0, 2.0, 3.0);
    const b = vec3.init(3.0, 2.0, 1.0);
    assert(a.add(b).equals(vec3.init(4.0, 4.0, 4.0)));
    assert(a.add(b).add(a).equals(vec3.init(5.0, 6.0, 7.0)));
}

test "vec3 sub" {
    const a = vec3.init(3.0, 2.0, 1.0);
    const b = vec3.init(1.0, 1.0, 1.0);
    assert(a.sub(b).equals(vec3.init(2.0, 1.0, 0.0)));
    assert(a.sub(b).sub(a).equals(vec3.init(-1.0, -1.0, -1.0)));
}

test "vec3 component_max" {
    const a = vec3.init(1.0, 2.0, 4.0);
    const b = vec3.init(3.0, 1.0, 3.5);
    assert(a.component_max(b).equals(vec3.init(3.0, 2.0, 4.0)));
}

test "vec3 component_min" {
    const a = vec3.init(1.0, 2.0, 4.0);
    const b = vec3.init(3.0, 1.0, 3.5);
    assert(a.component_min(b).equals(vec3.init(1.0, 1.0, 3.5)));
}

test "vec3 compoment_div" {
    const a = vec3.init(8.0, 10.0, 12.0);
    const b = vec3.init(4.0, 5.0, 6.0);
    assert(a.component_div(b).equals(vec3.init(2.0, 2.0, 2.0)));
}

test "vec3 component_mul" {
    const a = vec3.init(5.0, 6.0, 7.0);
    const b = vec3.init(3.0, 5.0, 4.0);
    assert(a.component_mul(b).equals(vec3.init(15.0, 30.0, 28.0)));
}

test "vec3 scale" {
    const a = vec3.init(5.0, 6.0, 7.0);
    assert(a.scale(3.0).equals(vec3.init(15.0, 18.0, 21.0)));
}

test "vec3 invert" {
    const a = vec3.init(3.0, 3.0, 2.0);
    assert(a.invert().equals(vec3.init(-3.0, -3.0, -2.0)));
}

test "vec3 mag magSq" {
    const a = vec3.init(2.0, 3.0, 4.0);
    assert(a.mag_sq() == 27.0);
    assert(a.mag() == math.sqrt(27.0));
}

test "vec3 set_mag" {
    const a = vec3.init(2.0, 3.0, 4.0);
    assert(root.equals_eps(f32, a.set_mag(3.0).mag(), 3.0, 0.0001));
}

test "vec3 dot" {
    const a = vec3.init(2.0, 3.0, 5.0);
    const b = vec3.init(3.0, 4.0, 1.0);
    assert(a.dot(b) == 23.0);
}

test "vec3 normalize" {
    const a = vec3.init(2.0, 2.0, 2.0);
    assert(a.normalize().equals_eps(vec3.init(math.sqrt(1.0/3.0), math.sqrt(1.0/3.0), math.sqrt(1.0/3.0)), 0.0001));
}

test "vec3 project" {
    const a = vec3.init(1.0, 2.0, 3.0);
    const b = vec3.init(0.0, 1.0, 0.0);
    assert(a.project(b).equals(vec3.init(0.0, 2.0, 0.0)));
}

test "vec3 reflect" {
    {
        const incident = vec3.init(1.0, -1.0, 1.0);
        const norm = vec3.init(0.0, 1.0, 0.0);
        assert(incident.reflect(norm).equals_eps(vec3.init(1.0, 1.0, 1.0), 0.0001));
    }
    {
        const incident = vec3.init(0.0, -2.0, 0.0);
        const norm = vec3.init(1.0, 1.0, 0.0).normalize();
        assert(incident.reflect(norm).equals_eps(vec3.init(2.0, 0.0, 0.0), 0.0001));
    }
}

test "vec3 refract" {
    {
        const incident = vec3.init(1.0, -1.0, 1.0);
        const norm = vec3.init(0.0, 1.0, 0.0);
        const eta = 1.0;
        assert(incident.refract(norm, eta).?.equals_eps(vec3.init(1.0, -1.0, 1.0), 0.0001));
    }
    {
        const incident = vec3.init(1.0, -1.0, 0.0).normalize();
        const norm = vec3.init(0.0, 1.0, 0.0);
        const eta = 1.0 / 1.5;
        const pass = vec3.from_vec2(vec2.from_angle(-math.pi / 2.0 + 0.49088268), 0.0);
        assert(incident.refract(norm, eta).?.equals_eps(pass, 0.0001));
    }
}
