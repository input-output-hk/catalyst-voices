//! Simple general purpose utility functions.

/// Convert T to an i16. (saturate if out of range.)
#[allow(dead_code)] // Its OK if we don't use this general utility function.
pub(crate) fn i16_from_saturating<T: TryInto<i16>>(value: T) -> i16 {
    match value.try_into() {
        Ok(value) => value,
        Err(_) => i16::MAX,
    }
}

/// Convert an `<T>` to `u16`. (saturate if out of range.)
#[allow(dead_code)] // Its OK if we don't use this general utility function.
pub(crate) fn u16_from_saturating<
    T: Copy
        + TryInto<u16>
        + std::ops::Sub<Output = T>
        + std::cmp::PartialOrd<T>
        + num_traits::identities::Zero,
>(
    value: T,
) -> u16 {
    if value < T::zero() {
        u16::MIN
    } else {
        match value.try_into() {
            Ok(value) => value,
            Err(_) => u16::MAX,
        }
    }
}

/// Convert an `<T>` to `usize`. (saturate if out of range.)
#[allow(dead_code)] // Its OK if we don't use this general utility function.
pub(crate) fn usize_from_saturating<
    T: Copy
        + TryInto<usize>
        + std::ops::Sub<Output = T>
        + std::cmp::PartialOrd<T>
        + num_traits::identities::Zero,
>(
    value: T,
) -> usize {
    if value < T::zero() {
        usize::MIN
    } else {
        match value.try_into() {
            Ok(value) => value,
            Err(_) => usize::MAX,
        }
    }
}

/// Convert an `<T>` to `u32`. (saturate if out of range.)
#[allow(dead_code)] // Its OK if we don't use this general utility function.
pub(crate) fn u32_from_saturating<
    T: Copy
        + TryInto<u32>
        + std::ops::Sub<Output = T>
        + std::cmp::PartialOrd<T>
        + num_traits::identities::Zero,
>(
    value: T,
) -> u32 {
    if value < T::zero() {
        u32::MIN
    } else {
        match value.try_into() {
            Ok(converted) => converted,
            Err(_) => u32::MAX,
        }
    }
}

/// Convert an `<T>` to `u64`. (saturate if out of range.)
#[allow(dead_code)] // Its OK if we don't use this general utility function.
pub(crate) fn u64_from_saturating<
    T: Copy
        + TryInto<u64>
        + std::ops::Sub<Output = T>
        + std::cmp::PartialOrd<T>
        + num_traits::identities::Zero,
>(
    value: T,
) -> u64 {
    if value < T::zero() {
        u64::MIN
    } else {
        match value.try_into() {
            Ok(converted) => converted,
            Err(_) => u64::MAX,
        }
    }
}
