pub struct SusfsClient {
    pub version: String,
    pub is_available: bool,
}

impl SusfsClient {
    pub fn probe() -> Self {
        // Dummy probe for scaffolding
        Self {
            version: "v2.3.0".to_string(),
            is_available: true,
        }
    }
}
