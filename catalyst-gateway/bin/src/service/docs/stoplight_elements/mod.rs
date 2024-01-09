//! Provides a `OpenAPI` UI using the Stoplight Elements interface.
use poem::{endpoint::make_sync, web::Html, Endpoint};

/// Stoplight Elements UI JavaScript
const STOPLIGHT_UI_JS: &str = include_str!("web-components.min.js");
/// Stoplight Elements UI CSS
const STOPLIGHT_UI_CSS: &str = include_str!("styles.min.css");

/// Stoplight Elements UI Template
const STOPLIGHT_UI_TEMPLATE: &str = r#"
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Catalyst Gateway API Documentation - StopLight Elements</title>
    <style charset="UTF-8">{:style}</style>
    <script charset="UTF-8">{:script}</script>
  </head>
  <body>

    <elements-api id="docs"
        router="hash"
        layout="sidebar">
    </elements-api>

    <script>
        (async () => {
            const docs = document.getElementById('docs');
            const apiDescriptionDocument = {:spec};
            docs.apiDescriptionDocument = apiDescriptionDocument;
        })();
    </script>
  </body>
</html>
"#;

/// Create the HTML from the Stoplight template above and our included CSS and .JS file.
fn create_html(document: &str) -> String {
    STOPLIGHT_UI_TEMPLATE
        .replace("{:style}", STOPLIGHT_UI_CSS)
        .replace("{:script}", STOPLIGHT_UI_JS)
        .replace("{:spec}", document)
}

/// Create an endpoint to return teh Stoplight documentation for our API.
pub(crate) fn create_endpoint(document: &str) -> impl Endpoint {
    let ui_html = create_html(document);
    poem::Route::new().at("/", make_sync(move |_| Html(ui_html.clone())))
}
