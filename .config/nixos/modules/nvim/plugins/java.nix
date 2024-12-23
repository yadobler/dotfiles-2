{ pkgs, ... }:
let 
jarTestDir = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
jarTestFiles = builtins.filter (file: builtins.match "com.microsoft.java.test.plugin-.*\\.jar" file != null) (builtins.attrNames (builtins.readDir jarTestDir));
javaTestPath = if (jarTestFiles != []) then "${jarTestDir}/${builtins.head jarTestFiles}" else throw "No matching JAR file found!";

jarDebugDir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
jarDebugFiles = builtins.filter (file: builtins.match "com.microsoft.java.debug.plugin-.*\\.jar" file != null) (builtins.attrNames (builtins.readDir jarDebugDir));
javaDebugPath = if (jarDebugFiles != []) then "${jarDebugDir}/${builtins.head jarDebugFiles}" else throw "No matching JAR file found!";

lldbDebugPath = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
jdtlsPath = "${pkgs.jdt-language-server}/bin/jdtls";
javaExecutablePath = "${pkgs.openjdk17}/bin/java";

in
{
    programs.nixvim = {
        extraPlugins = with pkgs; [
            google-java-format
        ];

        plugins.nvim-jtls = {
            enable = true;
            cmd = [
                "${jdtlsPath}" 
                    "--java-executable" "${javaExecutablePath}"
            ];
            data = "~/.cache/jdtls/workspace";
            settings = {
                java = {
                    signatureHelp = true;
                    completion = true;
                };
            };
            initOptions = {
                bundles = [
                    "${javaTestPath}"
                        "${javaDebugPath}"
                ];
            };
        };
    };
}
