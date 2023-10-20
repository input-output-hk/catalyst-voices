#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Group {
    pub(crate) fund_id: i32,
    pub(crate) token_identifier: String,
    pub(crate) group_id: String,
}
