{ pkgs, ... }:
let
lldbDebugPath = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
in
{
    programs.nixvim = {
        plugins = {
            dap = {
                enable = true;
                signs = {
                    dapBreakpoint = {
                        text = "●";
                        texthl = "DapBreakpoint";
                    };
                    dapBreakpointCondition = {
                        text = "●";
                        texthl = "DapBreakpointCondition";
                    };
                    dapLogPoint = {
                        text = "◆";
                        texthl = "DapLogPoint";
                    };
                };
                adapters.servers = {
                    codelldb = {
                        port = "\${port}";
                        executable = {
                            command = "${lldbDebugPath}";
                            args = ["--port" "\${port}"];
                        };
                    }; 
                };
                extensions = {
                    dap-python = {
                        enable = true;
                    };
                    dap-ui = {
                        enable = true;
                        floating.mappings = {
                            close = ["<ESC>" "q"];
                        };
                    };
                    dap-virtual-text = {
                        enable = true;
                    };
                };
                configurations = {
                    c = [
                    {
                        name = "Launch file";
                        type = "codelldb";
                        request = "launch";
                        program.__raw = ''
                            function()
                            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                            end
                            '';
                        cwd = "\${workspaceFolder}";
                        stopOnEntry = false;
                    }
                    ];

                    java = [
                    {
                        type = "java";
                        request = "launch";
                        name = "Debug (Attach) - Remote";
                        hostName = "127.0.0.1";
                        port = 5005;
                    }
                    ];
                };
            };
            keymaps = [
            {
                mode = [ "n" ];
                action = ":DapContinue<cr>";
                key = "<leader>dc";
                options = {
                    desc = "Continue";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapStepOver<cr>";
                key = "<leader>dO";
                options = {
                    desc = "Step over";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapStepInto<cr>";
                key = "<leader>di";
                options = {
                    desc = "Step Into";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapStepOut<cr>";
                key = "<leader>do";
                options = {
                    desc = "Step Out";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dap').pause()<cr>";
                key = "<leader>dp";
                options = {
                    desc = "Pause";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapToggleBreakpoint<cr>";
                key = "<leader>db";
                options = {
                    desc = "Toggle Breakpoint";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
                key = "<leader>dB";
                options = {
                    desc = "Breakpoint (conditional)";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapToggleRepl<cr>";
                key = "<leader>dR";
                options = {
                    desc = "Toggle REPL";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dap').run_last()<cr>";
                key = "<leader>dr";
                options = {
                    desc = "Run Last";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dap').session()<cr>";
                key = "<leader>ds";
                options = {
                    desc = "Session";
                };
            }
            {
                mode = [ "n" ];
                action = ":DapTerminate<cr>";
                key = "<leader>dt";
                options = {
                    desc = "Terminate";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
                key = "<leader>dw";
                options = {
                    desc = "Hover Widget";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dapui').toggle()<cr>";
                key = "<leader>du";
                options = {
                    desc = "Toggle UI";
                };
            }
            {
                mode = [ "n" ];
                action = "<cmd>lua require('dapui').eval()<cr>";
                key = "<leader>de";
                options = {
                    desc = "Eval";
                };
            }
            ];
        };
    };
}
