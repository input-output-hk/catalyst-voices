//! Simple general purpose utility functions.

/// Convert an `<T>` to `<R>`. (saturate if out of range.)
/// Note can convert any int to float, or f32 to f64 as well.
/// can not convert from float to int, or f64 to f32.
pub(crate) fn from_saturating<
    R: Copy + num_traits::identities::Zero + num_traits::Bounded,
    T: Copy
        + TryInto<R>
        + std::ops::Sub<Output = T>
        + std::cmp::PartialOrd<T>
        + num_traits::identities::Zero,
>(
    value: T,
) -> R {
    match value.try_into() {
        Ok(value) => value,
        Err(_) => {
            // If we couldn't convert, its out of range for the destination type.
            if value > T::zero() {
                // If the number is positive, its out of range in the positive direction.
                R::max_value()
            } else {
                // Otherwise its out of range in the negative direction.
                R::min_value()
            }
        },
    }
}

/// Convert a big uint to a u64, saturating if its out of range.
pub(crate) fn big_uint_to_u64(value: &num_bigint::BigInt) -> u64 {
    let (sign, digits) = value.to_u64_digits();
    if sign == num_bigint::Sign::Minus || digits.is_empty() {
        return 0;
    }
    if digits.len() > 1 {
        return u64::MAX;
    }
    // 100% safe due to the above checks.
    #[allow(clippy::indexing_slicing)]
    digits[0]
}

#[cfg(test)]
mod tests {

    use super::*;

    #[test]
    #[allow(clippy::float_cmp)]
    fn from_saturating_tests() {
        let x: u32 = from_saturating(0_u8);
        assert!(x == 0);
        let x: u32 = from_saturating(255_u8);
        assert!(x == 255);
        let x: i8 = from_saturating(0_u32);
        assert!(x == 0);
        let x: i8 = from_saturating(512_u32);
        assert!(x == 127);
        let x: i8 = from_saturating(-512_i32);
        assert!(x == -128);
        let x: u16 = from_saturating(-512_i32);
        assert!(x == 0);
        let x: f64 = from_saturating(0.0_f32);
        assert!(x == 0.0);
        let x: f64 = from_saturating(0_u32);
        assert!(x == 0.0);
        let x: f64 = from_saturating(65536_u32);
        assert!(x == 65536.0_f64);
        let x: f64 = from_saturating(i32::MIN);
        assert!(x == -2_147_483_648.0_f64);
    }
}
