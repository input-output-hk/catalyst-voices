//! Utility functions for the event db operations

/// `ParamType` alias
pub(crate) type ParamType<'a> = Option<&'a str>;

/// Prepare SQL parameters list from the provided list size and number of parameters.
/// Output format: `[($1, $2, $3), ($4, $5, $6)]`
pub(crate) fn prepare_sql_params_list(params: &[ParamType], list_size: usize) -> Vec<String> {
    let params_num = params.len();
    (0..list_size)
        .map(|row| {
            let placeholders: String = params
                .iter()
                .enumerate()
                .map(|(i, param_type)| {
                    let param_type = param_type.map(|val| format!("::{val}")).unwrap_or_default();
                    format!("${}{param_type}", row * params_num + i + 1)
                })
                .collect::<Vec<_>>()
                .join(",");
            format!("({placeholders})")
        })
        .collect()
}
