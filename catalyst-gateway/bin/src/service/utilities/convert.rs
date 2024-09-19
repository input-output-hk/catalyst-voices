//! Simple general purpose utility functions.

/// Convert an `<T>` to `<R>`. (saturate if out of range.)
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
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
    }
}
