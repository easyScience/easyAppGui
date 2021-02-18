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
                info: {
                    date: '01.01.2001',
                    branch_name: 'master',
                    commit_sha_short: 'undefined'
                },
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
