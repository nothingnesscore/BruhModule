const { createApp, ref, onMounted } = Vue;

createApp({
    setup() {
        const loading = ref(true);
        const engine = ref({
            susfs_active: false,
            vfs_active: false
        });
        const modules = ref([]);

        const loadData = async () => {
            try {
                if (window.ksu) {
                    // Check SUSFS
                    const susfsRes = await ksu.exec("dmesg | grep -i susfs | grep initialized");
                    engine.value.susfs_active = susfsRes && susfsRes.stdout && susfsRes.stdout.includes("version:");
                    
                    // Check ZeroMount VFS
                    const vfsRes = await ksu.exec("ls /dev/zeromount");
                    engine.value.vfs_active = vfsRes && vfsRes.stdout && vfsRes.stdout.includes("/dev/zeromount");

                    // Get Config
                    let configStr = "";
                    const configRes = await ksu.exec("cat /data/adb/modules/bruhmodule/config.toml");
                    if (configRes && configRes.stdout) {
                        configStr = configRes.stdout;
                    }

                    // Get Modules
                    const modsRes = await ksu.exec("ls /data/adb/modules");
                    if (modsRes && modsRes.stdout) {
                        const modDirs = modsRes.stdout.split("\\n").filter(m => m && m !== "bruhmodule");
                        
                        modules.value = modDirs.map(id => {
                            // Extract strategy from basic toml parsing
                            let strategy = "auto";
                            if (configStr.includes(`[modules.${id}]`)) {
                                if (configStr.includes(`force_strategy = "vfs"`)) strategy = "vfs";
                                else if (configStr.includes(`force_overlay = true`)) strategy = "overlay";
                                else if (configStr.includes(`force_magic = true`)) strategy = "magic";
                            }
                            
                            return {
                                id,
                                name: id, // Fallback, could read prop
                                strategy
                            };
                        });
                    }
                } else {
                    // Mock data for browser testing
                    engine.value.susfs_active = true;
                    engine.value.vfs_active = true;
                    modules.value = [
                        { id: "youtube-revanced", name: "YouTube ReVanced", strategy: "vfs" },
                        { id: "systemless-hosts", name: "Systemless Hosts", strategy: "overlay" }
                    ];
                }
            } catch (e) {
                console.error(e);
            } finally {
                loading.value = false;
            }
        };

        const saveConfig = async () => {
            if (!window.ksu) return;
            
            let toml = "[global]\\nmode = \\"hybrid\\"\\n\\n";
            modules.value.forEach(mod => {
                if (mod.strategy !== "auto") {
                    toml += `[modules.${mod.id}]\\n`;
                    if (mod.strategy === "vfs") toml += `force_strategy = "vfs"\\n`;
                    if (mod.strategy === "overlay") toml += `force_overlay = true\\n`;
                    if (mod.strategy === "magic") toml += `force_magic = true\\n`;
                    toml += "\\n";
                }
            });
            
            await ksu.exec(`echo "${toml}" > /data/adb/modules/bruhmodule/config.toml`);
            await ksu.exec("bruh_mount reload");
        };

        onMounted(() => {
            loadData();
        });

        return {
            loading,
            engine,
            modules,
            saveConfig
        }
    }
}).mount("#app");

