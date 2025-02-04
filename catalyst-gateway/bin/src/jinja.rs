//! `minijinja` static global variables

use std::sync::LazyLock;

use minijinja::{Environment, Template};

use crate::db::event::signed_docs::{
    FILTERED_COUNT_SIGNED_DOCS_TEMPLATE, FILTERED_SELECT_SIGNED_DOCS_TEMPLATE,
    SELECT_SIGNED_DOCS_TEMPLATE,
};

/// Jinja template source struct.
pub(crate) struct JinjaTemplateSource {
    /// Jinja template name
    pub(crate) name: &'static str,
    /// Jinja template source
    pub(crate) source: &'static str,
}

/// Global static `minijinja::Environment` with all preloaded templates
#[allow(clippy::unwrap_used)]
static JINJA_ENV: LazyLock<Environment> = LazyLock::new(|| {
    let mut env = minijinja::Environment::new();

    // Preload templates
    env.add_template(
        SELECT_SIGNED_DOCS_TEMPLATE.name,
        SELECT_SIGNED_DOCS_TEMPLATE.source,
    )
    .unwrap();
    env.add_template(
        FILTERED_SELECT_SIGNED_DOCS_TEMPLATE.name,
        FILTERED_SELECT_SIGNED_DOCS_TEMPLATE.source,
    )
    .unwrap();
    env.add_template(
        FILTERED_COUNT_SIGNED_DOCS_TEMPLATE.name,
        FILTERED_COUNT_SIGNED_DOCS_TEMPLATE.source,
    )
    .unwrap();

    env
});

/// Returns a template from the jinja environment, returns error if it does not exit.
pub(crate) fn get_template(temp: &JinjaTemplateSource) -> anyhow::Result<Template<'static, '_>> {
    let template = JINJA_ENV.get_template(temp.name)?;
    Ok(template)
}
