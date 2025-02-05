//! Processing for String Environment Variables

// cspell: words smhdwy

use std::{
    env::{self, VarError},
    fmt::{self, Display},
    str::FromStr,
    time::Duration,
};

use duration_string::DurationString;
use strum::VariantNames;
use tracing::{error, info};

/// An environment variable read as a string.
#[derive(Clone)]
pub(crate) struct StringEnvVar {
    /// Value of the env var.
    value: String,
    /// Whether the env var is displayed redacted or not.
    redacted: bool,
}

/// Ergonomic way of specifying if a env var needs to be redacted or not.
pub(super) enum StringEnvVarParams {
    /// The env var is plain and should not be redacted.
    Plain(String, Option<String>),
    /// The env var is redacted and should be redacted.
    Redacted(String, Option<String>),
}

impl From<&str> for StringEnvVarParams {
    fn from(s: &str) -> Self {
        StringEnvVarParams::Plain(String::from(s), None)
    }
}

impl From<String> for StringEnvVarParams {
    fn from(s: String) -> Self {
        StringEnvVarParams::Plain(s, None)
    }
}

impl From<(&str, bool)> for StringEnvVarParams {
    fn from((s, r): (&str, bool)) -> Self {
        if r {
            StringEnvVarParams::Redacted(String::from(s), None)
        } else {
            StringEnvVarParams::Plain(String::from(s), None)
        }
    }
}

impl From<(&str, bool, &str)> for StringEnvVarParams {
    fn from((s, r, c): (&str, bool, &str)) -> Self {
        if r {
            StringEnvVarParams::Redacted(String::from(s), Some(String::from(c)))
        } else {
            StringEnvVarParams::Plain(String::from(s), Some(String::from(c)))
        }
    }
}

/// An environment variable read as a string.
impl StringEnvVar {
    /// Read the env var from the environment.
    ///
    /// If not defined, read from a .env file.
    /// If still not defined, use the default.
    ///
    /// # Arguments
    ///
    /// * `var_name`: &str - the name of the env var
    /// * `default_value`: &str - the default value
    ///
    /// # Returns
    ///
    /// * Self - the value
    ///
    /// # Example
    ///
    /// ```rust,no_run
    /// #use cat_data_service::settings::StringEnvVar;
    ///
    /// let var = StringEnvVar::new("MY_VAR", "default");
    /// assert_eq!(var.as_str(), "default");
    /// ```
    pub(super) fn new(var_name: &str, param: StringEnvVarParams) -> Self {
        let (default_value, redacted, choices) = match param {
            StringEnvVarParams::Plain(s, c) => (s, false, c),
            StringEnvVarParams::Redacted(s, c) => (s, true, c),
        };

        match env::var(var_name) {
            Ok(value) => {
                let value = Self { value, redacted };
                info!(env=var_name, value=%value, "Env Var Defined");
                value
            },
            Err(err) => {
                let value = Self {
                    value: default_value,
                    redacted,
                };
                if err == VarError::NotPresent {
                    if let Some(choices) = choices {
                        info!(env=var_name, default=%value, choices=choices, "Env Var Defaulted");
                    } else {
                        info!(env=var_name, default=%value, "Env Var Defaulted");
                    }
                } else if let Some(choices) = choices {
                    info!(env=var_name, default=%value, choices=choices, error=?err,
                        "Env Var Error");
                } else {
                    info!(env=var_name, default=%value, error=?err, "Env Var Error");
                }

                value
            },
        }
    }

    /// New Env Var that is optional.
    pub(super) fn new_optional(var_name: &str, redacted: bool) -> Option<Self> {
        match env::var(var_name) {
            Ok(value) => {
                let value = Self { value, redacted };
                info!(env = var_name, value = %value, "Env Var Defined");
                Some(value)
            },
            Err(VarError::NotPresent) => {
                info!(env = var_name, "Env Var Not Set");
                None
            },
            Err(error) => {
                error!(env = var_name, error = ?error, "Env Var Error");
                None
            },
        }
    }

    /// Convert an Envvar into the required Enum Type.
    pub(super) fn new_as_enum<T: FromStr + Display + VariantNames>(
        var_name: &str, default: T, redacted: bool,
    ) -> T
    where <T as std::str::FromStr>::Err: std::fmt::Display {
        let mut choices = String::new();
        for name in T::VARIANTS {
            if choices.is_empty() {
                choices.push('[');
            } else {
                choices.push(',');
            }
            choices.push_str(name);
        }
        choices.push(']');

        let choice = StringEnvVar::new(
            var_name,
            (default.to_string().as_str(), redacted, choices.as_str()).into(),
        );

        let value = match T::from_str(choice.as_str()) {
            Ok(var) => var,
            Err(error) => {
                error!(error=%error, default=%default, choices=choices, choice=%choice,
                    "Invalid choice. Using Default.");
                default
            },
        };

        value
    }

    /// Convert an Envvar into the required Duration type.
    pub(crate) fn new_as_duration(var_name: &str, default: &str) -> Duration {
        let choices = "A value in the format of `[0-9]+(ns|us|ms|[smhdwy])`";

        let raw_value = StringEnvVar::new(
            var_name,
            (default.to_string().as_str(), false, choices).into(),
        )
        .as_string();

        match DurationString::try_from(raw_value.clone()) {
            Ok(duration) => duration.into(),
            Err(error) => {
                error!(
                    "Invalid Duration: {} : {}. Defaulting to {}.",
                    raw_value, error, default
                );

                match DurationString::try_from(default.to_string()) {
                    Ok(duration) => duration.into(),
                    // The error from parsing the default value must not happen
                    Err(error) => {
                        error!(
                            "Invalid Default Duration: {} : {}. Defaulting to 1s.",
                            default, error
                        );
                        Duration::from_secs(1)
                    },
                }
            },
        }
    }

    /// Convert an Envvar into an integer in the bounded range.
    pub(super) fn new_as<T>(var_name: &str, default: T, min: T, max: T) -> T
    where
        T: FromStr + Display + PartialOrd + tracing::Value,
        <T as std::str::FromStr>::Err: std::fmt::Display,
    {
        let choices = format!("A value in the range {min} to {max} inclusive");

        let raw_value = StringEnvVar::new(
            var_name,
            (default.to_string().as_str(), false, choices.as_str()).into(),
        )
        .as_string();

        match raw_value.parse::<T>() {
            Ok(value) => {
                if value < min {
                    error!("{var_name} out of range. Range = {min} to {max} inclusive. Clamped to {min}");
                    min
                } else if value > max {
                    error!("{var_name} out of range. Range = {min} to {max} inclusive. Clamped to {max}");
                    max
                } else {
                    value
                }
            },
            Err(error) => {
                error!(error=%error, default=default, "{var_name} not an integer. Range = {min} to {max} inclusive. Defaulted");
                default
            },
        }
    }

    /// Get the read env var as a str.
    ///
    /// # Returns
    ///
    /// * &str - the value
    pub(crate) fn as_str(&self) -> &str {
        &self.value
    }

    /// Get the read env var as a str.
    ///
    /// # Returns
    ///
    /// * &str - the value
    pub(crate) fn as_string(&self) -> String {
        self.value.clone()
    }
}

impl fmt::Display for StringEnvVar {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.redacted {
            return write!(f, "REDACTED");
        }
        write!(f, "{}", self.value)
    }
}

impl fmt::Debug for StringEnvVar {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.redacted {
            return write!(f, "REDACTED");
        }
        write!(f, "env: {}", self.value)
    }
}
