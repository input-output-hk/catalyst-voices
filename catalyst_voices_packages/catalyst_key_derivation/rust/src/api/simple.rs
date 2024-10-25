#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    let iterations = 5000;
    for i in 0..iterations {
        let mut result = 0.0;
        for j in 1..1_000_000 {
            result += (j as f64).sqrt();
        }
    }
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
