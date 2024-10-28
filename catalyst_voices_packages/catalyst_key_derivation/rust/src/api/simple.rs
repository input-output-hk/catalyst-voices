pub async fn greet(name: String) -> String {
    let iterations = 50000000;
    let mut result = 0.0;
    for i in 0..iterations {
        for j in 0..iterations {
            result += (i as f64).sqrt();
        }
    }
    format!("Hello, {name} {result}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
