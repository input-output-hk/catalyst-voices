#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Goal {
    pub(crate) id: i32,
    pub(crate) goal_name: String,
    pub(crate) fund_id: i32,
}
