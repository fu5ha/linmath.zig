const std = @import("std");
const math = std.math;

const root = @import("main.zig");

pub const vec2 = Vec2(f32);
pub const vec2_64 = Vec2(f64);

pub fn Vec2(comptime T: type) type {
    if (T != f32 and T != f64) {
        @compileError("Vec2 only implemented for f32 and f64");
    }

    return struct {
        pub data: [2]T,

        pub const ZERO = Vec2(T).init(0.0, 0.0);
        pub const X_AXIS = Vec2(T).init(1.0, 0.0);
        pub const Y_XIS = Vec2(T).init(0.0, 1.0);
        
        ///// Initialization /////

        /// Initialize new vec2
        pub fn init(x_val: T, y_val: T) Vec2(T) {
            return Vec2(T){
                .data = [2]T{x_val, y_val},
            };
        }

        /// Create new vec2 from an array
        pub fn from_slice(s: []const T) Vec2(T) {
            assert(s.len == 2);
            return Vec2(T){
                .data = [2]f32{s[0], s[1]}
            };
        }

        /// Create unit length vec2 from an angle
        pub fn from_angle(angle: T) Vec2(T) {
            return Vec2(T).init(math.cos(angle), math.sin(angle));
        }

        /// Copy a vec2
        pub fn copy(self: Vec2(T)) Vec2(T) {
            return Vec2(T).from_slice(self.data[0..]);
        }

        ///// Accessors /////

        /// Get x component of `self`
        pub fn x(self: Vec2(T)) T {
            return self.data[0];
        }

        /// Get y component of `self`
        pub fn y(self: Vec2(T)) T {
            return self.data[1];
        }

        /// Get square magnitude (length) of `self`
        pub fn mag_sq(self: Vec2(T)) T {
            var sum: T = 0.0;
            for (self.data) |v| sum += v * v;
            return sum;
        }

        /// Get magnitude (length) of `self`
        pub fn mag(self: Vec2(T)) T {
            return math.sqrt(self.mag_sq());
        }

        /// Get the heading angle of `self`
        pub fn heading(self: Vec2(T)) T {
            return math.atan2(T, self.y(), self.x());
        }

        ///// Operations /////

        /// Add `o` to `self` in-place
        pub fn add_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* += o.data[i];
            return self.*;
        }

        /// Add `o` to `self` and return result
        pub fn add(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().add_ip(o);
        }

        /// Divide `self` by `o` component-wise in-place
        pub fn component_div_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* /= o.data[i];
            return self.*;
        }

        /// Divide `self` by `o` component-wise and return result
        pub fn component_div(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().component_div_ip(o);
        }

        /// Perform component-wise maximum between `self` and `o` in-place
        pub fn component_max_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* = math.max(v.*, o.data[i]);
            return self.*;
        }

        /// Perform component-wise maximum between `self` and `o` and return result
        pub fn component_max(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().component_max_ip(o);
        }

        /// Perform component-wise minimum between `self` and `o` in-place
        pub fn component_min_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* = math.min(v.*, o.data[i]);
            return self.*;
        }

        /// Perform component-wise minimum between `self` and `o` and return result
        pub fn component_min(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().component_min_ip(o);
        }

        /// Multiply `self` by `o` component-wise in-place
        pub fn component_mul_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* *= o.data[i];
            return self.*;
        }

        /// Multiply `self` by `o` component-wise and return result
        pub fn component_mul(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().component_mul_ip(o);
        }

        /// Get the dot product of `self` and `o`
        pub fn dot(self: Vec2(T), o: Vec2(T)) T {
            var sum: T = 0.0;
            for (self.data) |v, i| sum += v * o.data[i];
            return sum;
        }

        /// Check if `self` and `o` are equal
        pub fn equals(self: Vec2(T), o: Vec2(T)) bool {
            for (self.data) |v, i| if (v != o.data[i]) return false;
            return true;
        }

        /// Check if `self` and `o` are equal to within a degree of confidence delta, `eps`.
        pub fn equals_eps(self: Vec2(T), o: Vec2(T), eps: T) bool {
            for (self.data) |v, i| if (!root.equals_eps(T, v, o.data[i], eps)) return false;
            return true;
        }

        /// Invert `self` in-place
        pub fn invert_ip(self: *Vec2(T)) Vec2(T) {
            _ = self.scale_ip(-1.0);
            return self.*;
        }

        /// Invert `self` an return result
        pub fn invert(self: Vec2(T)) Vec2(T) {
            return self.copy().invert_ip();
        }

        /// Sets `self` to the vector with larger magnitude bewteen `self` and `o`
        pub fn max_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            if (o.mag_sq() > self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the larger magnitude
        pub fn max(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().max_ip();
        }

        /// Sets `self` to the vector with smaller magnitude bewteen `self` and `o`
        pub fn min_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            if (o.mag_sq() < self.mag_sq()) self.* = o;
            return self.*;
        }

        /// Returns the vector between `self` and `o` with the smaller magnitude
        pub fn min(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().min_ip();
        }

        /// Normalize `self` in-place
        pub fn normalize_ip(self: *Vec2(T)) Vec2(T) {
            _ = self.scale_ip(1.0 / self.mag());
            return self.*;
        }

        /// Normalize `self` and return result
        pub fn normalize(self: Vec2(T)) Vec2(T) {
            return self.copy().normalize_ip();
        }

        /// Project `self` along `o` in-place. `o` *MUST* be normalized.
        pub fn project_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            self.* = o.scale(self.dot(o));
            return self.*;
        }

        /// Project `self` along `o` and return result. `o` *MUST* be normalized.
        pub fn project(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().project_ip(o);
        }

        /// Reflect incident vector `self` off surface with normal `norm` in-place
        /// `norm` *MUST* be normalized.
        pub fn reflect_ip(self: *Vec2(T), norm: Vec2(T)) Vec2(T) {
            var b = self.copy().project_ip(norm).scale_ip(2.0);
            _ = self.sub_ip(b);
            return self.*;
        }

        /// Reflect incident vector `self` of surface with normal `norm` and return result. 
        /// `norm` *MUST* be normalized.
        pub fn reflect(self: Vec2(T), norm: Vec2(T)) Vec2(T) {
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
        pub fn refract(self: Vec2(T), norm: Vec2(T), eta: T) ?Vec2(T) {
            var ndi = self.dot(norm);
            var k = 1.0 - eta * eta * (1.0 - ndi * ndi);
            if (k < 0.0)
                return null;

            return self.scale(eta).sub(norm.scale(eta * ndi + math.sqrt(k)));
        }

        /// Scale self by `c` in-place.
        pub fn scale_ip(self: *Vec2(T), c: T) Vec2(T) {
            for (self.*.data) |*v, i| v.* *= c;
            return self.*;
        }

        /// Scale self by `c` and return result;
        pub fn scale(self: Vec2(T), c: T) Vec2(T) {
            return self.copy().scale_ip(c);
        }

        /// Sets the magnitude of `self` to `c`
        pub fn set_mag_ip(self: *Vec2(T), c: T) Vec2(T) {
            _ = self.scale_ip(c / self.mag());
            return self.*;
        }
        /// Sets the magnitude (length) of `self` to `c`
        pub fn set_mag(self: Vec2(T), c: T) Vec2(T) {
            return self.copy().set_mag_ip(c);
        }

        /// Subtract `o` from `self` in-place
        pub fn sub_ip(self: *Vec2(T), o: Vec2(T)) Vec2(T) {
            for (self.*.data) |*v, i| v.* -= o.data[i];
            return self.*;
        }

        /// Subtract `o` from `self` and return the result
        pub fn sub(self: Vec2(T), o: Vec2(T)) Vec2(T) {
            return self.copy().sub_ip(o);
        }
    };
}

const assert = std.debug.assert;

test "vec.equals" {
    const a = vec2.init(1.0, 2.0);
    const b = vec2.init(1.0, 2.0);
    const c = vec2.init(2.0, 2.0);
    assert(a.equals(b) == true);
    assert(a.equals(c) == false);
}

test "vec2.add" {
    const a = vec2.init(1.0, 2.0);
    const b = vec2.init(3.0, 2.0);
    assert(a.add(b).equals(vec2.init(4.0, 4.0)));
    assert(a.add(b).add(a).equals(vec2.init(5.0, 6.0)));
}

test "vec2.sub" {
    const a = vec2.init(3.0, 2.0);
    const b = vec2.init(1.0, 1.0);
    assert(a.sub(b).equals(vec2.init(2.0, 1.0)));
    assert(a.sub(b).sub(a).equals(vec2.init(-1.0, -1.0)));
}

test "vec2 angle heading round trip" {
    const angle = math.pi / 4.0;
    const a = vec2.from_angle(angle);
    assert(a.equals_eps(vec2.init(0.5 * math.sqrt(2.0), 0.5 * math.sqrt(2.0)), 0.0001));
    assert(root.equals_eps(f32, a.heading(), angle, 0.0001));
    const b = vec2.from_angle(-math.pi / 4.0);
    assert(b.equals_eps(vec2.init(0.5 * math.sqrt(2.0), -0.5 * math.sqrt(2.0)), 0.0001));
}

test "vec2.component_max" {
    const a = vec2.init(1.0, 2.0);
    const b = vec2.init(3.0, 1.0);
    assert(a.component_max(b).equals(vec2.init(3.0, 2.0)));
}

test "vec2.component_min" {
    const a = vec2.init(1.0, 2.0);
    const b = vec2.init(3.0, 1.0);
    assert(a.component_min(b).equals(vec2.init(1.0, 1.0)));
}

test "vec2.compoment_div" {
    const a = vec2.init(8.0, 10.0);
    const b = vec2.init(4.0, 5.0);
    assert(a.component_div(b).equals(vec2.init(2.0, 2.0)));
}

test "vec2.component_mul" {
    const a = vec2.init(5.0, 6.0);
    const b = vec2.init(3.0, 5.0);
    assert(a.component_mul(b).equals(vec2.init(15.0, 30.0)));
}

test "vec2.scale" {
    const a = vec2.init(5.0, 6.0);
    assert(a.scale(3.0).equals(vec2.init(15.0, 18.0)));
}

test "vec2.invert" {
    const a = vec2.init(3.0, 3.0);
    assert(a.invert().equals(vec2.init(-3.0, -3.0)));
}

test "vec2.magSq" {
    const a = vec2.init(2.0, 3.0);
    assert(a.mag_sq() == 13.0);
}

test "vec2.mag" {
    const a = vec2.init(2.0, 3.0);
    assert(a.mag() == math.sqrt(13.0));
}

test "vec2.set_mag" {
    const a = vec2.init(2.0, 3.0);
    assert(root.equals_eps(f32, a.set_mag(3.0).mag(), 3.0, 0.0001));
}

test "vec2.dot" {
    const a = vec2.init(2.0, 3.0);
    const b = vec2.init(3.0, 4.0);
    assert(a.dot(b) == 18.0);
}

test "vec2.normalize" {
    const a = vec2.init(2.0, 2.0);
    assert(a.normalize().equals_eps(vec2.init(0.5 * math.sqrt(2.0), 0.5 * math.sqrt(2.0)), 0.0001));
}

test "vec2.project" {
    const a = vec2.init(1.0, 2.0);
    const b = vec2.init(0.0, 1.0);
    assert(a.project(b).equals(vec2.init(0.0, 2.0)));
}

test "vec2.reflect" {
    {
        const incident = vec2.init(1.0, -1.0);
        const norm = vec2.init(0.0, 1.0);
        assert(incident.reflect(norm).equals_eps(vec2.init(1.0, 1.0), 0.0001));
    }
    {
        const incident = vec2.init(0.0, -2.0);
        const norm = vec2.init(1.0, 1.0).normalize();
        assert(incident.reflect(norm).equals_eps(vec2.init(2.0, 0.0), 0.0001));
    }
}

test "vec2.refract" {
    {
        const incident = vec2.init(1.0, -1.0);
        const norm = vec2.init(0.0, 1.0);
        const eta = 1.0;
        assert(incident.refract(norm, eta).?.equals_eps(vec2.init(1.0, -1.0), 0.0001));
    }
    {
        const incident = vec2.init(1.0, -1.0).normalize();
        const norm = vec2.init(0.0, 1.0);
        const eta = 1.0 / 1.5;
        const angle_from_vertical = 0.49088268;
        assert(incident.refract(norm, eta).?.equals_eps(vec2.from_angle(-math.pi / 2.0 + angle_from_vertical), 0.0001));
    }
}
