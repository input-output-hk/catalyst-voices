//! Utility functions for the event db operations

/// Prepare SQL parameters list from the provided list size and number of parameters.
/// Output format: `[($1, $2, $3), ($4, $5, $6)]`
pub(crate) fn prepare_sql_params_list(params_num: usize, list_size: usize) -> Vec<String> {
    (0..list_size)
        .map(|row| {
            let placeholders: String = (0..params_num)
                .map(|i| format!("${}", row * params_num + i + 1))
                .collect::<Vec<_>>()
                .join(",");
            format!("({placeholders})")
        })
        .collect()
}
