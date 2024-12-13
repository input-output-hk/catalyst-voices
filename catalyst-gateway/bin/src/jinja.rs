//! `minijinja` static global variables

use std::sync::LazyLock;

use minijinja::Environment;

use crate::db::event::signed_docs::SELECT_SIGNED_DOCS_TEMPLATE;

/// Jinja template source struct.
pub(crate) struct JinjaTemplateSource {
    /// Jinja template name
    pub(crate) name: &'static str,
    /// Jinja template source
    pub(crate) source: &'static str,
}

/// Global static `minijinja::Environment` with all preloaded templates
#[allow(clippy::unwrap_used, dead_code)]
pub(crate) static JINJA_ENV: LazyLock<Environment> = LazyLock::new(|| {
    let mut env = minijinja::Environment::new();

    // Preload templates
    env.add_template(
        SELECT_SIGNED_DOCS_TEMPLATE.name,
        SELECT_SIGNED_DOCS_TEMPLATE.source,
    )
    .unwrap();

    env
});
