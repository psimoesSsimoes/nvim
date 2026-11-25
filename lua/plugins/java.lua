-- jdtls itself needs a recent JDK (25+ as of jdtls 1.63): use Homebrew's latest.
-- Projects compile and run tests on 21: mbcp's Mockito (Spring Boot 3.2) breaks on newer JDKs.
local JDTLS_JDK = "/opt/homebrew/opt/openjdk"
local JDK = "/opt/homebrew/opt/openjdk@21"
-- jdtls needs the real JDK home (with lib/modules), not Homebrew's prefix
local JDK_HOME = JDK .. "/libexec/openjdk.jdk/Contents/Home"

local function project_root(bufnr)
  return vim.fs.root(bufnr, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" })
end

-- Run Maven in a terminal split at the project root (like vim-go's :GoTest)
local function mvn(bufnr, args)
  local root = project_root(bufnr)
  if not root then
    vim.notify("No pom.xml found", vim.log.levels.WARN)
    return
  end
  local cmd = "mvn -B -ntp -Dcheckstyle.skip -Dspotbugs.skip -Dsurefire.failIfNoSpecifiedTests=false " .. args
  vim.cmd("botright 15new")
  vim.fn.jobstart(cmd, { term = true, cwd = root, env = { JAVA_HOME = JDK } })
  vim.cmd("normal! G")
end

local function test_class(bufnr)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t:r")
end

-- Test methods are void; walk up from the cursor to the enclosing one
local function test_method()
  for lnum = vim.fn.line("."), 1, -1 do
    local name = vim.fn.getline(lnum):match("void%s+([%w_]+)%s*%(")
    if name then
      return name
    end
  end
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      local function attach(bufnr)
        local root = project_root(bufnr)
        if not root then
          return
        end
        local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. root:gsub("/", "_")
        require("jdtls").start_or_attach({
          name = "jdtls",
          cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls", "-data", workspace, "--jvm-arg=-Xmx2g" },
          cmd_env = { JAVA_HOME = JDTLS_JDK },
          root_dir = root,
          settings = {
            java = {
              configuration = {
                runtimes = { { name = "JavaSE-21", path = JDK_HOME, default = true } },
              },
              maven = { downloadSources = true },
            },
          },
        }, { bufnr = bufnr })

        local jdtls = require("jdtls")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>t", function()
          local method = test_method()
          if not method then
            vim.notify("No test method above the cursor", vim.log.levels.WARN)
            return
          end
          -- "Class*" so @Nested inner classes (Class$Inner) match too
          mvn(bufnr, "test -Dtest='" .. test_class(bufnr) .. "*#" .. method .. "'")
        end, "Run Java test under cursor")
        map("n", "<leader>ta", function() mvn(bufnr, "test -Dtest='" .. test_class(bufnr) .. "*'") end, "Run Java tests in class")
        map("n", "<leader>tl", function() mvn(bufnr, "test-compile") end, "Compile Java tests")
        map("n", "<leader>jo", jdtls.organize_imports, "Organize imports")
        map({ "n", "v" }, "<leader>jv", jdtls.extract_variable, "Extract variable")
        map({ "n", "v" }, "<leader>jc", jdtls.extract_constant, "Extract constant")
        map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extract method")
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("JdtlsAttach", { clear = true }),
        pattern = "java",
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      -- The buffer that triggered loading this plugin already fired FileType
      if vim.bo.filetype == "java" then
        attach(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
