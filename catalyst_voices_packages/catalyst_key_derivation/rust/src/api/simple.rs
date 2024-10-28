use flutter_rust_bridge::spawn_blocking_with;
use crate::frb_generated::FLUTTER_RUST_BRIDGE_HANDLER;

// spawn_blocking_with works similary to tokio spawn_blocking
// basically running blocking operations on a separate thread
// Just use FLUTTER_RUST_BRIDGE_HANDLER.thread_pool() as the second argument
// as mention in https://github.com/fzyzcjy/flutter_rust_bridge/blob/master/frb_rust/src/rust_async/io.rs
// https://cjycode.com/flutter_rust_bridge/guides/cross-platform/async
pub async fn greet(name: String) -> String {
    let iterations = 50_000_000;
    
    let result = spawn_blocking_with(move || {
        let mut sum = 0.0;
        for i in 0..iterations {
            sum += (i as f64).sqrt();
        }
        sum
    }, FLUTTER_RUST_BRIDGE_HANDLER.thread_pool())
    .await 
    .unwrap();

    format!("Hello, {name} {result}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
