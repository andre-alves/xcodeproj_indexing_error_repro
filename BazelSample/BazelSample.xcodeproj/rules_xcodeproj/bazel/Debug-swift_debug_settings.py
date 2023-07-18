#!/usr/bin/python3

"""An lldb module that registers a stop hook to set swift settings."""

import lldb
import re

# Order matters, it needs to be from the most nested to the least
_BUNDLE_EXTENSIONS = [
    ".framework",
    ".xctest",
    ".appex",
    ".bundle",
    ".app",
]

_TRIPLE_MATCH = re.compile(r"([^-]+-[^-]+)(-\D+)[^-]*(-.*)?")

_SETTINGS = {
	"arm64-apple-ios-simulator BazelSample.app/BazelSample": {
		"c": "-F$(PROJECT_DIR)/Pods/lottie-ios/Frameworks/Lottie.xcframework/ios-arm64_x86_64-simulator -F$(PROJECT_DIR)/Pods/Cartography/Frameworks/Cartography.xcframework/ios-arm64_x86_64-simulator -F$(PROJECT_DIR)/Pods/Kingfisher/Frameworks/Kingfisher.xcframework/ios-arm64_x86_64-simulator -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -fmodule-map-file=$(PROJECT_DIR)/Pods/lottie-ios/Frameworks/Lottie.xcframework/ios-arm64_x86_64-simulator/Lottie.framework/Modules/module.modulemap -fmodule-map-file=$(PROJECT_DIR)/Pods/Cartography/Frameworks/Cartography.xcframework/ios-arm64_x86_64-simulator/Cartography.framework/Modules/module.modulemap -fmodule-map-file=$(PROJECT_DIR)/Pods/Kingfisher/Frameworks/Kingfisher.xcframework/ios-arm64_x86_64-simulator/Kingfisher.framework/Modules/module.modulemap -O0 -DDEBUG=1 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all -iquote$(PROJECT_DIR) -iquote$(PROJECT_DIR)/bazel-out/ios-sim_arm64-min14.0-applebin_ios-ios_sim_arm64-dbg-ST-983f5c65c923/bin -O0 -fstack-protector -fstack-protector-all",
		"f": [
			"$(PROJECT_DIR)/Pods/lottie-ios/Frameworks/Lottie.xcframework/ios-arm64_x86_64-simulator",
			"$(PROJECT_DIR)/Pods/Cartography/Frameworks/Cartography.xcframework/ios-arm64_x86_64-simulator",
			"$(PROJECT_DIR)/Pods/Kingfisher/Frameworks/Kingfisher.xcframework/ios-arm64_x86_64-simulator"
		],
		"s": [
			"/__build_bazel_rules_swift/swiftmodules"
		]
	}
}

def __lldb_init_module(debugger, _internal_dict):
    # Register the stop hook when this module is loaded in lldb
    ci = debugger.GetCommandInterpreter()
    res = lldb.SBCommandReturnObject()
    ci.HandleCommand(
        "target stop-hook add -P swift_debug_settings.StopHook",
        res,
    )
    if not res.Succeeded():
        print(f"""\
Failed to register Swift debug options stop hook:

{res.GetError()}
Please file a bug report here: \
https://github.com/MobileNativeFoundation/rules_xcodeproj/issues/new?template=bug.md
""")
        return

def _get_relative_executable_path(module):
    for extension in _BUNDLE_EXTENSIONS:
        prefix, _, suffix = module.rpartition(extension)
        if prefix:
            return prefix.split("/")[-1] + extension + suffix
    return module.split("/")[-1]

class StopHook:
    "An lldb stop hook class, that sets swift settings for the current module."

    def __init__(self, _target, _extra_args, _internal_dict):
        pass

    def handle_stop(self, exe_ctx, _stream):
        "Method that is called when the user stops in lldb."
        module = exe_ctx.frame.module
        if not module:
            return

        module_name = module.file.__get_fullpath__()
        versionless_triple = _TRIPLE_MATCH.sub(r"\1\2\3", module.GetTriple())
        executable_path = _get_relative_executable_path(module_name)
        key = f"{versionless_triple} {executable_path}"

        settings = _SETTINGS.get(key)

        if settings:
            frameworks = " ".join([
                f'"{path}"'
                for path in settings.get("f", [])
            ])
            if frameworks:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-framework-search-paths {frameworks}",
                )
            else:
                lldb.debugger.HandleCommand(
                    "settings clear target.swift-framework-search-paths",
                )

            includes = " ".join([
                f'"{path}"'
                for path in settings.get("s", [])
            ])
            if includes:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-module-search-paths {includes}",
                )
            else:
                lldb.debugger.HandleCommand(
                    "settings clear target.swift-module-search-paths",
                )

            clang = settings.get("c")
            if clang:
                lldb.debugger.HandleCommand(
                    f"settings set -- target.swift-extra-clang-flags '{clang}'",
                )
            else:
                lldb.debugger.HandleCommand(
                    "settings clear target.swift-extra-clang-flags",
                )

        return True
