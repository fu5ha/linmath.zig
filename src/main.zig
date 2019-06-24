const std = @import("std");

pub use @import("vec2.zig");
pub use @import("vec3.zig");
pub use @import("vec4.zig");

pub fn equals_eps(comptime T: type, a: f32, b: f32, eps: f32) bool {
    if (T != f32 and T != f64) {
        @compileError("equals_eps only implemented for f32 and f64");
    }
    return a < b + 0.5 * eps and a > b - 0.5 * eps;
}

// pub const vec4 = [4]f32;
// pub fn vec4_add(r: [*c]f32, a: [*c]const f32, b: [*c]const f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (a[i] + b[i]);
//     }
// }
// pub fn vec4_sub(r: [*c]f32, a: [*c]const f32, b: [*c]const f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (a[i] - b[i]);
//     }
// }
// pub fn vec4_scale(r: [*c]f32, v: [*c]const f32, s: f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (v[i] * s);
//     }
// }
// pub fn vec4_len(v: [*c]const f32) f32 {
//     return sqrtf(vec4_mul_inner(v, v));
// }
// pub fn vec4_min(r: [*c]f32, a: [*c]const f32, b: [*c]const f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = if (a[i] < b[i]) a[i] else b[i];
//     }
// }
// pub fn vec4_max(r: [*c]f32, a: [*c]const f32, b: [*c]const f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = if (a[i] > b[i]) a[i] else b[i];
//     }
// }
// pub fn vec3_mul_cross(r: [*c]f32, a: [*c]const f32, b: [*c]const f32) void {
//     r[0] = ((a[1] * b[2]) - (a[2] * b[1]));
//     r[1] = ((a[2] * b[0]) - (a[0] * b[2]));
//     r[2] = ((a[0] * b[1]) - (a[1] * b[0]));
// }
// pub const mat4x4 = [4]vec4;
// pub fn mat4x4_dup(M: [*c]vec4, N: [*c]vec4) void {
//     var i: c_int = undefined;
//     var j: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) {
//             j = 0;
//             while (j < 4) : (j += 1) M[i][j] = N[i][j];
//         }
//     }
// }
// pub fn mat4x4_row(r: [*c]f32, M: [*c]vec4, i: c_int) void {
//     var k: c_int = undefined;
//     {
//         k = 0;
//         while (k < 4) : (k += 1) r[k] = M[k][i];
//     }
// }
// pub fn mat4x4_col(r: [*c]f32, M: [*c]vec4, i: c_int) void {
//     var k: c_int = undefined;
//     {
//         k = 0;
//         while (k < 4) : (k += 1) r[k] = M[i][k];
//     }
// }
// pub fn mat4x4_transpose(M: [*c]vec4, N: [*c]vec4) void {
//     var i: c_int = undefined;
//     var j: c_int = undefined;
//     {
//         j = 0;
//         while (j < 4) : (j += 1) {
//             i = 0;
//             while (i < 4) : (i += 1) M[i][j] = N[j][i];
//         }
//     }
// }
// pub fn mat4x4_add(M: [*c]vec4, a: [*c]vec4, b: [*c]vec4) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) vec4_add(M[i], a[i], b[i]);
//     }
// }
// pub fn mat4x4_sub(M: [*c]vec4, a: [*c]vec4, b: [*c]vec4) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) vec4_sub(M[i], a[i], b[i]);
//     }
// }
// pub fn mat4x4_scale(M: [*c]vec4, a: [*c]vec4, k: f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) vec4_scale(M[i], a[i], k);
//     }
// }
// pub fn mat4x4_scale_aniso(M: [*c]vec4, a: [*c]vec4, x: f32, y: f32, z: f32) void {
//     var i: c_int = undefined;
//     vec4_scale(M[0], a[0], x);
//     vec4_scale(M[1], a[1], y);
//     vec4_scale(M[2], a[2], z);
//     {
//         i = 0;
//         while (i < 4) : (i += 1) {
//             M[3][i] = a[3][i];
//         }
//     }
// }
// pub fn mat4x4_translate(T: [*c]vec4, x: f32, y: f32, z: f32) void {
//     mat4x4_identity(T);
//     T[3][0] = x;
//     T[3][1] = y;
//     T[3][2] = z;
// }
// pub const quat = [4]f32;
// pub fn quat_add(r: [*c]f32, a: [*c]f32, b: [*c]f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (a[i] + b[i]);
//     }
// }
// pub fn quat_sub(r: [*c]f32, a: [*c]f32, b: [*c]f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (a[i] - b[i]);
//     }
// }
// pub fn quat_mul(r: [*c]f32, p: [*c]f32, q: [*c]f32) void {
//     var w: vec3 = undefined;
//     vec3_mul_cross(r, p, q);
//     vec3_scale(w, p, q[3]);
//     vec3_add(r, r, w);
//     vec3_scale(w, q, p[3]);
//     vec3_add(r, r, w);
//     r[3] = ((p[3] * q[3]) - vec3_mul_inner(p, q));
// }
// pub fn quat_scale(r: [*c]f32, v: [*c]f32, s: f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 4) : (i += 1) r[i] = (v[i] * s);
//     }
// }
// pub fn quat_conj(r: [*c]f32, q: [*c]f32) void {
//     var i: c_int = undefined;
//     {
//         i = 0;
//         while (i < 3) : (i += 1) r[i] = (-q[i]);
//     }
//     r[3] = q[3];
// }