function projectConfig() {
    return {
        tool: {
            poetry: {
                name: "easyExample",
                version: "0.0.1"
            }
        },
        ci: {
            app: {
                tutorials: {
                    video: {
                        fps: 15
                    }
                }
            },
            project: {
                subdirs: {
                    screenshots: ""
                }
            }
        }
    }
}
