//! Hermes binary build info

use build_info::{self as build_info_crate};
use local_ip_address::list_afinet_netifas;
use tracing::info;

use crate::service::utilities;

/// Formatted hermes binary build info
pub(crate) const BUILD_INFO: &str = build_info_crate::format!("
version: {},
git info: {{{}}}
compiler: {}
build time: {}
",
    $.crate_info.version,
    $.version_control,
    $.compiler,
    $.timestamp
);

build_info_crate::build_info!(fn build_info);

/// Log Build Info to our logs.
pub(crate) fn log_build_info() {
    let info = build_info();
    let timestamp = info.timestamp.to_rfc3339();
    let profile = info.profile.clone();
    let optimization_level = info.optimization_level.to_string();

    let name = info.crate_info.name.clone();
    let version = info.crate_info.version.to_string();
    let features = info.crate_info.enabled_features.join(",");

    let triple = info.target.triple.clone();
    let family = info.target.family.clone();
    let os = info.target.os.clone();
    let cpu_arch = info.target.cpu.arch.clone();
    let cpu_features = info.target.cpu.features.join(",");

    let compiler_channel = info.compiler.channel.to_string();
    let compiler_version = info.compiler.version.to_string();

    let mut commit_id = "Unknown".to_string();
    let mut commit_timestamp = "Unknown".to_string();
    let mut branch = "Unknown".to_string();
    let mut tags = "Unknown".to_string();

    if let Some(ref vc) = info.version_control {
        if let Some(git) = vc.git() {
            commit_id.clone_from(&git.commit_short_id);
            commit_timestamp = git.commit_timestamp.to_rfc3339();
            if let Some(git_branch) = git.branch.clone() {
                branch = git_branch;
            }
            tags = git.tags.join(",");
        }
    }

    let ipv4 = utilities::net::get_public_ipv4().to_string();
    let ipv6 = utilities::net::get_public_ipv6().to_string();

    let mut interfaces: String = "Unknown".to_string();

    // Get local IP address v4 and v6
    if let Ok(network_interfaces) = list_afinet_netifas() {
        if !network_interfaces.is_empty() {
            interfaces.clear();
            for iface in network_interfaces {
                if !interfaces.is_empty() {
                    interfaces.push(',');
                }
                interfaces.push_str(&format!("{}:{}", iface.0, iface.1));
            }
        }
    }

    info!(
        BuildTime = timestamp,
        Profile = profile,
        OptimizationLevel = optimization_level,
        Name = name,
        Version = version,
        Features = features,
        TargetTriple = triple,
        TargetFamily = family,
        TargetOs = os,
        CPUArch = cpu_arch,
        CPUFeatures = cpu_features,
        RustChannel = compiler_channel,
        RustVersion = compiler_version,
        GitCommitId = commit_id,
        GitCommitTimestamp = commit_timestamp,
        GitBranch = branch,
        GitTags = tags,
        PublicIPv4 = ipv4,
        PublicIPv6 = ipv6,
        NetworkInterfaces = interfaces,
        "Catalyst Gateway"
    );
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn build_info_test() {
        println!("{BUILD_INFO}");
    }
}
