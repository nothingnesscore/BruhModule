#[derive(Debug, Clone, PartialEq)]
pub enum MountStrategy {
    Auto,
    Vfs,
    Overlay,
    Magic,
}

#[derive(Debug, Clone)]
pub struct PlannedModule {
    pub id: String,
    pub path: String,
    pub strategy: MountStrategy,
}

#[derive(Debug, Clone)]
pub struct MountPlan {
    pub modules: Vec<PlannedModule>,
}
